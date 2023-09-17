package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.item.ItemInstance;
   
   public class BuyItemEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"BuyItemEvent",
         "cls":BuyItemEvent
      };
       
      
      public var item:ItemInstance;
      
      public function BuyItemEvent(param1:Object = null)
      {
         this.item = new ItemInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
