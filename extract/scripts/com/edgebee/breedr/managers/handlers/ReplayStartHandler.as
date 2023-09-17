package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ReplayStartEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ReplayStartHandler extends Handler
   {
       
      
      public var data:ReplayStartEvent;
      
      public var manager:EventProcessor;
      
      public function ReplayStartHandler(param1:ReplayStartEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Start(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.ReplayStartEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.ReplayStartHandler;

class Start extends HandlerState
{
    
   
   public function Start(param1:ReplayStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ReplayStartEvent = (machine as ReplayStartHandler).data;
      if(gameView.combatResultsWindow.visible)
      {
         gameView.combatResultsWindow.showAfterReplay = true;
      }
      client.currentReplay = _loc2_.replay;
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
