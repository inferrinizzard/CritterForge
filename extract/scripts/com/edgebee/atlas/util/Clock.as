package com.edgebee.atlas.util
{
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class Clock extends EventDispatcher
   {
       
      
      private var _timeScale:Number = 1;
      
      private var _currentTime:Number;
      
      private var _last:Number;
      
      private var _deltaTime:Number;
      
      private var _ticksPerSecond:Number;
      
      private var _defaultDeltaTime:Number;
      
      private var _timer:com.edgebee.atlas.util.Timer;
      
      public function Clock(param1:Number = 120)
      {
         super();
         this._timer = new com.edgebee.atlas.util.Timer(1);
         UIGlobals.root.stage.addEventListener(Event.ENTER_FRAME,this.onTimer);
         this._ticksPerSecond = param1;
         this._defaultDeltaTime = 1000 / param1;
      }
      
      public function start() : void
      {
         this._last = getTimer();
         this._timer.start();
      }
      
      public function stop() : void
      {
         this._timer.stop();
      }
      
      public function reset() : void
      {
         this.stop();
         this._currentTime = 0;
      }
      
      public function get gameTime() : Number
      {
         return this._currentTime;
      }
      
      public function get running() : Boolean
      {
         return this._timer.running;
      }
      
      public function get timeScale() : Number
      {
         return this._timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         this._timeScale = param1;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function onTimer(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.running)
         {
            _loc2_ = getTimer();
            _loc3_ = _loc2_ - this._last;
            _loc3_ *= this.timeScale;
            if(_loc3_ >= this._defaultDeltaTime)
            {
               this._last = _loc2_;
               this._currentTime += _loc3_;
               dispatchEvent(new ClockEvent(this._defaultDeltaTime,_loc3_,this._currentTime));
            }
         }
      }
   }
}
