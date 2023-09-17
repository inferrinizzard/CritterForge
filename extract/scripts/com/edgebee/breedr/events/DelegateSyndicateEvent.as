package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.Syndicate;
   
   public class DelegateSyndicateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"DelegateSyndicateEvent",
         "cls":DelegateSyndicateEvent
      };
       
      
      public var syndicate:Syndicate;
      
      public function DelegateSyndicateEvent(param1:Object = null)
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
