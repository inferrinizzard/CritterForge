package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class RemoveTeamEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RemoveTeamEvent",
         "cls":RemoveTeamEvent
      };
       
      
      public var team_id:uint;
      
      public var creature_id:uint;
      
      public function RemoveTeamEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
