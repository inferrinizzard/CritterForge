package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class SafariStopEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SafariStopEvent",
         "cls":SafariStopEvent
      };
       
      
      public var destination_id:uint;
      
      public function SafariStopEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
