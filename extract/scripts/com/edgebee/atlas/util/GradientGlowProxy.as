package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterType;
   import flash.filters.GradientGlowFilter;
   
   public class GradientGlowProxy extends EventDispatcher implements FilterProxy
   {
       
      
      private var _glow:GradientGlowFilter;
      
      public function GradientGlowProxy()
      {
         super();
         this.reset();
      }
      
      public function get type() : Class
      {
         return GradientGlowFilter;
      }
      
      public function get enabled() : Boolean
      {
         return this._glow.colors != null;
      }
      
      public function get alphas() : Array
      {
         return this._glow.alphas;
      }
      
      public function set alphas(param1:Array) : void
      {
         if(this._glow.alphas != param1)
         {
            this._glow.alphas = param1;
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
      
      public function get angle() : Number
      {
         return this._glow.angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._glow.angle != param1)
         {
            this._glow.angle = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get distance() : Number
      {
         return this._glow.distance;
      }
      
      public function set distance(param1:Number) : void
      {
         if(this._glow.distance != param1)
         {
            this._glow.distance = param1;
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
      
      public function get colors() : Array
      {
         return this._glow.colors;
      }
      
      public function set colors(param1:Array) : void
      {
         if(this._glow.colors != param1)
         {
            this._glow.colors = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get ratios() : Array
      {
         return this._glow.ratios;
      }
      
      public function set ratios(param1:Array) : void
      {
         if(this._glow.ratios != param1)
         {
            this._glow.ratios = param1;
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
      
      public function get gradType() : String
      {
         return this._glow.type;
      }
      
      public function set gradType(param1:String) : void
      {
         if(this._glow.type != param1)
         {
            this._glow.type = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get filter() : BitmapFilter
      {
         return new GradientGlowFilter(this.distance,this.angle,this.colors,this.alphas,this.ratios,this.blurX,this.blurY,this.strength,this.quality,this.gradType,this.knockout);
      }
      
      public function reset() : void
      {
         this._glow = new GradientGlowFilter(4,45,null,null,null,4,4,1,1,BitmapFilterType.OUTER,false);
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
