package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.events.FocusEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class DefaultTextInputSkin extends Skin
   {
       
      
      private var _textField:TextField;
      
      protected var _paddingLeft:Number;
      
      protected var _paddingRight:Number;
      
      protected var _paddingTop:Number;
      
      protected var _paddingBottom:Number;
      
      protected var _focused:Boolean;
      
      public function DefaultTextInputSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get textInput() : TextInput
      {
         return component as TextInput;
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function setEnabled(param1:Boolean) : void
      {
         super.setEnabled(param1);
         if(this._textField)
         {
            if(enabled)
            {
               this._textField.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn,false,0,true);
               this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
            }
            else
            {
               this._textField.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
               this._textField.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         setStyle("CornerRadius",getStyle("CornerRadius",5));
         setStyle("BorderThickness",getStyle("BorderThickness",1));
         this._textField = new TextField();
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this._textField.gridFitType = GridFitType.PIXEL;
         this._textField.type = TextFieldType.INPUT;
         this._textField.multiline = this.textInput.multiline;
         this._textField.maxChars = this.textInput.maxChars;
         this._textField.displayAsPassword = this.textInput.displayAsPassword;
         this._textField.restrict = enabled && this.textInput.editable ? null : "";
         if(enabled)
         {
            this._textField.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn,false,0,true);
            this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
         }
         this._textField.defaultTextFormat = new TextFormat(getStyle("FontFamily"),getStyle("FontSize"),getStyle("FontColor"),getStyle("FontWeight") == "bold",getStyle("FontStyle") == "italic",getStyle("FontDecoration") == "italic",null,null);
         addChild(this._textField);
      }
      
      override protected function measure() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         super.measure();
         this._paddingLeft = component.getStyle("PaddingLeft",3);
         this._paddingRight = component.getStyle("PaddingRight",3);
         this._paddingTop = component.getStyle("PaddingTop",5);
         this._paddingBottom = component.getStyle("PaddingBottom",5);
         this.textField.width = component.width - (this._paddingLeft + this._paddingRight);
         if(component.percentWidth == 0)
         {
            measuredWidth = this.textField.width + this._paddingLeft + this._paddingRight;
         }
         if(component.percentHeight == 0)
         {
            _loc1_ = [this.textField.selectionBeginIndex,this.textField.selectionEndIndex];
            _loc2_ = this.textField.text;
            this.textField.text = "Wj";
            measuredHeight = this.textField.textHeight + 4 + this._paddingTop + this._paddingBottom;
            this.textField.text = _loc2_;
            this.textField.setSelection(_loc1_[0],_loc1_[1]);
         }
         if(border)
         {
            border.invalidateSize();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:uint = 0;
         super.updateDisplayList(param1,param2);
         this._paddingLeft = component.getStyle("PaddingLeft",3);
         this._paddingRight = component.getStyle("PaddingRight",3);
         this._paddingTop = component.getStyle("PaddingTop",5);
         this._paddingBottom = component.getStyle("PaddingBottom",5);
         this.textField.height = component.height - (this._paddingTop + this._paddingBottom);
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(component.width,component.height,Math.PI / 2,0,0);
         var _loc4_:Number = UIUtils.adjustBrightness2(component.getStyle("BackgroundColor"),-5);
         var _loc5_:Number = UIUtils.adjustBrightness2(component.getStyle("BackgroundColor"),-40);
         graphics.beginGradientFill(GradientType.LINEAR,[0,0,0],[0.15,0,0],[0,60,255],_loc3_);
         graphics.drawRect(0,0,component.width,component.height);
         graphics.endFill();
         this._textField.y = this._paddingTop;
         this._textField.x = this._paddingLeft;
         if(this._focused)
         {
            _loc6_ = component.getStyle("ThemeColor");
            filters = [new GlowFilter(UIUtils.adjustBrightness2(_loc6_,50),1,5,5)];
         }
         else
         {
            filters = null;
         }
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         this._focused = true;
         invalidateDisplayList();
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         this._focused = false;
         invalidateDisplayList();
      }
      
      private function onStyleChange(param1:StyleChangedEvent) : void
      {
         if(Boolean(this._textField) && (param1.style.length >= 4 || param1.style.slice(0,4) == "Font"))
         {
            this._textField.defaultTextFormat = new TextFormat(getStyle("FontFamily"),getStyle("FontSize"),getStyle("FontColor"),getStyle("FontWeight") == "bold",getStyle("FontStyle") == "italic",getStyle("FontDecoration") == "italic",null,null);
         }
      }
   }
}
