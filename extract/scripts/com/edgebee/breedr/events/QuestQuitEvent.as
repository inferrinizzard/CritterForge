package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.world.Quest;
   
   public class QuestQuitEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"QuestQuitEvent",
         "cls":QuestQuitEvent
      };
       
      
      public var new_quest:Quest;
      
      public function QuestQuitEvent(param1:Object = null)
      {
         this.new_quest = new Quest();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
