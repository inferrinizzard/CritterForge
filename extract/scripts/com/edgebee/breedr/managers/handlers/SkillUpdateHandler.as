package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.SkillUpdateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SkillUpdateHandler extends Handler
   {
       
      
      public var data:SkillUpdateEvent;
      
      public var manager:EventProcessor;
      
      public function SkillUpdateHandler(param1:SkillUpdateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoSkillSkillLevelUp(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.SkillUpdateEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SkillUpdateHandler;

class DoSkillSkillLevelUp extends HandlerState
{
    
   
   public function DoSkillSkillLevelUp(param1:SkillUpdateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:SkillInstance = null;
      super.transitionInto(param1);
      var _loc2_:SkillUpdateEvent = (machine as SkillUpdateHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.skill_points = _loc2_.skill_points;
      _loc3_.skill_points_delta = 0;
      var _loc5_:int = 0;
      while(_loc5_ < _loc3_.modifiable_skills.length)
      {
         _loc2_.skills[_loc5_].copyTo(_loc3_.modifiable_skills[_loc5_]);
         _loc3_.modifiable_skills[_loc5_].originalIndex = _loc5_ + 1;
         _loc5_++;
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.skillEditorWindow.doClose();
      var _loc2_:SkillUpdateEvent = (machine as SkillUpdateHandler).data;
      if(!_loc2_.stealth)
      {
         --client.criticalComms;
      }
   }
}
