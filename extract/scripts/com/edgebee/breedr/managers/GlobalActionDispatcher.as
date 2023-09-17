package com.edgebee.breedr.managers
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.events.ActionDispatcherEvent;
   import flash.events.EventDispatcher;
   
   public class GlobalActionDispatcher extends EventDispatcher
   {
       
      
      private var _users:uint;
      
      private var _actions:DataArray;
      
      public function GlobalActionDispatcher()
      {
         this._actions = new DataArray();
         super();
      }
      
      public function reset() : void
      {
         this._actions = new DataArray();
         this._users = 0;
      }
      
      public function hasActionWaiting(param1:Class, param2:Object = null) : Boolean
      {
         var _loc3_:Object = null;
         for each(_loc3_ in this._actions)
         {
            if(_loc3_ is param1)
            {
               if(!param2 || param2 != _loc3_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function hasActionsWaiting() : Boolean
      {
         return this._actions.length > 0;
      }
      
      public function addActionType(param1:Object) : void
      {
         if(!this._actions.hasType(param1.name))
         {
            this._actions.addType(param1);
         }
      }
      
      public function getActions() : DataArray
      {
         return this._actions;
      }
      
      public function set actions(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            this._actions.append(_loc2_);
         }
         if(this._users == 0)
         {
            dispatchEvent(new ActionDispatcherEvent(ActionDispatcherEvent.PROCESSING_START,this));
            this.processNextOrStop();
         }
      }
      
      public function addActionProcessor() : void
      {
         ++this._users;
      }
      
      public function removeActionProcessor() : void
      {
         if(this._users > 0)
         {
            --this._users;
         }
         this.update();
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function update() : void
      {
         if(this._users == 0)
         {
            this._actions.removeItemAt(0);
            this.processNextOrStop();
         }
      }
      
      private function processNextOrStop() : void
      {
         if(this._actions.length > 0)
         {
            dispatchEvent(new ActionDispatcherEvent(ActionDispatcherEvent.PROCESS_ACTION,this,this._actions[0]));
            this.update();
         }
         else
         {
            dispatchEvent(new ActionDispatcherEvent(ActionDispatcherEvent.PROCESSING_STOP,this));
         }
      }
   }
}
