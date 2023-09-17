package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   
   public class GlowProxy extends EventDispatcher implements FilterProxy
   {
       
      
      private var _glow:GlowFilter;
      
      public function GlowProxy()
      {
         super();
         this.reset();
      }
      
      public function get type() : Class
      {
         return GlowFilter;
      }
      
      public function get enabled() : Boolean
      {
         return this._glow.color > 0 || this._glow.alpha > 0;
      }
      
      public function get alpha() : Number
      {
         return this._glow.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._glow.alpha != param1)
         {
            this._glow.alpha = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurX() : Number
      {
         return this._glow.blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         if(this._glow.blurX != param1)
         {
            this._glow.blurX = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurY() : Number
      {
         return this._glow.blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         if(this._glow.blurY != param1)
         {
            this._glow.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blur() : Number
      {
         return this._glow.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this._glow.blurX != param1 || this._glow.blurY != param1)
         {
            this._glow.blurX = param1;
            this._glow.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get color() : uint
      {
         return this._glow.color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._glow.color != param1)
         {
            this._glow.color = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get strength() : Number
      {
         return this._glow.strength;
      }
      
      public function set strength(param1:Number) : void
      {
         if(this._glow.strength != param1)
         {
            this._glow.strength = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get inner() : Boolean
      {
         return this._glow.inner;
      }
      
      public function set inner(param1:Boolean) : void
      {
         if(this._glow.inner != param1)
         {
            this._glow.inner = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get knockout() : Boolean
      {
         return this._glow.knockout;
      }
      
      public function set knockout(param1:Boolean) : void
      {
         if(this._glow.knockout != param1)
         {
            this._glow.knockout = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get quality() : int
      {
         return this._glow.quality;
      }
      
      public function set quality(param1:int) : void
      {
         if(this._glow.quality != param1)
         {
            this._glow.quality = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get filter() : BitmapFilter
      {
         return new GlowFilter(this.color,this.alpha,this.blurX,this.blurY,this.strength,this.quality,this.inner,this.knockout);
      }
      
      public function reset() : void
      {
         this._glow = new GlowFilter(0,0);
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
