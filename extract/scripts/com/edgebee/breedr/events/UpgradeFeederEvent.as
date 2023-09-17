package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class UpgradeFeederEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"UpgradeFeederEvent",
         "cls":UpgradeFeederEvent
      };
       
      
      public var stall_id:uint;
      
      public var level_id:uint;
      
      public function UpgradeFeederEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
