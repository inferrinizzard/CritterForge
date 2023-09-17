package com.edgebee.atlas.net
{
   import com.adobe.serialization.json.JSON;
   import com.edgebee.atlas.events.*;
   import com.edgebee.atlas.util.Timer;
   import flash.events.*;
   import flash.net.*;
   
   public class ServerConnection extends URLLoader
   {
      
      public static const STATE_CHANGED:String = "STATE_CHANGED";
      
      public static const RECEPTION_COMPLETE:String = "RECEPTION_COMPLETE";
      
      public static const TRANSPARENCY_TIMEOUT:String = "TRANSPARENCY_TIMEOUT";
      
      public static const CONNECTION_TIMEOUT:String = "CONNECTION_TIMEOUT";
      
      public static const STATE_DISCONNECTED:String = "STATE_DISCONNECTED";
      
      public static const STATE_AWAITING_CONNECTION:String = "STATE_AWAITING_CONNECTION";
      
      public static const STATE_CONNECTED:String = "STATE_CONNECTED";
      
      public static const STATE_COMPLETED:String = "STATE_COMPLETED";
      
      public static const STATE_TRANSFERING:String = "STATE_TRANSFERING";
      
      public static const STATE_ERROR:String = "STATE_ERROR";
       
      
      private var _url:String = null;
      
      private var _data:Object = null;
      
      private var _retryDelay:uint;
      
      private var _transparencyTimeout:uint;
      
      private var _maximumRetries:uint;
      
      private var _numRetries:int;
      
      private var _transTimer:Timer;
      
      private var _retryTimer:Timer;
      
      private var _resetTimer:Timer;
      
      private var _timeSent:uint = 0;
      
      private var _timeReceived:uint = 0;
      
      private var _savedBytesLoaded:uint = 0;
      
      private var _savedBytesTotal:uint = 0;
      
      private var _state:String = "STATE_DISCONNECTED";
      
      private var _isVisible:Boolean = false;
      
      private var _lastRequest:Object;
      
      public function ServerConnection(param1:URLRequest = null, param2:uint = 3000, param3:uint = 60000, param4:uint = 2)
      {
         super(param1);
         this._transparencyTimeout = param2;
         this._retryDelay = param3;
         this._maximumRetries = param4;
         this.addEventListener(Event.COMPLETE,this.__completeHandler);
         this.addEventListener(Event.OPEN,this.__openHandler);
         this.addEventListener(ProgressEvent.PROGRESS,this.__progressHandler);
         this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.__securityErrorHandler);
         this.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.__httpStatusHandler);
         this.addEventListener(IOErrorEvent.IO_ERROR,this.__ioErrorHandler);
         this._resetTimer = new Timer(500,1);
         this._resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onResetTimer);
         this._transTimer = new Timer(this._transparencyTimeout,1);
         this._transTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTransparencyTimeout);
         this._retryTimer = new Timer(this._retryDelay,1);
         this._retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimeout);
      }
      
      public function get busy() : Boolean
      {
         return this._state != STATE_DISCONNECTED;
      }
      
      public function get savedBytesLoaded() : uint
      {
         return this._savedBytesLoaded;
      }
      
      public function get savedBytesTotal() : uint
      {
         return this._savedBytesTotal;
      }
      
      public function get timeSent() : uint
      {
         return this._timeSent;
      }
      
      public function get timeReceived() : uint
      {
         return this._timeReceived;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get isVisible() : Boolean
      {
         return this._isVisible;
      }
      
      public function get sentData() : Object
      {
         return this._data;
      }
      
      public function get retries() : int
      {
         return this._maximumRetries - this._numRetries;
      }
      
      public function reset() : void
      {
         try
         {
            close();
         }
         catch(e:Error)
         {
            if(e.errorID != 2029)
            {
               throw e;
            }
         }
         this._url = null;
         this._data = null;
         this._transTimer.delay = this._transparencyTimeout;
         this._transTimer.reset();
         this._transTimer.stop();
         this._retryTimer.delay = this._retryDelay;
         this._retryTimer.reset();
         this._retryTimer.stop();
         this._numRetries = this._maximumRetries;
         this._timeReceived = 0;
         this._isVisible = false;
         this.state = STATE_DISCONNECTED;
      }
      
      public function send(param1:String, param2:Object, param3:String = "POST", param4:URLVariables = null) : void
      {
         var request:URLRequest;
         var url:String = param1;
         var data:Object = param2;
         var method:String = param3;
         var variables:URLVariables = param4;
         this._url = url;
         this._data = data;
         this._data.time = new Date().time;
         this._lastRequest = {
            "method":method,
            "variables":variables
         };
         if(!variables)
         {
            variables = new URLVariables();
            variables.input = com.adobe.serialization.json.JSON.encode(this._data);
         }
         request = new URLRequest(this._url);
         request.data = variables;
         request.method = method;
         this.state = STATE_AWAITING_CONNECTION;
         try
         {
            if(!this._isVisible)
            {
               this._transTimer.start();
            }
            this._retryTimer.reset();
            this._retryTimer.start();
            this._timeSent = new Date().time;
            this._timeReceived = 0;
            load(request);
         }
         catch(err:Error)
         {
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set state(param1:String) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            dispatchEvent(new Event(STATE_CHANGED));
         }
      }
      
      private function __completeHandler(param1:Event) : void
      {
         var latency:uint;
         var ev:ConnectionEvent;
         var answer:Object = null;
         var delta:Number = NaN;
         var event:Event = param1;
         try
         {
            delta = new Date().time;
            answer = com.adobe.serialization.json.JSON.decode(data,true);
            delta = new Date().time - delta;
         }
         catch(e:Error)
         {
            throw new Error("Error encountered while decoding JSON (" + e.message + "): " + (data as String).substr(0,200));
         }
         if(answer.hasOwnProperty("result") && answer.result.hasOwnProperty("exception") && answer.result.exception.cls == "ActionInProgress")
         {
            this._retryTimer.reset();
            this._retryTimer.start();
            return;
         }
         this._transTimer.reset();
         this._retryTimer.reset();
         this.state = STATE_COMPLETED;
         this._timeReceived = new Date().time;
         latency = uint(this._timeReceived - this._timeSent);
         ev = new ConnectionEvent(RECEPTION_COMPLETE,answer.hasOwnProperty("id") ? uint(answer.id) : 0,this._data.method,answer.result,latency);
         dispatchEvent(ev);
         this._resetTimer.reset();
         this._resetTimer.start();
      }
      
      private function onTransparencyTimeout(param1:TimerEvent) : void
      {
         this._transTimer.reset();
         this._isVisible = true;
         dispatchEvent(new Event(TRANSPARENCY_TIMEOUT));
      }
      
      private function resend() : void
      {
         try
         {
            close();
         }
         catch(e:Error)
         {
            if(e.errorID != 2029)
            {
               throw e;
            }
         }
         this._data.retries = Math.abs(this._numRetries - this._maximumRetries);
         this.send(this._url,this._data,this._lastRequest.method,this._lastRequest.variables);
      }
      
      private function onRetryTimeout(param1:TimerEvent) : void
      {
         --this._numRetries;
         if(this._numRetries > 0)
         {
            this.resend();
         }
         else
         {
            dispatchEvent(new Event(CONNECTION_TIMEOUT));
            this.state = STATE_ERROR;
            this._resetTimer.reset();
            this._resetTimer.start();
         }
      }
      
      private function onResetTimer(param1:TimerEvent) : void
      {
         this.reset();
      }
      
      private function __openHandler(param1:Event) : void
      {
         if(!this._isVisible)
         {
            this._transTimer.reset();
            this._transTimer.start();
         }
         this._retryTimer.reset();
         this._retryTimer.start();
         this.state = STATE_CONNECTED;
      }
      
      private function __progressHandler(param1:ProgressEvent) : void
      {
         if(!this._isVisible)
         {
            this._transTimer.reset();
            this._transTimer.start();
         }
         this._retryTimer.reset();
         this._retryTimer.start();
         this._savedBytesLoaded = param1.bytesLoaded;
         this._savedBytesTotal = param1.bytesTotal;
         this.state = STATE_TRANSFERING;
      }
      
      private function __httpStatusHandler(param1:HTTPStatusEvent) : void
      {
      }
      
      private function __securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this._transTimer.stop();
         this._retryTimer.stop();
         this.state = STATE_ERROR;
         throw Error("ServerConnection:: The url \'" + this._url + "\' could not be accessed because of player security " + param1.toString());
      }
      
      private function __ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.state = STATE_ERROR;
      }
   }
}
