package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.ConditionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class ConditionHandler extends Handler
   {
      
      public static var ConditionWav:Class = ConditionHandler_ConditionWav;
      
      public static var BoostWav:Class = ConditionHandler_BoostWav;
      
      public static var ReduceWav:Class = ConditionHandler_ReduceWav;
       
      
      public var data:ConditionEvent;
      
      public var manager:EventProcessor;
      
      public function ConditionHandler(param1:ConditionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoCondition(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.combat.Condition;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.ConditionEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ConditionHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoCondition extends CombatHandlerState
{
    
   
   public function DoCondition(param1:ConditionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc8_:SkillInstance = null;
      var _loc9_:Condition = null;
      var _loc10_:Condition = null;
      var _loc11_:Boolean = false;
      super.transitionInto(param1);
      var _loc2_:ConditionEvent = (machine as ConditionHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      var _loc6_:CreatureInstance = _loc3_.getCreatureById(_loc2_.inflictor_id);
      var _loc7_:ActorView = _loc3_.getViewById(_loc2_.inflictor_id);
      if(!_loc2_.is_primary)
      {
         _loc8_ = _loc6_.findSkill(_loc2_.skill_id);
         _loc7_.showSkillIcons(_loc8_,false);
      }
      if(_loc2_.resisted)
      {
         _loc5_.showNoEffect();
      }
      else
      {
         (_loc9_ = _loc2_.condition).duration = _loc2_.duration;
         _loc11_ = false;
         for each(_loc10_ in _loc4_.conditions)
         {
            if(_loc10_.id == _loc9_.id)
            {
               _loc11_ = true;
               break;
            }
         }
         if(_loc11_)
         {
            _loc9_.duration = _loc10_.duration;
         }
         else
         {
            _loc4_.conditions.addItem(_loc9_);
         }
         if(_loc9_.type & Condition.TYPE_REDUCE)
         {
            UIGlobals.playSound(ConditionHandler.ReduceWav);
         }
         else if(_loc9_.type & Condition.TYPE_BOOST)
         {
            UIGlobals.playSound(ConditionHandler.BoostWav);
         }
         else
         {
            UIGlobals.playSound(ConditionHandler.ConditionWav);
         }
         _loc5_.effectDisplay.showCondition(_loc2_.condition);
      }
      timer.delay = 750 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new ShowConditionValue(machine as ConditionHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.ConditionEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ConditionHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowConditionValue extends CombatHandlerState
{
    
   
   public function ShowConditionValue(param1:ConditionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ConditionEvent = (machine as ConditionHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      if(_loc2_.resisted)
      {
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_CONDITION_RESIST_LOG").value,{
            "name":decorateName(_loc4_.name),
            "afflict":_loc2_.afflict_text.value
         }));
      }
      else
      {
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_CONDITION_LOG").value,{
            "name":decorateName(_loc4_.name),
            "afflict":_loc2_.afflict_text.value,
            "rounds":_loc2_.condition.duration
         }));
      }
      timer.delay = 250 / client.combatSpeedMultiplier;
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
   }
}
