package com.edgebee.atlas.util
{
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class Color extends EventDispatcher
   {
       
      
      private var _red:Number;
      
      private var _green:Number;
      
      private var _blue:Number;
      
      public function Color(param1:Number = NaN)
      {
         super();
         if(!isNaN(param1))
         {
            this.hex = param1;
         }
      }
      
      public static function fromRgb(param1:Object) : Color
      {
         var _loc2_:Color = new Color();
         _loc2_.rgb = param1;
         return _loc2_;
      }
      
      private static function clamp(param1:Number, param2:Number = 0, param3:Number = 1) : Number
      {
         if(param1 < param2)
         {
            param1 = param2;
         }
         else if(param1 > param3)
         {
            param1 = param3;
         }
         return param1;
      }
      
      public function get red() : Number
      {
         return this._red;
      }
      
      public function set red(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         param1 = clamp(param1);
         if(this._red != param1)
         {
            _loc2_ = this._red;
            this._red = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"red",_loc2_,param1));
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      public function get red255() : Number
      {
         return this._red * 255;
      }
      
      public function set red255(param1:Number) : void
      {
         this.red = param1 / 255;
      }
      
      public function get r() : Number
      {
         return this.red;
      }
      
      public function set r(param1:Number) : void
      {
         this.red = param1;
      }
      
      public function get green() : Number
      {
         return this._green;
      }
      
      public function set green(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         param1 = clamp(param1);
         if(this._green != param1)
         {
            _loc2_ = this._green;
            this._green = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"green",_loc2_,param1));
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      public function get green255() : Number
      {
         return this._green * 255;
      }
      
      public function set green255(param1:Number) : void
      {
         this.green = param1 / 255;
      }
      
      public function get g() : Number
      {
         return this.green;
      }
      
      public function set g(param1:Number) : void
      {
         this.green = param1;
      }
      
      public function get blue() : Number
      {
         return this._blue;
      }
      
      public function set blue(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         param1 = clamp(param1);
         if(this._blue != param1)
         {
            _loc2_ = this._blue;
            this._blue = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"blue",_loc2_,param1));
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      public function get b() : Number
      {
         return this.blue;
      }
      
      public function set b(param1:Number) : void
      {
         this.blue = param1;
      }
      
      public function get blue255() : Number
      {
         return this._blue * 255;
      }
      
      public function set blue255(param1:Number) : void
      {
         this.blue = param1 / 255;
      }
      
      public function get hex() : Number
      {
         return this.red * 255 << 16 | this.green * 255 << 8 | this.blue * 255;
      }
      
      public function set hex(param1:Number) : void
      {
         this.red = ((param1 & 16711680) >> 16) / 255;
         this.green = ((param1 & 65280) >> 8) / 255;
         this.blue = (param1 & 255) / 255;
      }
      
      public function get rgb() : Object
      {
         return {
            "red":this.red,
            "r":this.red,
            "green":this.green,
            "g":this.green,
            "blue":this.blue,
            "b":this.blue
         };
      }
      
      public function set rgb(param1:Object) : void
      {
         if(param1.hasOwnProperty("red"))
         {
            this.red = param1["red"];
         }
         else if(param1.hasOwnProperty("r"))
         {
            this.red = param1["r"];
         }
         if(param1.hasOwnProperty("green"))
         {
            this.green = param1["green"];
         }
         else if(param1.hasOwnProperty("g"))
         {
            this.green = param1["g"];
         }
         if(param1.hasOwnProperty("blue"))
         {
            this.blue = param1["blue"];
         }
         else if(param1.hasOwnProperty("b"))
         {
            this.blue = param1["b"];
         }
      }
      
      public function get hue() : Number
      {
         var _loc1_:Number = Math.max(this.red,this.green,this.blue);
         var _loc2_:Number = Math.min(this.red,this.green,this.blue);
         if(_loc1_ == _loc2_)
         {
            return 0;
         }
         if(_loc1_ == this.red)
         {
            return (60 * (this.green - this.blue) / (_loc1_ - _loc2_) + 360) % 360;
         }
         if(_loc1_ == this.green)
         {
            return (60 * (this.blue - this.red) / (_loc1_ - _loc2_) + 120) % 360;
         }
         if(_loc1_ == this.blue)
         {
            return (60 * (this.red - this.green) / (_loc1_ - _loc2_) + 240) % 360;
         }
         return 0;
      }
      
      public function get hsl() : Object
      {
         return {
            "h":this.hue,
            "s":this.hsl_saturation,
            "l":this.hsl_lightness
         };
      }
      
      public function set hsl(param1:Object) : void
      {
         var h:Number;
         var s:Number;
         var l:Number;
         var q:Number = NaN;
         var p:Number = NaN;
         var hk:Number = NaN;
         var adjustC:Function = null;
         var tr:Number = NaN;
         var tg:Number = NaN;
         var tb:Number = NaN;
         var getC:Function = null;
         var v:Object = param1;
         if(!v.hasOwnProperty("h") || !v.hasOwnProperty("s") || !v.hasOwnProperty("l"))
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], l:[0,1]}");
         }
         h = Number(v.h);
         s = Number(v.s);
         l = Number(v.l);
         if(h < 0 || h > 360)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], l:[0,1]}");
         }
         if(s < 0 || s > 1)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], l:[0,1]}");
         }
         if(l < 0 || l > 1)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], l:[0,1]}");
         }
         if(s == 0)
         {
            this.red = this.green = this.blue = l;
         }
         else
         {
            if(l < 0.5)
            {
               q = l * (1 + s);
            }
            else
            {
               q = l + s - l * s;
            }
            p = 2 * l - q;
            hk = h / 360;
            adjustC = function(param1:Number):Number
            {
               if(param1 < 0)
               {
                  return param1 + 1;
               }
               if(param1 > 1)
               {
                  return param1 - 1;
               }
               return param1;
            };
            tr = hk + 1 / 3;
            tr = adjustC(tr);
            tg = hk;
            tg = adjustC(tg);
            tb = hk - 1 / 3;
            tb = adjustC(tb);
            getC = function(param1:Number, param2:Number, param3:Number):Number
            {
               if(param3 < 1 / 6)
               {
                  return param1 + (param2 - param1) * 6 * param3;
               }
               if(param3 >= 1 / 6 && param3 < 0.5)
               {
                  return param2;
               }
               if(param3 >= 0.5 && param3 < 2 / 3)
               {
                  return param1 + (param2 - param1) * 6 * (2 / 3 - param3);
               }
               return param1;
            };
            this.red = getC(p,q,tr);
            this.green = getC(p,q,tg);
            this.blue = getC(p,q,tb);
         }
      }
      
      public function get hsv() : Object
      {
         return {
            "h":this.hue,
            "s":this.hsv_saturation,
            "v":this.hsv_value
         };
      }
      
      public function set hsv(param1:Object) : void
      {
         if(!param1.hasOwnProperty("h") || !param1.hasOwnProperty("s") || !param1.hasOwnProperty("v"))
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], v:[0,1]}");
         }
         var _loc2_:Number = Number(param1.h);
         var _loc3_:Number = Number(param1.s);
         var _loc4_:Number = Number(param1.v);
         if(_loc2_ < 0 || _loc2_ > 360)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], v:[0,1]}");
         }
         if(_loc3_ < 0 || _loc3_ > 1)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], v:[0,1]}");
         }
         if(_loc4_ < 0 || _loc4_ > 1)
         {
            throw new Error("Need an object with h, s and l attributes. i.e.: {h:[0,360], s:[0,1], v:[0,1]}");
         }
         var _loc5_:Number = Math.floor(_loc2_ / 60) % 6;
         var _loc6_:Number = _loc2_ / 60 - Math.floor(_loc2_ / 60);
         var _loc7_:Number = _loc4_ * (1 - _loc3_);
         var _loc8_:Number = _loc4_ * (1 - _loc6_ * _loc3_);
         var _loc9_:Number = _loc4_ * (1 - (1 - _loc6_) * _loc3_);
         switch(_loc5_)
         {
            case 0:
               this.red = _loc4_;
               this.green = _loc9_;
               this.blue = _loc7_;
               break;
            case 1:
               this.red = _loc8_;
               this.green = _loc4_;
               this.blue = _loc7_;
               break;
            case 2:
               this.red = _loc7_;
               this.green = _loc4_;
               this.blue = _loc9_;
               break;
            case 3:
               this.red = _loc7_;
               this.green = _loc8_;
               this.blue = _loc4_;
               break;
            case 4:
               this.red = _loc9_;
               this.green = _loc7_;
               this.blue = _loc4_;
               break;
            case 5:
               this.red = _loc4_;
               this.green = _loc7_;
               this.blue = _loc8_;
         }
      }
      
      public function brighten(param1:Number) : void
      {
         this.hex = new Color(this.hex).brighter(param1).hex;
      }
      
      public function brighter(param1:Number) : Color
      {
         var _loc2_:Color = new Color(this.hex);
         if(param1 < 0)
         {
            param1 = (100 + param1) / 100;
            _loc2_.r *= param1;
            _loc2_.g *= param1;
            _loc2_.b *= param1;
         }
         else if(param1 > 0)
         {
            param1 /= 100;
            _loc2_.r += (1 - _loc2_.r) * param1;
            _loc2_.g += (1 - _loc2_.g) * param1;
            _loc2_.b += (1 - _loc2_.b) * param1;
         }
         return _loc2_;
      }
      
      public function invert() : void
      {
         this.r = 1 - this.r;
         this.g = 1 - this.g;
         this.b = 1 - this.b;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function interpolateTo(param1:Color, param2:Number = 1, param3:Function = null) : Color
      {
         if(param3 == null)
         {
            param3 = Interpolation.linear;
         }
         var _loc4_:Color;
         (_loc4_ = new Color()).red = param3(param2,this.red,param1.red - this.red,1);
         _loc4_.green = param3(param2,this.green,param1.green - this.green,1);
         _loc4_.blue = param3(param2,this.blue,param1.blue - this.blue,1);
         return _loc4_;
      }
      
      public function toColorTransform(param1:Number = 25, param2:Number = 1) : ColorTransform
      {
         return new ColorTransform(this.r,this.g,this.b,1,Math.min(255,param1 + this.red255 * param2),Math.min(255,param1 + this.green255 * param2),Math.min(255,param1 + this.blue255 * param2));
      }
      
      private function get hsl_lightness() : Number
      {
         var _loc1_:Number = Math.max(this.red,this.green,this.blue);
         var _loc2_:Number = Math.min(this.red,this.green,this.blue);
         return (_loc1_ + _loc2_) * 0.5;
      }
      
      private function get hsl_saturation() : Number
      {
         var _loc1_:Number = Math.max(this.red,this.green,this.blue);
         var _loc2_:Number = Math.min(this.red,this.green,this.blue);
         var _loc3_:Number = this.hsl_lightness;
         if(_loc1_ == _loc2_)
         {
            return 0;
         }
         if(_loc3_ <= 0.5)
         {
            return (_loc1_ - _loc2_) / (2 * _loc3_);
         }
         return (_loc1_ - _loc2_) / (2 - 2 * _loc3_);
      }
      
      private function get hsv_value() : Number
      {
         return Math.max(this.red,this.green,this.blue);
      }
      
      private function get hsv_saturation() : Number
      {
         var _loc1_:Number = Math.max(this.red,this.green,this.blue);
         var _loc2_:Number = Math.min(this.red,this.green,this.blue);
         if(_loc1_ == 0)
         {
            return 0;
         }
         return (_loc1_ - _loc2_) / _loc1_;
      }
   }
}
