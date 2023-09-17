package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.LeaveSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class LeaveSyndicateHandler extends Handler
   {
       
      
      public var data:LeaveSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function LeaveSyndicateHandler(param1:LeaveSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoLeaveSyndicate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Syndicate;
import com.edgebee.breedr.events.LeaveSyndicateEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.LeaveSyndicateHandler;

class DoLeaveSyndicate extends HandlerState
{
    
   
   public function DoLeaveSyndicate(param1:LeaveSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LeaveSyndicateEvent = (machine as LeaveSyndicateHandler).data;
      var _loc3_:Syndicate = new Syndicate();
      _loc3_.copyTo(player.syndicate);
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
