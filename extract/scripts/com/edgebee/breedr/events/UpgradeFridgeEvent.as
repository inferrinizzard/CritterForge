package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class UpgradeFridgeEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"UpgradeFridgeEvent",
         "cls":UpgradeFridgeEvent
      };
       
      
      public var level_id:uint;
      
      public function UpgradeFridgeEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
