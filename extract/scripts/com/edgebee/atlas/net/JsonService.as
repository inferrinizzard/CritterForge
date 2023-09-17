package com.edgebee.atlas.net
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.events.*;
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.events.*;
   import flash.net.URLVariables;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public dynamic class JsonService extends Proxy implements IEventDispatcher
   {
      
      public static const HANDLE_PIGGY_BACK:String = "HANDLE_PIGGY_BACK";
      
      public static const SHOW_NETWORK_STATUS_WINDOW:String = "SHOW_NETWORK_STATUS_WINDOW";
      
      public static const HIDE_NETWORK_STATUS_WINDOW:String = "HIDE_NETWORK_STATUS_WINDOW";
      
      public static const MAX_CONNECTIONS:uint = 8;
      
      public static const METHOD_NORMAL:int = 0;
      
      public static const METHOD_CRITICAL:int = 1;
       
      
      private var _client:Client;
      
      private var _url:String;
      
      private var _dispatcher:EventDispatcher;
      
      private var _id:uint = 0;
      
      private var _connections:Array;
      
      private var _statistics:com.edgebee.atlas.net.ServiceStatistics;
      
      private var _numLaggedConnections:int = 0;
      
      private var _registeredMethods:Object;
      
      public function JsonService(param1:Client, param2:String)
      {
         var _loc4_:ServerConnection = null;
         this._dispatcher = new EventDispatcher();
         this._connections = [];
         this._statistics = new com.edgebee.atlas.net.ServiceStatistics();
         this._registeredMethods = {};
         super();
         this._client = param1;
         this._url = param2;
         var _loc3_:uint = 0;
         while(_loc3_ < MAX_CONNECTIONS)
         {
            (_loc4_ = new ServerConnection()).addEventListener(ServerConnection.RECEPTION_COMPLETE,this.onReceptionComplete);
            _loc4_.addEventListener(ServerConnection.TRANSPARENCY_TIMEOUT,this.onTransparencyTimeout);
            _loc4_.addEventListener(ServerConnection.CONNECTION_TIMEOUT,this.onConnectionTimeout);
            _loc4_.addEventListener(ServerConnection.STATE_CHANGED,this.onConnectionStateChanged);
            this._connections.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function get connections() : Array
      {
         return this._connections;
      }
      
      public function get statistics() : com.edgebee.atlas.net.ServiceStatistics
      {
         return this._statistics;
      }
      
      public function registerMethod(param1:String, param2:Boolean = false) : void
      {
         this._registeredMethods[param1] = param2 ? METHOD_CRITICAL : METHOD_NORMAL;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._dispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._dispatcher.willTrigger(param1);
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:Object = new Object();
         _loc3_.method = param1.localName;
         if(rest[0] is Object)
         {
            _loc3_.params = [rest[0]];
         }
         else
         {
            _loc3_.params = [new Object()];
         }
         _loc3_.id = ++this._id;
         this.send(_loc3_);
      }
      
      public function callSpecificUrl(param1:String, param2:String, param3:String, param4:URLVariables, ... rest) : void
      {
         var _loc7_:String = null;
         var _loc6_:Object;
         (_loc6_ = new Object()).method = param2;
         if(rest[0] is Object)
         {
            _loc6_.params = [rest[0]];
         }
         else
         {
            _loc6_.params = [new Object()];
         }
         _loc6_.id = ++this._id;
         if(param1.indexOf("http://") < 0)
         {
            _loc7_ = this._url.substring(0,this._url.lastIndexOf("/") + 1) + param1;
         }
         else
         {
            _loc7_ = param1;
         }
         this.send(_loc6_,_loc7_,param3,param4);
      }
      
      private function updateStatusWindow() : void
      {
         var _loc2_:ServerConnection = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._connections)
         {
            if(_loc2_.isVisible)
            {
               _loc1_++;
            }
         }
         if(this._numLaggedConnections != _loc1_)
         {
            if(_loc1_ == 0)
            {
               this.dispatchEvent(new Event(HIDE_NETWORK_STATUS_WINDOW));
            }
            else if(this._numLaggedConnections == 0)
            {
               this.dispatchEvent(new Event(SHOW_NETWORK_STATUS_WINDOW));
            }
            this._numLaggedConnections = _loc1_;
         }
      }
      
      private function send(param1:Object, param2:String = null, param3:String = "POST", param4:URLVariables = null) : void
      {
         param1.client_id = this._client.id;
         if(this._registeredMethods.hasOwnProperty(param1.method) && this._registeredMethods[param1.method] == METHOD_CRITICAL)
         {
            ++this._client.criticalComms;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < MAX_CONNECTIONS)
         {
            if(!this._connections[_loc5_].busy)
            {
               if(param2)
               {
                  this._connections[_loc5_].reset();
                  this._connections[_loc5_].send(param2,param1,param3,param4);
               }
               else
               {
                  this._connections[_loc5_].reset();
                  this._connections[_loc5_].send(this._url + "/client_action",param1,param3,param4);
               }
               return;
            }
            _loc5_++;
         }
         throw Error("JsonServer::callProperty :: All servers are busy, send failed.");
      }
      
      private function onTransparencyTimeout(param1:Event) : void
      {
         this.updateStatusWindow();
      }
      
      private function onConnectionTimeout(param1:Event) : void
      {
         this.updateStatusWindow();
         UIGlobals.root.client.doClientOutOfSynch();
      }
      
      private function onConnectionStateChanged(param1:Event) : void
      {
         this.updateStatusWindow();
      }
      
      private function onReceptionComplete(param1:ConnectionEvent) : void
      {
         if(param1.name == "GetStaticDump")
         {
         }
         this.processReception(param1);
         this.updateStatusWindow();
      }
      
      private function processReception(param1:ConnectionEvent) : void
      {
         var _loc2_:ExceptionEvent = null;
         this.statistics.addRequest(param1.name,param1.latency);
         if(this._registeredMethods.hasOwnProperty(param1.name))
         {
            if(this._registeredMethods[param1.name] == METHOD_CRITICAL)
            {
               --this._client.criticalComms;
            }
            if(param1.data.hasOwnProperty("events"))
            {
               this._client.handleGameEvents(param1.data.events);
            }
         }
         if(param1.data.hasOwnProperty("exception"))
         {
            _loc2_ = new ExceptionEvent(ExceptionEvent.EXCEPTION,param1.name,param1.data,param1.data.exception);
            this.dispatchEvent(_loc2_);
            if(!_loc2_.handled)
            {
               this.dispatchEvent(new ExceptionEvent(ExceptionEvent.UNHANDLED_EXCEPTION,param1.name,param1.data,param1.data.exception));
            }
         }
         else if(param1.data.hasOwnProperty(ServerUnderMaintenanceEvent.SERVER_UNDER_MAINTENANCE))
         {
            this.dispatchEvent(new ServerUnderMaintenanceEvent());
         }
         else
         {
            this.dispatchEvent(new ServiceEvent(param1.name,param1.data));
         }
         if(param1.data.hasOwnProperty("piggy_back"))
         {
            this.dispatchEvent(new ExtendedEvent(HANDLE_PIGGY_BACK,param1.data.piggy_back));
         }
      }
   }
}
