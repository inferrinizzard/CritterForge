package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.data.l10n.FormattedAsset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.util.Utils;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class Label extends Component
   {
       
      
      private var _selectable:Boolean = false;
      
      private var _forcedColor = null;
      
      private var _wordWrap:Boolean = false;
      
      private var _useHtml:Boolean = false;
      
      private var _text;
      
      private var _actualText:String = "";
      
      private var _textField:TextField;
      
      private var _alignment:String = "left";
      
      private var _capitalizeFirst:Boolean;
      
      private var _capitalized:Boolean = false;
      
      public function Label()
      {
         super();
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get useHtml() : Boolean
      {
         return this._useHtml;
      }
      
      public function set useHtml(param1:Boolean) : void
      {
         if(this._useHtml != param1)
         {
            this._useHtml = param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get text() : *
      {
         return this._text;
      }
      
      public function set text(param1:*) : void
      {
         var _loc2_:Asset = null;
         var _loc3_:FormattedAsset = null;
         if(this._text != param1)
         {
            if(this._text is Asset || this._text is FormattedAsset)
            {
               this._localizedAsset.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLocaleChange);
            }
            this._text = param1;
            if(this._text is String)
            {
               this.actualText = this._text;
            }
            else if(this._text is Asset)
            {
               _loc2_ = this._localizedAsset;
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
            else if(this._text is FormattedAsset)
            {
               _loc3_ = this._formattedAsset;
               _loc3_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLocaleChange);
               this.actualText = _loc3_.text;
            }
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
            invalidateDisplayList();
         }
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
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
         if(this._textField)
         {
            this._textField.selectable = param1;
         }
      }
      
      override public function get styleClassName() : String
      {
         return "Label";
      }
      
      override protected function measure() : void
      {
         var _loc1_:TextFormat = null;
         super.measure();
         if(this.useHtml)
         {
            if(this.actualText != this._textField.htmlText)
            {
               this._textField.htmlText = this.actualText;
               invalidateDisplayList();
            }
         }
         else
         {
            this._textField.htmlText = "";
            if(this.actualText != this._textField.text)
            {
               this._textField.text = !!this.actualText ? this.actualText : "";
               invalidateDisplayList();
            }
            _loc1_ = this._textField.getTextFormat();
            _loc1_.font = getStyle("FontFamily");
            _loc1_.size = getStyle("FontSize");
            _loc1_.color = getStyle("FontColor");
            _loc1_.bold = getStyle("FontWeight") == "bold";
            _loc1_.italic = getStyle("FontStyle") == "italic";
            _loc1_.underline = getStyle("FontDecoration") == "underline";
            _loc1_.leading = getStyle("FontLeading");
            this._textField.setTextFormat(_loc1_);
         }
         this._textField.wordWrap = this.wordWrap;
         if(this._textField.wordWrap)
         {
            this._textField.width = measuredWidth;
         }
         if(percentWidth == 0)
         {
            measuredWidth = this._textField.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._textField.height;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         super.createChildren();
         this._textField = new TextField();
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.type = TextFieldType.DYNAMIC;
         this._textField.selectable = this.selectable;
         this._textField.cacheAsBitmap = true;
         this._textField.multiline = true;
         if(this.useHtml)
         {
            this._textField.htmlText = this.actualText;
         }
         else
         {
            this._textField.text = this.actualText;
         }
         addChild(this._textField);
         this._capitalizeFirst = getStyle("CapitalizeFirst",true);
         if(this.actualText)
         {
            _loc1_ = this.actualText;
            this._actualText = "";
            this.actualText = _loc1_;
         }
         this.updateText();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TextFormat = null;
         super.updateDisplayList(param1,param2);
         if(this._textField.width > param1)
         {
            _loc3_ = this._textField.getCharIndexAtPoint(param1,param2 / 2);
            if(_loc3_ > 3)
            {
               this._textField.replaceText(_loc3_ - 3,this._textField.length,"...");
               (_loc4_ = this._textField.getTextFormat()).font = getStyle("FontFamily");
               _loc4_.size = getStyle("FontSize");
               _loc4_.color = getStyle("FontColor");
               _loc4_.bold = getStyle("FontWeight") == "bold";
               _loc4_.italic = getStyle("FontStyle") == "italic";
               _loc4_.underline = getStyle("FontDecoration") == "underline";
               this._textField.setTextFormat(_loc4_);
            }
         }
         if(this.alignment == TextFieldAutoSize.RIGHT)
         {
            this._textField.x = param1 - this._textField.width;
         }
         else if(this.alignment == TextFieldAutoSize.CENTER)
         {
            this._textField.x = param1 / 2 - this._textField.width / 2;
         }
         else
         {
            this._textField.x = 0;
         }
      }
      
      private function get _localizedAsset() : Asset
      {
         return this._text as Asset;
      }
      
      private function get _formattedAsset() : FormattedAsset
      {
         return this._text as FormattedAsset;
      }
      
      private function get _textString() : String
      {
         return this._text as String;
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
         if(this._actualText != param1 || this._capitalizeFirst != this._capitalized)
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
            if(this.useHtml)
            {
               this._actualText = Utils.htmlWrap(this._actualText,getStyle("FontFamily"),getStyle("FontColor",0),getStyle("FontSize"),getStyle("FontWeight") == "bold");
            }
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function updateText() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this._formattedAsset)
            {
               this.actualText = (this._text as FormattedAsset).text;
            }
            else if(this._localizedAsset)
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
         if(param1.property == "value" || param1.property == "text")
         {
            this.updateText();
         }
      }
   }
}
