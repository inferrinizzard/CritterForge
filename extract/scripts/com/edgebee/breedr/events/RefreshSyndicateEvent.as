package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Syndicate;
   
   public class RefreshSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RefreshSyndicateEvent",
         "cls":RefreshSyndicateEvent
      };
       
      
      public var syndicate:Syndicate;
      
      public var stealth:Boolean;
      
      public function RefreshSyndicateEvent(param1:Object = null)
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
