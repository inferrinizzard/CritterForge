package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.world.Bid;
   
   public class BidEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"BidEvent",
         "cls":BidEvent
      };
       
      
      public var auction_id:uint;
      
      public var bid:Bid;
      
      public var dialog:String;
      
      public function BidEvent(param1:Object = null)
      {
         this.bid = new Bid();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
