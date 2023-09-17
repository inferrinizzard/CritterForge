package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.SellItemEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SellItemHandler extends Handler
   {
       
      
      public var data:SellItemEvent;
      
      public var manager:EventProcessor;
      
      public function SellItemHandler(param1:SellItemEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoSellItem(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.SellItemEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SellItemHandler;
import flash.events.Event;

class DoSellItem extends HandlerState
{
    
   
   public function DoSellItem(param1:SellItemHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SellItemEvent = (machine as SellItemHandler).data;
      var _loc3_:ItemInstance = player.items.findItemByProperty("id",_loc2_.item_id) as ItemInstance;
      player.items.removeItem(_loc3_);
      gameView.dialogView.dialog = Dialog.getInstanceByName("shop_transaction" + Utils.randomInt(1,3));
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
      gameView.dialogView.step();
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
