package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.BuyItemEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class BuyItemHandler extends Handler
   {
       
      
      public var data:BuyItemEvent;
      
      public var manager:EventProcessor;
      
      public function BuyItemHandler(param1:BuyItemEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoBuyItem(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.BuyItemEvent;
import com.edgebee.breedr.managers.TutorialManager;
import com.edgebee.breedr.managers.handlers.BuyItemHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import flash.events.Event;

class DoBuyItem extends HandlerState
{
    
   
   public function DoBuyItem(param1:BuyItemHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:BuyItemEvent = (machine as BuyItemHandler).data;
      player.items.addItem(_loc2_.item);
      if(client.tutorialManager.state == TutorialManager.STATE_COMPLETED)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("shop_transaction" + Utils.randomInt(1,3));
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
