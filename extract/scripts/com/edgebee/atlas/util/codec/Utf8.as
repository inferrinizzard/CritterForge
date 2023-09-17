package com.edgebee.atlas.util.codec
{
   public class Utf8
   {
       
      
      public function Utf8()
      {
         super();
      }
      
      public static function encode(param1:String) : String
      {
         var _loc4_:int = 0;
         param1 = param1.replace(/\r\n/g,"\n");
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc4_ = param1.charCodeAt(_loc3_)) < 128)
            {
               _loc2_ += String.fromCharCode(_loc4_);
            }
            else if(_loc4_ > 127 && _loc4_ < 2048)
            {
               _loc2_ += String.fromCharCode(_loc4_ >> 6 | 192);
               _loc2_ += String.fromCharCode(_loc4_ & 63 | 128);
            }
            else
            {
               _loc2_ += String.fromCharCode(_loc4_ >> 12 | 224);
               _loc2_ += String.fromCharCode(_loc4_ >> 6 & 63 | 128);
               _loc2_ += String.fromCharCode(_loc4_ & 63 | 128);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc4_ = param1.charCodeAt(_loc3_)) < 128)
            {
               _loc2_ += String.fromCharCode(_loc4_);
               _loc3_++;
            }
            else if(_loc4_ > 191 && _loc4_ < 224)
            {
               _loc6_ = param1.charCodeAt(_loc3_ + 1);
               _loc2_ += String.fromCharCode((_loc4_ & 31) << 6 | _loc6_ & 63);
               _loc3_ += 2;
            }
            else
            {
               _loc6_ = param1.charCodeAt(_loc3_ + 1);
               _loc7_ = param1.charCodeAt(_loc3_ + 2);
               _loc2_ += String.fromCharCode((_loc4_ & 15) << 12 | (_loc6_ & 63) << 6 | _loc7_ & 63);
               _loc3_ += 3;
            }
         }
         return _loc2_;
      }
   }
}
