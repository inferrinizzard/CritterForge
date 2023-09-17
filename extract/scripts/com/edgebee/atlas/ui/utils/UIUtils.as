package com.edgebee.atlas.ui.utils
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import flash.display.Bitmap;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class UIUtils
   {
       
      
      public function UIUtils()
      {
         super();
      }
      
      public static function adjustBrightness(param1:uint, param2:Number) : uint
      {
         var _loc3_:Number = Math.max(Math.min((param1 >> 16 & 255) + param2,255),0);
         var _loc4_:Number = Math.max(Math.min((param1 >> 8 & 255) + param2,255),0);
         var _loc5_:Number = Math.max(Math.min((param1 & 255) + param2,255),0);
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      public static function adjustBrightness2(param1:uint, param2:Number) : uint
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param2 == 0)
         {
            return param1;
         }
         if(param2 < 0)
         {
            param2 = (100 + param2) / 100;
            _loc3_ = (param1 >> 16 & 255) * param2;
            _loc4_ = (param1 >> 8 & 255) * param2;
            _loc5_ = (param1 & 255) * param2;
         }
         else
         {
            param2 /= 100;
            _loc3_ = param1 >> 16 & 255;
            _loc4_ = param1 >> 8 & 255;
            _loc5_ = param1 & 255;
            _loc3_ += (255 - _loc3_) * param2;
            _loc4_ += (255 - _loc4_) * param2;
            _loc5_ += (255 - _loc5_) * param2;
            _loc3_ = Math.min(_loc3_,255);
            _loc4_ = Math.min(_loc4_,255);
            _loc5_ = Math.min(_loc5_,255);
         }
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      public static function drawRoundRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Object = null, param7:Object = null, param8:Object = null, param9:Object = null, param10:String = null, param11:Array = null, param12:Object = null) : void
      {
         var _loc13_:Number = NaN;
         var _loc14_:Array = null;
         var _loc15_:Matrix = null;
         var _loc16_:Object = null;
         if(!param4 || !param5)
         {
            return;
         }
         if(param7 !== null)
         {
            if(param7 is Array)
            {
               if(param8 is Array)
               {
                  _loc14_ = param8 as Array;
               }
               else
               {
                  _loc14_ = [param8,param8];
               }
               if(!param11)
               {
                  param11 = [0,255];
               }
               _loc15_ = null;
               if(param9)
               {
                  if(param9 is Matrix)
                  {
                     _loc15_ = Matrix(param9);
                  }
                  else
                  {
                     _loc15_ = new Matrix();
                     if(param9 is Number)
                     {
                        _loc15_.createGradientBox(param4,param5,Number(param9) * Math.PI / 180,param2,param3);
                     }
                     else
                     {
                        _loc15_.createGradientBox(param9.w,param9.h,param9.r,param9.x,param9.y);
                     }
                  }
               }
               if(param10 == GradientType.RADIAL)
               {
                  param1.beginGradientFill(GradientType.RADIAL,param7 as Array,_loc14_,param11,_loc15_);
               }
               else
               {
                  param1.beginGradientFill(GradientType.LINEAR,param7 as Array,_loc14_,param11,_loc15_);
               }
            }
            else
            {
               param1.beginFill(Number(param7),Number(param8));
            }
         }
         if(!param6)
         {
            param1.drawRect(param2,param3,param4,param5);
         }
         else if(param6 is Number)
         {
            _loc13_ = Number(param6) * 2;
            param1.drawRoundRect(param2,param3,param4,param5,_loc13_,_loc13_);
         }
         else
         {
            drawRoundRectComplex(param1,param2,param3,param4,param5,param6.tl,param6.tr,param6.bl,param6.br);
         }
         if(param12)
         {
            if((_loc16_ = param12.r) is Number)
            {
               _loc13_ = Number(_loc16_) * 2;
               param1.drawRoundRect(param12.x,param12.y,param12.w,param12.h,_loc13_,_loc13_);
            }
            else
            {
               drawRoundRectComplex(param1,param12.x,param12.y,param12.w,param12.h,_loc16_.tl,_loc16_.tr,_loc16_.bl,_loc16_.br);
            }
         }
         if(param7 !== null)
         {
            param1.endFill();
         }
      }
      
      public static function drawRoundRectComplex(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc10_:Number = param2 + param4;
         var _loc11_:Number = param3 + param5;
         var _loc12_:Number = param4 < param5 ? param4 * 2 : param5 * 2;
         param6 = param6 < _loc12_ ? param6 : _loc12_;
         param7 = param7 < _loc12_ ? param7 : _loc12_;
         param8 = param8 < _loc12_ ? param8 : _loc12_;
         var _loc13_:Number = (param9 = param9 < _loc12_ ? param9 : _loc12_) * 0.292893218813453;
         var _loc14_:Number = param9 * 0.585786437626905;
         param1.moveTo(_loc10_,_loc11_ - param9);
         param1.curveTo(_loc10_,_loc11_ - _loc14_,_loc10_ - _loc13_,_loc11_ - _loc13_);
         param1.curveTo(_loc10_ - _loc14_,_loc11_,_loc10_ - param9,_loc11_);
         _loc13_ = param8 * 0.292893218813453;
         _loc14_ = param8 * 0.585786437626905;
         param1.lineTo(param2 + param8,_loc11_);
         param1.curveTo(param2 + _loc14_,_loc11_,param2 + _loc13_,_loc11_ - _loc13_);
         param1.curveTo(param2,_loc11_ - _loc14_,param2,_loc11_ - param8);
         _loc13_ = param6 * 0.292893218813453;
         _loc14_ = param6 * 0.585786437626905;
         param1.lineTo(param2,param3 + param6);
         param1.curveTo(param2,param3 + _loc14_,param2 + _loc13_,param3 + _loc13_);
         param1.curveTo(param2 + _loc14_,param3,param2 + param6,param3);
         _loc13_ = param7 * 0.292893218813453;
         _loc14_ = param7 * 0.585786437626905;
         param1.lineTo(_loc10_ - param7,param3);
         param1.curveTo(_loc10_ - _loc14_,param3,_loc10_ - _loc13_,param3 + _loc13_);
         param1.curveTo(_loc10_,param3 + _loc14_,_loc10_,param3 + param7);
         param1.lineTo(_loc10_,_loc11_ - param9);
      }
      
      public static function createBitmapIcon(param1:*, param2:Number, param3:Number = NaN) : BitmapComponent
      {
         var _loc4_:BitmapComponent = null;
         if(isNaN(param3))
         {
            param3 = param2;
         }
         _loc4_ = new BitmapComponent();
         if(param1 is Class)
         {
            _loc4_.source = param1;
         }
         else if(param1 is Bitmap)
         {
            _loc4_.bitmap = param1;
         }
         _loc4_.width = param2;
         _loc4_.height = param3;
         return _loc4_;
      }
      
      public static function drawCorneredRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1) : void
      {
         if(param6 < 1)
         {
            param6 = 1;
         }
         param1.moveTo(param2 + param6,param3);
         param1.lineTo(param2 + param4 - param6,param3);
         param1.lineTo(param2 + param4,param3 + param6);
         param1.lineTo(param2 + param4,param3 + param5 - param6);
         param1.lineTo(param2 + param4 - param6,param3 + param5);
         param1.lineTo(param2 + param6,param3 + param5);
         param1.lineTo(param2,param3 + param5 - param6);
         param1.lineTo(param2,param3 + param6);
         param1.lineTo(param2 + param6,param3);
      }
      
      public static function performLayout(param1:*, param2:Component, param3:Array, param4:Boolean = false, param5:int = -1) : void
      {
         var _loc7_:Object = null;
         var _loc8_:Class = null;
         var _loc9_:Component = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:* = undefined;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         var _loc6_:int = param5;
         for each(_loc7_ in param3)
         {
            _loc9_ = new _loc7_["CLASS"]();
            if(_loc7_.hasOwnProperty("ID"))
            {
               param1[_loc7_["ID"]] = _loc9_;
            }
            if(_loc7_.hasOwnProperty("name"))
            {
               _loc9_.name = _loc7_["name"];
            }
            for(_loc10_ in _loc7_)
            {
               if(_loc10_ != "CLASS" && _loc10_ != "ID" && _loc10_ != "name" && _loc10_ != "STYLES" && _loc10_ != "EVENTS" && _loc10_ != "CHILDREN")
               {
                  if(_loc7_[_loc10_] is String)
                  {
                     if(_loc11_ = _loc7_[_loc10_].match(/\{(\w+.*)\}/))
                     {
                        _loc12_ = (_loc11_[1] as String).split(".");
                        _loc13_ = param1;
                        if(_loc12_.length > 1 || _loc12_[0] != "this")
                        {
                           for each(_loc14_ in _loc12_)
                           {
                              if(!_loc13_.hasOwnProperty(_loc14_))
                              {
                                 throw Error("Unknown property " + _loc14_ + " in property chain {" + _loc11_[0] + "}.");
                              }
                              _loc13_ = _loc13_[_loc14_];
                           }
                        }
                        _loc9_[_loc10_] = _loc13_;
                        continue;
                     }
                  }
                  _loc9_[_loc10_] = _loc7_[_loc10_];
               }
            }
            if(_loc7_.hasOwnProperty("STYLES"))
            {
               for(_loc15_ in _loc7_["STYLES"])
               {
                  _loc9_.setStyle(_loc15_,_loc7_["STYLES"][_loc15_]);
               }
            }
            if(_loc7_.hasOwnProperty("CHILDREN"))
            {
               if(!(_loc7_["CHILDREN"] is Array))
               {
                  throw Error("CHILDREN must be an Array.");
               }
               performLayout(param1,_loc9_,_loc7_["CHILDREN"],param4);
            }
            if(!param4 && _loc7_.hasOwnProperty("EVENTS"))
            {
               if(!(_loc7_["EVENTS"] is Array))
               {
                  throw Error("EVENTS must be an Array.");
               }
               for each(_loc16_ in _loc7_["EVENTS"])
               {
                  if(!_loc16_.hasOwnProperty("TYPE"))
                  {
                     throw Error("You must specify and event type in TYPE property.");
                  }
                  if(!_loc16_.hasOwnProperty("LISTENER"))
                  {
                     throw Error("You must specify a listener, in the LISTENER property.");
                  }
                  if(_loc16_["LISTENER"] is String)
                  {
                     _loc9_.addEventListener(_loc16_["TYPE"],param1[_loc16_["LISTENER"]]);
                  }
                  else if(_loc16_["LISTENER"] is Function)
                  {
                     _loc9_.addEventListener(_loc16_["TYPE"],_loc16_["LISTENER"]);
                  }
               }
            }
            if(param5 >= 0)
            {
               param2.addChildAt(_loc9_,_loc6_);
            }
            else
            {
               param2.addChild(_loc9_);
            }
            _loc6_++;
         }
      }
   }
}
