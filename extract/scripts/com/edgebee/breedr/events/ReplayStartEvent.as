package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.combat.Replay;
   
   public class ReplayStartEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ReplayStartEvent",
         "cls":ReplayStartEvent
      };
       
      
      public var replay:Replay;
      
      public function ReplayStartEvent(param1:Object = null)
      {
         this.replay = new Replay();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
