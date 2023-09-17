package com.edgebee.atlas.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.ColorMatrixFilter;
   
   public class ColorMatrix extends EventDispatcher
   {
       
      
      protected const LUMINANCE_R:Number = 0.212671;
      
      protected const LUMINANCE_G:Number = 0.71516;
      
      protected const LUMINANCE_B:Number = 0.072169;
      
      protected const IDENTITY:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      protected var m_aMatrix:Array;
      
      protected var m_nAlpha:Number;
      
      protected var m_nBrightness:Number;
      
      protected var m_nContrast:Number;
      
      protected var m_nHue:Number;
      
      protected var m_nSaturation:Number;
      
      public function ColorMatrix(param1:Array = null)
      {
         super();
         this.init(param1 == null ? this.IDENTITY.concat() : param1.concat());
      }
      
      public function valueOf() : Array
      {
         return this.m_aMatrix.concat();
      }
      
      public function clone() : ColorMatrix
      {
         return new ColorMatrix(this.valueOf());
      }
      
      public function reset() : void
      {
         this.init(this.IDENTITY.concat());
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get alpha() : Number
      {
         return this.m_nAlpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         var _loc2_:Number = this.m_nAlpha / 100;
         this.m_nAlpha = param1;
         param1 /= 100;
         param1 /= _loc2_;
         var _loc3_:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,param1,0];
         this.multiply(_loc3_);
      }
      
      public function get brightness() : Number
      {
         return this.m_nBrightness;
      }
      
      public function set brightness(param1:Number) : void
      {
         var _loc2_:Number = this.m_nBrightness * (255 / 100);
         this.m_nBrightness = param1;
         param1 *= 255 / 100;
         param1 -= _loc2_;
         var _loc3_:Array = [1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0];
         this.multiply(_loc3_);
      }
      
      public function get contrast() : Number
      {
         return this.m_nContrast;
      }
      
      public function set contrast(param1:Number) : void
      {
         var _loc2_:Number = this.m_nContrast / 100 + 1;
         this.m_nContrast = param1;
         param1 = param1 / 100 + 1;
         param1 /= _loc2_;
         var _loc3_:Array = [param1,0,0,0,128 * (1 - param1),0,param1,0,0,128 * (1 - param1),0,0,param1,0,128 * (1 - param1),0,0,0,1,0];
         this.multiply(_loc3_);
      }
      
      public function get hue() : Number
      {
         return this.m_nHue;
      }
      
      public function set hue(param1:Number) : void
      {
         var _loc2_:Number = this.m_nHue * (Math.PI / 180);
         this.m_nHue = param1;
         param1 *= Math.PI / 180;
         param1 -= _loc2_;
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         var _loc5_:Array = [this.LUMINANCE_R + _loc3_ * (1 - this.LUMINANCE_R) + _loc4_ * -this.LUMINANCE_R,this.LUMINANCE_G + _loc3_ * -this.LUMINANCE_G + _loc4_ * -this.LUMINANCE_G,this.LUMINANCE_B + _loc3_ * -this.LUMINANCE_B + _loc4_ * (1 - this.LUMINANCE_B),0,0,this.LUMINANCE_R + _loc3_ * -this.LUMINANCE_R + _loc4_ * 0.143,this.LUMINANCE_G + _loc3_ * (1 - this.LUMINANCE_G) + _loc4_ * 0.14,this.LUMINANCE_B + _loc3_ * -this.LUMINANCE_B + _loc4_ * -0.283,0,0,this.LUMINANCE_R + _loc3_ * -this.LUMINANCE_R + _loc4_ * -(1 - this.LUMINANCE_R),this.LUMINANCE_G + _loc3_ * -this.LUMINANCE_G + _loc4_ * this.LUMINANCE_G,this.LUMINANCE_B + _loc3_ * (1 - this.LUMINANCE_B) + _loc4_ * this.LUMINANCE_B,0,0,0,0,0,1,0];
         this.multiply(_loc5_);
      }
      
      public function get saturation() : Number
      {
         return this.m_nSaturation;
      }
      
      public function set saturation(param1:Number) : void
      {
         var _loc2_:Number = (this.m_nSaturation + 100) / 100;
         this.m_nSaturation = Math.min(100,Math.max(-99.99,param1));
         param1 = (this.m_nSaturation + 100) / 100;
         param1 /= _loc2_;
         var _loc3_:Number = (1 - param1) * this.LUMINANCE_R;
         var _loc4_:Number = (1 - param1) * this.LUMINANCE_G;
         var _loc5_:Number = (1 - param1) * this.LUMINANCE_B;
         var _loc6_:Array = [_loc3_ + param1,_loc4_,_loc5_,0,0,_loc3_,_loc4_ + param1,_loc5_,0,0,_loc3_,_loc4_,_loc5_ + param1,0,0,0,0,0,1,0];
         this.multiply(_loc6_);
      }
      
      public function get filter() : ColorMatrixFilter
      {
         return new ColorMatrixFilter(this.valueOf());
      }
      
      public function setDisabledPreset() : void
      {
         this.saturation = -100;
         this.contrast = -25;
         this.brightness = -15;
      }
      
      protected function init(param1:Array) : void
      {
         this.m_aMatrix = param1;
         this.setDefaultValues();
      }
      
      protected function setDefaultValues() : void
      {
         this.m_nAlpha = 100;
         this.m_nBrightness = 0;
         this.m_nContrast = 0;
         this.m_nHue = 0;
         this.m_nSaturation = 0;
      }
      
      protected function multiply(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = 0;
            while(_loc5_ < 5)
            {
               _loc2_[_loc3_ + _loc5_] = param1[_loc3_] * this.m_aMatrix[_loc5_] + param1[_loc3_ + 1] * this.m_aMatrix[_loc5_ + 5] + param1[_loc3_ + 2] * this.m_aMatrix[_loc5_ + 10] + param1[_loc3_ + 3] * this.m_aMatrix[_loc5_ + 15] + (_loc5_ == 4 ? param1[_loc3_ + 4] : 0);
               _loc5_++;
            }
            _loc3_ += 5;
            _loc4_++;
         }
         this.m_aMatrix = _loc2_.concat();
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
