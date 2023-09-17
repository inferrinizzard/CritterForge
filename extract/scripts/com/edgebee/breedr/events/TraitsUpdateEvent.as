package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.skill.TraitInstance;
   
   public class TraitsUpdateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"TraitsUpdateEvent",
         "cls":TraitsUpdateEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var skill_points:uint;
      
      public var traits:DataArray;
      
      public var is_stealth:Boolean;
      
      public var seed_count:uint;
      
      public var max_stamina_id:uint;
      
      public var stamina_id:uint;
      
      public function TraitsUpdateEvent(param1:Object = null)
      {
         this.traits = new DataArray(TraitInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
