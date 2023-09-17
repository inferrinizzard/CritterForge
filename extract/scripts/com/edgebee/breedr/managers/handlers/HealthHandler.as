package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.HealthEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class HealthHandler extends Handler
   {
       
      
      public var data:HealthEvent;
      
      public var manager:EventProcessor;
      
      public function HealthHandler(param1:HealthEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoHealth(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.HealthEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HealthHandler;

class DoHealth extends HandlerState
{
    
   
   public function DoHealth(param1:HealthHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HealthEvent = (machine as HealthHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.health = _loc2_.health;
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
