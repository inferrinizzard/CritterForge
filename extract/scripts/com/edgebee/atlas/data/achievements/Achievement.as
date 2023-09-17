package com.edgebee.atlas.data.achievements
{
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class Achievement extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Achievement",
         "cls":Achievement
      };
      
      private static var FLAG_ALWAYS_SHOW:int = 1;
      
      private static var FLAG_SHOW_REWARD:int = 2;
      
      private static var FLAG_SHOW_CHILDREN:int = 4;
      
      private static var FLAG_SHOW_PROGRESS:int = 8;
      
      public static var REWARD_TYPES:Array;
       
      
      public var id:uint;
      
      public var index:uint;
      
      public var type:int;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var image:String;
      
      public var flags:int;
      
      public var limit:Number;
      
      public var parent_id:uint;
      
      public var reward:DataReference;
      
      public function Achievement(param1:Object = null)
      {
         var _loc2_:* = undefined;
         this.reward = new DataReference();
         for each(_loc2_ in REWARD_TYPES)
         {
            this.reward.addType(_loc2_.classinfo);
         }
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Achievement
      {
         if(!param1)
         {
            return null;
         }
         return StaticData.getInstance(param1,"id","Achievement") as Achievement;
      }
      
      override public function get classinfo() : Object
      {
         return Achievement.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get description() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function get parent() : Achievement
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
