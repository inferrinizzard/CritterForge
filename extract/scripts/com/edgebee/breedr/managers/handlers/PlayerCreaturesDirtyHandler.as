package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.PlayerCreaturesDirtyEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class PlayerCreaturesDirtyHandler extends Handler
   {
       
      
      public var data:PlayerCreaturesDirtyEvent;
      
      public var manager:EventProcessor;
      
      public function PlayerCreaturesDirtyHandler(param1:PlayerCreaturesDirtyEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.PlayerCreaturesDirtyEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.PlayerCreaturesDirtyHandler;

class Update extends HandlerState
{
    
   
   public function Update(param1:PlayerCreaturesDirtyHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Stall = null;
      super.transitionInto(param1);
      var _loc2_:PlayerCreaturesDirtyEvent = (machine as PlayerCreaturesDirtyHandler).data;
      var _loc4_:uint = 0;
      while(_loc4_ < _loc2_.stalls.length)
      {
         _loc3_ = _loc2_.stalls[_loc4_] as Stall;
         if(!_loc3_.locked)
         {
            _loc3_.creature.copyTo((player.stalls[_loc4_] as Stall).creature);
         }
         _loc4_++;
      }
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
