package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class UpgradeRanchEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"UpgradeRanchEvent",
         "cls":UpgradeRanchEvent
      };
       
      
      public var level_id:uint;
      
      public function UpgradeRanchEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
