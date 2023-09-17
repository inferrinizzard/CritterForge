package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class MoveCreatureToStallEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"MoveCreatureToStallEvent",
         "cls":MoveCreatureToStallEvent
      };
       
      
      public var stall_id:uint;
      
      public var creature_id:uint;
      
      public function MoveCreatureToStallEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
