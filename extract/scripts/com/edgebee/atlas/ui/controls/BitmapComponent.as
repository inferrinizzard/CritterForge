package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.Component;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   
   public class BitmapComponent extends Component
   {
       
      
      private var _bitmap:Bitmap;
      
      private var _centered:Boolean = false;
      
      private var _smoothing:Boolean = true;
      
      private var _pixelSnapping:String = "auto";
      
      private var _isSquare:Boolean = false;
      
      private var _bitmapRect:Rectangle;
      
      public function BitmapComponent()
      {
         super();
      }
      
      public function get bitmap() : Bitmap
      {
         return this._bitmap;
      }
      
      public function set bitmap(param1:Bitmap) : void
      {
         if(this._bitmap != param1)
         {
            if(this._bitmap)
            {
               removeChild(this._bitmap);
            }
            this._bitmap = param1;
            if(this._bitmap)
            {
               if(this.bitmapRect)
               {
                  this._bitmap.x = this.bitmapRect.x * width;
                  this._bitmap.y = this.bitmapRect.y * height;
                  this._bitmap.width = this.bitmapRect.width * width;
                  this._bitmap.height = this.bitmapRect.height * height;
               }
               else
               {
                  this._bitmap.x = 0;
                  this._bitmap.y = 0;
                  this._bitmap.width = width;
                  this._bitmap.height = height;
               }
               this._bitmap.pixelSnapping = this.pixelSnapping;
               this._bitmap.smoothing = this.smoothing;
               addChild(this._bitmap);
            }
            invalidateDisplayList();
         }
      }
      
      public function set source(param1:Class) : void
      {
         if(param1)
         {
            this.bitmap = new param1();
         }
         else
         {
            this.bitmap = null;
         }
      }
      
      public function get centered() : Boolean
      {
         return this._centered;
      }
      
      public function set centered(param1:Boolean) : void
      {
         this._centered = param1;
         invalidateDisplayList();
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         if(this._smoothing != param1)
         {
            this._smoothing = param1;
            if(this.bitmap)
            {
               this.bitmap.smoothing = this._smoothing;
            }
         }
      }
      
      public function get pixelSnapping() : String
      {
         return this._pixelSnapping;
      }
      
      public function set pixelSnapping(param1:String) : void
      {
         if(this._pixelSnapping != param1)
         {
            this._pixelSnapping = param1;
            if(this.bitmap)
            {
               this.bitmap.pixelSnapping = this._pixelSnapping;
            }
         }
      }
      
      public function get isSquare() : Boolean
      {
         return this._isSquare;
      }
      
      public function set isSquare(param1:Boolean) : void
      {
         if(this._isSquare != param1)
         {
            this._isSquare = param1;
            invalidateSize();
         }
      }
      
      public function get bitmapRect() : Rectangle
      {
         return this._bitmapRect;
      }
      
      public function set bitmapRect(param1:Rectangle) : void
      {
         if(this._bitmapRect != param1)
         {
            this._bitmapRect = param1;
            if(this.bitmap)
            {
               this._bitmap.x = this.bitmapRect.x * width;
               this._bitmap.y = this.bitmapRect.y * height;
               this._bitmap.width = this.bitmapRect.width * width;
               this._bitmap.height = this.bitmapRect.height * height;
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.positionBitmap();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.isSquare)
         {
            if(width != height && height > 0)
            {
               width = height;
            }
            else if(width != height && width > 0)
            {
               height = width;
            }
         }
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         if(this._bitmap)
         {
            if(this.bitmapRect)
            {
               this._bitmap.x = this.bitmapRect.x * width;
               this._bitmap.y = this.bitmapRect.y * height;
               this._bitmap.width = this.bitmapRect.width * width;
               this._bitmap.height = this.bitmapRect.height * height;
            }
            else
            {
               this._bitmap.x = 0;
               this._bitmap.y = 0;
               this._bitmap.width = width;
               this._bitmap.height = height;
            }
         }
         if(this.isSquare)
         {
            if(width != height && height > 0)
            {
               width = height;
            }
            else if(width != height && width > 0)
            {
               height = width;
            }
         }
      }
      
      private function positionBitmap() : void
      {
         if(Boolean(this.bitmap) && !this.bitmapRect)
         {
            if(this.centered)
            {
               this.bitmap.x = -this.bitmap.width / 2;
               this.bitmap.y = -this.bitmap.height / 2;
            }
            else
            {
               this.bitmap.x = 0;
               this.bitmap.y = 0;
            }
         }
      }
   }
}
