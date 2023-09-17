package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ConnectionEvent extends Event
   {
       
      
      public var id:uint;
      
      public var name:String;
      
      public var data:Object;
      
      public var latency:uint;
      
      public function ConnectionEvent(param1:String, param2:uint, param3:String, param4:Object, param5:uint, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,param6,param7);
         this.id = param2;
         this.name = param3;
         this.data = param4;
         this.latency = param5;
      }
   }
}
