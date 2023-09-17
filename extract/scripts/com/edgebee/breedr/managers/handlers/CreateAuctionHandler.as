package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.CreateAuctionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class CreateAuctionHandler extends Handler
   {
       
      
      public var data:CreateAuctionEvent;
      
      public var manager:EventProcessor;
      
      public function CreateAuctionHandler(param1:CreateAuctionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoCreateAuction(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.data.world.Auction;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.CreateAuctionEvent;
import com.edgebee.breedr.managers.handlers.CreateAuctionHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.ui.world.areas.auction.AuctionView;
import flash.events.Event;

class DoCreateAuction extends HandlerState
{
    
   
   public function DoCreateAuction(param1:CreateAuctionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:Auction = null;
      var _loc5_:CreatureInstance = null;
      var _loc6_:ItemInstance = null;
      super.transitionInto(param1);
      var _loc2_:CreateAuctionEvent = (machine as CreateAuctionHandler).data;
      if(_loc2_.auction.creature.id > 0)
      {
         (_loc5_ = player.creatures.findItemByProperty("id",_loc2_.auction.creature.id) as CreatureInstance).auction_id = _loc2_.auction.id;
      }
      if(_loc2_.auction.item.id > 0)
      {
         (_loc6_ = player.items.findItemByProperty("id",_loc2_.auction.item.id) as ItemInstance).auction_id = _loc2_.auction.id;
      }
      var _loc3_:AuctionView = gameView.auctionView;
      _loc4_ = new Auction();
      _loc2_.auction.copyTo(_loc4_);
      _loc3_.ownedAuctionsArr.append(_loc4_);
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
