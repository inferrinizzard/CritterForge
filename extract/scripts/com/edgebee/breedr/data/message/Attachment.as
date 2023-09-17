package com.edgebee.breedr.data.message
{
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.data.messaging.Attachment;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.ladder.ChallengeResults;
   
   public class Attachment extends com.edgebee.atlas.data.messaging.Attachment
   {
      
      public static const STATE_EXECUTED:int = 1;
      
      public static const TYPE_REPLAY:int = 1;
      
      public static const TYPE_CREDITS:int = 2;
      
      public static const TYPE_ITEM:int = 3;
      
      public static const TYPE_INVITATION:int = 4;
      
      public static const TYPE_CHALLENGE_RESULTS:int = 5;
      
      public static const TYPE_CREATURE:int = 6;
      
      private static const _classinfo:Object = {
         "name":"Attachment",
         "cls":com.edgebee.breedr.data.message.Attachment
      };
       
      
      public var credits:uint;
      
      public var invitation_id:uint;
      
      public var challenge_results:DataReference;
      
      public var item_id:uint;
      
      public var creature:CreatureInstance;
      
      public function Attachment(param1:Object = null)
      {
         this.challenge_results = new DataReference(ChallengeResults.classinfo);
         this.creature = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get item() : Item
      {
         return Item.getInstanceById(this.item_id);
      }
      
      public function get isReplay() : Boolean
      {
         return type == TYPE_REPLAY;
      }
      
      public function get isCredits() : Boolean
      {
         return type == TYPE_CREDITS;
      }
      
      public function get isItem() : Boolean
      {
         return type == TYPE_ITEM;
      }
      
      public function get isInvitation() : Boolean
      {
         return type == TYPE_INVITATION;
      }
      
      public function get isChallengeResults() : Boolean
      {
         return type == TYPE_CHALLENGE_RESULTS;
      }
      
      public function get isCreature() : Boolean
      {
         return type == TYPE_CREATURE;
      }
      
      override public function get canDelete() : Boolean
      {
         return this.isReplay || this.isInvitation || this.isChallengeResults || isExecuted || token_cost > 0;
      }
   }
}
