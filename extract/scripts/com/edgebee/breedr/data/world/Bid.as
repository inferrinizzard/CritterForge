package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.l10n.*;
   
   public class Bid extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Bid",
         "cls":Bid
      };
       
      
      public var id:uint;
      
      public var amount:Number;
      
      public var date:Date;
      
      public var player:Player;
      
      public function Bid(param1:Object = null)
      {
         this.player = new Player();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.amount = this.amount;
         param1.date = this.date;
         this.player.copyTo(param1.player);
      }
   }
}
