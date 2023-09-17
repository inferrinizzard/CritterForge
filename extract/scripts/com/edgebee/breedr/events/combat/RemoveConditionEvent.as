package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class RemoveConditionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RemoveConditionEvent",
         "cls":RemoveConditionEvent
      };
      
      public static var REASON_EXPIRED:uint = 1;
      
      public static var REASON_DISPELED:uint = 2;
      
      public static var REASON_HIT:uint = 3;
       
      
      public var creature_instance_id:int;
      
      public var condition_id:int;
      
      public var reason:int;
      
      public function RemoveConditionEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
