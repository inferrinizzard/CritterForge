package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   
   public class PersonalAchievement extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"PersonalAchievement",
         "cls":PersonalAchievement
      };
      
      public static const TYPE_CREDITS_SPENT:int = 1;
      
      public static const TYPE_AUCTION_SPENT:int = 2;
      
      public static const TYPE_AUCTION_SOLD:int = 3;
      
      public static const TYPE_BUILDINGS_ADV:int = 4;
      
      public static const TYPE_BUILDINGS_MAX:int = 5;
      
      public static const TYPE_SAFARI_WINS_01:int = 6;
      
      public static const TYPE_SAFARI_WINS_02:int = 7;
      
      public static const TYPE_SAFARI_WINS_03:int = 8;
      
      public static const TYPE_SAFARI_WINS_04:int = 9;
      
      public static const TYPE_SAFARI_WINS_05:int = 10;
      
      public static const TYPE_SAFARI_WINS_06:int = 11;
      
      public static const TYPE_SAFARI_WINS_07:int = 12;
      
      public static const TYPE_SAFARI_WINS_08:int = 13;
      
      public static const TYPE_SAFARI_WINS:Array = [TYPE_SAFARI_WINS_01,TYPE_SAFARI_WINS_02,TYPE_SAFARI_WINS_03,TYPE_SAFARI_WINS_04,TYPE_SAFARI_WINS_05,TYPE_SAFARI_WINS_06,TYPE_SAFARI_WINS_07,TYPE_SAFARI_WINS_08];
      
      public static const TYPE_UNCOMMON_BREEDED:int = 14;
      
      public static const TYPE_RARE_BREEDED:int = 15;
      
      public static const TYPE_LEGENDARY_BREEDED:int = 16;
      
      public static const TYPE_FEED_COUNT:int = 17;
      
      public static const TYPE_PLAY_COUNT:int = 18;
      
      public static const TYPE_NURSE_COUNT:int = 19;
      
      public static const TYPE_SYNDICATE_WINS_L2:int = 20;
      
      public static const TYPE_SYNDICATE_WINS_L3:int = 21;
      
      public static const TYPE_SYNDICATE_WINS_L4:int = 22;
      
      public static const TYPE_SYNDICATE_WINS_L5:int = 23;
      
      public static const TYPE_SYNDICATE_WINS_L6:int = 24;
      
      public static const TYPE_SYNDICATE_WINS_L7:int = 25;
      
      public static const TYPE_SYNDICATE_WINS_L8:int = 26;
      
      public static const TYPE_SYNDICATE_WINS_L9:int = 27;
      
      public static const TYPE_SYNDICATE_WINS_L10:int = 28;
      
      public static const TYPE_SYNDICATE_WINS_L11:int = 29;
      
      public static const TYPE_SYNDICATE_WINS:Object = {
         2:TYPE_SYNDICATE_WINS_L2,
         3:TYPE_SYNDICATE_WINS_L3,
         4:TYPE_SYNDICATE_WINS_L4,
         5:TYPE_SYNDICATE_WINS_L5,
         6:TYPE_SYNDICATE_WINS_L6,
         7:TYPE_SYNDICATE_WINS_L7,
         8:TYPE_SYNDICATE_WINS_L8,
         9:TYPE_SYNDICATE_WINS_L9,
         10:TYPE_SYNDICATE_WINS_L10,
         11:TYPE_SYNDICATE_WINS_L11
      };
      
      public static const TYPE_WINNING_STREAK:int = 30;
      
      public static const TYPE_LOSING_STREAK:int = 31;
      
      public static const TYPE_UNDEFEATED:int = 32;
      
      public static const TYPE_RING_EXPERIENCE:int = 33;
      
      public static const TYPE_PRIZE_FIGHTER:int = 34;
      
      public static const TYPE_EXPERIENCED:int = 35;
      
      public static const TYPE_OLD_FAMILY:int = 36;
      
      private static var FLAG_ALWAYS_SHOW:int = 1;
      
      private static var FLAG_SHOW_REWARD:int = 2;
      
      private static var FLAG_SHOW_CHILDREN:int = 4;
      
      private static var FLAG_SHOW_PROGRESS:int = 8;
       
      
      public var id:uint;
      
      public var type:int;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var image:String;
      
      public var flags:int;
      
      public var limit:Number;
      
      public var parent_id:uint;
      
      public var reward:DataReference;
      
      public function PersonalAchievement(param1:Object = null)
      {
         this.reward = new DataReference(PersonalAchievementReward.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : PersonalAchievement
      {
         if(!param1)
         {
            return null;
         }
         return StaticData.getInstance(param1,"id","PersonalAchievement") as PersonalAchievement;
      }
      
      override public function get classinfo() : Object
      {
         return PersonalAchievement.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get description() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function getDescription() : String
      {
         var _loc1_:* = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>";
         return _loc1_ + Utils.htmlWrap(Utils.capitalizeFirst(this.description.value),null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
      }
      
      public function getProgressDescription() : String
      {
         var _loc1_:* = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>{amount} / {limit}<br>";
         return _loc1_ + Utils.htmlWrap(Utils.capitalizeFirst(this.description.value),null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
      }
      
      public function get parent() : PersonalAchievement
      {
         if(this.parent_id)
         {
            return getInstanceById(this.parent_id);
         }
         return null;
      }
      
      public function get alwaysShow() : Boolean
      {
         return (this.flags & FLAG_ALWAYS_SHOW) != 0;
      }
      
      public function get showReward() : Boolean
      {
         return (this.flags & FLAG_SHOW_REWARD) != 0;
      }
      
      public function get showChildren() : Boolean
      {
         return (this.flags & FLAG_SHOW_CHILDREN) != 0;
      }
      
      public function get showProgress() : Boolean
      {
         return (this.flags & FLAG_SHOW_PROGRESS) != 0;
      }
   }
}
