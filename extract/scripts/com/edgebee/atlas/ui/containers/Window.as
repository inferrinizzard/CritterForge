package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.skins.WindowSkin;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Window extends Component
   {
      
      public static const WINDOW_VISIBLE:String = "WINDOW_VISIBLE";
      
      public static const WINDOW_INVISIBLE:String = "WINDOW_INVISIBLE";
       
      
      private var _content:com.edgebee.atlas.ui.containers.Box;
      
      private var _statusBar:com.edgebee.atlas.ui.containers.Box;
      
      protected var _mouseIsDown:Boolean = false;
      
      private var _mouseDownPos:Point;
      
      private var _dragComponent:Component;
      
      private var _draggable:Boolean = true;
      
      private var _showCloseButton:Boolean = true;
      
      private var _title;
      
      private var _titleIcon;
      
      private var _useFade:Boolean = false;
      
      private var _centered:Boolean = false;
      
      protected var _skin:Skin;
      
      private var _rememberPositionId:String = "";
      
      private var _fade:AnimationInstance;
      
      public function Window()
      {
         this._content = new com.edgebee.atlas.ui.containers.Box(com.edgebee.atlas.ui.containers.Box.VERTICAL);
         this._statusBar = new com.edgebee.atlas.ui.containers.Box(com.edgebee.atlas.ui.containers.Box.HORIZONTAL);
         super();
         addEventListener(Component.RESIZE,this.onWindowResized);
      }
      
      public static function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get content() : com.edgebee.atlas.ui.containers.Box
      {
         return this._content;
      }
      
      public function get statusBar() : com.edgebee.atlas.ui.containers.Box
      {
         return this._statusBar;
      }
      
      public function get title() : *
      {
         return this._title;
      }
      
      public function set title(param1:*) : void
      {
         this._title = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"title",null,param1));
      }
      
      public function get titleIcon() : *
      {
         return this._titleIcon;
      }
      
      public function set titleIcon(param1:*) : void
      {
         this._titleIcon = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"titleIcon",null,param1));
      }
      
      public function get showCloseButton() : Boolean
      {
         return this._showCloseButton;
      }
      
      public function set showCloseButton(param1:Boolean) : void
      {
         this._showCloseButton = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"showCloseButton",null,param1));
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      public function set draggable(param1:Boolean) : void
      {
         if(this._draggable != param1)
         {
            this._draggable = param1;
            if(this._dragComponent)
            {
               if(this._draggable)
               {
                  this._dragComponent.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               }
               else
               {
                  this._dragComponent.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               }
            }
         }
      }
      
      public function get centered() : Boolean
      {
         return this._centered;
      }
      
      public function set centered(param1:Boolean) : void
      {
         this._centered = param1;
      }
      
      public function get skin() : Skin
      {
         return this._skin;
      }
      
      public function get rememberPosition() : Boolean
      {
         return !!this._rememberPositionId;
      }
      
      public function get rememberPositionId() : String
      {
         return this._rememberPositionId;
      }
      
      public function set rememberPositionId(param1:String) : void
      {
         this._rememberPositionId = param1;
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         super.createChildren();
         if(this.rememberPosition && Boolean(client.userCookie._ui.windows.hasOwnProperty(this.rememberPositionId)))
         {
            x = client.userCookie._ui.windows[this.rememberPositionId].x;
            y = client.userCookie._ui.windows[this.rememberPositionId].y;
         }
         var _loc1_:int = UIGlobals.root.stage.width;
         var _loc2_:int = UIGlobals.root.stage.height;
         var _loc3_:Point = new Point(x,y);
         _loc3_ = parent.localToGlobal(_loc3_);
         if(_loc3_.x > _loc1_ - 30)
         {
            _loc5_ = width;
            if(width < 30)
            {
               _loc5_ = 30;
            }
            x -= _loc3_.x - (_loc1_ - _loc5_);
         }
         else if(_loc3_.x < 0)
         {
            x -= _loc3_.x;
         }
         if(_loc3_.y > _loc2_ - 30)
         {
            _loc6_ = height;
            if(height < 30)
            {
               _loc6_ = 30;
            }
            y -= _loc3_.y - (_loc2_ - _loc6_);
         }
         else if(_loc3_.y < 0)
         {
            y -= _loc3_.y;
         }
         this._content.name = "Window:_content";
         this._statusBar.name = "Window:_statusBar";
         var _loc4_:Class = getStyle("Skin",WindowSkin);
         this._skin = new _loc4_(this);
         this._skin.name = "Window:_skin";
         addChild(this._skin);
         if(!visible)
         {
            dispatchEvent(new Event(WINDOW_INVISIBLE));
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(!percentWidth && isNaN(explicitWidth))
         {
            measuredWidth = this._skin.width;
         }
         else
         {
            this._skin.invalidateSize();
         }
         if(percentHeight == 0 && isNaN(explicitHeight))
         {
            measuredHeight = this._skin.height;
         }
         else
         {
            this._skin.invalidateSize();
         }
      }
      
      override public function get styleClassName() : String
      {
         return "Window";
      }
      
      public function doClose() : void
      {
         if(getStyle("CloseSound",null) != null)
         {
            UIGlobals.playSound(getStyle("CloseSound"));
         }
         UIGlobals.popUpManager.removePopUp(this);
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function setDragComponent(param1:Component) : void
      {
         this._dragComponent = param1;
         if(this._dragComponent)
         {
            if(this._draggable)
            {
               this._dragComponent.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            }
            else
            {
               this._dragComponent.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            }
         }
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         if(this._useFade)
         {
            if(param1)
            {
               super.doSetVisible(param1);
               dispatchEvent(new Event(WINDOW_VISIBLE));
               if(alpha != 1)
               {
                  if(this._fade)
                  {
                     this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
                  }
                  this._fade = controller.animateTo({"alpha":1});
                  this._fade.speed = 15;
                  this._fade.addEventListener(AnimationEvent.STOP,this.onFadeStop);
               }
            }
            else if(alpha != 0)
            {
               if(this._fade)
               {
                  this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
               }
               this._fade = controller.animateTo({"alpha":0});
               this._fade.speed = 10;
               this._fade.addEventListener(AnimationEvent.STOP,this.onFadeStop);
            }
         }
         else
         {
            super.doSetVisible(param1);
            if(param1)
            {
               dispatchEvent(new Event(WINDOW_VISIBLE));
            }
            else
            {
               dispatchEvent(new Event(WINDOW_INVISIBLE));
            }
         }
      }
      
      public function setDefaultToCenter() : void
      {
         if(!this.rememberPosition || !client.userCookie._ui.windows.hasOwnProperty(this.rememberPositionId))
         {
            if(UIGlobals.popUpManager.isPopUp(this))
            {
               UIGlobals.popUpManager.centerPopUp(this);
            }
            else
            {
               x = parent.width / 2 - width / 2;
               y = parent.height / 2 - height / 2;
            }
         }
      }
      
      public function setDefaultPosition(param1:Number, param2:Number) : void
      {
         if(!this.rememberPosition || !client.userCookie._ui.windows.hasOwnProperty(this.rememberPositionId))
         {
            this.x = param1;
            this.y = param2;
         }
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseIsDown = true;
         this._mouseDownPos = new Point(param1.stageX - x,param1.stageY - y);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
         stage.addEventListener(Event.MOUSE_LEAVE,this.onMouseUp,false,0,true);
         if(UIGlobals.popUpManager.isPopUp(this))
         {
            UIGlobals.popUpManager.bringToFront(this);
         }
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this._mouseIsDown;
         this._mouseIsDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false);
         stage.removeEventListener(Event.MOUSE_LEAVE,this.onMouseUp,false);
         if(_loc2_)
         {
            this.saveWinPosition();
         }
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(this._mouseIsDown)
         {
            param1.stopImmediatePropagation();
            if(UIGlobals.popUpManager.isPopUp(this))
            {
               _loc2_ = parent.parent;
            }
            else
            {
               _loc2_ = parent;
            }
            x = param1.stageX - this._mouseDownPos.x;
            if(x < 0)
            {
               x = 0;
            }
            else if(x + width > _loc2_.width)
            {
               x = _loc2_.width - width;
            }
            y = param1.stageY - this._mouseDownPos.y;
            if(y < 0)
            {
               y = 0;
            }
            else if(y + height > _loc2_.height)
            {
               y = _loc2_.height - height;
            }
         }
      }
      
      protected function saveWinPosition() : void
      {
         if(childrenCreated && this.rememberPosition)
         {
            if(!client.userCookie._ui.windows.hasOwnProperty(this.rememberPositionId))
            {
               client.userCookie._ui.windows[this.rememberPositionId] = new Object();
            }
            client.userCookie._ui.windows[this.rememberPositionId].x = x;
            client.userCookie._ui.windows[this.rememberPositionId].y = y;
            client.saveCookie();
         }
      }
      
      private function onWindowResized(param1:Event) : void
      {
         if(this.centered && !this.draggable && UIGlobals.popUpManager.isPopUp(this))
         {
            UIGlobals.popUpManager.centerPopUp(this);
         }
      }
      
      private function onFadeStop(param1:AnimationEvent) : void
      {
         this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
         this._fade = null;
         if(alpha < 0.1)
         {
            super.doSetVisible(false);
            dispatchEvent(new Event(WINDOW_INVISIBLE));
         }
      }
   }
}
