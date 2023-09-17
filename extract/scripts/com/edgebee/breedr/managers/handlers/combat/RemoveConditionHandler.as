package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.RemoveConditionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class RemoveConditionHandler extends Handler
   {
       
      
      public var data:RemoveConditionEvent;
      
      public var manager:EventProcessor;
      
      public function RemoveConditionHandler(param1:RemoveConditionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRemoveCondition(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.combat.Condition;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.RemoveConditionEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.RemoveConditionHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class DoRemoveCondition extends CombatHandlerState
{
    
   
   public function DoRemoveCondition(param1:RemoveConditionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:RemoveConditionEvent = (machine as RemoveConditionHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance;
      var _loc5_:Condition = (_loc4_ = _loc3_.getCreatureById(_loc2_.creature_instance_id)).findCondition(_loc2_.condition_id);
      _loc4_.conditions.removeItem(_loc5_);
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_CONDITION_REMOVE_LOG").value,{
         "name":decorateName(_loc4_.name),
         "afflict":_loc5_.afflict_text.value
      }));
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
