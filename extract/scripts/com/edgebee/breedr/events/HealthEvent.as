package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class HealthEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"HealthEvent",
         "cls":HealthEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var health:int;
      
      public function HealthEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
