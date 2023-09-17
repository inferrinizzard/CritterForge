package com.edgebee.atlas.util
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   
   public class ClockTimer extends EventDispatcher implements ITimer
   {
       
      
      private var _time:Number = 0;
      
      private var _count:int = 0;
      
      private var _delay:Number = 0;
      
      private var _repeatCount:int = 0;
      
      private var _running:Boolean;
      
      public function ClockTimer(param1:Clock, param2:Number, param3:int = 0)
      {
         super();
         this._delay = param2;
         this._repeatCount = param3;
         param1.addEventListener(ClockEvent.TICK,this.onTick);
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function get currentCount() : int
      {
         return this._count;
      }
      
      public function set currentCount(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get delay() : Number
      {
         return this._delay;
      }
      
      public function set delay(param1:Number) : void
      {
         this._delay = param1;
      }
      
      public function get repeatCount() : int
      {
         return this._repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         this._repeatCount = param1;
      }
      
      public function start() : void
      {
         this._running = true;
      }
      
      public function stop() : void
      {
         this._running = false;
      }
      
      public function reset() : void
      {
         this.stop();
         this._time = 0;
         this._count = 0;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function onTick(param1:ClockEvent) : void
      {
         if(this._running)
         {
            this._time += param1.deltaTime;
            if(this._time >= this._delay)
            {
               if(this._repeatCount > 0)
               {
                  do
                  {
                     if(this._count >= this._repeatCount)
                     {
                        this.reset();
                        dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
                        break;
                     }
                     ++this._count;
                     this._time -= this.delay;
                     dispatchEvent(new TimerEvent(TimerEvent.TIMER));
                  }
                  while(this._time >= this._delay);
                  
               }
               else
               {
                  do
                  {
                     this._time -= this.delay;
                     dispatchEvent(new TimerEvent(TimerEvent.TIMER));
                  }
                  while(this._time >= this._delay);
                  
               }
            }
         }
      }
   }
}
