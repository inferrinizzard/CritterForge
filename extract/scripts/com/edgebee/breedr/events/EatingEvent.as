package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class EatingEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"EatingEvent",
         "cls":EatingEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var feeder_quantity:uint;
      
      public function EatingEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
