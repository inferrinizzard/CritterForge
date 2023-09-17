package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.AttackEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class AttackHandler extends Handler
   {
       
      
      public var data:AttackEvent;
      
      public var manager:EventProcessor;
      
      public function AttackHandler(param1:AttackEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoAttack(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.AttackEvent;
import com.edgebee.breedr.managers.handlers.combat.AttackHandler;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoAttack extends CombatHandlerState
{
    
   
   public function DoAttack(param1:AttackHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc6_:SkillInstance = null;
      super.transitionInto(param1);
      var _loc2_:AttackEvent = (machine as AttackHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.inflictor_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.inflictor_id);
      if(!_loc2_.is_primary)
      {
         _loc5_.showAction();
         _loc6_ = _loc4_.findSkill(_loc2_.skill_id);
         _loc5_.showSkillIcons(_loc6_,false);
         timer.delay = 500 / client.combatSpeedMultiplier;
         timer.start();
      }
      else
      {
         timerComplete = true;
      }
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
   }
}
