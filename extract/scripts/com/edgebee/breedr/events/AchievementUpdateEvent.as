package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.player.PersonalAchievementInstance;
   
   public class AchievementUpdateEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"AchievementUpdateEvent",
         "cls":AchievementUpdateEvent
      };
       
      
      public var achievements:DataArray;
      
      public function AchievementUpdateEvent(param1:Object = null)
      {
         this.achievements = new DataArray(PersonalAchievementInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
