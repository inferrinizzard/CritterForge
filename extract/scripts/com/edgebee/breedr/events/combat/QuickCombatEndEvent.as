package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class QuickCombatEndEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"QuickCombatEndEvent",
         "cls":QuickCombatEndEvent
      };
       
      
      public function QuickCombatEndEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
