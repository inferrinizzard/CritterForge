package com.edgebee.atlas.events
{
   import com.edgebee.atlas.data.Exception;
   import flash.events.Event;
   
   public class ExceptionEvent extends Event
   {
      
      public static const UNHANDLED_EXCEPTION:String = "unhandled_exception";
      
      public static const EXCEPTION:String = "exception";
       
      
      public var data:Object;
      
      public var exception:Exception;
      
      public var handled:Boolean;
      
      public var method:String;
      
      public function ExceptionEvent(param1:String, param2:String, param3:Object, param4:Object = null, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.handled = false;
         this.data = param3;
         this.method = param2;
         this.exception = new Exception(param4);
      }
   }
}
