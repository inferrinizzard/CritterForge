package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class ChangeRightsSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ChangeRightsSyndicateEvent",
         "cls":ChangeRightsSyndicateEvent
      };
       
      
      public var player_id:uint;
      
      public var syndicate_flags:int;
      
      public function ChangeRightsSyndicateEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
