package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.events.ScrollEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.containers.ScrollableBox;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   
   public class LoggingBox extends ScrollableBox
   {
       
      
      private var _textArea:com.edgebee.atlas.ui.controls.TextArea;
      
      private var _channel:String = "default";
      
      private var _channels:Object;
      
      private var _maxCharacters:uint = 3072;
      
      private var _fontFamily:String;
      
      private var _fontColor:Number = 16777215;
      
      private var _fontSize:Number = 10;
      
      private var _textAlign:String = "left";
      
      public function LoggingBox()
      {
         this._channels = {"default":""};
         super();
      }
      
      public function get maxCharacters() : uint
      {
         return this._maxCharacters;
      }
      
      public function set maxCharacters(param1:uint) : void
      {
         this._maxCharacters = param1;
         if(childrenCreated)
         {
            this.prune();
         }
      }
      
      override public function get styleClassName() : String
      {
         return "LoggingBox";
      }
      
      public function get channel() : String
      {
         return this._channel;
      }
      
      public function set channel(param1:String) : void
      {
         if(this._channel != param1)
         {
            this._channel = param1;
            if(!this._channels.hasOwnProperty(this._channel))
            {
               this._channels[this._channel] = "";
            }
            this._textArea.text = this._channels[this.channel];
            this.prune(this.channel);
            content.invalidateSize();
            content.validateNow(true);
            scrollPosition = 0;
            this.onContentResize(null);
         }
      }
      
      public function deleteChannel(param1:String) : void
      {
         if(this._channels.hasOwnProperty(param1))
         {
            delete this._channels[param1];
         }
      }
      
      public function print(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false, param5:String = null) : void
      {
         if(!param5)
         {
            param5 = this.channel;
         }
         param1 = param1.replace(/\[/g,"&#91;");
         param1 = param1.replace(/\]/g,"&#93;");
         this._channels[param5] += Utils.htmlWrap(param1,this._fontFamily,!!param2 ? param2 : this._fontColor,this._fontSize,param3,param4);
         if(param5 == this.channel)
         {
            this._textArea.text = this._channels[param5];
         }
      }
      
      public function flush(param1:String = null, param2:Boolean = true) : void
      {
         if(!param1)
         {
            param1 = this.channel;
         }
         this._channels[param1] += "<br>";
         if(param1 == this.channel)
         {
            this._textArea.text = this._channels[param1];
         }
         this.prune(param1);
      }
      
      override public function onContentResize(param1:Event) : void
      {
         super.onContentResize(param1);
         dispatchEvent(new ScrollEvent(ScrollEvent.CONTENT_RESIZE));
         scrollBar.scrollToMaximum();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._textArea = new com.edgebee.atlas.ui.controls.TextArea();
         this._textArea.text = "";
         this._textArea.percentWidth = 1;
         this._textArea.useHtml = true;
         this._textArea.alignment = this._textAlign;
         content.addChild(this._textArea);
      }
      
      override protected function onStyleChanged(param1:StyleChangedEvent) : void
      {
         super.onStyleChanged(param1);
         if(param1.style == "FontFamily")
         {
            this._fontFamily = param1.newValue;
         }
         if(param1.style == "FontColor")
         {
            this._fontColor = param1.newValue;
         }
         if(param1.style == "FontSize")
         {
            this._fontSize = param1.newValue;
         }
         if(param1.style == "TextAlignment")
         {
            this._textAlign = param1.newValue;
            if(childrenCreated || childrenCreating)
            {
               this._textArea.alignment = param1.newValue;
            }
         }
      }
      
      private function prune(param1:String = null) : void
      {
         var _loc3_:uint = 0;
         if(!param1)
         {
            param1 = this.channel;
         }
         var _loc2_:Boolean = false;
         while(this._channels[param1].length > this.maxCharacters)
         {
            _loc3_ = uint(this._channels[param1].indexOf("<br>"));
            if(_loc3_ < 0)
            {
               break;
            }
            this._channels[param1] = this._channels[param1].slice(_loc3_ + 4);
            _loc2_ = true;
         }
         if(_loc2_ && param1 == this.channel)
         {
            this._textArea.text = this._channels[param1];
         }
      }
   }
}
