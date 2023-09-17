package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.Data;
   
   public class PersonalAchievementInstance extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"PersonalAchievementInstance",
         "cls":PersonalAchievementInstance
      };
       
      
      public var id:uint;
      
      public var date:Date;
      
      public var static_id:uint;
      
      private var _personalAchievement:com.edgebee.breedr.data.player.PersonalAchievement;
      
      public function PersonalAchievementInstance(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get personalAchievement() : com.edgebee.breedr.data.player.PersonalAchievement
      {
         if(!this._personalAchievement)
         {
            this._personalAchievement = com.edgebee.breedr.data.player.PersonalAchievement.getInstanceById(this.static_id);
         }
         return this._personalAchievement;
      }
   }
}
