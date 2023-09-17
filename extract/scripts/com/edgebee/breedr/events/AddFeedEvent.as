package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class AddFeedEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"AddFeedEvent",
         "cls":AddFeedEvent
      };
       
      
      public var feeder_id:uint;
      
      public var quantity:uint;
      
      public var item_id:uint;
      
      public function AddFeedEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
