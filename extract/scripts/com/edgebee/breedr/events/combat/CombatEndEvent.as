package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class CombatEndEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CombatEndEvent",
         "cls":CombatEndEvent
      };
       
      
      public var winner_id:int;
      
      public function CombatEndEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
