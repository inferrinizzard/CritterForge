package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ActionDispatcherEvent extends Event
   {
      
      public static const PROCESSING_START:String = "PROCESSING_START";
      
      public static const PROCESSING_STOP:String = "PROCESSING_STOP";
      
      public static const PROCESS_ACTION:String = "PROCESS_ACTION";
       
      
      public var manager:Object;
      
      public var action:Object;
      
      public function ActionDispatcherEvent(param1:String, param2:Object, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         this.manager = param2;
         this.action = param3;
         super(param1,param4,param5);
      }
   }
}
