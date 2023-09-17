package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Syndicate;
   
   public class CreateSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreateSyndicateEvent",
         "cls":CreateSyndicateEvent
      };
       
      
      public var syndicate:Syndicate;
      
      public function CreateSyndicateEvent(param1:Object = null)
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
