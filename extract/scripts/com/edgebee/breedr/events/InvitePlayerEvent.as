package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Log;
   
   public class InvitePlayerEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"InvitePlayerEvent",
         "cls":InvitePlayerEvent
      };
       
      
      public var log:Log;
      
      public function InvitePlayerEvent(param1:Object = null)
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
