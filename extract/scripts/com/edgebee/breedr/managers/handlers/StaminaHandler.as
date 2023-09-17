package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.StaminaEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class StaminaHandler extends Handler
   {
       
      
      public var data:StaminaEvent;
      
      public var manager:EventProcessor;
      
      public function StaminaHandler(param1:StaminaEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoStamina(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.StaminaEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.StaminaHandler;

class DoStamina extends HandlerState
{
    
   
   public function DoStamina(param1:StaminaHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:StaminaEvent = (machine as StaminaHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.stamina_id = _loc2_.stamina_id;
      _loc3_.sleep_time_left = _loc2_.sleep_time_left;
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
