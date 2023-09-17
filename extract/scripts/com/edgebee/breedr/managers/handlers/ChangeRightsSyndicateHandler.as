package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ChangeRightsSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ChangeRightsSyndicateHandler extends Handler
   {
       
      
      public var data:ChangeRightsSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function ChangeRightsSyndicateHandler(param1:ChangeRightsSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoChangeRights(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.events.ChangeRightsSyndicateEvent;
import com.edgebee.breedr.managers.handlers.ChangeRightsSyndicateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoChangeRights extends HandlerState
{
    
   
   public function DoChangeRights(param1:ChangeRightsSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ChangeRightsSyndicateEvent = (machine as ChangeRightsSyndicateHandler).data;
      var _loc3_:Player = player.syndicate.members.findItemByProperty("id",_loc2_.player_id) as Player;
      _loc3_.syndicate_flags = _loc2_.syndicate_flags;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
