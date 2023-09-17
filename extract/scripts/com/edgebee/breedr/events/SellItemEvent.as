package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class SellItemEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SellItemEvent",
         "cls":SellItemEvent
      };
       
      
      public var item_id:uint;
      
      public function SellItemEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
