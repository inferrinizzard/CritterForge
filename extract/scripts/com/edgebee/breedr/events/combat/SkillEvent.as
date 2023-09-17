package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class SkillEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SkillEvent",
         "cls":SkillEvent
      };
       
      
      public var skill_id:uint;
      
      public var user_id:uint;
      
      public var lucky:Boolean;
      
      public var countered:Boolean;
      
      public var index:int;
      
      public var creature_pp:uint;
      
      public var chances:Number;
      
      public function SkillEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
