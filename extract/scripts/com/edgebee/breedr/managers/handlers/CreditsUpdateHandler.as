package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.CreditsUpdateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class CreditsUpdateHandler extends Handler
   {
      
      public static var CreditsChangeWav:Class = CreditsUpdateHandler_CreditsChangeWav;
       
      
      public var data:CreditsUpdateEvent;
      
      public var manager:EventProcessor;
      
      public function CreditsUpdateHandler(param1:CreditsUpdateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoCreditsUpdate(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.CreditsUpdateEvent;
import com.edgebee.breedr.managers.handlers.CreditsUpdateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoCreditsUpdate extends HandlerState
{
    
   
   public function DoCreditsUpdate(param1:CreditsUpdateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CreditsUpdateEvent = (machine as CreditsUpdateHandler).data;
      if(player.credits != _loc2_.credits)
      {
         player.credits = _loc2_.credits;
         UIGlobals.playSound(CreditsUpdateHandler.CreditsChangeWav);
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
