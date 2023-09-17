package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class HappinessEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"HappinessEvent",
         "cls":HappinessEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var happiness:int;
      
      public function HappinessEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
