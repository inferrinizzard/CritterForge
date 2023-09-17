package com.edgebee.atlas.util.fsm
{
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.events.TimerEvent;
   
   public class AutomaticMachine extends Machine
   {
       
      
      public function AutomaticMachine()
      {
         super();
      }
      
      override public function start(param1:State) : void
      {
         super.start(param1);
         UIGlobals.twentyfiveMsTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      override public function stop() : void
      {
         super.stop();
         UIGlobals.twentyfiveMsTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         execute();
      }
   }
}
