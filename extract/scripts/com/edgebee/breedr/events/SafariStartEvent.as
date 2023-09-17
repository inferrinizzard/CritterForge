package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class SafariStartEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SafariStartEvent",
         "cls":SafariStartEvent
      };
       
      
      public var creature_id:uint;
      
      public var destination_id:uint;
      
      public function SafariStartEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
