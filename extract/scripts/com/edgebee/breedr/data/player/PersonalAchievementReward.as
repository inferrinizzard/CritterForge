package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.item.Item;
   
   public class PersonalAchievementReward extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"PersonalAchievementReward",
         "cls":PersonalAchievementReward
      };
       
      
      public var id:uint;
      
      public var is_item:Boolean;
      
      public var is_credits:Boolean;
      
      public var item_id:uint;
      
      public var credits:uint;
      
      public function PersonalAchievementReward(param1:Object = null)
      {
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
   }
}
