package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class MissEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"MissEvent",
         "cls":MissEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var blocked:Boolean;
      
      public var on_self:Boolean;
      
      public function MissEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
