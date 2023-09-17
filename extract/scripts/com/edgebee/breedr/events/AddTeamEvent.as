package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class AddTeamEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"AddTeamEvent",
         "cls":AddTeamEvent
      };
       
      
      public var team_id:uint;
      
      public var creature_id:uint;
      
      public var cant_add_until:Number;
      
      public function AddTeamEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
