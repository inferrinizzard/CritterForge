package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ExtendedEvent extends Event
   {
       
      
      public var data:Object;
      
      public function ExtendedEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
