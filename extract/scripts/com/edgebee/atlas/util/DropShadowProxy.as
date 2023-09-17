package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   
   public class DropShadowProxy extends EventDispatcher implements FilterProxy
   {
       
      
      private var _shadow:DropShadowFilter;
      
      public function DropShadowProxy()
      {
         super();
         this.reset();
      }
      
      public function get type() : Class
      {
         return DropShadowFilter;
      }
      
      public function get enabled() : Boolean
      {
         return this._shadow.alpha > 0;
      }
      
      public function get alpha() : Number
      {
         return this._shadow.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._shadow.alpha != param1)
         {
            this._shadow.alpha = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get angle() : Number
      {
         return this._shadow.angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._shadow.angle != param1)
         {
            this._shadow.angle = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurX() : Number
      {
         return this._shadow.blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         if(this._shadow.blurX != param1)
         {
            this._shadow.blurX = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurY() : Number
      {
         return this._shadow.blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         if(this._shadow.blurY != param1)
         {
            this._shadow.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blur() : Number
      {
         return this._shadow.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this._shadow.blurX != param1 || this._shadow.blurY != param1)
         {
            this._shadow.blurX = param1;
            this._shadow.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get color() : uint
      {
         return this._shadow.color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._shadow.color != param1)
         {
            this._shadow.color = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get distance() : Number
      {
         return this._shadow.distance;
      }
      
      public function set distance(param1:Number) : void
      {
         if(this._shadow.distance != param1)
         {
            this._shadow.distance = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get hideObject() : Boolean
      {
         return this._shadow.hideObject;
      }
      
      public function set hideObject(param1:Boolean) : void
      {
         if(this._shadow.hideObject != param1)
         {
            this._shadow.hideObject = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get strength() : Number
      {
         return this._shadow.strength;
      }
      
      public function set strength(param1:Number) : void
      {
         if(this._shadow.strength != param1)
         {
            this._shadow.strength = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get inner() : Boolean
      {
         return this._shadow.inner;
      }
      
      public function set inner(param1:Boolean) : void
      {
         if(this._shadow.inner != param1)
         {
            this._shadow.inner = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get knockout() : Boolean
      {
         return this._shadow.knockout;
      }
      
      public function set knockout(param1:Boolean) : void
      {
         if(this._shadow.knockout != param1)
         {
            this._shadow.knockout = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get quality() : int
      {
         return this._shadow.quality;
      }
      
      public function set quality(param1:int) : void
      {
         if(this._shadow.quality != param1)
         {
            this._shadow.quality = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get filter() : BitmapFilter
      {
         return new DropShadowFilter(this.distance,this.angle,this.color,this.alpha,this.blurX,this.blurY,this.strength,this.quality,this.inner,this.knockout,this.hideObject);
      }
      
      public function reset() : void
      {
         this._shadow = new DropShadowFilter(4,45,0,0);
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
