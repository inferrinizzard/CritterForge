package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.*;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TextInput extends Component
   {
      
      private static var _keypad:com.edgebee.atlas.ui.controls.Keypad = new com.edgebee.atlas.ui.controls.Keypad();
       
      
      private var _skin:Skin;
      
      private var _text:String = null;
      
      private var _htmlText:String = null;
      
      private var _editable:Boolean = true;
      
      private var _restrict:String = null;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _multiline:Boolean = false;
      
      private var _maxChars:int = 0;
      
      private var _editing:Boolean = false;
      
      public function TextInput()
      {
         super();
      }
      
      override protected function setEnabled(param1:Boolean) : void
      {
         super.setEnabled(param1);
         if(this.textField)
         {
            this.textField.restrict = this._editable && enabled ? this.restrict : "";
         }
      }
      
      public function get skin() : Skin
      {
         if(!this._skin)
         {
            this.createSkin(getStyle("Skin",DefaultTextInputSkin));
         }
         return this._skin;
      }
      
      public function set skin(param1:Skin) : void
      {
         this._skin = param1;
         invalidateSize();
         this.invalidateDisplayList();
      }
      
      protected function createSkin(param1:Class) : void
      {
         this._skin = new param1(this);
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(this._editable != param1)
         {
            this._editable = param1;
            if(this.textField)
            {
               this.textField.restrict = this._editable && enabled ? this.restrict : "";
            }
         }
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         this._restrict = param1;
         if(this.textField)
         {
            this.textField.restrict = this._editable && enabled ? this._restrict : "";
         }
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         this._displayAsPassword = param1;
         if(this.textField)
         {
            this.textField.displayAsPassword = param1;
         }
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._multiline = param1;
         if(this.textField)
         {
            this.textField.multiline = param1;
         }
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         this._maxChars = param1;
         if(this.textField)
         {
            this.textField.maxChars = param1;
         }
      }
      
      public function get textField() : TextField
      {
         return (this.skin as Object).textField;
      }
      
      public function get text() : String
      {
         return this.textField.text;
      }
      
      public function set text(param1:String) : void
      {
         this._htmlText = null;
         if(!childrenCreated)
         {
            this._text = param1;
         }
         else
         {
            this.textField.text = param1;
         }
         invalidateSize();
         if(this._skin)
         {
            this.skin.invalidateSize();
            this.skin.invalidateDisplayList();
         }
      }
      
      public function get htmlText() : String
      {
         return this.textField.htmlText;
      }
      
      public function set htmlText(param1:String) : void
      {
         this._text = null;
         if(!this.textField)
         {
            this._htmlText = param1;
         }
         else
         {
            this.textField.htmlText = param1;
         }
         invalidateSize();
         if(this._skin)
         {
            this.skin.invalidateSize();
            this.skin.invalidateDisplayList();
         }
      }
      
      override public function get styleClassName() : String
      {
         return "TextInput";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(this.skin)
         {
            this.skin.invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addChildAt(this.skin,0);
         if(this._text)
         {
            this.textField.text = this._text;
         }
         if(this._htmlText)
         {
            this.textField.htmlText = this._htmlText;
         }
         this.textField.restrict = this._editable && enabled ? this.restrict : "";
         this.textField.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(percentWidth == 0)
         {
            measuredWidth = this.skin.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this.skin.height;
         }
         this.skin.minHeight = getExplicitOrMeasuredHeight();
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         this.skin.width = width;
      }
      
      override public function kbActivate() : void
      {
      }
      
      private function onKeypadComplete(param1:Event) : void
      {
         if(this._editing)
         {
            this._editing = false;
            _keypad.removeEventListener(Event.COMPLETE,this.onKeypadComplete);
            _keypad.textInput = null;
            UIGlobals.popUpManager.removePopUp(_keypad);
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(UIGlobals.root.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            if(!this._editing)
            {
               this._editing = true;
               _keypad.textInput = this;
               _keypad.addEventListener(Event.COMPLETE,this.onKeypadComplete);
               UIGlobals.popUpManager.addPopUp(_keypad,UIGlobals.root);
               _loc2_ = new Point(0,height);
               _loc2_ = localToGlobal(_loc2_);
               UIGlobals.popUpManager.positionPopUp(_keypad,_loc2_.x,_loc2_.y);
               param1.stopPropagation();
            }
         }
      }
   }
}
