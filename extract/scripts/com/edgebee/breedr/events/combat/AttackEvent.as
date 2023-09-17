package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class AttackEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"AttackEvent",
         "cls":AttackEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var blocked:Boolean;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      public var chances:Number;
      
      public function AttackEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
