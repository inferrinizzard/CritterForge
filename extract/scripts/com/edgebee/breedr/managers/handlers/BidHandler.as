package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.BidEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class BidHandler extends Handler
   {
       
      
      public var data:BidEvent;
      
      public var manager:EventProcessor;
      
      public function BidHandler(param1:BidEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoBid(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Auction;
import com.edgebee.breedr.data.world.Bid;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.BidEvent;
import com.edgebee.breedr.managers.handlers.BidHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.ui.world.areas.auction.AuctionView;
import flash.events.Event;

class DoBid extends HandlerState
{
    
   
   public function DoBid(param1:BidHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:Auction = null;
      var _loc5_:Bid = null;
      super.transitionInto(param1);
      var _loc2_:BidEvent = (machine as BidHandler).data;
      var _loc3_:AuctionView = gameView.auctionView;
      for each(_loc4_ in _loc3_.ownedAuctionsArr)
      {
         if(_loc4_.id == _loc2_.auction_id)
         {
            _loc5_ = new Bid();
            _loc2_.bid.copyTo(_loc5_);
            _loc4_.bids.append(_loc2_.bid);
            break;
         }
      }
      for each(_loc4_ in _loc3_.bidsAuctionsArr)
      {
         if(_loc4_.id == _loc2_.auction_id)
         {
            _loc5_ = new Bid();
            _loc2_.bid.copyTo(_loc5_);
            _loc4_.bids.append(_loc2_.bid);
            break;
         }
      }
      for each(_loc4_ in _loc3_.allSearchAuctionsArr)
      {
         if(_loc4_.id == _loc2_.auction_id)
         {
            _loc5_ = new Bid();
            _loc2_.bid.copyTo(_loc5_);
            _loc4_.bids.append(_loc2_.bid);
            break;
         }
      }
      if(_loc2_.dialog.length)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName(_loc2_.dialog);
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
         gameView.dialogView.step();
      }
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
