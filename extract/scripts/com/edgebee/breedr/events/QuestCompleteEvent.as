package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.world.Quest;
   
   public class QuestCompleteEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"QuestCompleteEvent",
         "cls":QuestCompleteEvent
      };
       
      
      public var new_quest:Quest;
      
      public function QuestCompleteEvent(param1:Object = null)
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
