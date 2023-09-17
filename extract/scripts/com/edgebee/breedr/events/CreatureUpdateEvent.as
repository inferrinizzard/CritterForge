package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class CreatureUpdateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreatureUpdateEvent",
         "cls":CreatureUpdateEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var stamina_id:uint;
      
      public var seed_count:uint;
      
      public var is_sterile:Boolean;
      
      public var feeder_quantity:uint;
      
      public function CreatureUpdateEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
