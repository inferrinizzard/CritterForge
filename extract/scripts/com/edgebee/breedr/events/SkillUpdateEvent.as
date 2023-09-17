package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.skill.SkillInstance;
   
   public class SkillUpdateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SkillUpdateEvent",
         "cls":SkillUpdateEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var level:int;
      
      public var skill_points:int;
      
      public var skills:DataArray;
      
      public var stealth:Boolean;
      
      public function SkillUpdateEvent(param1:Object = null)
      {
         this.skills = new DataArray(SkillInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
