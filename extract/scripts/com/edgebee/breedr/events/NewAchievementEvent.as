package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.player.PersonalAchievementInstance;
   
   public class NewAchievementEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"NewAchievementEvent",
         "cls":NewAchievementEvent
      };
       
      
      public var achievement_instance:PersonalAchievementInstance;
      
      public function NewAchievementEvent(param1:Object = null)
      {
         this.achievement_instance = new PersonalAchievementInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
