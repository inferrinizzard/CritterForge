package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ServerUnderMaintenanceEvent extends Event
   {
      
      public static const SERVER_UNDER_MAINTENANCE:String = "serverUnderMaintenance";
       
      
      public function ServerUnderMaintenanceEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super(SERVER_UNDER_MAINTENANCE,param1,param2);
      }
   }
}
