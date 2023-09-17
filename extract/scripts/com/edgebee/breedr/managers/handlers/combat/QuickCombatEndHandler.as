package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.QuickCombatEndEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class QuickCombatEndHandler extends Handler
   {
       
      
      public var data:QuickCombatEndEvent;
      
      public var manager:EventProcessor;
      
      public function QuickCombatEndHandler(param1:QuickCombatEndEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoEnd(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.combat.QuickCombatEndHandler;

class DoEnd extends HandlerState
{
    
   
   public function DoEnd(param1:QuickCombatEndHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      --client.criticalComms;
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
