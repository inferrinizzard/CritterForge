package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class Restoration extends Data
   {
      
      public static const HP:int = 0;
      
      public static const PP:int = 1;
      
      private static const _classinfo:Object = {
         "name":"Restoration",
         "cls":Restoration
      };
       
      
      public var type:int;
      
      public var value:int;
      
      public function Restoration(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
