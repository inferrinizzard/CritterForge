package com.edgebee.atlas.util
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.utils.getQualifiedClassName;
   
   public class Utils
   {
      
      public static var datePattern:RegExp = /20[0-9]{6}T[0-9]{2}:[0-9]{2}:[0-9]{2}[.]*[0-9]*/i;
      
      private static const LTrimExp:RegExp = /^(\s|\n|\r|\t|\v)*/m;
      
      private static const RTrimExp:RegExp = /(\s|\n|\r|\t|\v)*$/;
      
      private static var performanceTimers:Object = {};
       
      
      public function Utils()
      {
         super();
      }
      
      public static function updateAllPropertiesDeep(param1:*, param2:*) : uint
      {
         var _loc4_:String = null;
         var _loc3_:uint = 0;
         if(param1 != null && param2 != null)
         {
            if(getQualifiedClassName(param1) == "Object")
            {
               for(_loc4_ in param1)
               {
                  if(param2.hasOwnProperty(_loc4_))
                  {
                     if(param2.__explicit_properties != null && param2.__explicit_properties.hasOwnProperty(_loc4_) && param2.__explicit_properties[_loc4_] == true)
                     {
                        param2.initializeProperty(_loc4_,param1[_loc4_]);
                     }
                     else if(param2[_loc4_] is Data || param2[_loc4_] is DataArray || param2[_loc4_] is DataReference)
                     {
                        param2[_loc4_].update(param1[_loc4_]);
                        if(param2 is IEventDispatcher)
                        {
                           (param2 as IEventDispatcher).dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,param2,_loc4_,null,param2[_loc4_]));
                        }
                     }
                     else if(param2[_loc4_] is ArrayCollection)
                     {
                        param2[_loc4_].source = param1[_loc4_];
                     }
                     else if(typeof param1[_loc4_] == "string" && datePattern.test(param1[_loc4_]))
                     {
                        param2[_loc4_] = dateFromString(param1[_loc4_]);
                     }
                     else
                     {
                        param2[_loc4_] = param1[_loc4_];
                     }
                     _loc3_++;
                  }
                  else if(_loc4_ != "__type__")
                  {
                  }
               }
            }
            else if(getQualifiedClassName(param1) == getQualifiedClassName(param2))
            {
               param1.copyTo(param2);
            }
         }
         return _loc3_;
      }
      
      public static function dateFromString(param1:String) : Date
      {
         var _loc2_:Date = new Date();
         if(param1.length > 16)
         {
            _loc2_.setUTCFullYear(param1.slice(0,4),Number(param1.slice(4,6)) - 1,param1.slice(6,8));
            _loc2_.setUTCHours(param1.slice(9,11),param1.slice(12,14),param1.slice(15,17));
            return _loc2_;
         }
         return null;
      }
      
      public static function format_xml(param1:String) : String
      {
         var _loc2_:String = new String(param1);
         return _loc2_.split("><").join(">\n<");
      }
      
      public static function format_json(param1:String) : String
      {
         var _loc2_:String = new String(param1);
         return _loc2_.split(",").join(",\n");
      }
      
      public static function getLocalDateTimeString(param1:Date) : String
      {
         return "" + (param1.getMonth() + 1) + "/" + param1.getDate() + "/" + param1.getFullYear() + " " + getLocalTimeString(param1);
      }
      
      public static function getLocalTimeString(param1:Date) : String
      {
         var _loc2_:String = null;
         if(param1.getMinutes() < 10)
         {
            _loc2_ = "0" + param1.getMinutes();
         }
         else
         {
            _loc2_ = param1.getMinutes().toString();
         }
         return "" + param1.getHours() + ":" + _loc2_;
      }
      
      public static function formatString(param1:String, param2:Object) : String
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc3_:Array = param1.split(/(\{\w+:*-*[0-9]*\})/);
         var _loc4_:* = "";
         for each(_loc5_ in _loc3_)
         {
            if(_loc6_ = _loc5_.match(/\{(\w+:*-*[0-9]*)\}/))
            {
               _loc7_ = (_loc7_ = _loc6_[0] as String).substr(1,_loc7_.length - 2);
               _loc8_ = 0;
               if(_loc7_.indexOf(":") >= 0)
               {
                  _loc7_ = (_loc9_ = _loc7_.split(":"))[0] as String;
                  _loc8_ = int(_loc9_[1]);
               }
               if(param2.hasOwnProperty(_loc7_) && param2[_loc7_] != null)
               {
                  _loc10_ = String(param2[_loc7_].toString());
                  if(_loc8_ > 0 && _loc10_.length < _loc8_)
                  {
                     _loc11_ = uint(_loc8_ - _loc10_.length);
                     _loc12_ = 0;
                     while(_loc12_ < _loc11_)
                     {
                        _loc4_ += " ";
                        _loc12_++;
                     }
                  }
                  _loc4_ += _loc10_;
                  if(_loc8_ < 0 && _loc10_.length < Math.abs(_loc8_))
                  {
                     _loc11_ = Math.abs(_loc8_) - _loc10_.length;
                     _loc13_ = 0;
                     while(_loc13_ < _loc11_)
                     {
                        _loc4_ += " ";
                        _loc13_++;
                     }
                  }
                  continue;
               }
            }
            _loc4_ += _loc5_;
         }
         return _loc4_;
      }
      
      public static function getClassName(param1:Class) : String
      {
         return String(param1.classinfo.name);
      }
      
      public static function getInstanceClassName(param1:*) : String
      {
         return String((param1 as StaticData).classinfo.name);
      }
      
      public static function quicksort(param1:*, param2:Function) : void
      {
         var array:* = param1;
         var cmp:Function = param2;
         var sort:Function = function(param1:*, param2:int, param3:int, param4:Function):void
         {
            var _loc7_:* = undefined;
            var _loc5_:int = param2;
            var _loc6_:int = param3;
            var _loc8_:* = param1[int((param2 + param3) / 2)];
            do
            {
               while(param4(param1[_loc5_],_loc8_) < 0)
               {
                  _loc5_++;
               }
               while(param4(_loc8_,param1[_loc6_]) < 0)
               {
                  _loc6_--;
               }
               if(_loc5_ <= _loc6_)
               {
                  _loc7_ = param1[_loc5_];
                  var _loc9_:*;
                  param1[_loc9_ = _loc5_++] = param1[_loc6_];
                  var _loc10_:*;
                  param1[_loc10_ = _loc6_--] = _loc7_;
               }
            }
            while(_loc5_ <= _loc6_);
            
            if(param2 < _loc6_)
            {
               sort(param1,param2,_loc6_,param4);
            }
            if(_loc5_ < param3)
            {
               sort(param1,_loc5_,param3,param4);
            }
         };
         if(array.length > 1)
         {
            sort(array,0,array.length - 1,cmp);
         }
      }
      
      public static function shuffle(param1:*) : void
      {
         var array:* = param1;
         quicksort(array,function(param1:*, param2:*):int
         {
            return randomInt(-1,1);
         });
      }
      
      public static function getPropertyFromPath(param1:Object, param2:String, param3:Boolean = true) : *
      {
         var _loc6_:String = null;
         var _loc4_:Array = param2.split(".");
         var _loc5_:* = param1;
         if(!param1.hasOwnProperty(param2) && param3 && _loc4_.length > 1)
         {
            for each(_loc6_ in _loc4_)
            {
               if(!_loc5_.hasOwnProperty(_loc6_))
               {
                  throw Error("Utils::getPropertyFromPath : Unknown property " + _loc6_ + " in property path \"" + param2 + "\".");
               }
               _loc5_ = _loc5_[_loc6_];
            }
            return _loc5_;
         }
         return _loc5_[param2];
      }
      
      public static function setPropertyFromPath(param1:Object, param2:String, param3:*) : *
      {
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc4_:Array = param2.split(".");
         var _loc5_:* = param1;
         if(!param1.hasOwnProperty(param2) && _loc4_.length > 1)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length - 1)
            {
               _loc7_ = String(_loc4_[_loc6_]);
               if(!_loc5_.hasOwnProperty(_loc7_))
               {
                  throw Error("Utils::getPropertyFromPath : Unknown property " + _loc7_ + " in property path \"" + param2 + "\".");
               }
               _loc5_ = _loc5_[_loc7_];
               _loc6_++;
            }
            _loc5_[_loc4_[_loc4_.length - 1]] = param3;
         }
         else
         {
            _loc5_[param2] = param3;
         }
      }
      
      public static function htmlWrap(param1:String, param2:String = null, param3:* = null, param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:String = null) : String
      {
         var _loc8_:* = "<font";
         if(param2)
         {
            _loc8_ += " face=\"" + param2 + "\"";
         }
         else
         {
            _loc8_ += " face=\"" + UIGlobals.getStyle("FontFamily") + "\"";
         }
         if(param3)
         {
            if(param3 is uint || param3 is int || param3 is Number)
            {
               param3 = "#" + (param3 as Number).toString(16);
            }
            _loc8_ += " color=\"" + param3 + "\"";
         }
         else
         {
            param3 = "#" + UIGlobals.getStyle("FontColor",0).toString(16);
            _loc8_ += " color=\"" + param3 + "\"";
         }
         if(param4 > 0)
         {
            _loc8_ += " size=\"" + param4 + "\"";
         }
         else if(param4 < 0)
         {
            _loc8_ += " size=\"" + UIGlobals.getStyle("FontSize",12) + "\"";
         }
         _loc8_ += ">";
         if(param7)
         {
            _loc8_ += "<p align=\"" + param7 + "\">";
         }
         if(param5)
         {
            _loc8_ += "<b>";
         }
         if(param6)
         {
            _loc8_ += "<i>";
         }
         _loc8_ += param1;
         if(param6)
         {
            _loc8_ += " </i>";
         }
         if(param5)
         {
            _loc8_ += "</b>";
         }
         if(param7)
         {
            _loc8_ += "</p>";
         }
         return _loc8_ + "</font>";
      }
      
      public static function capitalizeFirst(param1:String) : String
      {
         if(Boolean(param1) && param1.length > 0)
         {
            return param1.slice(0,1).toLocaleUpperCase() + param1.slice(1);
         }
         return param1;
      }
      
      public static function getIndent(param1:uint) : String
      {
         var _loc2_:* = "";
         var _loc3_:uint = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += "  ";
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function round(param1:Number, param2:uint) : Number
      {
         param1 *= Math.pow(10,param2);
         param1 = Math.round(param1);
         return param1 / Math.pow(10,param2);
      }
      
      public static function toFixed(param1:Number, param2:uint = 1) : String
      {
         var _loc3_:String = param1.toFixed(param2);
         var _loc4_:uint = 0;
         if(_loc3_.indexOf(".") >= 0)
         {
            while(_loc3_.charAt(_loc3_.length - 1 - _loc4_) == "0")
            {
               _loc4_++;
            }
            if(_loc3_.charAt(_loc3_.length - 1 - _loc4_) == ".")
            {
               _loc4_++;
            }
         }
         if(_loc4_)
         {
            return _loc3_.slice(0,-_loc4_);
         }
         return _loc3_;
      }
      
      public static function getRankString(param1:uint) : String
      {
         switch(param1 % 10)
         {
            case 1:
               if(param1 % 100 == 11)
               {
                  return Asset.getInstanceByName("NTH_RANK").value;
               }
               return Asset.getInstanceByName("FIRST_RANK").value;
               break;
            case 2:
               if(param1 % 100 == 12)
               {
                  return Asset.getInstanceByName("NTH_RANK").value;
               }
               return Asset.getInstanceByName("SECOND_RANK").value;
               break;
            case 3:
               if(param1 % 100 == 13)
               {
                  return Asset.getInstanceByName("NTH_RANK").value;
               }
               return Asset.getInstanceByName("THIRD_RANK").value;
               break;
            default:
               return Asset.getInstanceByName("NTH_RANK").value;
         }
      }
      
      public static function rotateOnCenter(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-param1.width / 2 - param1.x,-param1.height / 2 - param1.y);
         _loc3_.rotate(param2);
         _loc3_.translate(param1.width / 2 + param1.x,param1.height / 2 + param1.y);
         param1.transform.matrix = _loc3_;
      }
      
      public static function invertBitmapColors(param1:BitmapData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Color = null;
         var _loc2_:Number = 0;
         while(_loc2_ < param1.width)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.height)
            {
               (_loc4_ = new Color()).hex = param1.getPixel(_loc2_,_loc3_);
               _loc4_.invert();
               param1.setPixel(_loc2_,_loc3_,_loc4_.hex);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public static function rtrim(param1:String) : String
      {
         return param1.replace(LTrimExp,"");
      }
      
      public static function ltrim(param1:String) : String
      {
         return param1.replace(RTrimExp,"");
      }
      
      public static function trim(param1:String) : String
      {
         return ltrim(rtrim(param1));
      }
      
      public static function clamp(param1:Number, param2:Number = 0, param3:Number = 1) : Number
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
      
      public static function perfBegin(param1:String) : void
      {
         performanceTimers[param1] = new Date().time;
      }
      
      public static function perfEnd(param1:String) : void
      {
         var _loc2_:Number = new Date().time;
         var _loc3_:Number = (_loc2_ - performanceTimers[param1]) / 1000;
      }
      
      public static function abreviateNumber(param1:Number, param2:uint = 1) : String
      {
         if(param1 > 1000000000000)
         {
            return toFixed(param1 / 1000000000000,param2) + "T";
         }
         if(param1 > 1000000000)
         {
            return toFixed(param1 / 1000000000,param2) + "G";
         }
         if(param1 > 1000000)
         {
            return toFixed(param1 / 1000000,param2) + "M";
         }
         if(param1 > 1000)
         {
            return toFixed(param1 / 1000,param2) + "K";
         }
         return toFixed(Math.round(param1),0);
      }
      
      public static function isAbreviated(param1:Number) : Boolean
      {
         return param1 > 1000;
      }
      
      public static function padNumberLeft(param1:Number, param2:int = 0) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      public static function dateToString(param1:Date, param2:Boolean = false, param3:Boolean = false, param4:String = "-", param5:String = ":") : String
      {
         var _loc6_:String = (_loc6_ = (_loc6_ = param1.fullYear.toString()) + (param4 + param1.month)) + (param4 + param1.day);
         if(!param2)
         {
            _loc6_ = (_loc6_ += " " + padNumberLeft(param1.hours,2)) + (param5 + padNumberLeft(param1.minutes,2));
            if(param3)
            {
               _loc6_ += param5 + padNumberLeft(param1.hours,2);
            }
         }
         return _loc6_;
      }
      
      public static function dateToElapsed(param1:Date) : String
      {
         var _loc2_:Number = int(new Date().time - param1.time) / 1000;
         if(_loc2_ <= 0)
         {
            return "---";
         }
         if(_loc2_ >= 3600 * 24 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_ELAPSED_DAYS").value,{"days":uint(_loc2_ / (3600 * 24)).toString()});
         }
         if(_loc2_ >= 3600 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_ELAPSED_HOURS").value,{"hours":uint(_loc2_ / 3600).toString()});
         }
         if(_loc2_ >= 60 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_ELAPSED_MINUTES").value,{"minutes":uint(_loc2_ / 60).toString()});
         }
         return formatString(Asset.getInstanceByName("TIME_ELAPSED_SECONDS").value,{"seconds":uint(_loc2_).toString()});
      }
      
      public static function secondsToDelta(param1:Number) : String
      {
         if(param1 < 0)
         {
            return Asset.getInstanceByName("EXPIRED").value;
         }
         if(param1 >= 3600 * 24 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_DELTA_DAYS").value,{"days":uint(param1 / (3600 * 24)).toString()});
         }
         if(param1 >= 3600 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_DELTA_HOURS").value,{"hours":uint(param1 / 3600).toString()});
         }
         if(param1 >= 60 * 2)
         {
            return formatString(Asset.getInstanceByName("TIME_DELTA_MINUTES").value,{"minutes":uint(param1 / 60).toString()});
         }
         return formatString(Asset.getInstanceByName("TIME_DELTA_SECONDS").value,{"seconds":uint(param1).toString()});
      }
      
      public static function secondsToTimer(param1:Number) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:* = "0:00:00";
         if(param1 > 0)
         {
            _loc2_ = "";
            if(param1 >= 3600 * 24)
            {
               _loc2_ += uint(Math.floor(param1 / (3600 * 24))).toString();
               _loc2_ += " ";
            }
            _loc3_ = uint(Math.floor(param1 % (3600 * 24) / 3600));
            _loc2_ += _loc3_.toString();
            _loc2_ += ":";
            if((_loc4_ = uint(Math.floor(param1 % 3600 / 60))) < 10)
            {
               _loc2_ += "0";
            }
            _loc2_ += _loc4_.toString();
            _loc2_ += ":";
            if((_loc5_ = uint(param1 % 60)) < 10)
            {
               _loc2_ += "0";
            }
            _loc2_ += _loc5_.toString();
         }
         return _loc2_;
      }
      
      public static function etaToTimer(param1:Date) : String
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = Math.round((param1.time - _loc2_.time) / 1000);
         return secondsToTimer(_loc3_);
      }
      
      public static function randomInt(param1:int, param2:int) : int
      {
         if(param2 < param1)
         {
            throw new Error("Bad random int values");
         }
         if(param2 == param1)
         {
            return param1;
         }
         if(param2 >= int.MAX_VALUE)
         {
            throw new Error("Maximum value in randomInt cant exceed or equal int.MAX_VALUE (" + int.MAX_VALUE.toString() + ")");
         }
         if(param1 < int.MIN_VALUE)
         {
            throw new Error("Minimum value in randomInt cant be less than int.MIN_VALUE (" + int.MIN_VALUE.toString() + ")");
         }
         return int(Math.floor((Number(param2 - param1) + 1) * Math.random())) + param1;
      }
      
      public static function randomUint(param1:uint, param2:uint) : uint
      {
         if(param2 < param1)
         {
            throw new Error("Bad random uint values");
         }
         if(param2 >= uint.MAX_VALUE)
         {
            throw new Error("Maximum value in randomUint cant exceed or equal uint.MAX_VALUE (" + uint.MAX_VALUE.toString() + ")");
         }
         if(param2 == param1)
         {
            return param1;
         }
         return uint(Math.floor((Number(param2 - param1) + 1) * Math.random())) + param1;
      }
      
      public static function isKongregate(param1:LoaderInfo) : Boolean
      {
         var _loc2_:Array = param1.loaderURL.match(/.*kongregate\.com.*/);
         return Boolean(_loc2_) && _loc2_.length > 0;
      }
      
      public static function isFacebook(param1:LoaderInfo) : Boolean
      {
         return param1.parameters.hasOwnProperty("signed_request");
      }
      
      public static function isOpenSocial(param1:LoaderInfo) : Boolean
      {
         return param1.parameters.hasOwnProperty("security_token");
      }
      
      public static function getOpenSocialProvider(param1:LoaderInfo) : String
      {
         if(param1.parameters.hasOwnProperty("provider"))
         {
            return param1.parameters["provider"];
         }
         return null;
      }
   }
}
