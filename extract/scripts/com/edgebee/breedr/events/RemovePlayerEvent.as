package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Log;
   
   public class RemovePlayerEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RemovePlayerEvent",
         "cls":RemovePlayerEvent
      };
       
      
      public var player_id:uint;
      
      public var log:Log;
      
      public function RemovePlayerEvent(param1:Object = null)
      {
         this.log = new Log();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
