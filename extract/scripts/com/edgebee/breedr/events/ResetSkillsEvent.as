package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.skill.SkillInstance;
   
   public class ResetSkillsEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ResetSkillsEvent",
         "cls":ResetSkillsEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var skills:DataArray;
      
      public var skill_points:uint;
      
      public var effect_pieces:Array;
      
      public var modifier_pieces:Array;
      
      public var respec_count:uint;
      
      public var respec_expiration:uint;
      
      public function ResetSkillsEvent(param1:Object = null)
      {
         this.skills = new DataArray(SkillInstance.classinfo);
         this.effect_pieces = [];
         this.modifier_pieces = [];
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
