package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.filters.BlurFilter;
   
   public class BlurProxy extends EventDispatcher implements FilterProxy
   {
       
      
      private var _blur:BlurFilter;
      
      public function BlurProxy()
      {
         super();
         this.reset();
      }
      
      public function get type() : Class
      {
         return BlurFilter;
      }
      
      public function get enabled() : Boolean
      {
         return this._blur.blurX > 0 || this._blur.blurY > 0;
      }
      
      public function get blur() : Number
      {
         return this._blur.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this._blur.blurX != param1 || this._blur.blurY != param1)
         {
            this._blur.blurX = param1;
            this._blur.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurX() : Number
      {
         return this._blur.blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         if(this._blur.blurX != param1)
         {
            this._blur.blurX = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blurY() : Number
      {
         return this._blur.blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         if(this._blur.blurY != param1)
         {
            this._blur.blurY = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get quality() : int
      {
         return this._blur.quality;
      }
      
      public function set quality(param1:int) : void
      {
         if(this._blur.quality != param1)
         {
            this._blur.quality = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get filter() : BitmapFilter
      {
         return new BlurFilter(this._blur.blurX,this._blur.blurY,this._blur.quality);
      }
      
      public function reset() : void
      {
         this._blur = new BlurFilter(0,0);
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
