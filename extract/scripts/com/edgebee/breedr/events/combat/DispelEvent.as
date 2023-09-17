package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class DispelEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"DispelEvent",
         "cls":DispelEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      public function DispelEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
