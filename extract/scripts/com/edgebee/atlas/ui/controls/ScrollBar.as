package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.events.ScrollEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.Scrollable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.skins.BottomArrowButtonSkin;
   import com.edgebee.atlas.ui.skins.LeftArrowButtonSkin;
   import com.edgebee.atlas.ui.skins.RightArrowButtonSkin;
   import com.edgebee.atlas.ui.skins.ScrollBarThumbSkin;
   import com.edgebee.atlas.ui.skins.ScrollBarTrackSkin;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.skins.TopArrowButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ScrollBar extends Component
   {
      
      public static const HORIZONTAL:String = "HORIZONTAL";
      
      public static const VERTICAL:String = "VERTICAL";
       
      
      private var _direction:String = "VERTICAL";
      
      private var _scrollable:Scrollable;
      
      private var _onlyShowWhenNeeded:Boolean = true;
      
      private var _thumbButtonScrolling:Boolean = false;
      
      private var _thumbScrollingStartPos:Point;
      
      private var _thumbClickPos:Point;
      
      private var _needed:Boolean = false;
      
      private var _thumbSkin:Skin;
      
      private var _trackSkin:Skin;
      
      public var scrollBox:Box;
      
      public var forwardBtn:com.edgebee.atlas.ui.controls.Button;
      
      public var backBtn:com.edgebee.atlas.ui.controls.Button;
      
      public var thumbCanvas:Canvas;
      
      public var thumbBtn:Canvas;
      
      private var _verticalLayout:Array;
      
      private var _horizontalLayout:Array;
      
      public function ScrollBar()
      {
         this._verticalLayout = [{
            "CLASS":Box,
            "ID":"scrollBox",
            "percentHeight":1,
            "direction":Box.VERTICAL,
            "spreadProportionality":false,
            "CHILDREN":[{
               "CLASS":com.edgebee.atlas.ui.controls.Button,
               "ID":"backBtn",
               "STYLES":{
                  "Skin":UIGlobals.getStyle("Scrollbar.UpButtonSkin",TopArrowButtonSkin),
                  "ShowBorder":false
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onBackBtnClick"
               }]
            },{
               "CLASS":Canvas,
               "ID":"thumbCanvas",
               "percentHeight":1,
               "percentWidth":1,
               "EVENTS":[{
                  "TYPE":Component.RESIZE,
                  "LISTENER":"onThumbCanvasResize"
               }],
               "CHILDREN":[{
                  "CLASS":Canvas,
                  "ID":"thumbBtn",
                  "EVENTS":[{
                     "TYPE":MouseEvent.MOUSE_DOWN,
                     "LISTENER":"onThumbMouseDown"
                  }]
               }]
            },{
               "CLASS":com.edgebee.atlas.ui.controls.Button,
               "ID":"forwardBtn",
               "STYLES":{
                  "Skin":UIGlobals.getStyle("Scrollbar.DownButtonSkin",BottomArrowButtonSkin),
                  "ShowBorder":false
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onForwardBtnClick"
               }]
            }]
         }];
         this._horizontalLayout = [{
            "CLASS":Box,
            "ID":"scrollBox",
            "direction":Box.HORIZONTAL,
            "STYLES":{
               "BackgroundColor":11184810,
               "BackgroundAlpha":0.75
            },
            "CHILDREN":[{
               "CLASS":com.edgebee.atlas.ui.controls.Button,
               "ID":"backBtn",
               "width":16,
               "height":16,
               "STYLES":{"Skin":LeftArrowButtonSkin}
            },{
               "CLASS":com.edgebee.atlas.ui.controls.Button,
               "ID":"forwardBtn",
               "width":16,
               "height":16,
               "STYLES":{"Skin":RightArrowButtonSkin}
            }]
         }];
         super();
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
            if(this._direction == HORIZONTAL)
            {
               throw Error("Horizontal scrolling not implemented");
            }
         }
      }
      
      public function get scrollable() : Scrollable
      {
         return this._scrollable;
      }
      
      public function set scrollable(param1:Scrollable) : void
      {
         if(this._scrollable != param1)
         {
            this._scrollable = param1;
            if(this._scrollable)
            {
               this._scrollable.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
               this._scrollable.addEventListener(ScrollEvent.CONTENT_RESIZE,this.onScrollableResized);
            }
         }
      }
      
      public function get onlyShowWhenNeeded() : Boolean
      {
         return this._onlyShowWhenNeeded;
      }
      
      public function set onlyShowWhenNeeded(param1:Boolean) : void
      {
         if(this._onlyShowWhenNeeded != param1)
         {
            this._onlyShowWhenNeeded = param1;
            if(this._onlyShowWhenNeeded)
            {
               visible = this._needed;
            }
         }
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this.direction == VERTICAL ? this._verticalLayout : this._horizontalLayout);
         if(this._thumbSkin)
         {
            this.thumbSkin = this.thumbSkin;
         }
         else
         {
            this.thumbSkin;
         }
         if(this._trackSkin)
         {
            this.trackSkin = this.trackSkin;
         }
         else
         {
            this.trackSkin;
         }
         this.updateThumb();
      }
      
      public function scrollToMaximum() : void
      {
         if(this.scrollable.scrollVisibleSize != 0 && this.scrollable.scrollMaxPosition > this.scrollable.scrollVisibleSize)
         {
            this.scrollable.scrollPosition = this.scrollable.scrollVisibleSize - this.scrollable.scrollMaxPosition;
            this.updateThumb();
         }
      }
      
      override protected function sizeChanged() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Component = null;
         if(childrenCreated || childrenCreating)
         {
            _loc1_ = 0;
            while(_loc1_ < numChildren)
            {
               _loc2_ = getChildAt(_loc1_) as Component;
               if(Boolean(_loc2_) && (Boolean(_loc2_.percentWidth) || Boolean(_loc2_.percentHeight)))
               {
                  _loc2_.invalidateSize();
               }
               _loc1_++;
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.direction == HORIZONTAL)
         {
            throw new Error("not yet supported");
         }
         if(percentWidth == 0)
         {
            measuredWidth = this.backBtn.width;
         }
         measuredMinWidth = this.backBtn.width;
      }
      
      override public function get styleClassName() : String
      {
         return "Scrollbar";
      }
      
      public function get thumbSkin() : Skin
      {
         if(!this._thumbSkin)
         {
            this.createThumbSkin(getStyle("ThumbSkin",ScrollBarThumbSkin));
         }
         return this._thumbSkin;
      }
      
      public function set thumbSkin(param1:Skin) : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this._thumbSkin)
            {
               this.thumbBtn.removeChild(this._thumbSkin);
            }
            this._thumbSkin = param1;
            if(this._thumbSkin)
            {
               this.thumbBtn.addChildAt(this._thumbSkin,0);
            }
         }
      }
      
      protected function createThumbSkin(param1:Class) : void
      {
         var _loc2_:Skin = new param1(this);
         this.thumbSkin = _loc2_;
      }
      
      public function get trackSkin() : Skin
      {
         if(!this._trackSkin)
         {
            this.createTrackSkin(getStyle("TrackSkin",ScrollBarTrackSkin));
         }
         return this._trackSkin;
      }
      
      public function set trackSkin(param1:Skin) : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this._trackSkin)
            {
               this.thumbCanvas.removeChild(this._trackSkin);
            }
            this._trackSkin = param1;
            if(this._trackSkin)
            {
               this.thumbCanvas.addChildAt(this._trackSkin,0);
            }
         }
      }
      
      protected function createTrackSkin(param1:Class) : void
      {
         var _loc2_:Skin = new param1(this);
         this.trackSkin = _loc2_;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(param1.delta > 0)
         {
            this.onBackBtnClick(null);
         }
         else if(param1.delta < 0)
         {
            this.onForwardBtnClick(null);
         }
      }
      
      private function onScrollableResized(param1:ScrollEvent) : void
      {
         this.updateThumb();
      }
      
      private function updateThumb() : void
      {
         if(!this._thumbButtonScrolling)
         {
            if(this.scrollable.scrollMaxPosition > this.scrollable.scrollVisibleSize)
            {
               this._needed = this.thumbBtn.visible = true;
               this.thumbBtn.height = this.thumbCanvas.height * (this.scrollable.scrollVisibleSize / this.scrollable.scrollMaxPosition);
               this.thumbBtn.width = this.thumbCanvas.width - 4;
               this.thumbBtn.x = 2;
               if(this.thumbCanvas.height > 0)
               {
                  this.thumbBtn.y = this.thumbCanvas.height * (Math.abs(this.scrollable.scrollPosition) / this.scrollable.scrollMaxPosition);
               }
               if(this.thumbBtn.y < 0)
               {
                  this.thumbBtn.y = 0;
               }
               if(this.thumbBtn.y + this.thumbBtn.height > this.thumbCanvas.height)
               {
                  this.thumbBtn.y = this.thumbCanvas.height - this.thumbBtn.height;
               }
            }
            else
            {
               this._needed = this.thumbBtn.visible = false;
            }
            if(this.onlyShowWhenNeeded)
            {
               visible = this._needed;
            }
            else
            {
               visible = true;
            }
         }
      }
      
      public function onBackBtnClick(param1:MouseEvent) : void
      {
         if(this.scrollable.scrollPosition < this.scrollable.scrollMinPosition)
         {
            this.scrollable.scrollPosition += Math.min(this.scrollable.scrollStepSize,Math.abs(this.scrollable.scrollPosition));
            this.updateThumb();
         }
      }
      
      public function onForwardBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.scrollable.scrollPosition + this.scrollable.scrollMaxPosition;
         if(_loc2_ > this.scrollable.scrollVisibleSize)
         {
            this.scrollable.scrollPosition -= Math.min(this.scrollable.scrollStepSize,_loc2_ - this.scrollable.scrollVisibleSize);
            this.updateThumb();
         }
      }
      
      public function onThumbMouseDown(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         this._thumbButtonScrolling = true;
         this._thumbScrollingStartPos = new Point(this.thumbBtn.x,this.thumbBtn.y);
         this._thumbClickPos = new Point(param1.stageX,param1.stageY);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove,true,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbRelease,true,0,true);
         stage.addEventListener(Event.MOUSE_LEAVE,this.onThumbRelease,false,0,true);
      }
      
      public function onThumbCanvasResize(param1:Event) : void
      {
         this.updateThumb();
      }
      
      private function onThumbMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!enabled)
         {
            return;
         }
         if(this.direction == VERTICAL)
         {
            _loc2_ = param1.stageY - this._thumbClickPos.y;
            this.thumbBtn.y = this._thumbScrollingStartPos.y + _loc2_;
            if(this.thumbBtn.y < 0)
            {
               this.thumbBtn.y = 0;
            }
            if(this.thumbBtn.y + this.thumbBtn.height > this.thumbCanvas.height)
            {
               this.thumbBtn.y = this.thumbCanvas.height - this.thumbBtn.height;
            }
            this.scrollable.scrollPosition = this.thumbPositionToIndex();
         }
      }
      
      private function thumbPositionToIndex() : Number
      {
         var _loc1_:Number = this.thumbBtn.y / this.thumbCanvas.height;
         return -1 * Math.round(_loc1_ * this.scrollable.scrollMaxPosition);
      }
      
      private function onThumbRelease(param1:* = null) : void
      {
         if(!enabled)
         {
            return;
         }
         this._thumbButtonScrolling = false;
         this.updateThumb();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove,true);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbRelease,true);
         stage.removeEventListener(Event.MOUSE_LEAVE,this.onThumbRelease);
      }
   }
}
