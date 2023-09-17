package com.edgebee.atlas.util
{
   import flash.events.TimerEvent;
   
   public class DelayedCallback
   {
       
      
      private var _delay:uint;
      
      private var _callback:Function;
      
      private var _timer:com.edgebee.atlas.util.Timer;
      
      public function DelayedCallback(param1:uint, param2:Function)
      {
         super();
         this._delay = param1;
         this._callback = param2;
         this._timer = new com.edgebee.atlas.util.Timer(param1,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer,false,0,false);
      }
      
      public function touch() : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      public function provoke() : void
      {
         this._timer.reset();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         this._callback();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         this._callback();
      }
   }
}
