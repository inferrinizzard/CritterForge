package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ServiceEvent extends Event
   {
      
      public static const LOGIN:String = "Login";
      
      public static const GUEST_LOGIN:String = "GuestLogin";
      
      public static const LOGOUT:String = "Logout";
      
      public static const REGISTER:String = "Register";
      
      public static const RESET:String = "Reset";
      
      public static const AUTOMATIC_LOGIN:String = "gameevent_automatic_login";
       
      
      public var data:Object;
      
      public function ServiceEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
