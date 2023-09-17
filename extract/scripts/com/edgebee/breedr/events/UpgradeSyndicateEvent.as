package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Syndicate;
   
   public class UpgradeSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"UpgradeSyndicateEvent",
         "cls":UpgradeSyndicateEvent
      };
       
      
      public var level_id:uint;
      
      public var syndicate:Syndicate;
      
      public function UpgradeSyndicateEvent(param1:Object = null)
      {
         this.syndicate = new Syndicate();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
