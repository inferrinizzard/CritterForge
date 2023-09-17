package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.DeactivateTeamEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class DeactivateTeamHandler extends Handler
   {
       
      
      public var data:DeactivateTeamEvent;
      
      public var manager:EventProcessor;
      
      public function DeactivateTeamHandler(param1:DeactivateTeamEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoDeactivateTeam(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.DeactivateTeamEvent;
import com.edgebee.breedr.managers.handlers.DeactivateTeamHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import flash.events.Event;

class DoDeactivateTeam extends HandlerState
{
    
   
   public function DoDeactivateTeam(param1:DeactivateTeamHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:DeactivateTeamEvent = (machine as DeactivateTeamHandler).data;
      var _loc3_:Team = player.syndicate.teams.findItemByProperty("id",_loc2_.team_id) as Team;
      _loc3_.disbanded_until = _loc2_.disbanded_until;
      _loc3_.active = false;
      if(player.syndicate_level.level >= 8)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_friendly" + Utils.randomInt(1,3));
      }
      else
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_annoyed" + Utils.randomInt(1,5));
      }
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
