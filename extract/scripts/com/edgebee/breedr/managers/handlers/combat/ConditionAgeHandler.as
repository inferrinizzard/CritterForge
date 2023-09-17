package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.ConditionAgeEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class ConditionAgeHandler extends Handler
   {
       
      
      public var data:ConditionAgeEvent;
      
      public var manager:EventProcessor;
      
      public function ConditionAgeHandler(param1:ConditionAgeEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoConditionAge(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.combat.Condition;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.ConditionAgeEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ConditionAgeHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class DoConditionAge extends CombatHandlerState
{
    
   
   public function DoConditionAge(param1:ConditionAgeHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ConditionAgeEvent = (machine as ConditionAgeHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc5_:Condition;
      var _loc4_:CreatureInstance;
      (_loc5_ = (_loc4_ = _loc3_.getCreatureById(_loc2_.creature_instance_id)).findCondition(_loc2_.condition_id)).duration = _loc2_.duration;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
