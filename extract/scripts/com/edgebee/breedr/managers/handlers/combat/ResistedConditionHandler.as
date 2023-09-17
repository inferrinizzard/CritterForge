package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.ResistedConditionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class ResistedConditionHandler extends Handler
   {
       
      
      public var data:ResistedConditionEvent;
      
      public var manager:EventProcessor;
      
      public function ResistedConditionHandler(param1:ResistedConditionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoResistCondition(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.ResistedConditionEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ResistedConditionHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class DoResistCondition extends CombatHandlerState
{
    
   
   public function DoResistCondition(param1:ResistedConditionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ResistedConditionEvent = (machine as ResistedConditionHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.creature_instance_id);
      loggingBox.print(decorateName(_loc4_.name) + " resisted getting " + _loc2_.afflict_text.value);
      loggingBox.flush();
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
