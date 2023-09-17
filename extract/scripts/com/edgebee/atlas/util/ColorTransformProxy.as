package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class ColorTransformProxy extends EventDispatcher
   {
       
      
      private var _transform:ColorTransform;
      
      public function ColorTransformProxy()
      {
         super();
         this.reset();
      }
      
      public function reset() : void
      {
         this._transform = new ColorTransform();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get isDefaults() : Boolean
      {
         return this.redOffset == 0 && this.greenOffset == 0 && this.blueOffset == 0 && this.alphaOffset == 0 && this.redMultiplier == 1 && this.greenMultiplier == 1 && this.blueMultiplier == 1 && this.alphaMultiplier == 1;
      }
      
      public function get redOffset() : Number
      {
         return this._transform.redOffset;
      }
      
      public function set redOffset(param1:Number) : void
      {
         if(this._transform.redOffset != param1)
         {
            this._transform.redOffset = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get redMultiplier() : Number
      {
         return this._transform.redMultiplier;
      }
      
      public function set redMultiplier(param1:Number) : void
      {
         if(this._transform.redMultiplier != param1)
         {
            this._transform.redMultiplier = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get greenOffset() : Number
      {
         return this._transform.greenOffset;
      }
      
      public function set greenOffset(param1:Number) : void
      {
         if(this._transform.greenOffset != param1)
         {
            this._transform.greenOffset = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get greenMultiplier() : Number
      {
         return this._transform.greenMultiplier;
      }
      
      public function set greenMultiplier(param1:Number) : void
      {
         if(this._transform.greenMultiplier != param1)
         {
            this._transform.greenMultiplier = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blueOffset() : Number
      {
         return this._transform.blueOffset;
      }
      
      public function set blueOffset(param1:Number) : void
      {
         if(this._transform.blueOffset != param1)
         {
            this._transform.blueOffset = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get blueMultiplier() : Number
      {
         return this._transform.blueMultiplier;
      }
      
      public function set blueMultiplier(param1:Number) : void
      {
         if(this._transform.blueMultiplier != param1)
         {
            this._transform.blueMultiplier = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get multiplier() : Number
      {
         return (this._transform.redMultiplier + this._transform.greenMultiplier + this._transform.blueMultiplier) / 3;
      }
      
      public function set multiplier(param1:Number) : void
      {
         if(this.multiplier != param1)
         {
            this._transform.redMultiplier = param1;
            this._transform.greenMultiplier = param1;
            this._transform.blueMultiplier = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get offset() : Number
      {
         return (this._transform.redOffset + this._transform.greenOffset + this._transform.blueOffset) / 3;
      }
      
      public function set offset(param1:Number) : void
      {
         if(this.offset != param1)
         {
            this._transform.redOffset = param1;
            this._transform.greenOffset = param1;
            this._transform.blueOffset = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get alphaOffset() : Number
      {
         return this._transform.alphaOffset;
      }
      
      public function set alphaOffset(param1:Number) : void
      {
         if(this._transform.alphaOffset != param1)
         {
            this._transform.alphaOffset = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get alphaMultiplier() : Number
      {
         return this._transform.alphaMultiplier;
      }
      
      public function set alphaMultiplier(param1:Number) : void
      {
         if(this._transform.alphaMultiplier != param1)
         {
            this._transform.alphaMultiplier = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get color() : uint
      {
         return this._transform.color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._transform.color != param1)
         {
            this._transform.color = param1;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get transform() : ColorTransform
      {
         return new ColorTransform(this.redMultiplier,this.greenMultiplier,this.blueMultiplier,this.alphaMultiplier,this.redOffset,this.greenOffset,this.blueOffset,this.alphaOffset);
      }
   }
}
