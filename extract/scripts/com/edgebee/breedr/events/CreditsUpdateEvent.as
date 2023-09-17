package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class CreditsUpdateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreditsUpdateEvent",
         "cls":CreditsUpdateEvent
      };
       
      
      public var credits:Number;
      
      public function CreditsUpdateEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
