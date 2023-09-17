package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.data.l10n.FormattedAsset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TextArea extends Component
   {
       
      
      private var _useHtml:Boolean = false;
      
      protected var _text;
      
      private var _actualText:String = "";
      
      protected var _textField:TextField;
      
      private var _preferedWidth:Number = NaN;
      
      private var _alignment:String = "left";
      
      private var _editable:Boolean = true;
      
      public function TextArea()
      {
         super();
         this._textField = new TextField();
         this._textField.selectable = true;
         addChild(this._textField);
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
            this.resetTextField();
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
            if(this._text is Asset)
            {
               (this._text as Asset).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLocaleChange);
            }
            else if(this._text is FormattedAsset)
            {
               (this._text as FormattedAsset).removeEventListener(Event.CHANGE,this.onFormattedAssetChange);
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
            else if(this._text is FormattedAsset)
            {
               _loc3_ = this._text as FormattedAsset;
               _loc3_.addEventListener(Event.CHANGE,this.onFormattedAssetChange);
               if(_loc3_.text)
               {
                  this.actualText = _loc3_.text;
               }
               else
               {
                  this.actualText = "";
               }
            }
         }
      }
      
      public function get displayedText() : String
      {
         if(this._textField)
         {
            return this._textField.text;
         }
         return "";
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
            this.resetTextField();
         }
      }
      
      public function get textWidth() : Number
      {
         if(childrenCreated)
         {
            return this._textField.textWidth;
         }
         return 0;
      }
      
      public function get textHeight() : Number
      {
         if(childrenCreated)
         {
            return this._textField.textHeight;
         }
         return 0;
      }
      
      public function get preferedWidth() : Number
      {
         return this._preferedWidth;
      }
      
      public function set preferedWidth(param1:Number) : void
      {
         if(this._preferedWidth != param1)
         {
            this._preferedWidth = param1;
            this.resetTextField();
         }
      }
      
      public function set textColor(param1:uint) : void
      {
         this._textField.textColor = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this._textField.selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._textField.selectable = param1;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._textField.wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._textField.wordWrap = param1;
      }
      
      override public function get styleClassName() : String
      {
         return "Label";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.resetTextField();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = this._textField.width;
         var _loc2_:Number = this._textField.height;
         if(percentWidth == 0)
         {
            if(!isNaN(explicitWidth))
            {
               this._textField.width = explicitWidth;
            }
            else if(!isNaN(this.preferedWidth))
            {
               this._textField.width = this.preferedWidth;
            }
            else if(this.hasCarriageReturn)
            {
               this._textField.width = UIGlobals.root.width;
            }
            else if(this._textField.numLines > 1 && percentHeight == 0 && isNaN(explicitHeight))
            {
               while(this._textField.textWidth / this._textField.textHeight < 1.3)
               {
                  this._textField.width += 120;
               }
            }
         }
         else
         {
            this._textField.width = measuredWidth;
         }
         if(percentHeight == 0)
         {
            if(!isNaN(explicitHeight))
            {
               this._textField.height = explicitHeight;
            }
         }
         else
         {
            this._textField.height = measuredHeight;
         }
         if(percentWidth == 0)
         {
            this._textField.width = this._textField.textWidth + 6;
            measuredWidth = this._textField.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._textField.height;
         }
         this._textField.width = _loc1_;
         this._textField.height = _loc2_;
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         if(this._textField.width != width)
         {
            this._textField.width = width;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:Number = getStyle("BackgroundAlpha");
         if(_loc3_)
         {
            _loc4_ = getStyle("CornerRadius");
            graphics.beginFill(getStyle("BackgroundColor"),_loc3_);
            graphics.drawRoundRect(0,0,param1,param2,_loc4_,_loc4_);
            graphics.endFill();
         }
      }
      
      public function resetTextField() : void
      {
         var _loc1_:TextFormat = null;
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         this._textField.multiline = true;
         this._textField.wordWrap = true;
         _loc1_ = this._textField.getTextFormat();
         _loc1_.font = getStyle("FontFamily");
         _loc1_.size = getStyle("FontSize");
         _loc1_.color = getStyle("FontColor");
         _loc1_.leading = getStyle("TextLeading",null);
         _loc1_.bold = getStyle("FontWeight") == "bold";
         _loc1_.italic = getStyle("FontStyle") == "italic";
         _loc1_.underline = getStyle("FontDecoration") == "underline";
         _loc1_.align = this.alignment;
         this._textField.defaultTextFormat = _loc1_;
         if(this._useHtml)
         {
            this._textField.htmlText = this.actualText;
         }
         else
         {
            this._textField.text = this.actualText;
            _loc1_ = this._textField.getTextFormat();
            _loc1_.font = getStyle("FontFamily");
            _loc1_.size = getStyle("FontSize");
            _loc1_.color = getStyle("FontColor");
            _loc1_.leading = getStyle("TextLeading",null);
            _loc1_.bold = getStyle("FontWeight") == "bold";
            _loc1_.italic = getStyle("FontStyle") == "italic";
            _loc1_.underline = getStyle("FontDecoration") == "underline";
            _loc1_.align = this.alignment;
            this._textField.setTextFormat(_loc1_);
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function get actualText() : String
      {
         return this._actualText;
      }
      
      protected function set actualText(param1:String) : void
      {
         if(this._actualText != param1)
         {
            if(this.useHtml)
            {
               param1 = Utils.htmlWrap(Utils.capitalizeFirst(param1),getStyle("FontFamily"),getStyle("FontColor"),getStyle("FontSize"),false,false,getStyle("Alignment",null));
            }
            else
            {
               param1 = Utils.capitalizeFirst(param1);
            }
            this._actualText = param1;
            this.resetTextField();
         }
      }
      
      private function onLocaleChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "value")
         {
            if(this.text is Asset)
            {
               this.actualText = (this.text as Asset).value;
            }
         }
      }
      
      private function onFormattedAssetChange(param1:Event) : void
      {
         if(this.text is FormattedAsset)
         {
            this.actualText = (this.text as FormattedAsset).text;
         }
      }
      
      private function get hasCarriageReturn() : Boolean
      {
         var _loc1_:RegExp = null;
         if(this.useHtml)
         {
            _loc1_ = /<br>|\n/i;
            return this.actualText.search(_loc1_) != -1;
         }
         return this.actualText.search("\n") != -1;
      }
   }
}
