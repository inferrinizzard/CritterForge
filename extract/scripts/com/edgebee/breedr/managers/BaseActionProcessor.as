package com.edgebee.breedr.managers
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.events.ActionDispatcherEvent;
   import com.edgebee.atlas.interfaces.IDisposable;
   import com.edgebee.atlas.util.Cursor;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.fsm.Machine;
   import com.edgebee.breedr.Client;
   import flash.events.*;
   
   public class BaseActionProcessor extends EventDispatcher implements IDisposable
   {
       
      
      private var _active:Boolean;
      
      private var _paused:Boolean;
      
      private var _currentMachine:Machine;
      
      private var _currentProcess:Object;
      
      private var _handledActionsMap:Object;
      
      private var _machines:ArrayCollection;
      
      protected var _client:Client;
      
      protected var timer:Timer;
      
      public function BaseActionProcessor(param1:Client, param2:Object)
      {
         var _loc3_:Object = null;
         super();
         this._active = true;
         this._client = param1;
         this._client.actionDispatcher.addEventListener(ActionDispatcherEvent.PROCESS_ACTION,this.onProcessAction);
         this._handledActionsMap = param2;
         this._machines = new ArrayCollection();
         for each(_loc3_ in this._handledActionsMap)
         {
            if(_loc3_.hasOwnProperty("data"))
            {
               param1.actionDispatcher.addActionType(_loc3_.data.classinfo);
            }
         }
         this.timer = new Timer(50);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      public function set paused(param1:Boolean) : void
      {
         this._paused = param1;
      }
      
      public function get client() : *
      {
         return this._client;
      }
      
      public function get currentMachine() : Machine
      {
         if(!this.active)
         {
            return null;
         }
         return this._machines[0];
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispose() : void
      {
         this.client.actionDispatcher.removeEventListener(ActionDispatcherEvent.PROCESS_ACTION,this.onProcessAction);
      }
      
      protected function onProcessAction(param1:ActionDispatcherEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Class = null;
         var _loc3_:Class = null;
         for each(_loc4_ in this._handledActionsMap)
         {
            if(param1.action is _loc4_.data)
            {
               this._currentProcess = _loc4_;
               _loc2_ = _loc4_.data as Class;
               _loc3_ = _loc4_.machine as Class;
               break;
            }
         }
         if(_loc2_)
         {
            if(this._currentProcess.hasOwnProperty("activates") && Boolean(this._currentProcess.activates))
            {
               this.active = true;
            }
            if(!_loc3_ && this._currentProcess.hasOwnProperty("deactivates") && Boolean(this._currentProcess.deactivates))
            {
               this.active = false;
            }
            if(this.active && Boolean(_loc3_))
            {
               this._client.actionDispatcher.addActionProcessor();
               this._machines.addItem(new _loc3_(param1.action as _loc2_,this));
               this.timer.start();
            }
         }
      }
      
      protected function beforeTerminate() : void
      {
         if(this._currentProcess.hasOwnProperty("deactivates") && Boolean(this._currentProcess.deactivates))
         {
            this.active = false;
         }
      }
      
      private function onTimerEvent(param1:TimerEvent) : void
      {
         var _loc2_:Cursor = null;
         var _loc3_:Machine = null;
         if(this._machines.length > 0 && !this.paused)
         {
            _loc2_ = new Cursor(this._machines);
            while(_loc2_.valid)
            {
               if(this.paused)
               {
                  break;
               }
               _loc3_ = _loc2_.current as Machine;
               _loc3_.execute();
               if(!_loc3_.active)
               {
                  if(this._machines.length == 1)
                  {
                     this.beforeTerminate();
                     this.timer.stop();
                  }
                  _loc2_.remove();
                  this._client.actionDispatcher.removeActionProcessor();
               }
               else
               {
                  _loc2_.next();
               }
            }
         }
      }
   }
}
