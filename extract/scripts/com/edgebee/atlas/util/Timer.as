package com.edgebee.atlas.util
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   
   public class Timer extends EventDispatcher implements com.edgebee.atlas.util.ITimer
   {
       
      
      private var _implementation:com.edgebee.atlas.util.ITimer;
      
      public function Timer(param1:Number, param2:int = 0)
      {
         super();
         if(0)
         {
            this._implementation = new DebuggerSupportedTimer(param1,param2);
         }
         else
         {
            this._implementation = new NormalTimer(param1,param2);
         }
         this._implementation.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this._implementation.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerEvent);
      }
      
      public function get currentCount() : int
      {
         return this._implementation.currentCount;
      }
      
      public function get running() : Boolean
      {
         return this._implementation.running;
      }
      
      public function get delay() : Number
      {
         return this._implementation.delay;
      }
      
      public function set delay(param1:Number) : void
      {
         this._implementation.delay = param1;
      }
      
      public function get repeatCount() : int
      {
         return this._implementation.repeatCount;
      }
      
      public function set repeatCount(param1:int) : void
      {
         this._implementation.repeatCount = param1;
      }
      
      public function start() : void
      {
         var f:Function = function():void
         {
            _implementation.start();
         };
         f();
      }
      
      public function stop() : void
      {
         this._implementation.stop();
      }
      
      public function reset() : void
      {
         this._implementation.reset();
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function onTimerEvent(param1:TimerEvent) : void
      {
         dispatchEvent(new TimerEvent(param1.type,param1.bubbles,param1.cancelable));
      }
   }
}

import com.edgebee.atlas.util.ITimer;
import flash.utils.Timer;

class NormalTimer extends Timer implements ITimer
{
    
   
   public function NormalTimer(param1:Number, param2:int = 0)
   {
      super(param1,param2);
   }
   
   override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
   {
      super.addEventListener(param1,param2,param3,param4,param5);
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.ITimer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;

class DebuggerSupportedTimer extends EventDispatcher implements ITimer
{
    
   
   private var _listenerRegistered:Boolean = false;
   
   private var _currentTime:Number = 0;
   
   private var _currentCount:int = 0;
   
   private var _delay:Number = 0;
   
   private var _repeatCount:int = 0;
   
   private var _lastFrame:Number;
   
   private var _running:Boolean = false;
   
   private const DEBUGGER_BREAK_DETECT_THRESHOLD:Number = 3000;
   
   public function DebuggerSupportedTimer(param1:Number, param2:int = 0)
   {
      super();
      this.delay = param1;
      this.repeatCount = param2;
   }
   
   public function get currentCount() : int
   {
      return this._currentCount;
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
   
   override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
   {
      super.addEventListener(param1,param2,param3,param4,param5);
   }
   
   public function start() : void
   {
      this.registerListener();
      this._running = true;
      this._lastFrame = new Date().time;
   }
   
   public function stop() : void
   {
      this.registerListener();
      this._running = false;
   }
   
   public function reset() : void
   {
      this.registerListener();
      this.stop();
      this._currentCount = 0;
      this._currentTime = 0;
      this._lastFrame = 0;
   }
   
   private function registerListener() : void
   {
      if(!this._listenerRegistered && UIGlobals && UIGlobals.root && Boolean(UIGlobals.root.stage))
      {
         UIGlobals.root.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
      }
   }
   
   private function onEnterFrame(param1:Event) : void
   {
      var _loc2_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc4_:Number = NaN;
      if(this._running)
      {
         _loc2_ = new Date().time;
         _loc3_ = _loc2_ - this._lastFrame;
         if(_loc3_ > this.DEBUGGER_BREAK_DETECT_THRESHOLD)
         {
            _loc3_ = 1 / 60;
         }
         this._lastFrame = _loc2_;
         this._currentTime += _loc3_;
         if(this._currentTime >= this._delay)
         {
            _loc4_ = this._currentTime - this.delay;
            if(this._repeatCount > 0)
            {
               if(this._currentCount < this._repeatCount)
               {
                  ++this._currentCount;
                  this._currentTime = _loc4_;
                  dispatchEvent(new TimerEvent(TimerEvent.TIMER));
               }
               else
               {
                  this.reset();
                  dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
               }
            }
            else
            {
               dispatchEvent(new TimerEvent(TimerEvent.TIMER));
               dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
            }
         }
      }
   }
}
