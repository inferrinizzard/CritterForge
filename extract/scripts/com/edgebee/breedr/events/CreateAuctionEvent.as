package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.world.Auction;
   
   public class CreateAuctionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreateAuctionEvent",
         "cls":CreateAuctionEvent
      };
       
      
      public var auction:Auction;
      
      public var dialog:String;
      
      public function CreateAuctionEvent(param1:Object = null)
      {
         this.auction = new Auction();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
