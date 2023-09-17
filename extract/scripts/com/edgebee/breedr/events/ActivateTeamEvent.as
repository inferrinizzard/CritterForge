package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class ActivateTeamEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ActivateTeamEvent",
         "cls":ActivateTeamEvent
      };
       
      
      public var team_id:uint;
      
      public var position:Number;
      
      public function ActivateTeamEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
