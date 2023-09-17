package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.TraitsUpdateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class TraitsUpdateHandler extends Handler
   {
       
      
      public var data:TraitsUpdateEvent;
      
      public var manager:EventProcessor;
      
      public function TraitsUpdateHandler(param1:TraitsUpdateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.TraitInstance;
import com.edgebee.breedr.events.TraitsUpdateEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TraitsUpdateHandler;

class Update extends HandlerState
{
    
   
   public function Update(param1:TraitsUpdateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:TraitInstance = null;
      var _loc5_:TraitInstance = null;
      super.transitionInto(param1);
      var _loc2_:TraitsUpdateEvent = (machine as TraitsUpdateHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      for each(_loc5_ in _loc2_.traits)
      {
         if(_loc4_ = _loc3_.traits.findItemByProperty("id",_loc5_.id) as TraitInstance)
         {
            _loc5_.copyTo(_loc4_);
         }
         else
         {
            _loc3_.traits.addItem(_loc5_);
         }
      }
      _loc3_.skill_points = _loc2_.skill_points;
      _loc3_.skill_points_delta = 0;
      _loc3_.seed_count = _loc2_.seed_count;
      _loc3_.stamina_id = _loc2_.stamina_id;
      _loc3_.max_stamina_id = _loc2_.max_stamina_id;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:TraitsUpdateEvent = (machine as TraitsUpdateHandler).data;
      if(!_loc2_.is_stealth)
      {
         --client.criticalComms;
      }
   }
}
