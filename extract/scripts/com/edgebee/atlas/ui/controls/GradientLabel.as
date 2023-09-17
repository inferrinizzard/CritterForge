package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.util.Utils;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class GradientLabel extends Component
   {
       
      
      private var _integer:Number = 0;
      
      private var _abbreviate:Boolean;
      
      private var _text = "";
      
      private var _actualText:String = "";
      
      private var _textField:TextField;
      
      private var _gradientTextField:TextField;
      
      private var _alignment:String = "left";
      
      private var _autoSize:Boolean = true;
      
      private var _mask:Sprite;
      
      private var _angle:Number = 1.5707963267948966;
      
      private var _colors:Array;
      
      private var _alphas:Array;
      
      private var _ratios:Array;
      
      private var _wordWrap:Boolean = false;
      
      private var _capitalizeFirst:Boolean;
      
      private var _capitalized:Boolean = false;
      
      public function GradientLabel()
      {
         this._colors = [7829367,16777215];
         this._alphas = [1,1];
         this._ratios = [55,200];
         super();
         cacheAsBitmap = true;
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
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
         return this._integer;
      }
      
      public function set integer(param1:Number) : void
      {
         var _loc2_:String = null;
         this._integer = param1;
         if(this._abbreviate)
         {
            _loc2_ = Utils.abreviateNumber(Math.floor(param1),1);
         }
         else
         {
            _loc2_ = Utils.toFixed(Math.floor(param1),0);
         }
         this.text = _loc2_;
      }
      
      public function get abbreviate() : Boolean
      {
         return this._abbreviate;
      }
      
      public function set abbreviate(param1:Boolean) : void
      {
         this._abbreviate = true;
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
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap != param1)
         {
            this._wordWrap = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override public function get styleClassName() : String
      {
         return "Label";
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         super.createChildren();
         this._textField = new TextField();
         this._textField.type = TextFieldType.DYNAMIC;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.selectable = false;
         this._textField.cacheAsBitmap = true;
         this._textField.multiline = true;
         addChild(this._textField);
         this._gradientTextField = new TextField();
         this._gradientTextField.type = TextFieldType.DYNAMIC;
         this._gradientTextField.autoSize = TextFieldAutoSize.LEFT;
         this._gradientTextField.selectable = false;
         this._gradientTextField.cacheAsBitmap = true;
         this._textField.multiline = true;
         addChild(this._gradientTextField);
         this._mask = new Sprite();
         this._mask.cacheAsBitmap = true;
         addChild(this._mask);
         this._gradientTextField.mask = this._mask;
         this._capitalizeFirst = getStyle("CapitalizeFirst",true);
         if(this.actualText)
         {
            _loc1_ = this.actualText;
            this._actualText = "";
            this.actualText = _loc1_;
         }
      }
      
      override protected function measure() : void
      {
         var _loc2_:TextFormat = null;
         super.measure();
         if(!this._textField)
         {
            return;
         }
         if(this.colors.length != 2)
         {
            throw Error("Gradient label only supports two colors");
         }
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            this._textField.text = this.actualText;
            this._gradientTextField.text = this.actualText;
            _loc2_ = this._textField.getTextFormat();
            _loc2_.font = getStyle("FontFamily");
            _loc2_.size = getStyle("FontSize");
            _loc2_.color = this.colors[0];
            _loc2_.bold = getStyle("FontWeight") == "bold";
            _loc2_.italic = getStyle("FontStyle") == "italic";
            _loc2_.underline = getStyle("FontDecoration") == "underline";
            _loc2_.align = TextFormatAlign.LEFT;
            this._textField.autoSize = TextFieldAutoSize.LEFT;
            this._textField.setTextFormat(_loc2_);
            this._textField.wordWrap = this.wordWrap;
            _loc2_ = this._gradientTextField.getTextFormat();
            _loc2_.font = getStyle("FontFamily");
            _loc2_.size = getStyle("FontSize");
            _loc2_.color = this.colors[1];
            _loc2_.bold = getStyle("FontWeight") == "bold";
            _loc2_.italic = getStyle("FontStyle") == "italic";
            _loc2_.underline = getStyle("FontDecoration") == "underline";
            _loc2_.align = TextFormatAlign.LEFT;
            this._gradientTextField.autoSize = TextFieldAutoSize.LEFT;
            this._gradientTextField.setTextFormat(_loc2_);
            this._gradientTextField.x = 0;
            this._gradientTextField.wordWrap = this.wordWrap;
            if(percentWidth == 0)
            {
               measuredWidth = this._textField.width;
            }
            if(percentHeight == 0)
            {
               measuredHeight = this._textField.height;
            }
            _loc1_++;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:int = 0;
         super.updateDisplayList(param1,param2);
         if(this._textField.width > param1)
         {
            if((_loc5_ = this._textField.getCharIndexAtPoint(param1,param2 / 2)) > 3)
            {
               this._textField.replaceText(_loc5_ - 3,this._textField.length,"...");
               this._gradientTextField.replaceText(_loc5_ - 3,this._gradientTextField.length,"...");
            }
         }
         var _loc3_:TextFormat = this._textField.getTextFormat();
         _loc3_.font = getStyle("FontFamily");
         _loc3_.size = getStyle("FontSize");
         _loc3_.color = this.colors[0];
         _loc3_.bold = getStyle("FontWeight") == "bold";
         _loc3_.italic = getStyle("FontStyle") == "italic";
         _loc3_.underline = getStyle("FontDecoration") == "underline";
         _loc3_.align = TextFormatAlign.LEFT;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.setTextFormat(_loc3_);
         _loc3_ = this._gradientTextField.getTextFormat();
         _loc3_.font = getStyle("FontFamily");
         _loc3_.size = getStyle("FontSize");
         _loc3_.color = this.colors[1];
         _loc3_.bold = getStyle("FontWeight") == "bold";
         _loc3_.italic = getStyle("FontStyle") == "italic";
         _loc3_.underline = getStyle("FontDecoration") == "underline";
         _loc3_.align = TextFormatAlign.LEFT;
         this._gradientTextField.autoSize = TextFieldAutoSize.LEFT;
         this._gradientTextField.setTextFormat(_loc3_);
         var _loc4_:Matrix;
         (_loc4_ = new Matrix()).createGradientBox(param1,param2,this.angle,0,0);
         this._mask.graphics.clear();
         this._mask.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[1,0],this.ratios,_loc4_);
         this._mask.graphics.drawRect(0,0,param1,param2);
         this._mask.graphics.endFill();
      }
      
      private function onStyleChange(param1:StyleChangedEvent) : void
      {
         if(param1.style == "CapitalizeFirst")
         {
            this._capitalizeFirst = param1.newValue;
            this.updateText();
         }
      }
      
      private function get actualText() : String
      {
         return this._actualText;
      }
      
      private function set actualText(param1:String) : void
      {
         if(this._actualText != param1)
         {
            if(param1 == null)
            {
               param1 = "";
            }
            if(this._capitalizeFirst)
            {
               this._capitalized = true;
               this._actualText = Utils.capitalizeFirst(param1);
            }
            else
            {
               this._capitalized = false;
               this._actualText = param1;
            }
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function updateText() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this._text as Asset)
            {
               this.actualText = (this._text as Asset).value;
            }
            else
            {
               this.actualText = this._text as String;
            }
         }
      }
      
      private function onLocaleChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "value")
         {
            this.updateText();
         }
      }
   }
}
