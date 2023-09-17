package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.UpgradeFeederEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class UpgradeFeederHandler extends Handler
   {
       
      
      public var data:UpgradeFeederEvent;
      
      public var manager:EventProcessor;
      
      public function UpgradeFeederHandler(param1:UpgradeFeederEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoUpgradeFeeder(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.UpgradeFeederEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.UpgradeFeederHandler;
import com.edgebee.breedr.managers.handlers.UpgradeFridgeHandler;
import flash.events.Event;

class DoUpgradeFeeder extends HandlerState
{
    
   
   public function DoUpgradeFeeder(param1:UpgradeFeederHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:UpgradeFeederEvent = (machine as UpgradeFeederHandler).data;
      var _loc3_:Stall = player.stalls.findItemByProperty("id",_loc2_.stall_id) as Stall;
      _loc3_.feeder.level_id = _loc2_.level_id;
      UIGlobals.playSound(UpgradeFridgeHandler.FridgeUpgradeWav);
      gameView.dialogView.dialog = Dialog.getInstanceByName("upgrade_feeder");
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
