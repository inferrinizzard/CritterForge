package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class DeactivateTeamEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"DeactivateTeamEvent",
         "cls":DeactivateTeamEvent
      };
       
      
      public var team_id:uint;
      
      public var disbanded_until:Number;
      
      public function DeactivateTeamEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
