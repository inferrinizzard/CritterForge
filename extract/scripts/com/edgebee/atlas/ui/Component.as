package com.edgebee.atlas.ui
{
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.animation.IAnimatable;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.interfaces.IKbNavigatable;
   import com.edgebee.atlas.interfaces.INamed;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.util.BevelProxy;
   import com.edgebee.atlas.util.BlurProxy;
   import com.edgebee.atlas.util.ColorMatrix;
   import com.edgebee.atlas.util.ColorTransformProxy;
   import com.edgebee.atlas.util.DropShadowProxy;
   import com.edgebee.atlas.util.FilterProxy;
   import com.edgebee.atlas.util.GlowProxy;
   import com.edgebee.atlas.util.GradientGlowProxy;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.ui.Keyboard;
   
   public class Component extends Sprite implements IStylable, IAnimatable, IKbNavigatable, INamed
   {
      
      public static const CHILDREN_CREATED:String = "CHILDREN_CREATED";
      
      public static const RESIZE:String = "RESIZE";
      
      public static const X_CHANGED:String = "X_CHANGED";
      
      public static const Y_CHANGED:String = "Y_CHANGED";
      
      public static const ENABLED_CHANGE:String = "ENABLED_CHANGE";
       
      
      private var _disableOnCriticalComms:Boolean = false;
      
      private var _hasKbFocus:Boolean = false;
      
      private var _kbFirstNode:IKbNavigatable;
      
      private var _kbUpNode:IKbNavigatable;
      
      private var _kbDownNode:IKbNavigatable;
      
      private var _kbLeftNode:IKbNavigatable;
      
      private var _kbRightNode:IKbNavigatable;
      
      private var _kbAnchorUpNode:IKbNavigatable;
      
      private var _kbAnchorDownNode:IKbNavigatable;
      
      private var _kbAnchorLeftNode:IKbNavigatable;
      
      private var _kbAnchorRightNode:IKbNavigatable;
      
      private var _upLink:IKbNavigatable;
      
      private var _downLink:IKbNavigatable;
      
      private var _leftLink:IKbNavigatable;
      
      private var _rightLink:IKbNavigatable;
      
      private var _includeInLayout:Boolean = true;
      
      private var _childrenCreationDeferred:Boolean = false;
      
      private var _createChildrenOnVisible:Boolean = false;
      
      public var updateCompletePending:Boolean = false;
      
      protected var hasChildrenNotifyValidation:Boolean = false;
      
      private var _measuredWidth:Number = 0;
      
      private var _measuredHeight:Number = 0;
      
      private var _measuredMinWidth:Number = NaN;
      
      private var _measuredMinHeight:Number = NaN;
      
      private var _name:String;
      
      protected var _childrenCreated:Boolean = false;
      
      private var _childrenCreating:Boolean = false;
      
      private var _width:Number = NaN;
      
      private var _height:Number = NaN;
      
      private var _percentWidth:Number = 0;
      
      private var _percentHeight:Number = 0;
      
      private var _explicitWidth:Number = NaN;
      
      private var _explicitHeight:Number = NaN;
      
      private var _unlimitedMeasuredWidth:Number = 0;
      
      private var _unlimitedMeasuredHeight:Number = 0;
      
      private var _explicitMinWidth:Number = NaN;
      
      private var _explicitMinHeight:Number = NaN;
      
      private var _explicitMaxWidth:Number = NaN;
      
      private var _explicitMaxHeight:Number = NaN;
      
      private var _measuredMaxWidth:Number = NaN;
      
      private var _measuredMaxHeight:Number = NaN;
      
      private var _oldMinWidth:Number = NaN;
      
      private var _oldMinHeight:Number = NaN;
      
      private var _oldMaxWidth:Number = NaN;
      
      private var _oldMaxHeight:Number = NaN;
      
      private var _oldExplicitWidth:Number = NaN;
      
      private var _oldExplicitHeight:Number = NaN;
      
      private var _parent:WeakReference;
      
      private var _nestLevel:int = 0;
      
      private var _enabled:Boolean = true;
      
      private var _parentEnabled:Boolean = true;
      
      private var _invalidSize:Boolean = false;
      
      private var _invalidDisplayList:Boolean = false;
      
      private var _initialized:Boolean = false;
      
      private var _processedDescriptors:Boolean = false;
      
      private var _visible:Boolean = true;
      
      private var _useMouseScreen:Boolean = false;
      
      private var _clipContent:Boolean = false;
      
      private var _animationController:Controller;
      
      private var _colorMatrix:ColorMatrix;
      
      private var _blurProxy:BlurProxy;
      
      private var _glowProxy:GlowProxy;
      
      private var _bevelProxy:BevelProxy;
      
      private var _gradientGlowProxy:GradientGlowProxy;
      
      private var _colorTransformProxy:ColorTransformProxy;
      
      private var _dropShadowProxy:DropShadowProxy;
      
      private var _styles:Object;
      
      private var _toolTip:Object;
      
      public function Component()
      {
         this._parent = new WeakReference(null,DisplayObjectContainer);
         this._styles = {};
         super();
         this._width = super.width;
         this._height = super.height;
         this._colorMatrix = new ColorMatrix();
         this._blurProxy = new BlurProxy();
         this._glowProxy = new GlowProxy();
         this._bevelProxy = new BevelProxy();
         this._gradientGlowProxy = new GradientGlowProxy();
         this._colorTransformProxy = new ColorTransformProxy();
         this._dropShadowProxy = new DropShadowProxy();
         this.colorMatrix.addEventListener(Event.CHANGE,this.onColorMatrixChange,false,0,true);
         this.blurProxy.addEventListener(Event.CHANGE,this.onFilterProxyChange,false,0,true);
         this.glowProxy.addEventListener(Event.CHANGE,this.onFilterProxyChange,false,0,true);
         this.bevelProxy.addEventListener(Event.CHANGE,this.onFilterProxyChange,false,0,true);
         this.gradientGlowProxy.addEventListener(Event.CHANGE,this.onFilterProxyChange,false,0,true);
         this.colorTransformProxy.addEventListener(Event.CHANGE,this.onColorTransformProxyChange,false,0,true);
         this.dropShadowProxy.addEventListener(Event.CHANGE,this.onFilterProxyChange,false,0,true);
         this.enabled = true;
         tabEnabled = false;
         this._animationController = new Controller(this);
         super.visible = false;
      }
      
      public function get disableOnCriticalComms() : Boolean
      {
         return this._disableOnCriticalComms;
      }
      
      public function set disableOnCriticalComms(param1:Boolean) : void
      {
         if(this._disableOnCriticalComms != param1)
         {
            this._disableOnCriticalComms = param1;
            if(this.disableOnCriticalComms)
            {
               UIGlobals.root.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
               this.enabled = UIGlobals.root.client.criticalComms == 0;
            }
            else
            {
               UIGlobals.root.client.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
            }
         }
      }
      
      override public function set name(param1:String) : void
      {
         var _loc2_:String = null;
         if(super.name != param1)
         {
            _loc2_ = name;
            super.name = param1;
            UIGlobals.namedObjects.add(this,_loc2_);
         }
      }
      
      override public function set x(param1:Number) : void
      {
         if(super.x == param1)
         {
            return;
         }
         super.x = param1;
         dispatchEvent(new Event(X_CHANGED));
      }
      
      override public function set y(param1:Number) : void
      {
         if(super.y == param1)
         {
            return;
         }
         super.y = param1;
         dispatchEvent(new Event(Y_CHANGED));
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         var _loc1_:DisplayObjectContainer = this._parent.get() as DisplayObjectContainer;
         return !!_loc1_ ? _loc1_ : super.parent;
      }
      
      override public function set doubleClickEnabled(param1:Boolean) : void
      {
         if(doubleClickEnabled != param1)
         {
            super.doubleClickEnabled = param1;
            this.setChildrenDoubleClickEnable(param1);
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:Component = null;
         this._visible = param1;
         if(this.createChildrenOnVisible && this._childrenCreationDeferred && param1)
         {
            this.initialized = false;
            this._childrenCreated = false;
            this._childrenCreating = false;
            this.initialize();
            this._childrenCreationDeferred = false;
         }
         if(this.initialized && super.visible != param1)
         {
            this.doSetVisible(param1);
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren && !_loc2_.layoutInvisibleChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      protected function doSetVisible(param1:Boolean) : void
      {
         super.visible = param1;
         dispatchEvent(PropertyChangeEvent.create(this,"visible",!param1,param1));
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         this.addingChild(param1);
         super.addChild(param1);
         this.childAdded(param1);
         return param1;
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         this.addingChild(param1);
         super.addChildAt(param1,param2);
         this.childAdded(param1);
         return param1;
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.removeChild(param1);
         var _loc3_:Component = _loc2_ as Component;
         if(_loc3_)
         {
            _loc3_.setParent(null);
            if(this.layoutChildren && _loc3_.includeInLayout)
            {
               this.invalidateSize();
            }
         }
         return _loc2_;
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         var _loc2_:DisplayObject = super.removeChildAt(param1);
         var _loc3_:Component = _loc2_ as Component;
         if(_loc3_)
         {
            _loc3_.setParent(null);
            if(this.layoutChildren && _loc3_.includeInLayout)
            {
               this.invalidateSize();
            }
         }
         return _loc2_;
      }
      
      public function removeAllChildren() : void
      {
         while(numChildren)
         {
            this.removeChildAt(0);
         }
      }
      
      private function addingChild(param1:DisplayObject) : void
      {
         var _loc2_:Component = param1 as Component;
         if(_loc2_)
         {
            _loc2_.nestLevel = this.nestLevel + 1;
            _loc2_.setParent(this);
         }
      }
      
      private function childAdded(param1:DisplayObject) : void
      {
         var _loc2_:Component = param1 as Component;
         if(_loc2_)
         {
            if(!_loc2_.initialized)
            {
               _loc2_.initialize();
            }
         }
         if(doubleClickEnabled && param1 is InteractiveObject)
         {
            (param1 as InteractiveObject).doubleClickEnabled = doubleClickEnabled;
         }
      }
      
      private function setParent(param1:DisplayObjectContainer) : void
      {
         if(!param1)
         {
            if(this._parent.get())
            {
               this._parent.get().removeEventListener(ENABLED_CHANGE,this.onParentEnabledChange);
               this.parentEnabled = true;
            }
            this._parent.reset(null);
            this._nestLevel = 0;
         }
         else if(param1 is Component)
         {
            if(this._parent.get())
            {
               this._parent.get().removeEventListener(ENABLED_CHANGE,this.onParentEnabledChange);
            }
            this._parent.reset(param1);
            this._parent.get().addEventListener(ENABLED_CHANGE,this.onParentEnabledChange);
            this.parentEnabled = (this._parent.get() as Component).enabled;
         }
         else
         {
            if(this._parent.get())
            {
               this._parent.get().removeEventListener(ENABLED_CHANGE,this.onParentEnabledChange);
               this.parentEnabled = true;
            }
            this._parent.reset(param1.parent);
         }
      }
      
      private function get parentEnabled() : Boolean
      {
         return this._parentEnabled;
      }
      
      private function set parentEnabled(param1:Boolean) : void
      {
         if(this._parentEnabled != param1)
         {
            this._parentEnabled = param1;
            this.setEnabled(this.enabled);
         }
      }
      
      private function onParentEnabledChange(param1:Event) : void
      {
         var _loc2_:Boolean = (this._parent.get() as Component).enabled;
         this.parentEnabled = _loc2_;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get hasKbFocus() : Boolean
      {
         return this._hasKbFocus;
      }
      
      public function set hasKbFocus(param1:Boolean) : void
      {
         if(this.isMetaKbNode)
         {
            throw new Error("Cannot set kb focus to a meta node");
         }
         if(param1 != this.hasKbFocus)
         {
            this._hasKbFocus = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"hasKbFocus",!this.hasKbFocus,this.hasKbFocus));
         }
      }
      
      public function get kbFirstNode() : IKbNavigatable
      {
         if(this._kbFirstNode)
         {
            return this._kbFirstNode.kbFirstNode;
         }
         return this;
      }
      
      public function set kbFirstNode(param1:IKbNavigatable) : void
      {
         this._kbFirstNode = param1;
      }
      
      public function get kbUpNode() : IKbNavigatable
      {
         if(this._kbUpNode)
         {
            return this._kbUpNode.kbUpNode;
         }
         return this;
      }
      
      public function set kbUpNode(param1:IKbNavigatable) : void
      {
         this._kbUpNode = param1;
      }
      
      public function get kbDownNode() : IKbNavigatable
      {
         if(this._kbDownNode)
         {
            return this._kbDownNode.kbDownNode;
         }
         return this;
      }
      
      public function set kbDownNode(param1:IKbNavigatable) : void
      {
         this._kbDownNode = param1;
      }
      
      public function get kbLeftNode() : IKbNavigatable
      {
         if(this._kbLeftNode)
         {
            return this._kbLeftNode.kbLeftNode;
         }
         return this;
      }
      
      public function set kbLeftNode(param1:IKbNavigatable) : void
      {
         this._kbLeftNode = param1;
      }
      
      public function get kbRightNode() : IKbNavigatable
      {
         if(this._kbRightNode)
         {
            return this._kbRightNode.kbRightNode;
         }
         return this;
      }
      
      public function set kbRightNode(param1:IKbNavigatable) : void
      {
         this._kbRightNode = param1;
      }
      
      public function get kbAnchorUpNode() : IKbNavigatable
      {
         return this._kbAnchorUpNode;
      }
      
      public function set kbAnchorUpNode(param1:IKbNavigatable) : void
      {
         this._kbAnchorUpNode = param1;
      }
      
      public function get kbAnchorDownNode() : IKbNavigatable
      {
         return this._kbAnchorDownNode;
      }
      
      public function set kbAnchorDownNode(param1:IKbNavigatable) : void
      {
         this._kbAnchorDownNode = param1;
      }
      
      public function get kbAnchorLeftNode() : IKbNavigatable
      {
         return this._kbAnchorLeftNode;
      }
      
      public function set kbAnchorLeftNode(param1:IKbNavigatable) : void
      {
         this._kbAnchorLeftNode = param1;
      }
      
      public function get kbAnchorRightNode() : IKbNavigatable
      {
         return this._kbAnchorRightNode;
      }
      
      public function set kbAnchorRightNode(param1:IKbNavigatable) : void
      {
         this._kbAnchorRightNode = param1;
      }
      
      public function get isMetaKbNode() : Boolean
      {
         return this.kbFirstNode != this;
      }
      
      public function kbLink(param1:IKbNavigatable, param2:uint, param3:Boolean = true) : void
      {
         if(param2 == Keyboard.UP)
         {
            this._upLink = param1;
            if(param3)
            {
               param1.kbLink(this,Keyboard.DOWN,false);
            }
         }
         else if(param2 == Keyboard.DOWN)
         {
            this._downLink = param1;
            if(param3)
            {
               param1.kbLink(this,Keyboard.UP,false);
            }
         }
         else if(param2 == Keyboard.LEFT)
         {
            this._leftLink = param1;
            if(param3)
            {
               param1.kbLink(this,Keyboard.RIGHT,false);
            }
         }
         else
         {
            if(param2 != Keyboard.RIGHT)
            {
               throw new Error("Invalid direction: " + param2.toString());
            }
            this._rightLink = param1;
            if(param3)
            {
               param1.kbLink(this,Keyboard.LEFT,false);
            }
         }
      }
      
      public function kbAnchor(param1:IKbNavigatable, param2:uint) : void
      {
         if(param2 == Keyboard.UP)
         {
            param1.kbUpNode = this;
            this.kbAnchorUpNode = param1;
         }
         else if(param2 == Keyboard.DOWN)
         {
            param1.kbDownNode = this;
            this.kbAnchorDownNode = param1;
         }
         else if(param2 == Keyboard.LEFT)
         {
            param1.kbLeftNode = this;
            this.kbAnchorLeftNode = param1;
         }
         else if(param2 == Keyboard.RIGHT)
         {
            param1.kbRightNode = this;
            this.kbAnchorRightNode = param1;
         }
      }
      
      public function getKbNode(param1:uint) : IKbNavigatable
      {
         if(param1 == Keyboard.UP)
         {
            return this.upLink;
         }
         if(param1 == Keyboard.DOWN)
         {
            return this.downLink;
         }
         if(param1 == Keyboard.LEFT)
         {
            return this.leftLink;
         }
         if(param1 == Keyboard.RIGHT)
         {
            return this.rightLink;
         }
         throw new Error("unsupported direction: " + param1.toString());
      }
      
      protected function get upLink() : IKbNavigatable
      {
         if(this._upLink)
         {
            return this._upLink.kbDownNode;
         }
         if(this.kbAnchorUpNode)
         {
            return this.kbAnchorUpNode.getKbNode(Keyboard.UP).kbDownNode;
         }
         return this;
      }
      
      protected function get downLink() : IKbNavigatable
      {
         if(this._downLink)
         {
            return this._downLink.kbUpNode;
         }
         if(this.kbAnchorDownNode)
         {
            return this.kbAnchorDownNode.getKbNode(Keyboard.DOWN).kbUpNode;
         }
         return this;
      }
      
      protected function get leftLink() : IKbNavigatable
      {
         if(this._leftLink)
         {
            return this._leftLink.kbRightNode;
         }
         if(this.kbAnchorLeftNode)
         {
            return this.kbAnchorLeftNode.getKbNode(Keyboard.LEFT).kbRightNode;
         }
         return this;
      }
      
      protected function get rightLink() : IKbNavigatable
      {
         if(this._rightLink)
         {
            return this._rightLink.kbLeftNode;
         }
         if(this.kbAnchorRightNode)
         {
            return this.kbAnchorRightNode.getKbNode(Keyboard.RIGHT).kbLeftNode;
         }
         return this;
      }
      
      public function kbMove(param1:uint) : IKbNavigatable
      {
         var _loc2_:IKbNavigatable = null;
         if(param1 == Keyboard.UP)
         {
            _loc2_ = this.upLink;
         }
         else if(param1 == Keyboard.DOWN)
         {
            _loc2_ = this.downLink;
         }
         else if(param1 == Keyboard.LEFT)
         {
            _loc2_ = this.leftLink;
         }
         else
         {
            if(param1 != Keyboard.RIGHT)
            {
               throw new Error("Invalid direction: " + param1.toString());
            }
            _loc2_ = this.rightLink;
         }
         if(_loc2_ != this)
         {
            this.hasKbFocus = false;
            _loc2_.hasKbFocus = true;
         }
         return _loc2_;
      }
      
      public function kbActivate() : void
      {
         throw new Error("must override");
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function set initialized(param1:Boolean) : void
      {
         this._initialized = param1;
         if(param1)
         {
            this.visible = this._visible;
         }
      }
      
      public function get processedDescriptors() : Boolean
      {
         return this._processedDescriptors;
      }
      
      public function set processedDescriptors(param1:Boolean) : void
      {
         this._processedDescriptors = param1;
      }
      
      public function initialize() : void
      {
         if(!this.initialized)
         {
            if(!this.childrenCreated && !this.childrenCreating)
            {
               if(this._childrenCreationDeferred || !this.createChildrenOnVisible || visible)
               {
                  this.createChildren();
               }
               else
               {
                  this._childrenCreationDeferred = true;
               }
               this._childrenCreated = true;
               this._childrenCreating = false;
               dispatchEvent(new Event(CHILDREN_CREATED));
               this.setChildrenDoubleClickEnable(doubleClickEnabled);
            }
            this.invalidateSize();
            this.invalidateDisplayList();
            this.initializationComplete();
         }
      }
      
      protected function initializationComplete() : void
      {
         this.processedDescriptors = true;
      }
      
      public function get nestLevel() : int
      {
         return this._nestLevel;
      }
      
      public function set nestLevel(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Component = null;
         if(this._nestLevel != param1)
         {
            _loc2_ = this._nestLevel;
            this._nestLevel = param1;
            _loc3_ = 0;
            while(_loc3_ < numChildren)
            {
               if(_loc4_ = getChildAt(_loc3_) as Component)
               {
                  _loc4_.nestLevel = this.nestLevel + 1;
               }
               _loc3_++;
            }
            if((this.childrenCreated || this.childrenCreating) && (this._invalidSize || this._invalidDisplayList))
            {
               UIGlobals.layoutManager.renest(this,_loc2_,this.nestLevel);
            }
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled && this.parentEnabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            this.setEnabled(this.enabled);
         }
      }
      
      protected function setEnabled(param1:Boolean) : void
      {
         this.invalidateDisplayList();
         dispatchEvent(new Event(ENABLED_CHANGE));
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent != param1)
         {
            if(this._clipContent && Boolean(mask))
            {
               this.removeChild(mask);
               mask = null;
            }
            this._clipContent = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get layoutChildren() : Boolean
      {
         return false;
      }
      
      public function get layoutInvisibleChildren() : Boolean
      {
         return true;
      }
      
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(param1:Boolean) : void
      {
         this._includeInLayout = param1;
      }
      
      public function get createChildrenOnVisible() : Boolean
      {
         return this._createChildrenOnVisible;
      }
      
      public function set createChildrenOnVisible(param1:Boolean) : void
      {
         this._createChildrenOnVisible = param1;
      }
      
      public function get useMouseScreen() : Boolean
      {
         return this._useMouseScreen;
      }
      
      public function set useMouseScreen(param1:Boolean) : void
      {
         if(this._useMouseScreen != param1)
         {
            this._useMouseScreen = param1;
            this.invalidateDisplayList();
         }
      }
      
      public function get toolTip() : Object
      {
         return this._toolTip;
      }
      
      public function set toolTip(param1:Object) : void
      {
         if(this._toolTip != param1)
         {
            if(!this._toolTip)
            {
               UIGlobals.toolTipManager.addComponent(this);
            }
            else if(!param1)
            {
               UIGlobals.toolTipManager.removeComponent(this);
            }
            this._toolTip = param1;
         }
      }
      
      public function get childrenCreated() : Boolean
      {
         return this._childrenCreated;
      }
      
      public function get childrenCreating() : Boolean
      {
         return this._childrenCreating;
      }
      
      public function invalidateSize() : void
      {
         if(!this._invalidSize && (this.childrenCreated || this.childrenCreating))
         {
            UIGlobals.layoutManager.invalidateSize(this);
            this._invalidSize = true;
         }
      }
      
      public function validateSize() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Component = null;
         if(this._invalidSize)
         {
            _loc1_ = this.measureSizes();
            if(_loc1_)
            {
               this.setActualSize(this.getExplicitOrMeasuredWidth(),this.getExplicitOrMeasuredHeight());
               _loc2_ = this.parent as Component;
               if(this.includeInLayout && Boolean(_loc2_))
               {
                  _loc2_.childrenNotifyValidation(this);
               }
            }
            this.validateChildren();
         }
      }
      
      public function invalidateDisplayList() : void
      {
         if(!this._invalidDisplayList && (this.childrenCreated || this.childrenCreating))
         {
            UIGlobals.layoutManager.invalidateDisplayList(this);
            this._invalidDisplayList = true;
         }
      }
      
      public function validateDisplayList() : void
      {
         if(this._invalidDisplayList)
         {
            this.updateDisplayList(this.width,this.height);
            this._invalidDisplayList = false;
         }
      }
      
      public function validateNow(param1:Boolean) : void
      {
         UIGlobals.layoutManager.validateNow(this,param1);
      }
      
      protected function childrenNotifyValidation(param1:Component) : void
      {
         this.hasChildrenNotifyValidation = true;
         if(this.layoutChildren)
         {
            this.invalidateSize();
            this.invalidateDisplayList();
         }
      }
      
      protected function validateChildren() : void
      {
         this.hasChildrenNotifyValidation = false;
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         if(this._width != param1)
         {
            this._width = param1;
            _loc3_ = true;
         }
         if(this._height != param2)
         {
            this._height = param2;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            this.sizeChanged();
         }
      }
      
      protected function sizeChanged() : void
      {
         dispatchEvent(new Event(RESIZE));
         this.invalidateDisplayList();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this.explicitWidth != param1)
         {
            this.explicitWidth = param1;
            this.invalidateSize();
         }
         if(this._width != param1)
         {
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
            this._width = param1;
            this.sizeChanged();
         }
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this.explicitHeight != param1)
         {
            this.explicitHeight = param1;
            this.invalidateSize();
         }
         if(this._height != param1)
         {
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
            this._height = param1;
            this.sizeChanged();
         }
      }
      
      public function get unlimitedWidth() : Number
      {
         if(!isNaN(this.explicitWidth))
         {
            return this.explicitWidth;
         }
         return this._unlimitedMeasuredWidth;
      }
      
      public function get unlimitedHeight() : Number
      {
         if(!isNaN(this.explicitHeight))
         {
            return this.explicitHeight;
         }
         return this._unlimitedMeasuredHeight;
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitWidth != param1)
         {
            if(!isNaN(param1))
            {
               this._percentWidth = 0;
            }
            this._explicitWidth = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitHeight != param1)
         {
            if(!isNaN(param1))
            {
               this._percentHeight = 0;
            }
            this._explicitHeight = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get minWidth() : Number
      {
         if(!isNaN(this.explicitMinWidth))
         {
            return this.explicitMinWidth;
         }
         return this.measuredMinWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         if(this.explicitMinWidth != param1)
         {
            this.explicitMinWidth = param1;
         }
      }
      
      public function get minHeight() : Number
      {
         if(!isNaN(this.explicitMinHeight))
         {
            return this.explicitMinHeight;
         }
         return this.measuredMinHeight;
      }
      
      public function set minHeight(param1:Number) : void
      {
         if(this.explicitMinHeight != param1)
         {
            this.explicitMinHeight = param1;
         }
      }
      
      public function get maxWidth() : Number
      {
         if(!isNaN(this.explicitMaxWidth))
         {
            return this.explicitMaxWidth;
         }
         return Number.MAX_VALUE;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         if(this.explicitMaxWidth != param1)
         {
            this.explicitMaxWidth = param1;
         }
      }
      
      public function get maxHeight() : Number
      {
         if(!isNaN(this.explicitMaxHeight))
         {
            return this.explicitMaxHeight;
         }
         return Number.MAX_VALUE;
      }
      
      public function set maxHeight(param1:Number) : void
      {
         if(this.explicitMaxHeight != param1)
         {
            this.explicitMaxHeight = param1;
         }
      }
      
      public function get explicitMinWidth() : Number
      {
         return this._explicitMinWidth;
      }
      
      public function set explicitMinWidth(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitMinWidth != param1)
         {
            this._explicitMinWidth = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get explicitMinHeight() : Number
      {
         return this._explicitMinHeight;
      }
      
      public function set explicitMinHeight(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitMinHeight != param1)
         {
            this._explicitMinHeight = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function set explicitMaxWidth(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitMaxWidth != param1)
         {
            this._explicitMaxWidth = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function set explicitMaxHeight(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._explicitMaxHeight != param1)
         {
            this._explicitMaxHeight = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get percentWidth() : Number
      {
         return this._percentWidth;
      }
      
      public function set percentWidth(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._percentWidth != param1)
         {
            this._explicitWidth = NaN;
            this._percentWidth = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get percentHeight() : Number
      {
         return this._percentHeight;
      }
      
      public function set percentHeight(param1:Number) : void
      {
         var _loc2_:Component = null;
         if(this._percentHeight != param1)
         {
            this._explicitHeight = NaN;
            this._percentHeight = param1;
            this.invalidateSize();
            _loc2_ = this.parent as Component;
            if(this.includeInLayout && _loc2_ && _loc2_.layoutChildren)
            {
               _loc2_.invalidateSize();
               _loc2_.invalidateDisplayList();
            }
         }
      }
      
      public function get measuredWidth() : Number
      {
         return this._measuredWidth;
      }
      
      public function set measuredWidth(param1:Number) : void
      {
         this._measuredWidth = param1;
      }
      
      public function get measuredHeight() : Number
      {
         return this._measuredHeight;
      }
      
      public function set measuredHeight(param1:Number) : void
      {
         this._measuredHeight = param1;
      }
      
      public function get measuredMinWidth() : Number
      {
         return this._measuredMinWidth;
      }
      
      public function set measuredMinWidth(param1:Number) : void
      {
         this._measuredMinWidth = param1;
      }
      
      public function get measuredMinHeight() : Number
      {
         return this._measuredMinHeight;
      }
      
      public function set measuredMinHeight(param1:Number) : void
      {
         this._measuredMinHeight = param1;
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         return !isNaN(this.explicitWidth) ? this.explicitWidth : this.measuredWidth;
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         return !isNaN(this.explicitHeight) ? this.explicitHeight : this.measuredHeight;
      }
      
      public function get unreservedWidth() : Number
      {
         return this.width;
      }
      
      public function set unreservedWidth(param1:Number) : void
      {
      }
      
      public function get unreservedHeight() : Number
      {
         return this.height;
      }
      
      public function set unreservedHeight(param1:Number) : void
      {
      }
      
      public function get colorMatrix() : ColorMatrix
      {
         return this._colorMatrix;
      }
      
      public function get blurProxy() : BlurProxy
      {
         return this._blurProxy;
      }
      
      public function get glowProxy() : GlowProxy
      {
         return this._glowProxy;
      }
      
      public function get bevelProxy() : BevelProxy
      {
         return this._bevelProxy;
      }
      
      public function get gradientGlowProxy() : GradientGlowProxy
      {
         return this._gradientGlowProxy;
      }
      
      public function get colorTransformProxy() : ColorTransformProxy
      {
         return this._colorTransformProxy;
      }
      
      public function get dropShadowProxy() : DropShadowProxy
      {
         return this._dropShadowProxy;
      }
      
      public function get styleClassName() : String
      {
         return "";
      }
      
      public function get inheritStyles() : Boolean
      {
         return true;
      }
      
      public function getStyle(param1:String, param2:* = null, param3:Boolean = true) : *
      {
         var _loc4_:Array = param1.split(".");
         var _loc5_:String = String(_loc4_[_loc4_.length - 1]);
         if(Boolean(this._styles) && this._styles.hasOwnProperty(param1))
         {
            return this._styles[param1];
         }
         if(Boolean(this._styles) && this._styles.hasOwnProperty(_loc5_))
         {
            return this._styles[_loc5_];
         }
         if(this.inheritStyles && param3 && this is Skin && Boolean((this as Skin).component))
         {
            return (this as Skin).component.getStyle(param1,param2);
         }
         return UIGlobals.styleManager.getStyle(this.styleClassName + "." + param1,param2);
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc3_:Array = param1.split(".");
         if(_loc3_[0] == this.styleClassName)
         {
            _loc5_ = _loc3_.slice(1).join(".");
            if(this._styles[_loc5_] != param2)
            {
               _loc4_ = this._styles[_loc5_];
               this._styles[_loc5_] = param2;
               dispatchEvent(new StyleChangedEvent(_loc5_,_loc4_,param2));
               this.invalidateSize();
               this.invalidateDisplayList();
            }
         }
         else if(this._styles[param1] != param2)
         {
            _loc4_ = this._styles[param1];
            this._styles[param1] = param2;
            dispatchEvent(new StyleChangedEvent(param1,_loc4_,param2));
            this.invalidateSize();
            this.invalidateDisplayList();
         }
      }
      
      public function get controller() : Controller
      {
         return this._animationController;
      }
      
      public function getProperty(param1:String) : *
      {
         if(param1.indexOf(".") >= 0)
         {
            return Utils.getPropertyFromPath(this,param1);
         }
         return this[param1];
      }
      
      public function setProperty(param1:String, param2:*) : void
      {
         if(param1.indexOf(".") >= 0)
         {
            Utils.setPropertyFromPath(this,param1,param2);
         }
         else
         {
            this[param1] = param2;
         }
      }
      
      public function traceNestLevels(param1:String = "") : void
      {
         var _loc3_:Component = null;
         param1 += " ";
         var _loc2_:uint = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_) as Component;
            if(_loc3_)
            {
               _loc3_.traceNestLevels(param1);
            }
            _loc2_++;
         }
      }
      
      protected function measure() : void
      {
         this.measuredMinWidth = 0;
         this.measuredMinHeight = 0;
         this.measuredWidth = 0;
         this.measuredHeight = 0;
         var _loc1_:Component = this.parent as Component;
         if(Boolean(this.percentWidth) && Boolean(_loc1_))
         {
            this.measuredWidth = _loc1_.unreservedWidth * this.percentWidth;
         }
         if(Boolean(this.percentHeight) && Boolean(_loc1_))
         {
            this.measuredHeight = _loc1_.unreservedHeight * this.percentHeight;
         }
      }
      
      protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Sprite = null;
         graphics.clear();
         if(this.useMouseScreen)
         {
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         if(this.clipContent)
         {
            if(!mask)
            {
               mask = new Sprite();
            }
            if(!mask.parent)
            {
               this.addChild(mask);
            }
            _loc3_ = mask as Sprite;
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(16777215,1);
            _loc3_.graphics.drawRect(0,0,param1 + 1,param2);
            _loc3_.graphics.endFill();
         }
      }
      
      protected function createChildren() : void
      {
         this._childrenCreating = true;
      }
      
      protected function setChildrenDoubleClickEnable(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:InteractiveObject = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_) as InteractiveObject;
               if(_loc3_)
               {
                  _loc3_.doubleClickEnabled = doubleClickEnabled;
               }
               _loc2_++;
            }
         }
      }
      
      private function measureSizes() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc1_:Boolean = false;
         if(!this._invalidSize)
         {
            return _loc1_;
         }
         this.measure();
         this._unlimitedMeasuredWidth = this.measuredWidth;
         this._unlimitedMeasuredHeight = this.measuredHeight;
         this._invalidSize = false;
         if(!isNaN(this.explicitMinWidth) && this.measuredWidth < this.explicitMinWidth)
         {
            this.measuredWidth = this.explicitMinWidth;
         }
         if(!isNaN(this.explicitMaxWidth) && this.measuredWidth > this.explicitMaxWidth)
         {
            this.measuredWidth = this.explicitMaxWidth;
         }
         if(!isNaN(this.explicitMinHeight) && this.measuredHeight < this.explicitMinHeight)
         {
            this.measuredHeight = this.explicitMinHeight;
         }
         if(!isNaN(this.explicitMaxHeight) && this.measuredHeight > this.explicitMaxHeight)
         {
            this.measuredHeight = this.explicitMaxHeight;
         }
         _loc2_ = !isNaN(this.explicitMinWidth) ? this.explicitMinWidth : this.measuredMinWidth;
         if(_loc2_ != this._oldMinWidth)
         {
            this._oldMinWidth = _loc2_;
            _loc1_ = true;
         }
         _loc2_ = !isNaN(this.explicitMinHeight) ? this.explicitMinHeight : this.measuredMinHeight;
         if(_loc2_ != this._oldMinHeight)
         {
            this._oldMinHeight = _loc2_;
            _loc1_ = true;
         }
         _loc2_ = !isNaN(this.explicitWidth) ? this.explicitWidth : this.measuredWidth;
         if(_loc2_ != this._oldExplicitWidth)
         {
            this._oldExplicitWidth = _loc2_;
            _loc1_ = true;
         }
         _loc2_ = !isNaN(this.explicitHeight) ? this.explicitHeight : this.measuredHeight;
         if(_loc2_ != this._oldExplicitHeight)
         {
            this._oldExplicitHeight = _loc2_;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function onFilterProxyChange(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(filters.length);
         var _loc4_:FilterProxy = param1.target as FilterProxy;
         if(_loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               if(!(filters[_loc5_] is _loc4_.type))
               {
                  _loc2_.push(filters[_loc5_]);
               }
               _loc5_++;
            }
         }
         if(_loc4_.enabled)
         {
            _loc2_.push(_loc4_.filter);
         }
         filters = _loc2_;
      }
      
      private function onColorTransformProxyChange(param1:Event) : void
      {
         if(this.colorTransformProxy.isDefaults)
         {
            transform.colorTransform = new ColorTransform();
         }
         else
         {
            transform.colorTransform = this.colorTransformProxy.transform;
         }
      }
      
      private function onColorMatrixChange(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(filters.length);
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(!(filters[_loc4_] is ColorMatrixFilter))
               {
                  _loc2_.push(filters[_loc4_]);
               }
               _loc4_++;
            }
         }
         _loc2_.push(new ColorMatrixFilter(this.colorMatrix.valueOf()));
         filters = _loc2_;
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(this.disableOnCriticalComms && param1.property == "criticalComms")
         {
            this.enabled = param1.newValue == 0;
         }
      }
   }
}
