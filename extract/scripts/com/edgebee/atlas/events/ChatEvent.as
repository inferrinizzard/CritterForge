package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      
      public static const CONNECTING:String = "CONNECTING";
      
      public static const CONNECT:String = "CONNECT";
      
      public static const DISCONNECT:String = "DISCONNECT";
      
      public static const ABORT:String = "ABORT";
      
      public static const RECONNECT:String = "RECONNECT";
      
      public static const AUTHORIZATION_REQUIRED:String = "AUTHORIZATION_REQUIRED";
      
      public static const AUTHORIZED:String = "AUTHORIZED";
      
      public static const NOTICE:String = "NOTICE";
      
      public static const MESSAGE:String = "MESSAGE";
      
      public static const WHISPER:String = "WHISPER";
      
      public static const JOIN_CHANNEL:String = "JOIN_CHANNEL";
      
      public static const LEAVE_CHANNEL:String = "LEAVE_CHANNEL";
      
      public static const CHANNEL_MEMBERS:String = "CHANNEL_MEMBERS";
      
      public static const ERROR:String = "ERROR";
       
      
      private var _data:Object;
      
      public function ChatEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
