package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class Fizzle extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Fizzle",
         "cls":Fizzle
      };
       
      
      public var condition_id:int;
      
      public var value:int;
      
      public function Fizzle(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
