package com.adobe.serialization.json
{
   public class JSONEncoder
   {
       
      
      private var jsonString:String;
      
      public function JSONEncoder(param1:*)
      {
         super();
         this.jsonString = this.convertToString(param1);
      }
      
      public function getString() : String
      {
         return this.jsonString;
      }
      
      private function convertToString(param1:*) : String
      {
         if(param1 is String)
         {
            return this.escapeString(param1 as String);
         }
         if(param1 is Number)
         {
            return isFinite(param1 as Number) ? String(param1.toString()) : "null";
         }
         if(param1 is Boolean)
         {
            return !!param1 ? "true" : "false";
         }
         if(param1 is Array)
         {
            return this.arrayToString(param1 as Array);
         }
         if(param1 is Object && param1 != null)
         {
            return this.objectToString(param1);
         }
         return "null";
      }
      
      private function escapeString(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:* = "";
         var _loc4_:Number = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.charAt(_loc5_);
            switch(_loc3_)
            {
               case "\"":
                  _loc2_ += "\\\"";
                  break;
               case "\\":
                  _loc2_ += "\\\\";
                  break;
               case "\b":
                  _loc2_ += "\\b";
                  break;
               case "\f":
                  _loc2_ += "\\f";
                  break;
               case "\n":
                  _loc2_ += "\\n";
                  break;
               case "\r":
                  _loc2_ += "\\r";
                  break;
               case "\t":
                  _loc2_ += "\\t";
                  break;
               default:
                  if(_loc3_ < " ")
                  {
                     _loc7_ = (_loc6_ = _loc3_.charCodeAt(0).toString(16)).length == 2 ? "00" : "000";
                     _loc2_ += "\\u" + _loc7_ + _loc6_;
                  }
                  else
                  {
                     _loc2_ += _loc3_;
                  }
                  break;
            }
            _loc5_++;
         }
         return "\"" + _loc2_ + "\"";
      }
      
      private function arrayToString(param1:Array) : String
      {
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += ",";
            }
            _loc2_ += this.convertToString(param1[_loc3_]);
            _loc3_++;
         }
         return "[" + _loc2_ + "]";
      }
      
      private function objectToString(param1:Object) : String
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc2_:* = "";
         for(_loc4_ in param1)
         {
            _loc3_ = param1[_loc4_];
            if(!(_loc3_ is Function))
            {
               if(_loc2_.length > 0)
               {
                  _loc2_ += ",";
               }
               _loc2_ += this.escapeString(_loc4_) + ":" + this.convertToString(_loc3_);
            }
         }
         return "{" + _loc2_ + "}";
      }
   }
}
