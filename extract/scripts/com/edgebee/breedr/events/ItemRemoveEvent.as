package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class ItemRemoveEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ItemRemoveEvent",
         "cls":ItemRemoveEvent
      };
       
      
      public var id:uint;
      
      public function ItemRemoveEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
