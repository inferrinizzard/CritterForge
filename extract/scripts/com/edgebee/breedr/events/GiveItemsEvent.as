package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.item.ItemInstance;
   
   public class GiveItemsEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"GiveItemsEvent",
         "cls":GiveItemsEvent
      };
       
      
      public var items:DataArray;
      
      public function GiveItemsEvent(param1:Object = null)
      {
         this.items = new DataArray(ItemInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
