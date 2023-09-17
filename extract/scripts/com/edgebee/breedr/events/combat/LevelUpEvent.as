package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.skill.TraitInstance;
   
   public class LevelUpEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"LevelUpEvent",
         "cls":LevelUpEvent
      };
      
      public static const MAX_TRAIT_CHOICES:int = 3;
       
      
      public var creature_instance_id:uint;
      
      public var skill_points:int;
      
      public var level:int;
      
      public var trait_choices:DataArray;
      
      public function LevelUpEvent(param1:Object = null)
      {
         this.trait_choices = new DataArray(TraitInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
