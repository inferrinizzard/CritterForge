package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.HappinessEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class HappinessHandler extends Handler
   {
       
      
      public var data:HappinessEvent;
      
      public var manager:EventProcessor;
      
      public function HappinessHandler(param1:HappinessEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoHappiness(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.HappinessEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HappinessHandler;

class DoHappiness extends HandlerState
{
    
   
   public function DoHappiness(param1:HappinessHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HappinessEvent = (machine as HappinessHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.happiness = _loc2_.happiness;
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
