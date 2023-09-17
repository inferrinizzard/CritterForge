package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.AddTeamEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class AddTeamHandler extends Handler
   {
       
      
      public var data:AddTeamEvent;
      
      public var manager:EventProcessor;
      
      public function AddTeamHandler(param1:AddTeamEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoAddTeam(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.AddTeamEvent;
import com.edgebee.breedr.managers.handlers.AddTeamHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import flash.events.Event;

class DoAddTeam extends HandlerState
{
    
   
   public function DoAddTeam(param1:AddTeamHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:CreatureInstance = null;
      super.transitionInto(param1);
      var _loc2_:AddTeamEvent = (machine as AddTeamHandler).data;
      var _loc3_:Team = player.syndicate.teams.findItemByProperty("id",_loc2_.team_id) as Team;
      if(_loc4_ = _loc3_.members.findItemByProperty("team_id",_loc2_.team_id) as CreatureInstance)
      {
         _loc4_.team_id = 0;
         _loc3_.members.removeItem(_loc4_);
         (_loc4_ = player.creatures.findItemByProperty("id",_loc4_.id) as CreatureInstance).team_id = 0;
      }
      (_loc4_ = player.creatures.findItemByProperty("id",_loc2_.creature_id) as CreatureInstance).team_id = _loc3_.id;
      _loc4_.cant_add_until = _loc2_.cant_add_until;
      var _loc5_:CreatureInstance = new CreatureInstance();
      _loc4_.copyTo(_loc5_);
      _loc3_.members.addItem(_loc5_);
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
