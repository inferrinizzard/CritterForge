package com.adobe.serialization.json
{
   public class JSON
   {
       
      
      public function JSON()
      {
         super();
      }
      
      public static function encode(param1:Object) : String
      {
         var _loc2_:JSONEncoder = new JSONEncoder(param1);
         return _loc2_.getString();
      }
      
      public static function decode(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:JSONDecoder = new JSONDecoder(param1,param2);
         return _loc3_.getValue();
      }
   }
}
