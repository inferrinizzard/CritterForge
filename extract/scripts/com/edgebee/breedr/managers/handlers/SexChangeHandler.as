package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.SexChangeEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SexChangeHandler extends Handler
   {
       
      
      public var data:SexChangeEvent;
      
      public var manager:EventProcessor;
      
      public function SexChangeHandler(param1:SexChangeEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new ChangeSex(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.SexChangeEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SexChangeHandler;

class ChangeSex extends HandlerState
{
    
   
   public function ChangeSex(param1:SexChangeHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SexChangeEvent = (machine as SexChangeHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.is_male = _loc2_.is_male;
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
