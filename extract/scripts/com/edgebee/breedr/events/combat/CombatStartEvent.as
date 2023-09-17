package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class CombatStartEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CombatStartEvent",
         "cls":CombatStartEvent
      };
       
      
      public var combat_type:uint;
      
      public var area_id:uint;
      
      public var creature1:CreatureInstance;
      
      public var creature2:CreatureInstance;
      
      public function CombatStartEvent(param1:Object = null)
      {
         this.creature1 = new CreatureInstance();
         this.creature2 = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
