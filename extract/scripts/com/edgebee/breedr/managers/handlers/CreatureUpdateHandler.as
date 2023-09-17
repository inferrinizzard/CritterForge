package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.CreatureUpdateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class CreatureUpdateHandler extends Handler
   {
       
      
      public var data:CreatureUpdateEvent;
      
      public var manager:EventProcessor;
      
      public function CreatureUpdateHandler(param1:CreatureUpdateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoUpdate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.world.Feeder;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.CreatureUpdateEvent;
import com.edgebee.breedr.managers.handlers.CreatureUpdateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoUpdate extends HandlerState
{
    
   
   public function DoUpdate(param1:CreatureUpdateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:Feeder = null;
      var _loc5_:Stall = null;
      super.transitionInto(param1);
      var _loc2_:CreatureUpdateEvent = (machine as CreatureUpdateHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.stamina_id = _loc2_.stamina_id;
      _loc3_.seed_count = _loc2_.seed_count;
      _loc3_.is_sterile = _loc2_.is_sterile;
      for each(_loc5_ in player.stalls)
      {
         if(_loc5_.creature.id == _loc2_.creature_instance_id)
         {
            _loc4_ = _loc5_.feeder;
            break;
         }
      }
      if(!_loc4_)
      {
         throw new Error("Can\'t find feeder for creature " + _loc3_.name);
      }
      _loc4_.quantity = _loc2_.feeder_quantity;
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
