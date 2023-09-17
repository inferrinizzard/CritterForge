package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class SafariSlotRevealEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SafariSlotRevealEvent",
         "cls":SafariSlotRevealEvent
      };
       
      
      public var index:int;
      
      public var flags:Number;
      
      public var data:int;
      
      public function SafariSlotRevealEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
