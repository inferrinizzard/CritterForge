package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class ExtractSeedEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ExtractSeedEvent",
         "cls":ExtractSeedEvent
      };
       
      
      public var item_id:uint;
      
      public var success:Boolean;
      
      public var creature:CreatureInstance;
      
      public var source_creature_id:uint;
      
      public var source_creature_is_sterile:Boolean;
      
      public function ExtractSeedEvent(param1:Object = null)
      {
         this.creature = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
