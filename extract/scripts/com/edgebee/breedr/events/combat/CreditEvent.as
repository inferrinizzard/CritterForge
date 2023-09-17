package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.Player;
   
   public class CreditEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreditEvent",
         "cls":CreditEvent
      };
       
      
      public var creature1_credits:uint;
      
      public var creature2_credits:uint;
      
      public var creature_instance1_id:uint;
      
      public var creature_instance2_id:uint;
      
      public var owner1:Player;
      
      public var owner2:Player;
      
      public function CreditEvent(param1:Object = null)
      {
         this.owner1 = new Player();
         this.owner2 = new Player();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
