package com.edgebee.atlas.util.fsm
{
   import com.edgebee.atlas.interfaces.IExecutable;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class Machine extends EventDispatcher implements IExecutable
   {
      
      public static const STOPPED:String = "STOPPED";
       
      
      private var _started:Boolean;
      
      private var _active:Boolean;
      
      private var _current:com.edgebee.atlas.util.fsm.State;
      
      private var _timer:uint;
      
      public var debug:Boolean;
      
      public function Machine()
      {
         super();
         this._started = false;
         this._active = false;
         this._current = null;
         this._timer = 0;
         this.debug = false;
      }
      
      public function start(param1:com.edgebee.atlas.util.fsm.State) : void
      {
         this._started = true;
         this._active = true;
         this._current = param1;
         this._timer = 0;
      }
      
      public function execute() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:uint = 0;
         if(this._active)
         {
            if(this._started)
            {
               this._started = false;
               this._current.transitionInto(this.debug);
            }
            if(!this.waiting)
            {
               _loc1_ = this._current.loop(this.debug);
               if(_loc1_ is Result)
               {
                  _loc2_ = uint(_loc1_.type);
               }
               else if(_loc1_ is uint)
               {
                  _loc2_ = _loc1_;
                  if(_loc2_ == Result.TRANSITION)
                  {
                     throw Error("Must return a Result object for state transitions!");
                  }
               }
               switch(_loc2_)
               {
                  case Result.CONTINUE:
                  default:
                     break;
                  case Result.STOP:
                     this.stop();
                     break;
                  case Result.TRANSITION:
                     this._current.transitionOut(this.debug);
                     this._current = _loc1_.state;
                     this._current.transitionInto(this.debug);
                     this.execute();
               }
            }
         }
      }
      
      public function stop() : void
      {
         this._active = false;
         this._current.transitionOut(this.debug);
         dispatchEvent(new Event(STOPPED));
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      private function get waiting() : Boolean
      {
         return this._timer >= getTimer();
      }
      
      public function set wait(param1:uint) : void
      {
         this._timer = getTimer() + param1;
      }
      
      protected function get currentState() : com.edgebee.atlas.util.fsm.State
      {
         return this._current;
      }
   }
}
