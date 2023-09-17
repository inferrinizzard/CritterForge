package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class DoNothingEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"DoNothingEvent",
         "cls":DoNothingEvent
      };
       
      
      public var user_id:uint;
      
      public var creature_pp:uint;
      
      public var what:int;
      
      public var index:int;
      
      public function DoNothingEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
