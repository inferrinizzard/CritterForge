package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.events.GameEventData;
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.events.EventDispatcher;
   
   public class GameEventDispatcher extends EventDispatcher
   {
      
      public static const INSTANTANEOUS:uint = 0;
      
      public static const SEQUENTIAL:uint = 1;
      
      public static const PARALLEL:uint = 2;
      
      public static const SCHEDULED:uint = 3;
       
      
      private var _types:Object;
      
      public function GameEventDispatcher()
      {
         this._types = {};
         super();
      }
      
      public function register(param1:Class, param2:uint = 0) : void
      {
         this._types[param1.classinfo.name] = new EventHandlingInformation(param1,param2);
      }
      
      public function dispatch(param1:Array) : void
      {
         var _loc2_:EventHandlingInformation = null;
         var _loc3_:GameEventData = null;
         var _loc4_:Object = null;
         for each(_loc4_ in param1)
         {
            if(!_loc4_.hasOwnProperty("__type__"))
            {
               throw new Error("Event object is missing its \"__type__\" property.");
            }
            if(!this._types.hasOwnProperty(_loc4_.__type__))
            {
               throw new Error("Unrecognized game event \"" + _loc4_.__type__ + "\", did you forget to register the event class in the client?");
            }
            _loc2_ = this._types[_loc4_.__type__] as EventHandlingInformation;
            _loc3_ = new _loc2_.dataCls(_loc4_);
            switch(_loc2_.handling)
            {
               case INSTANTANEOUS:
                  _loc3_.execute();
                  break;
               case SEQUENTIAL:
                  this.client.sequentialProcessor.add(_loc3_);
                  break;
               case PARALLEL:
                  this.client.parallelProcessor.add(_loc3_);
                  break;
               case SCHEDULED:
                  this.client.scheduledProcessor.add(_loc3_);
                  break;
            }
         }
      }
      
      private function get client() : Client
      {
         return UIGlobals.root.client;
      }
   }
}

class EventHandlingInformation
{
    
   
   public var dataCls:Class;
   
   public var handling:uint;
   
   public function EventHandlingInformation(param1:Class, param2:uint)
   {
      super();
      this.dataCls = param1;
      this.handling = param2;
   }
   
   public function get name() : String
   {
      return this.dataCls.classinfo.name;
   }
}
