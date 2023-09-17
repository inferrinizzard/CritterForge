package com.edgebee.atlas.managers.processors
{
   import com.edgebee.atlas.data.events.ScheduledEvent;
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.util.ClockTimer;
   import com.edgebee.atlas.util.Cursor;
   import flash.events.TimerEvent;
   
   public class ScheduledProcessor extends BaseProcessor
   {
       
      
      private var timer:ClockTimer;
      
      public function ScheduledProcessor()
      {
         super();
         this.timer = client.createClockTimer(25);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      override public function add(param1:IExecutable) : void
      {
         var _loc2_:IExecutable = null;
         for each(_loc2_ in executables)
         {
            if(_loc2_ == param1)
            {
               throw Error("Event already scheduled.");
            }
         }
         super.add(param1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc3_:ScheduledEvent = null;
         var _loc2_:Cursor = new Cursor(executables);
         while(_loc2_.valid)
         {
            _loc3_ = _loc2_.current as ScheduledEvent;
            if(_loc3_.conditionFunc())
            {
               _loc3_.execute();
               _loc2_.remove();
            }
            else
            {
               _loc2_.next();
            }
         }
      }
   }
}
