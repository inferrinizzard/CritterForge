package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.ItemInstance;
   
   public class Auction extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Auction",
         "cls":Auction
      };
       
      
      public var id:uint;
      
      public var creation_date:Date;
      
      public var closing_date:Date;
      
      public var last_bid_time:Date;
      
      public var starting_bid:Number;
      
      public var player:Player;
      
      public var item:ItemInstance;
      
      public var creature:CreatureInstance;
      
      public var bids:DataArray;
      
      public function Auction(param1:Object = null)
      {
         this.player = new Player();
         this.item = new ItemInstance();
         this.creature = new CreatureInstance();
         this.bids = new DataArray(Bid.classinfo);
         this.bids.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onBidsChange);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get shortName() : *
      {
         if(this.item.id > 0)
         {
            return this.item.item.name.value + " (" + this.item.creature.creature.name.value + ")";
         }
         if(this.creature.id > 0)
         {
            if(this.creature.isEgg)
            {
               return Asset.getInstanceByName("CREATURE_EGG");
            }
            return this.creature.creature.name;
         }
         return "";
      }
      
      public function get lastBid() : Bid
      {
         if(this.bids.length > 0)
         {
            return this.bids.getItemAt(this.bids.length - 1) as Bid;
         }
         return null;
      }
      
      public function get currentBidAmount() : *
      {
         if(this.lastBid)
         {
            return this.lastBid.amount;
         }
         return this.starting_bid;
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc3_:Bid = null;
         var _loc4_:Bid = null;
         param1.id = this.id;
         param1.creation_date = this.creation_date;
         param1.closing_date = this.closing_date;
         param1.last_bid_time = this.last_bid_time;
         param1.starting_bid = this.starting_bid;
         this.player.copyTo(param1.player);
         param1.item = this.item;
         param1.creature = this.creature;
         var _loc2_:Array = [];
         for each(_loc4_ in this.bids)
         {
            _loc3_ = new Bid();
            _loc4_.copyTo(_loc3_);
            _loc2_.push(_loc3_);
         }
         this.bids.source = _loc2_;
      }
      
      public function get quickBidAmount() : Number
      {
         var _loc1_:Number = Math.round(this.currentBidAmount * 0.05);
         return _loc1_ >= 1 ? _loc1_ : 1;
      }
      
      public function get codeName() : String
      {
         if(this.item.id > 0)
         {
            return this.item.creature.creature.code_name;
         }
         if(this.creature.id > 0)
         {
            if(this.creature.isEgg)
            {
               return "egg";
            }
            return this.creature.creature.code_name;
         }
         return null;
      }
      
      private function onBidsChange(param1:CollectionEvent) : void
      {
         dispatchEvent(PropertyChangeEvent.create(this,"bids",null,null));
      }
   }
}
