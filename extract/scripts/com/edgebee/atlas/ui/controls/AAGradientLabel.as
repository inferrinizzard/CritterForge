package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.util.Utils;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class AAGradientLabel extends Component
   {
       
      
      private var _text = "";
      
      private var _actualText:String = "";
      
      private var _textField:TextField;
      
      private var _colors:Array;
      
      private var _alphas:Array;
      
      private var _ratios:Array;
      
      private var _background:Sprite;
      
      private var _alignment:String = "left";
      
      private var _autoSize:Boolean = true;
      
      private var _mask:Sprite;
      
      private var _angle:Number = 1.5707963267948966;
      
      private var _gradientColor:Number = 16777215;
      
      private var _capitalizeFirst:Boolean;
      
      public function AAGradientLabel()
      {
         this._colors = [7829367,16777215];
         this._alphas = [1,1];
         this._ratios = [10,245];
         super();
      }
      
      public function get text() : *
      {
         return this._text;
      }
      
      public function set text(param1:*) : void
      {
         var _loc2_:Asset = null;
         if(this._text != param1)
         {
            if(this._text is Asset)
            {
               (this._text as Asset).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLocaleChange);
            }
            this._text = param1;
            if(this._text is String)
            {
               this.actualText = this._text;
            }
            else if(this._text is Asset)
            {
               _loc2_ = this._text as Asset;
               _loc2_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLocaleChange);
               if(_loc2_.value)
               {
                  this.actualText = _loc2_.value;
               }
               else
               {
                  this.actualText = "";
               }
            }
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get integer() : Number
      {
         return int(this._text);
      }
      
      public function set integer(param1:Number) : void
      {
         var _loc2_:String = Utils.toFixed(Math.floor(param1),0);
         this.text = _loc2_;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._angle != param1)
         {
            this._angle = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get alignment() : String
      {
         return this._alignment;
      }
      
      public function set alignment(param1:String) : void
      {
         if(this._alignment != param1)
         {
            this._alignment = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get colors() : Array
      {
         return this._colors;
      }
      
      public function set colors(param1:Array) : void
      {
         this._colors = param1;
         invalidateDisplayList();
      }
      
      public function get alphas() : Array
      {
         return this._alphas;
      }
      
      public function set alphas(param1:Array) : void
      {
         this._alphas = param1;
         invalidateDisplayList();
      }
      
      public function get ratios() : Array
      {
         return this._ratios;
      }
      
      public function set ratios(param1:Array) : void
      {
         this._ratios = param1;
         invalidateDisplayList();
      }
      
      override public function get styleClassName() : String
      {
         return "Label";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._background = new Sprite();
         this._background.cacheAsBitmap = true;
         addChild(this._background);
         this._textField = new TextField();
         this._textField.type = TextFieldType.DYNAMIC;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this._textField.selectable = false;
         this._textField.cacheAsBitmap = true;
         addChild(this._textField);
         this._background.mask = this._textField;
         this._capitalizeFirst = getStyle("CapitalizeFirst",true);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(!this._textField)
         {
            return;
         }
         this._textField.text = this.actualText;
         var _loc1_:TextFormat = this._textField.getTextFormat();
         _loc1_.font = getStyle("FontFamily");
         _loc1_.size = getStyle("FontSize");
         _loc1_.bold = getStyle("FontWeight") == "bold";
         _loc1_.italic = getStyle("FontStyle") == "italic";
         _loc1_.underline = getStyle("FontDecoration") == "underline";
         _loc1_.align = TextFormatAlign.LEFT;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.setTextFormat(_loc1_);
         if(percentWidth == 0)
         {
            measuredWidth = this._textField.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._textField.height;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Matrix = null;
         super.updateDisplayList(param1,param2);
         if(this.colors.length != this.alphas.length || this.alphas.length != this.ratios.length || this.colors.length != this.ratios.length)
         {
            throw Error("Numbers of colors, alphas and ratios must match.");
         }
         this._textField.x = getStyle("TextFieldXOffset",0);
         this._textField.y = getStyle("TextFieldYOffset",0);
         var _loc3_:Array = [];
         for each(_loc4_ in this.ratios)
         {
            _loc3_.push(_loc4_ / 255 * 145 + 55);
         }
         (_loc5_ = new Matrix()).createGradientBox(param1,param2,this.angle,0,0);
         this._background.graphics.clear();
         this._background.graphics.beginGradientFill(GradientType.LINEAR,this.colors,this.alphas,_loc3_,_loc5_);
         this._background.graphics.drawRect(this._textField.x,this._textField.y,this._textField.width,this._textField.height);
         this._background.graphics.endFill();
      }
      
      private function get actualText() : String
      {
         return this._actualText;
      }
      
      private function set actualText(param1:String) : void
      {
         if(this._actualText != param1)
         {
            this._actualText = Utils.capitalizeFirst(param1);
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function onLocaleChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "value")
         {
            if(this._text is Asset)
            {
               this.actualText = (this._text as Asset).value;
            }
         }
      }
   }
}
