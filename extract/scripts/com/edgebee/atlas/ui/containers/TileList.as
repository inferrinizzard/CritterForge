package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ScrollEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.Scrollable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.ProgressIndicator;
   import com.edgebee.atlas.ui.skins.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TileList extends Canvas implements Scrollable
   {
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL:String = "vertical";
      
      public static const CHANGE:String = "change";
       
      
      private var _rendererProps:Object;
      
      private var _sortFunc:Function;
      
      private var _filterFunc:Function;
      
      private var _canUnselect:Boolean = false;
      
      private var _direction:String = "horizontal";
      
      private var _renderer:Class;
      
      private var _sourceDataProvider:ArrayCollection;
      
      private var _dataProvider:ArrayCollection;
      
      private var _heightInRows:Number = NaN;
      
      private var _widthInColumns:Number = NaN;
      
      private var _currentStartIndex:int = 0;
      
      private var _startIndex:int = 0;
      
      private var _scrollDirection:int = 0;
      
      private var _selectable:Boolean = true;
      
      private var _showSelection:Boolean = true;
      
      private var _showHighlight:Boolean = true;
      
      private var _highlightable:Boolean = true;
      
      private var _selected:Object;
      
      private var _selectedListItem:Listable;
      
      private var _highlightedListItem:Listable;
      
      private var _stable:Boolean = true;
      
      private var _instanciateFct:Function;
      
      protected var _mainBox:com.edgebee.atlas.ui.containers.Box;
      
      private var _busyOverlay:com.edgebee.atlas.ui.containers.Box;
      
      private var _overStateSkin:Skin;
      
      private var _selectedStateSkin:Skin;
      
      private var _normalStateSkin:Skin;
      
      private var _showBorder:Boolean = true;
      
      private var _animInstance:AnimationInstance;
      
      private var _busyOverlayed:Boolean = false;
      
      private var _progressIndicator:ProgressIndicator;
      
      private var _animated:Boolean = true;
      
      public function TileList(param1:String = "horizontal")
      {
         this._filterFunc = defaultFilterFunc;
         this._instanciateFct = this.defaultInstanciate;
         super();
         this.direction = param1;
         clipContent = true;
         this._dataProvider = new ArrayCollection();
         this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onDataProviderChange);
      }
      
      private static function defaultFilterFunc(param1:*, param2:int, param3:Array) : Boolean
      {
         return true;
      }
      
      override public function get styleClassName() : String
      {
         return "TileList";
      }
      
      override protected function setEnabled(param1:Boolean) : void
      {
         super.setEnabled(param1);
         if(enabled)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseMoveOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseMoveOutHandler);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseMoveOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseMoveOutHandler);
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction != param1)
         {
            this._direction = param1;
            this.reset();
         }
      }
      
      public function get renderer() : Class
      {
         return this._renderer;
      }
      
      public function set renderer(param1:Class) : void
      {
         this._renderer = param1;
         this.reset();
      }
      
      public function get rendererProps() : Object
      {
         return this._rendererProps;
      }
      
      public function set rendererProps(param1:Object) : void
      {
         this._rendererProps = param1;
         this.reset();
      }
      
      public function get sortFunc() : Function
      {
         return this._sortFunc;
      }
      
      public function set sortFunc(param1:Function) : void
      {
         if(this._sortFunc != param1)
         {
            this._sortFunc = param1;
            this.onSourceChange();
         }
      }
      
      public function get filterFunc() : Function
      {
         return this._filterFunc;
      }
      
      public function set filterFunc(param1:Function) : void
      {
         if(this._filterFunc != param1)
         {
            this._filterFunc = param1;
            if(this._filterFunc == null)
            {
               this._filterFunc = defaultFilterFunc;
            }
            this.onSourceChange();
         }
      }
      
      private function onSourceChange(param1:* = null) : void
      {
         var source:Array = null;
         var i:int = 0;
         var event:* = param1;
         source = [];
         var changed:Boolean = false;
         if(this._sourceDataProvider)
         {
            source = this._sourceDataProvider.source.filter(this.filterFunc);
            if(this.sortFunc != null)
            {
               source.sort(this.sortFunc);
            }
            changed = source.length != this._dataProvider.source.length;
            i = 0;
            while(!changed && i < source.length)
            {
               try
               {
                  changed = !(source[i] as Data).equals(this._dataProvider.source[i] as Data);
               }
               catch(error:Error)
               {
                  changed = source[i] != _dataProvider.source[i];
               }
               i++;
            }
         }
         if(changed || !event)
         {
            this._dataProvider.source = source;
            this.reset();
            this.selectedItem = null;
            dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
         }
      }
      
      public function get dataProvider() : ArrayCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:ArrayCollection) : void
      {
         if(this._sourceDataProvider)
         {
            this._sourceDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSourceChange);
            this._sourceDataProvider.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSourceChange);
            this._sourceDataProvider.removeEventListener(Event.CHANGE,this.onSourceChange);
         }
         this._sourceDataProvider = param1;
         if(this._sourceDataProvider)
         {
            this._sourceDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSourceChange);
            this._sourceDataProvider.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSourceChange);
            this._sourceDataProvider.addEventListener(Event.CHANGE,this.onSourceChange);
            this.onSourceChange();
         }
         else
         {
            this._dataProvider.source = [];
            this.reset();
            this.selectedItem = null;
            dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
         }
      }
      
      public function get heightInRows() : uint
      {
         return this._heightInRows;
      }
      
      public function set heightInRows(param1:uint) : void
      {
         if(this._heightInRows != param1)
         {
            this._heightInRows = param1;
            this.reset();
         }
      }
      
      public function get widthInColumns() : uint
      {
         return this._widthInColumns;
      }
      
      public function set widthInColumns(param1:uint) : void
      {
         if(this._widthInColumns != param1)
         {
            this._widthInColumns = param1;
            this.reset();
         }
      }
      
      public function get rowCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.floor(height / this.itemHeight);
         }
         return Math.ceil(height / this.itemHeight);
      }
      
      public function get columnCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.ceil(width / this.itemWidth);
         }
         return Math.floor(width / this.itemWidth);
      }
      
      public function get completeRowCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.floor(height / this.itemHeight);
         }
         return Math.floor(height / this.itemHeight);
      }
      
      public function get completeColumnCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.floor(width / this.itemWidth);
         }
         return Math.floor(width / this.itemWidth);
      }
      
      public function get totalRowCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.floor(this.dataProvider.length / this.columnCount);
         }
         return Math.ceil(this.dataProvider.length / this.columnCount);
      }
      
      public function get totalColumnCount() : uint
      {
         if(this.direction == HORIZONTAL)
         {
            return Math.ceil(this.dataProvider.length / this.rowCount);
         }
         return Math.floor(this.dataProvider.length / this.rowCount);
      }
      
      public function get startIndex() : int
      {
         return this._startIndex;
      }
      
      public function set startIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(this._startIndex != param1)
         {
            _loc2_ = this._startIndex;
            this._startIndex = param1;
            _loc3_ = this.completeRowCount;
            _loc4_ = this.completeColumnCount;
            _loc5_ = _loc3_ * _loc4_;
            if(this._startIndex < 0)
            {
               this._startIndex = 0;
            }
            else if(this._dataProvider.length < _loc5_)
            {
               this._startIndex = 0;
            }
            else if(this.direction == HORIZONTAL)
            {
               _loc6_ = Math.ceil(this.dataProvider.length / _loc3_);
               if(this._startIndex > _loc6_ - _loc4_ + 1)
               {
                  this.startIndex = _loc6_ - _loc4_ + 1;
               }
            }
            else
            {
               _loc7_ = Math.ceil(this.dataProvider.length / _loc4_);
               if(this._startIndex > _loc7_ - _loc3_)
               {
                  this.startIndex = _loc7_ - _loc3_;
               }
            }
            if(this._stable)
            {
               this.update();
            }
         }
      }
      
      public function get canUnselect() : Boolean
      {
         return this._canUnselect;
      }
      
      public function set canUnselect(param1:Boolean) : void
      {
         this._canUnselect = param1;
      }
      
      public function unselect() : void
      {
         if(!this._selectedListItem)
         {
            return;
         }
         this._selectedListItem.selected = false;
         this._selected = null;
         this._selectedListItem = null;
         this.selectedStateSkin.visible = false;
         var _loc1_:Object = new Object();
         _loc1_.selected = this._selected;
         _loc1_.event = null;
         dispatchEvent(new ExtendedEvent(CHANGE,_loc1_));
      }
      
      public function get selectedListItem() : Listable
      {
         return this._selectedListItem;
      }
      
      public function get selectedItem() : Object
      {
         return this._selected;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         var _loc2_:Listable = null;
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         if(enabled)
         {
            if(!this.selectable)
            {
               return;
            }
            if(!this._selected && Boolean(this.selectedStateSkin))
            {
               this.selectedStateSkin.visible = this.showSelection;
            }
            _loc2_ = null;
            _loc3_ = false;
            if(param1)
            {
               _loc5_ = uint(this.dataProvider.getItemIndex(param1));
               _loc6_ = this.completeColumnCount * this.completeRowCount;
               _loc7_ = 0;
               _loc8_ = 0;
               if(this.direction == HORIZONTAL)
               {
                  _loc7_ = this.startIndex * this.completeRowCount;
                  _loc8_ = _loc5_ / this.completeRowCount;
               }
               else
               {
                  _loc7_ = this.startIndex * this.completeColumnCount;
                  _loc8_ = _loc5_ / this.completeColumnCount;
               }
               if(_loc5_ >= _loc7_ && _loc5_ < _loc7_ + _loc6_)
               {
                  _loc2_ = this.findListable(param1);
               }
               else
               {
                  _loc9_ = this.animated;
                  this.animated = false;
                  this.startIndex = _loc8_;
                  this.animated = true;
                  _loc2_ = this.findListable(param1);
                  _loc3_ = true;
               }
            }
            if(Boolean(this._selectedListItem) && this._selectedListItem != _loc2_)
            {
               this._selectedListItem.selected = false;
            }
            this._selectedListItem = _loc2_;
            if(this._selectedListItem)
            {
               this._selectedListItem.selected = true;
               this._selected = this._selectedListItem.listElement;
               this.setSkinOnDisplay(this.selectedStateSkin,_loc2_ as Component);
            }
            else
            {
               this._selected = null;
            }
            (_loc4_ = new Object()).selected = this._selected;
            _loc4_.event = null;
            dispatchEvent(new ExtendedEvent(CHANGE,_loc4_));
            if(_loc3_)
            {
               dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
            }
         }
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         if(this._selectable != param1)
         {
            this._selected = null;
            if(Boolean(this._selectedListItem) && this._selectedListItem.selected)
            {
               this._selectedListItem.selected = false;
               this._selectedListItem = null;
            }
            this._selectable = param1;
            if(this.selectedStateSkin)
            {
               this.selectedStateSkin.visible = false;
            }
         }
      }
      
      public function get showSelection() : Boolean
      {
         return this._showSelection;
      }
      
      public function set showSelection(param1:Boolean) : void
      {
         if(this._showSelection != param1)
         {
            this._showSelection = param1;
            if(this.selectedStateSkin)
            {
               this.selectedStateSkin.visible = this._showSelection;
            }
         }
      }
      
      public function get showHighlight() : Boolean
      {
         return this._showHighlight;
      }
      
      public function set showHighlight(param1:Boolean) : void
      {
         if(this._showHighlight != param1)
         {
            this._showHighlight = param1;
            if(this.overStateSkin)
            {
               this.overStateSkin.visible = this._showHighlight;
            }
         }
      }
      
      public function get highlightable() : Boolean
      {
         return this._highlightable;
      }
      
      public function set highlightable(param1:Boolean) : void
      {
         if(this._highlightable != param1)
         {
            this._highlightable = param1;
            if(this.overStateSkin)
            {
               this.overStateSkin.visible = false;
            }
         }
      }
      
      public function get overStateSkin() : Skin
      {
         return this._overStateSkin;
      }
      
      public function set overStateSkin(param1:Skin) : void
      {
         if(this._overStateSkin)
         {
            removeChild(this._overStateSkin);
         }
         this._overStateSkin = param1;
         if(this._overStateSkin)
         {
            addChildAt(this._overStateSkin,0);
         }
      }
      
      public function get selectedStateSkin() : Skin
      {
         return this._selectedStateSkin;
      }
      
      public function set selectedStateSkin(param1:Skin) : void
      {
         this._selectedStateSkin = param1;
      }
      
      public function get showBorder() : Boolean
      {
         return this._showBorder;
      }
      
      public function set showBorder(param1:Boolean) : void
      {
         this._showBorder = param1;
         if(childrenCreated)
         {
            if(border)
            {
               border.visible = this.showBorder;
            }
         }
      }
      
      public function set instanciateFct(param1:Function) : void
      {
         this._instanciateFct = param1;
      }
      
      public function get scrollStepSize() : Number
      {
         return 1;
      }
      
      public function get scrollPosition() : Number
      {
         return Number(-this.startIndex);
      }
      
      public function set scrollPosition(param1:Number) : void
      {
         this.startIndex = -param1;
      }
      
      public function get scrollMinPosition() : Number
      {
         return 0;
      }
      
      public function get scrollVisibleSize() : Number
      {
         if(this.direction == HORIZONTAL)
         {
            return this.completeColumnCount;
         }
         return this.completeRowCount;
      }
      
      public function get scrollMaxPosition() : Number
      {
         if(this.dataProvider)
         {
            if(this.direction == HORIZONTAL)
            {
               return this.totalColumnCount;
            }
            return this.totalRowCount;
         }
         return 0;
      }
      
      public function get busyOverlayed() : Boolean
      {
         return this._busyOverlayed;
      }
      
      public function set busyOverlayed(param1:Boolean) : void
      {
         this._busyOverlayed = param1;
         this._busyOverlay.visible = this._busyOverlayed;
         this._mainBox.visible = !this._busyOverlayed;
         this._progressIndicator.paused = !this._busyOverlayed;
      }
      
      public function get listables() : Array
      {
         var _loc3_:com.edgebee.atlas.ui.containers.Box = null;
         var _loc4_:uint = 0;
         var _loc5_:Listable = null;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._mainBox.numChildren)
         {
            _loc3_ = this._mainBox.getChildAt(_loc2_) as com.edgebee.atlas.ui.containers.Box;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_) as Listable;
               _loc1_.push(_loc5_);
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(enabled)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseMoveOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseMoveOutHandler);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseMoveOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseMoveOutHandler);
         }
         var _loc1_:Class = getStyle("OverState.Skin",DefaultListOverStateSkin) as Class;
         this.overStateSkin = new _loc1_(this);
         _loc1_ = getStyle("SelectedState.Skin",DefaultListOverStateSkin) as Class;
         this.selectedStateSkin = new _loc1_(this);
         this.overStateSkin.visible = false;
         this.selectedStateSkin.visible = false;
         this._mainBox = new com.edgebee.atlas.ui.containers.Box();
         this._mainBox.name = "TileList:_mainBox";
         this._mainBox.autoSizeChildren = true;
         var _loc2_:com.edgebee.atlas.ui.containers.Box = new com.edgebee.atlas.ui.containers.Box();
         if(this.direction == HORIZONTAL)
         {
            this._mainBox.direction = com.edgebee.atlas.ui.containers.Box.HORIZONTAL;
            this._mainBox.percentWidth = 1;
            _loc2_.direction = com.edgebee.atlas.ui.containers.Box.VERTICAL;
         }
         else
         {
            this._mainBox.direction = com.edgebee.atlas.ui.containers.Box.VERTICAL;
            this._mainBox.percentHeight = 1;
            _loc2_.direction = com.edgebee.atlas.ui.containers.Box.HORIZONTAL;
         }
         addChild(this._mainBox);
         this._busyOverlay = new com.edgebee.atlas.ui.containers.Box(com.edgebee.atlas.ui.containers.Box.HORIZONTAL,com.edgebee.atlas.ui.containers.Box.ALIGN_CENTER,com.edgebee.atlas.ui.containers.Box.ALIGN_MIDDLE);
         this._busyOverlay.percentHeight = this._busyOverlay.percentWidth = 1;
         this._busyOverlay.visible = false;
         this._progressIndicator = new ProgressIndicator();
         this._progressIndicator.width = UIGlobals.relativizeX(32);
         this._progressIndicator.height = UIGlobals.relativizeY(32);
         this._busyOverlay.addChild(this._progressIndicator);
         addChild(this._busyOverlay);
         if(border)
         {
            border.visible = this.showBorder;
         }
         this._mainBox.addChild(_loc2_);
         var _loc3_:Listable = this.instanciate();
         _loc3_.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         _loc3_.addEventListener(Component.RESIZE,this.onRendererResize);
         _loc2_.addChild(_loc3_ as DisplayObject);
         this.reset();
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         this.reset();
      }
      
      public function get animated() : Boolean
      {
         return this._animated;
      }
      
      public function set animated(param1:Boolean) : void
      {
         this._animated = param1;
      }
      
      public function refresh() : void
      {
         this.onSourceChange();
      }
      
      private function instanciate() : Listable
      {
         return this._instanciateFct();
      }
      
      private function defaultInstanciate() : Listable
      {
         var _loc2_:String = null;
         var _loc1_:Listable = new this._renderer();
         if(this.rendererProps)
         {
            for(_loc2_ in this.rendererProps)
            {
               _loc1_[_loc2_] = this.rendererProps[_loc2_];
            }
         }
         return _loc1_;
      }
      
      private function get itemHeight() : Number
      {
         if(!this._mainBox || !this._mainBox.numChildren)
         {
            return 0;
         }
         var _loc1_:Component = (this._mainBox.getChildAt(0) as DisplayObjectContainer).getChildAt(0) as Component;
         if(_loc1_)
         {
            _loc1_.validateNow(false);
         }
         return (this._mainBox.getChildAt(0) as DisplayObjectContainer).getChildAt(0).height;
      }
      
      private function get itemWidth() : Number
      {
         if(!this._mainBox || !this._mainBox.numChildren)
         {
            return 0;
         }
         var _loc1_:Component = (this._mainBox.getChildAt(0) as DisplayObjectContainer).getChildAt(0) as Component;
         if(_loc1_)
         {
            _loc1_.validateNow(false);
         }
         return (this._mainBox.getChildAt(0) as DisplayObjectContainer).getChildAt(0).width;
      }
      
      private function onDataProviderChange(param1:CollectionEvent) : void
      {
         this.reset();
         dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
      }
      
      private function findListable(param1:Object) : Listable
      {
         var _loc3_:com.edgebee.atlas.ui.containers.Box = null;
         var _loc4_:uint = 0;
         var _loc5_:Listable = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._mainBox.numChildren)
         {
            _loc3_ = this._mainBox.getChildAt(_loc2_) as com.edgebee.atlas.ui.containers.Box;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               if((_loc5_ = _loc3_.getChildAt(_loc4_) as Listable).listElement == param1)
               {
                  return _loc5_;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:com.edgebee.atlas.ui.containers.Box = null;
         var _loc5_:Listable = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(!(childrenCreated || childrenCreating) || !this.dataProvider)
         {
            return;
         }
         if(!isNaN(this._heightInRows))
         {
            height = this._heightInRows * this.itemHeight;
         }
         if(!isNaN(this._widthInColumns))
         {
            width = this._widthInColumns * this.itemWidth;
         }
         if(this.direction == HORIZONTAL)
         {
            _loc1_ = Math.min(this.columnCount,this.dataProvider.length);
            _loc3_ = this.rowCount;
            _loc2_ = com.edgebee.atlas.ui.containers.Box.VERTICAL;
            this._mainBox.direction = com.edgebee.atlas.ui.containers.Box.HORIZONTAL;
            this._currentStartIndex = this._startIndex = Math.max(0,Math.min(this._currentStartIndex,this.totalColumnCount - this.columnCount));
         }
         else
         {
            _loc1_ = Math.min(this.rowCount,this.dataProvider.length);
            _loc3_ = this.columnCount;
            _loc2_ = com.edgebee.atlas.ui.containers.Box.HORIZONTAL;
            this._mainBox.direction = com.edgebee.atlas.ui.containers.Box.VERTICAL;
            this._currentStartIndex = this._startIndex = Math.max(0,Math.min(this._currentStartIndex,this.totalRowCount - this.rowCount));
         }
         _loc1_++;
         if(!_loc3_)
         {
            _loc3_++;
         }
         if(this._mainBox.numChildren > _loc1_)
         {
            _loc6_ = uint(this._mainBox.numChildren);
            while(_loc6_ > _loc1_)
            {
               this._mainBox.removeChildAt(this._mainBox.numChildren - 1);
               _loc6_--;
            }
         }
         else
         {
            _loc6_ = uint(this._mainBox.numChildren);
            while(_loc6_ < _loc1_)
            {
               _loc4_ = new com.edgebee.atlas.ui.containers.Box(_loc2_);
               this._mainBox.addChild(_loc4_);
               _loc6_++;
            }
         }
         _loc6_ = 0;
         while(_loc6_ < this._mainBox.numChildren)
         {
            if((_loc4_ = this._mainBox.getChildAt(_loc6_) as com.edgebee.atlas.ui.containers.Box).numChildren > _loc3_)
            {
               _loc7_ = uint(_loc4_.numChildren);
               while(_loc7_ > _loc3_)
               {
                  _loc4_.removeChildAt(this._mainBox.numChildren - 1);
                  _loc7_--;
               }
            }
            else
            {
               _loc7_ = uint(_loc4_.numChildren);
               while(_loc7_ < _loc3_)
               {
                  (_loc5_ = this.instanciate()).addEventListener(MouseEvent.CLICK,this.onMouseClick);
                  _loc5_.addEventListener(Component.RESIZE,this.onRendererResize);
                  _loc4_.addChild(_loc5_ as DisplayObject);
                  _loc7_++;
               }
            }
            _loc6_++;
         }
         this.update();
         if(this.canUnselect)
         {
            this.selectedStateSkin.visible = false;
         }
      }
      
      private function initializeAnimations() : void
      {
         var _loc2_:Track = null;
         var _loc1_:Animation = new Animation();
         if(this.direction == VERTICAL)
         {
            _loc2_ = new Track("y");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(0.25,-this.itemHeight));
         }
         else
         {
            _loc2_ = new Track("x");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(0.25,-this.itemWidth));
         }
         _loc1_.addTrack(_loc2_);
         this._animInstance = this._mainBox.controller.addAnimation(_loc1_);
         this._animInstance.speed = getStyle("AnimationSpeed",1);
         this._animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationFinish);
      }
      
      private function update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:com.edgebee.atlas.ui.containers.Box = null;
         var _loc3_:uint = 0;
         var _loc4_:Listable = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(!(childrenCreated || childrenCreating) || !this.dataProvider)
         {
            return;
         }
         if(!this.animated)
         {
            this._currentStartIndex = this._startIndex;
         }
         if(this._currentStartIndex != this._startIndex)
         {
            this._stable = false;
            if(!this._animInstance)
            {
               this.initializeAnimations();
            }
            if(!this._animInstance.playing)
            {
               if(this._currentStartIndex < this._startIndex)
               {
                  this._scrollDirection = 1;
                  this._animInstance.speed = Math.abs(this._currentStartIndex - this._startIndex) > Math.max(2,this.scrollVisibleSize / 3) ? 1000000000000 : 4;
                  if(!this.animated)
                  {
                     this._animInstance.speed = 1000000000000;
                  }
                  this._animInstance.gotoStartAndPlay();
               }
               else
               {
                  this._scrollDirection = -1;
                  if(this.direction == HORIZONTAL)
                  {
                     _loc1_ = this.rowCount;
                  }
                  else
                  {
                     _loc1_ = this.columnCount;
                  }
                  _loc2_ = this._mainBox.removeChildAt(this._mainBox.numChildren - 1) as com.edgebee.atlas.ui.containers.Box;
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_.numChildren)
                  {
                     if((_loc4_ = _loc2_.getChildAt(_loc3_) as Listable).listElement == this.selectedItem && this.selectable && this.selectedStateSkin && this.selectedStateSkin.parent == _loc4_)
                     {
                        (_loc4_ as Component).removeChild(this.selectedStateSkin);
                     }
                     _loc4_.listElement = this.dataProvider.getItemAt((this._currentStartIndex - 1) * _loc1_ + _loc3_);
                     if(_loc4_.listElement == this.selectedItem && this.selectable && Boolean(this.selectedStateSkin))
                     {
                        this.setSkinOnDisplay(this.selectedStateSkin,_loc4_ as Component);
                     }
                     _loc3_++;
                  }
                  this._mainBox.addChildAt(_loc2_ as DisplayObject,0);
                  this._mainBox.forceRealignNow();
                  this._animInstance.speed = Math.abs(this._currentStartIndex - this._startIndex) > Math.max(2,this.scrollVisibleSize / 3) ? 1000000000000 : 4;
                  if(!this.animated)
                  {
                     this._animInstance.speed = 1000000000000;
                  }
                  this._animInstance.gotoEndAndPlayReversed();
               }
            }
         }
         else
         {
            this._stable = true;
            if(this.direction == HORIZONTAL)
            {
               _loc1_ = this.rowCount;
            }
            else
            {
               _loc1_ = this.columnCount;
            }
            _loc3_ = 0;
            while(_loc3_ < this._mainBox.numChildren)
            {
               _loc2_ = this._mainBox.getChildAt(_loc3_) as com.edgebee.atlas.ui.containers.Box;
               _loc6_ = 0;
               while(_loc6_ < _loc2_.numChildren)
               {
                  _loc4_ = _loc2_.getChildAt(_loc6_) as Listable;
                  if((_loc7_ = (this._currentStartIndex + _loc3_) * _loc1_ + _loc6_) < this.dataProvider.length)
                  {
                     _loc5_ = this.dataProvider.getItemAt(_loc7_);
                  }
                  else
                  {
                     _loc5_ = null;
                  }
                  if(_loc4_.listElement != _loc5_)
                  {
                     _loc4_.listElement = _loc5_;
                  }
                  if(_loc4_.listElement == this.selectedItem && this.selectable && Boolean(this.selectedStateSkin))
                  {
                     this.setSkinOnDisplay(this.selectedStateSkin,_loc4_ as Component);
                  }
                  _loc6_++;
               }
               _loc3_++;
            }
         }
      }
      
      private function onAnimationFinish(param1:AnimationEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:com.edgebee.atlas.ui.containers.Box = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Listable = null;
         var _loc7_:uint = 0;
         this._currentStartIndex += this._scrollDirection;
         if(this._scrollDirection == 1)
         {
            if(this.direction == HORIZONTAL)
            {
               _loc2_ = this.rowCount;
            }
            else
            {
               _loc2_ = this.columnCount;
            }
            _loc3_ = this._mainBox.removeChildAt(0) as com.edgebee.atlas.ui.containers.Box;
            _loc5_ = 0;
            while(_loc5_ < _loc3_.numChildren)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_) as Listable;
               _loc7_ = (this._currentStartIndex + this._mainBox.numChildren) * _loc2_ + _loc5_;
               if(_loc6_.listElement == this.selectedItem && this.selectable && this.selectedStateSkin && this.selectedStateSkin.parent == _loc6_)
               {
                  (_loc6_ as Component).removeChild(this.selectedStateSkin);
               }
               if(_loc7_ < this.dataProvider.length)
               {
                  _loc4_ = this.dataProvider.getItemAt(_loc7_);
               }
               else
               {
                  _loc4_ = null;
               }
               if(_loc6_.listElement != _loc4_)
               {
                  _loc6_.listElement = _loc4_;
               }
               if(_loc6_.listElement == this.selectedItem && this.selectable && Boolean(this.selectedStateSkin))
               {
                  this.setSkinOnDisplay(this.selectedStateSkin,_loc6_ as Component);
               }
               _loc5_++;
            }
            this._mainBox.addChildAt(_loc3_,this._mainBox.numChildren);
            this._mainBox.forceRealignNow();
            if(this.direction == HORIZONTAL)
            {
               this._mainBox.x = 0;
            }
            else
            {
               this._mainBox.y = 0;
            }
         }
         this.update();
      }
      
      private function setSkinOnDisplay(param1:Component, param2:Component) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.x = param1.y = 0;
         param1.height = param2.height;
         param1.width = param2.width;
         param1.invalidateDisplayList();
         param2.addChildAt(param1,0);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Listable = null;
         var _loc3_:Object = null;
         if(enabled)
         {
            if(!this.selectable)
            {
               return;
            }
            if(!this._selected)
            {
               this.selectedStateSkin.visible = this.showSelection;
            }
            _loc2_ = param1.currentTarget as Listable;
            if(this._selectedListItem)
            {
               if(this._selectedListItem != _loc2_)
               {
                  this._selectedListItem.selected = false;
               }
               else if(this.canUnselect)
               {
                  this._selectedListItem.selected = false;
                  _loc2_ = null;
               }
            }
            this._selectedListItem = _loc2_;
            if(_loc2_)
            {
               this._selectedListItem.selected = true;
               this._selected = this._selectedListItem.listElement;
               this.setSkinOnDisplay(this.selectedStateSkin,param1.currentTarget as Component);
            }
            else
            {
               this._selected = null;
               this.selectedStateSkin.visible = false;
            }
            _loc3_ = new Object();
            _loc3_.selected = this._selected;
            _loc3_.event = param1;
            dispatchEvent(new ExtendedEvent(CHANGE,_loc3_));
         }
      }
      
      private function mouseMoveOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Listable = null;
         if(!this.highlightable)
         {
            return;
         }
         var _loc3_:DisplayObject = param1.target as DisplayObject;
         if(_loc3_ is this._renderer)
         {
            _loc2_ = _loc3_ as Listable;
         }
         else
         {
            while(Boolean(_loc3_) && _loc3_ != this)
            {
               if(_loc3_ is this._renderer)
               {
                  _loc2_ = _loc3_ as Listable;
                  break;
               }
               _loc3_ = _loc3_.parent;
            }
         }
         if(_loc2_)
         {
            this._highlightedListItem = _loc2_;
            this._highlightedListItem.highlighted = true;
            if(this.showHighlight)
            {
               this.setSkinOnDisplay(this.overStateSkin,_loc3_ as Component);
               this.overStateSkin.visible = true;
            }
         }
      }
      
      private function mouseMoveOutHandler(param1:MouseEvent) : void
      {
         if(this._highlightedListItem)
         {
            this.overStateSkin.visible = false;
            this._highlightedListItem.highlighted = false;
         }
      }
      
      private function onRendererResize(param1:Event) : void
      {
         this.reset();
      }
   }
}
