package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.NewCreatureEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class NewCreatureHandler extends Handler
   {
       
      
      public var data:NewCreatureEvent;
      
      public var manager:EventProcessor;
      
      public function NewCreatureHandler(param1:NewCreatureEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new AddNewCreature(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.NewCreatureEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewCreatureHandler;

class AddNewCreature extends HandlerState
{
    
   
   public function AddNewCreature(param1:NewCreatureHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:NewCreatureEvent = (machine as NewCreatureHandler).data;
      var _loc3_:Stall = player.stalls.findItemByProperty("id",_loc2_.stall_id) as Stall;
      _loc2_.creature_instance.copyTo(_loc3_.creature);
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
