package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class BreedrTextInputSkin extends Skin
   {
       
      
      private var _textField:TextField;
      
      protected var _paddingLeft:Number;
      
      protected var _paddingRight:Number;
      
      protected var _paddingTop:Number;
      
      protected var _paddingBottom:Number;
      
      protected var _focused:Boolean;
      
      protected var _mouseIsOver:Boolean;
      
      public function BreedrTextInputSkin(param1:Component)
      {
         super(param1);
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
         this._textField = new TextField();
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this._textField.gridFitType = GridFitType.PIXEL;
         this._textField.type = TextFieldType.INPUT;
         this._textField.multiline = this.textInput.multiline;
         this._textField.maxChars = this.textInput.maxChars;
         this._textField.displayAsPassword = this.textInput.displayAsPassword;
         this._textField.restrict = enabled && this.textInput.editable ? null : "";
         this._textField.filters = [new BlurFilter(0,0,0)];
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
         this._paddingLeft = component.getStyle("PaddingLeft",4);
         this._paddingRight = component.getStyle("PaddingRight",4);
         this._paddingTop = component.getStyle("PaddingTop",4);
         this._paddingBottom = component.getStyle("PaddingBottom",4);
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
         super.updateDisplayList(param1,param2);
         graphics.clear();
         this._paddingLeft = component.getStyle("PaddingLeft",4);
         this._paddingRight = component.getStyle("PaddingRight",4);
         this._paddingTop = component.getStyle("PaddingTop",4);
         this._paddingBottom = component.getStyle("PaddingBottom",4);
         this.textField.height = component.height - (this._paddingTop + this._paddingBottom);
         var _loc3_:Number = Math.max(0,UIGlobals.getStyle("CornerRadius",5));
         var _loc4_:uint = UIGlobals.getStyle("ThemeColor",3355630);
         var _loc5_:uint = UIUtils.adjustBrightness2(_loc4_,65);
         var _loc6_:uint = UIUtils.adjustBrightness2(_loc4_,-60);
         var _loc7_:uint = UIUtils.adjustBrightness2(_loc4_,-90);
         var _loc8_:Matrix = new Matrix();
         var _loc9_:Number = this._focused ? 1 : 0.6;
         this._textField.alpha = this._focused ? 1 : 0.65;
         glowProxy.alpha = this._mouseIsOver ? 1 : 0;
         glowProxy.color = _loc4_;
         _loc8_.createGradientBox(component.width,component.height,Math.PI / 2);
         graphics.beginGradientFill(GradientType.LINEAR,[_loc7_,_loc6_],[_loc9_,_loc9_],[0,255],_loc8_);
         graphics.drawRoundRect(1,1,component.width - 2,component.height - 2,_loc3_,_loc3_);
         graphics.endFill();
         _loc8_.createGradientBox(component.width,component.height,Math.PI / 2);
         graphics.lineStyle(1.5,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc5_,_loc4_],[_loc9_,_loc9_],[25,255],_loc8_);
         graphics.drawRoundRect(0,0,component.width,component.height,_loc3_,_loc3_);
         this._textField.y = this._paddingTop;
         this._textField.x = this._paddingLeft;
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
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._mouseIsOver = true;
         invalidateDisplayList();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._mouseIsOver = false;
         invalidateDisplayList();
      }
   }
}
