package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class FailedSkillEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"FailedSkillEvent",
         "cls":FailedSkillEvent
      };
      
      public static const REASON_NOT_ENOUGH_PP:uint = 1;
      
      public static const REASON_CANNOT_COUNTER:uint = 2;
      
      public static const REASON_NEEDS_MOVEMENT:uint = 3;
      
      public static const REASON_NEEDS_THINKING:uint = 4;
       
      
      public var skill_id:uint;
      
      public var user_id:uint;
      
      public var reason:uint;
      
      public var index:int;
      
      public var creature_pp:uint;
      
      public function FailedSkillEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
