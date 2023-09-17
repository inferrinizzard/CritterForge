package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class StaminaEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"StaminaEvent",
         "cls":StaminaEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var stamina_id:int;
      
      public var sleep_time_left:uint;
      
      public function StaminaEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
