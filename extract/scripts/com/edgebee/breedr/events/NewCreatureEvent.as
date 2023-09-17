package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class NewCreatureEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"NewCreatureEvent",
         "cls":NewCreatureEvent
      };
       
      
      public var creature_instance:CreatureInstance;
      
      public var stall_id:int;
      
      public function NewCreatureEvent(param1:Object = null)
      {
         this.creature_instance = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
