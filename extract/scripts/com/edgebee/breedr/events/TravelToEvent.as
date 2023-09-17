package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class TravelToEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"TravelToEvent",
         "cls":TravelToEvent
      };
       
      
      public var destination_id:uint;
      
      public var instant:Boolean;
      
      public var is_stealth:Boolean;
      
      public function TravelToEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
