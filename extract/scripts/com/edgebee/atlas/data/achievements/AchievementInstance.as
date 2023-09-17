package com.edgebee.atlas.data.achievements
{
   import com.edgebee.atlas.data.Data;
   
   public class AchievementInstance extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"AchievementInstance",
         "cls":AchievementInstance
      };
       
      
      public var id:uint;
      
      public var date:Date;
      
      public var achievement_id:uint;
      
      private var _achievement:com.edgebee.atlas.data.achievements.Achievement;
      
      public function AchievementInstance(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get achievement() : com.edgebee.atlas.data.achievements.Achievement
      {
         if(!this._achievement)
         {
            this._achievement = com.edgebee.atlas.data.achievements.Achievement.getInstanceById(this.achievement_id);
         }
         return this._achievement;
      }
   }
}
