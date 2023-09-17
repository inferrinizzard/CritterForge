package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.UpgradeFridgeEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class UpgradeFridgeHandler extends Handler
   {
      
      public static var FridgeUpgradeWav:Class = UpgradeFridgeHandler_FridgeUpgradeWav;
       
      
      public var data:UpgradeFridgeEvent;
      
      public var manager:EventProcessor;
      
      public function UpgradeFridgeHandler(param1:UpgradeFridgeEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoUpgradeFridge(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.UpgradeFridgeEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.UpgradeFridgeHandler;
import flash.events.Event;

class DoUpgradeFridge extends HandlerState
{
    
   
   public function DoUpgradeFridge(param1:UpgradeFridgeHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:UpgradeFridgeEvent = (machine as UpgradeFridgeHandler).data;
      player.fridge_level_id = _loc2_.level_id;
      UIGlobals.playSound(UpgradeFridgeHandler.FridgeUpgradeWav);
      if(player.area.type == Area.TYPE_RANCH)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("upgrade_fridge");
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
