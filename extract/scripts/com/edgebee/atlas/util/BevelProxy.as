package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BevelFilter;
   import flash.filters.BitmapFilter;
   
   public class BevelProxy extends EventDispatcher implements FilterProxy
   {
       
      
      private var _bevel:BevelFilter;
      
      public function BevelProxy()
      {
         super();
         this.reset();
      }
      
      public function get type() : Class
      {
         return BevelFilter;
      }
      
      public function get enabled() : Boolean
      {
         return this._bevel.highlightAlpha > 0 && this._bevel.shadowAlpha > 0;
      }
      
      public function get angle() : Number
      {
         return this._bevel.angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._bevel.angle != param1)
         {
            this._bevel.angle = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get distance() : Number
      {
         return this._bevel.distance;
      }
      
      public function set distance(param1:Number) : void
      {
         if(this._bevel.distance != param1)
         {
            this._bevel.distance = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get highlightAlpha() : Number
      {
         return this._bevel.highlightAlpha;
      }
      
      public function set highlightAlpha(param1:Number) : void
      {
         if(this._bevel.highlightAlpha != param1)
         {
            this._bevel.highlightAlpha = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get highlightColor() : uint
      {
         return this._bevel.highlightColor;
      }
      
      public function set highlightColor(param1:uint) : void
      {
         if(this._bevel.highlightColor != param1)
         {
            this._bevel.highlightColor = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get shadowAlpha() : Number
      {
         return this._bevel.shadowAlpha;
      }
      
      public function set shadowAlpha(param1:Number) : void
      {
         if(this._bevel.shadowAlpha != param1)
         {
            this._bevel.shadowAlpha = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get shadowColor() : uint
      {
         return this._bevel.shadowColor;
      }
      
      public function set shadowColor(param1:uint) : void
      {
         if(this._bevel.shadowColor != param1)
         {
            this._bevel.shadowColor = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blur() : Number
      {
         return this._bevel.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this._bevel.blurX != param1 || this._bevel.blurY != param1)
         {
            this._bevel.blurX = param1;
            this._bevel.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurX() : Number
      {
         return this._bevel.blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         if(this._bevel.blurX != param1)
         {
            this._bevel.blurX = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurY() : Number
      {
         return this._bevel.blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         if(this._bevel.blurY != param1)
         {
            this._bevel.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get quality() : int
      {
         return this._bevel.quality;
      }
      
      public function set quality(param1:int) : void
      {
         if(this._bevel.quality != param1)
         {
            this._bevel.quality = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get knockout() : Boolean
      {
         return this._bevel.knockout;
      }
      
      public function set knockout(param1:Boolean) : void
      {
         if(this._bevel.knockout != param1)
         {
            this._bevel.knockout = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get bevelType() : String
      {
         return this._bevel.type;
      }
      
      public function set bevelType(param1:String) : void
      {
         if(this._bevel.type != param1)
         {
            this._bevel.type = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get filter() : BitmapFilter
      {
         return new BevelFilter(this._bevel.distance,this._bevel.angle,this._bevel.highlightColor,this._bevel.highlightAlpha,this._bevel.shadowColor,this._bevel.shadowAlpha,this._bevel.blurX,this._bevel.blurY,this._bevel.strength,this._bevel.quality,this._bevel.type,this._bevel.knockout);
      }
      
      public function reset() : void
      {
         this._bevel = new BevelFilter();
         this._bevel.highlightAlpha = 0;
         this._bevel.shadowAlpha = 0;
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
