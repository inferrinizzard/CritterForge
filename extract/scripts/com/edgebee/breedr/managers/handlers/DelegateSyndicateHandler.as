package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.DelegateSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class DelegateSyndicateHandler extends Handler
   {
       
      
      public var data:DelegateSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function DelegateSyndicateHandler(param1:DelegateSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoDelegateSyndicate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.DelegateSyndicateEvent;
import com.edgebee.breedr.managers.handlers.DelegateSyndicateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoDelegateSyndicate extends HandlerState
{
    
   
   public function DoDelegateSyndicate(param1:DelegateSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:DelegateSyndicateEvent = (machine as DelegateSyndicateHandler).data;
      _loc2_.syndicate.copyTo(player.syndicate);
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
