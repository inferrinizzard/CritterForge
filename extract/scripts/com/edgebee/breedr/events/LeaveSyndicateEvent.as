package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class LeaveSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"LeaveSyndicateEvent",
         "cls":LeaveSyndicateEvent
      };
       
      
      public function LeaveSyndicateEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
