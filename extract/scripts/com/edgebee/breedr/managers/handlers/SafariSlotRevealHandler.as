package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.SafariSlotRevealEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SafariSlotRevealHandler extends Handler
   {
       
      
      public var data:SafariSlotRevealEvent;
      
      public var manager:EventProcessor;
      
      public function SafariSlotRevealHandler(param1:SafariSlotRevealEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoSafarySlotRevealUpdate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.SafariCard;
import com.edgebee.breedr.events.SafariSlotRevealEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariSlotRevealHandler;
import com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
import com.edgebee.breedr.ui.world.areas.safari.SafariGridView;
import flash.events.Event;

class DoSafarySlotRevealUpdate extends HandlerState
{
    
   
   public function DoSafarySlotRevealUpdate(param1:SafariSlotRevealHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SafariSlotRevealEvent = (machine as SafariSlotRevealHandler).data;
      var _loc3_:SafariCard = player.safari_cards[_loc2_.index] as SafariCard;
      _loc3_.flags = _loc2_.flags;
      _loc3_.data = _loc2_.data;
      var _loc4_:SafariCardView;
      if(!(_loc4_ = gameView.safariView.gridView[SafariGridView.cards[_loc2_.index]] as SafariCardView).animComplete)
      {
         _loc4_.addEventListener(Event.COMPLETE,this.onCardAnimComplete);
      }
      else
      {
         timer.delay = 750;
         timer.start();
      }
   }
   
   private function onCardAnimComplete(param1:Event) : void
   {
      var _loc2_:SafariSlotRevealEvent = (machine as SafariSlotRevealHandler).data;
      var _loc3_:SafariCardView = gameView.safariView.gridView[SafariGridView.cards[_loc2_.index]] as SafariCardView;
      _loc3_.removeEventListener(Event.COMPLETE,this.onCardAnimComplete);
      timer.delay = 750;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:SafariSlotRevealEvent = (machine as SafariSlotRevealHandler).data;
      if(!(_loc2_.flags & SafariCard.SLOT_CREATURE || _loc2_.flags & SafariCard.SLOT_BOSS || _loc2_.flags & SafariCard.SLOT_QUEST))
      {
         --client.criticalComms;
      }
   }
}
