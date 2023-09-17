package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.ButtonSkin;
   import com.edgebee.atlas.ui.skins.Skin;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class Button extends Component
   {
       
      
      private var _label;
      
      private var _labelUseHtml:Boolean = false;
      
      private var _actualLabel:String;
      
      private var _icon:DisplayObject;
      
      private var _skin:Skin;
      
      private var _state:String;
      
      protected var _mouseIsOver:Boolean;
      
      protected var _mouseIsDown:Boolean;
      
      private var _userData:Object;
      
      public function Button()
      {
         super();
      }
      
      public function get label() : *
      {
         return this._label;
      }
      
      public function set label(param1:*) : void
      {
         if(this._label != param1)
         {
            this._label = param1;
            invalidateSize();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"label",null,this.label));
         }
      }
      
      public function get labelUseHtml() : Boolean
      {
         return this._labelUseHtml;
      }
      
      public function set labelUseHtml(param1:Boolean) : void
      {
         if(this._labelUseHtml != param1)
         {
            this._labelUseHtml = param1;
            invalidateSize();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"labelUseHtml",null,this.label));
         }
      }
      
      public function get icon() : DisplayObject
      {
         return this._icon;
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         if(this._icon != param1)
         {
            this._icon = param1;
            invalidateSize();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"icon",null,this.icon));
         }
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"state",null,this.state));
      }
      
      public function get userData() : Object
      {
         return this._userData;
      }
      
      public function set userData(param1:Object) : void
      {
         this._userData = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"userData",null,this.userData));
      }
      
      public function get skin() : Skin
      {
         if(!this._skin)
         {
            this.createSkin(getStyle("Skin",ButtonSkin));
         }
         return this._skin;
      }
      
      public function set skin(param1:Skin) : void
      {
         var _loc2_:uint = uint(numChildren);
         if(Boolean(this._skin) && Boolean(_loc2_))
         {
            removeChildAt(0);
         }
         this._skin = param1;
         if(Boolean(this._skin) && Boolean(_loc2_))
         {
            addChildAt(this._skin,0);
         }
         invalidateSize();
         this.invalidateDisplayList();
      }
      
      protected function createSkin(param1:Class) : void
      {
         this._skin = new param1(this);
         this._skin.addEventListener(MouseEvent.CLICK,this.onClick);
         this._skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this._skin.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this._skin.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseIsDown);
         this._skin.addEventListener(MouseEvent.MOUSE_UP,this.onMouseIsUp);
         this.updateState();
      }
      
      override public function get styleClassName() : String
      {
         return "Button";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(this._skin)
         {
            this.skin.invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addChildAt(this.skin,0);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(percentWidth == 0)
         {
            measuredWidth = this._skin.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._skin.height;
         }
         measuredMinWidth = this.skin.width;
         measuredMinHeight = this._skin.height;
      }
      
      override protected function setEnabled(param1:Boolean) : void
      {
         super.setEnabled(param1);
         this.updateState();
         if(this._skin)
         {
            this._skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            this._skin.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            this._skin.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseIsDown);
            this._skin.addEventListener(MouseEvent.MOUSE_UP,this.onMouseIsUp);
         }
      }
      
      override public function kbActivate() : void
      {
         if(enabled)
         {
            this.playClickSound();
            this._skin.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      protected function updateState() : void
      {
         if(!enabled)
         {
            this.state = "disabled";
         }
         else if(this._mouseIsDown)
         {
            this.state = "down";
         }
         else if(this._mouseIsOver)
         {
            this.state = "over";
         }
         else
         {
            this.state = "up";
         }
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(enabled)
         {
            this.playClickSound();
            dispatchEvent(param1);
         }
      }
      
      protected function playClickSound() : void
      {
         var _loc1_:* = this.skin.getStyle("ClickSound",null,false);
         if(!_loc1_)
         {
            _loc1_ = getStyle("ClickSound",null);
         }
         if(_loc1_)
         {
            UIGlobals.playSound(_loc1_);
         }
      }
      
      protected function onMouseIsDown(param1:MouseEvent) : void
      {
         this._mouseIsDown = true;
         this.updateState();
      }
      
      protected function onMouseIsUp(param1:MouseEvent) : void
      {
         this._mouseIsDown = false;
         this.updateState();
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         this._mouseIsOver = true;
         this.updateState();
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         this._mouseIsOver = false;
         this._mouseIsDown = false;
         this.updateState();
      }
   }
}
