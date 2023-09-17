package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.PlayerItemsDirtyEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class PlayerItemsDirtyHandler extends Handler
   {
       
      
      public var data:PlayerItemsDirtyEvent;
      
      public var manager:EventProcessor;
      
      public function PlayerItemsDirtyHandler(param1:PlayerItemsDirtyEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.PlayerItemsDirtyEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.PlayerItemsDirtyHandler;

class Update extends HandlerState
{
    
   
   public function Update(param1:PlayerItemsDirtyHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:PlayerItemsDirtyEvent = (machine as PlayerItemsDirtyHandler).data;
      player.items.source = _loc2_.items.source;
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
