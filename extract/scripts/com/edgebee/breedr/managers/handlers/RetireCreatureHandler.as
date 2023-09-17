package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.RetireCreatureEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class RetireCreatureHandler extends Handler
   {
      
      public static var RetireWav:Class = RetireCreatureHandler_RetireWav;
       
      
      public var data:RetireCreatureEvent;
      
      public var manager:EventProcessor;
      
      public function RetireCreatureHandler(param1:RetireCreatureEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Retire(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.RetireCreatureEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.RetireCreatureHandler;
import flash.events.Event;

class Retire extends HandlerState
{
    
   
   public function Retire(param1:RetireCreatureHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:Team = null;
      var _loc5_:CreatureInstance = null;
      super.transitionInto(param1);
      var _loc2_:RetireCreatureEvent = (machine as RetireCreatureHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      gameView.statusWindow.doClose();
      if(_loc3_.level >= _loc3_.max_level)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("ranch_retire_old");
      }
      else
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("ranch_retire");
      }
      UIGlobals.playSound(RetireCreatureHandler.RetireWav);
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
      gameView.dialogView.step({"name":_loc3_.name});
      for each(_loc4_ in player.syndicate.teams)
      {
         for each(_loc5_ in _loc4_.members)
         {
            if(_loc5_.id == _loc3_.id)
            {
               _loc4_.members.removeItem(_loc5_);
               break;
            }
         }
      }
      new CreatureInstance().copyTo(_loc3_);
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
