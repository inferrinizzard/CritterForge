package com.edgebee.atlas.managers
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.events.ChatEvent;
   import com.edgebee.atlas.util.DelayedCallback;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.system.Capabilities;
   import flash.system.Security;
   
   public class ChatManager extends EventDispatcher
   {
      
      private static const AUTHORIZATION_REQUIRED:String = MD5.hash("AUTHORIZATION_REQUIRED");
      
      private static const AUTHORIZED:String = MD5.hash("AUTHORIZED");
      
      private static const NOTICE:String = MD5.hash("NOTICE");
      
      private static const MESSAGE:String = MD5.hash("MESSAGE");
      
      private static const JOIN:String = MD5.hash("JOIN");
      
      private static const LEAVE:String = MD5.hash("LEAVE");
      
      private static const CHANNEL:String = MD5.hash("CHANNEL");
      
      private static const WHISPER:String = MD5.hash("WHISPER");
      
      private static const INITIALIZE:String = MD5.hash("INITIALIZE");
      
      private static const CHANNEL_SUSTAIN:String = MD5.hash("CHANNEL_SUSTAIN");
      
      private static const CHANNEL_CREATE:String = MD5.hash("CHANNEL_CREATE");
       
      
      private var _socket:Socket;
      
      private var _host:String = "localhost";
      
      private var _port:uint = 3001;
      
      private var _client:Client;
      
      private var _username:String;
      
      private var _password:String;
      
      private var _buffer:String;
      
      private var _connecting:Boolean = false;
      
      private var _autoReconnect:Boolean = true;
      
      private var _numReconnectAttempts:uint = 0;
      
      private const MAX_RECONNECT:uint = 10;
      
      private var _reconnectCallback:DelayedCallback;
      
      public function ChatManager(param1:Client)
      {
         super();
         this._client = param1;
         this._socket = new Socket();
         this.socket.addEventListener(Event.CONNECT,this.onConnect);
         this.socket.addEventListener(Event.CLOSE,this.onClose);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onData);
      }
      
      public function get client() : Client
      {
         return this._client;
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function get connected() : Boolean
      {
         return this._socket.connected;
      }
      
      public function get autoReconnect() : Boolean
      {
         return this._autoReconnect;
      }
      
      public function set autoReconnect(param1:Boolean) : void
      {
         this._autoReconnect = param1;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function set host(param1:String) : void
      {
         this._host = param1;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function set port(param1:uint) : void
      {
         this._port = param1;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function connect(param1:Boolean = false) : void
      {
         if(this._connecting && !param1)
         {
            return;
         }
         if(this.socket.connected)
         {
            return;
         }
         this._connecting = true;
         this._reconnectCallback = null;
         if(this._numReconnectAttempts > this.MAX_RECONNECT)
         {
            dispatchEvent(new ChatEvent(ChatEvent.ABORT));
         }
         else
         {
            Security.loadPolicyFile("xmlsocket://" + this.host + ":" + this.port.toString());
            this.socket.connect(this.host,this.port);
            dispatchEvent(new ChatEvent(ChatEvent.CONNECTING));
         }
         ++this._numReconnectAttempts;
      }
      
      public function reconnect() : void
      {
         this.connect(true);
      }
      
      public function initialize() : void
      {
         this.socket.writeUTFBytes(MD5.hash("INITIALIZE") + "\r\n");
         this.socket.flush();
      }
      
      public function sendMessage(param1:String, param2:String) : void
      {
         param2 = param2.replace(/</g,"&lt;");
         param2 = param2.replace(/>/g,"&gt;");
         this.socket.writeUTFBytes(MD5.hash("MESSAGE") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "message":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function sendWhisper(param1:String, param2:String) : void
      {
         param2 = param2.replace(/</g,"&lt;");
         param2 = param2.replace(/>/g,"&gt;");
         this.socket.writeUTFBytes(MD5.hash("WHISPER") + " " + com.adobe.serialization.json.JSON.encode({
            "target":param1,
            "message":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function sendAuth(param1:String, param2:String, param3:String = null) : void
      {
         this.socket.writeUTFBytes(MD5.hash("AUTHORIZATION") + " " + com.adobe.serialization.json.JSON.encode({
            "username":param1,
            "password":param2,
            "foreign_type":param3,
            "gamename":this.client.name,
            "os":Capabilities.os,
            "playerType":Capabilities.playerType,
            "version":Capabilities.version,
            "bo":this.socket.endian
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function getStatus(param1:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("STATUS") + " " + com.adobe.serialization.json.JSON.encode({"channel":param1}) + "\r\n");
         this.socket.flush();
      }
      
      public function getHelp() : void
      {
         this.socket.writeUTFBytes(MD5.hash("HELP") + "\r\n");
         this.socket.flush();
      }
      
      public function joinChannel(param1:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("JOIN") + " " + com.adobe.serialization.json.JSON.encode({"channel":param1}) + "\r\n");
         this.socket.flush();
      }
      
      public function createChannel(param1:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("CREATE_CHANNEL") + " " + com.adobe.serialization.json.JSON.encode({"channel":param1}) + "\r\n");
         this.socket.flush();
      }
      
      public function sustainChannel(param1:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("SUSTAIN_CHANNEL") + " " + com.adobe.serialization.json.JSON.encode({"channel":param1}) + "\r\n");
         this.socket.flush();
      }
      
      public function leaveChannel(param1:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("LEAVE") + " " + com.adobe.serialization.json.JSON.encode({"channel":param1}) + "\r\n");
         this.socket.flush();
      }
      
      public function kick(param1:String, param2:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("KICK") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "user":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function addModerator(param1:String, param2:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("ADD_MODERATOR") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "user":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function removeModerator(param1:String, param2:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("REMOVE_MODERATOR") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "user":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function addBan(param1:String, param2:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("ADD_BAN") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "user":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function removeBan(param1:String, param2:String) : void
      {
         this.socket.writeUTFBytes(MD5.hash("REMOVE_BAN") + " " + com.adobe.serialization.json.JSON.encode({
            "channel":param1,
            "user":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      public function mute(param1:String, param2:uint) : void
      {
         this.socket.writeUTFBytes(MD5.hash("MUTE") + " " + com.adobe.serialization.json.JSON.encode({
            "user":param1,
            "minutes":param2
         }) + "\r\n");
         this.socket.flush();
      }
      
      private function handleData() : void
      {
         var line:String = null;
         var cmd:String = null;
         var params:Object = null;
         var split:int = 0;
         var lines:Array = this._buffer.split("\r\n");
         for each(line in lines)
         {
            split = line.indexOf(" ");
            if(split >= 0)
            {
               cmd = line.slice(0,split);
               try
               {
                  params = com.adobe.serialization.json.JSON.decode(line.slice(split + 1));
               }
               catch(e:Error)
               {
                  dispatchEvent(new ChatEvent(ChatEvent.ERROR,"Error while decoding incoming data " + line));
                  return;
               }
            }
            else
            {
               cmd = line;
               params = {};
            }
            switch(cmd)
            {
               case AUTHORIZATION_REQUIRED:
                  dispatchEvent(new ChatEvent(ChatEvent.AUTHORIZATION_REQUIRED));
                  break;
               case AUTHORIZED:
                  dispatchEvent(new ChatEvent(ChatEvent.AUTHORIZED));
                  break;
               case NOTICE:
                  dispatchEvent(new ChatEvent(ChatEvent.NOTICE,params));
                  break;
               case MESSAGE:
                  dispatchEvent(new ChatEvent(ChatEvent.MESSAGE,params));
                  break;
               case WHISPER:
                  dispatchEvent(new ChatEvent(ChatEvent.WHISPER,params));
                  break;
               case JOIN:
                  dispatchEvent(new ChatEvent(ChatEvent.JOIN_CHANNEL,params));
                  break;
               case LEAVE:
                  dispatchEvent(new ChatEvent(ChatEvent.LEAVE_CHANNEL,params));
                  break;
               case CHANNEL:
                  dispatchEvent(new ChatEvent(ChatEvent.CHANNEL_MEMBERS,params));
                  break;
               case CHANNEL_SUSTAIN:
                  this.client.user.tokens -= 5;
                  break;
               case CHANNEL_CREATE:
                  this.client.user.tokens -= 25;
                  break;
               default:
                  dispatchEvent(new ChatEvent(ChatEvent.ERROR,"Unknown server command " + cmd));
                  break;
            }
         }
      }
      
      private function onConnect(param1:Event) : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT));
         this.initialize();
      }
      
      private function onClose(param1:Event) : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.DISCONNECT));
         if(this.autoReconnect && !this._reconnectCallback)
         {
            this._reconnectCallback = new DelayedCallback(5000,this.reconnect);
            this._reconnectCallback.touch();
            dispatchEvent(new ChatEvent(ChatEvent.RECONNECT,5000));
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.ERROR,param1));
         if(this.autoReconnect && !this._reconnectCallback)
         {
            this._reconnectCallback = new DelayedCallback(5000,this.reconnect);
            this._reconnectCallback.touch();
            dispatchEvent(new ChatEvent(ChatEvent.RECONNECT,5000));
         }
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.ERROR,param1));
         if(this.autoReconnect && !this._reconnectCallback)
         {
            this._reconnectCallback = new DelayedCallback(5000,this.reconnect);
            this._reconnectCallback.touch();
            dispatchEvent(new ChatEvent(ChatEvent.RECONNECT,5000));
         }
      }
      
      private function onData(param1:ProgressEvent) : void
      {
         if(this._buffer == null)
         {
            this._buffer = "";
         }
         this._buffer += this.socket.readUTFBytes(param1.bytesLoaded);
         if(this._buffer.search(/\r?\n$/) != -1)
         {
            this._buffer = Utils.trim(this._buffer);
            this.handleData();
            this._buffer = null;
         }
      }
   }
}
