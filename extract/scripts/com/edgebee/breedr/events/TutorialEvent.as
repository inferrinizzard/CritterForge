package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class TutorialEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"TutorialEvent",
         "cls":TutorialEvent
      };
       
      
      public var state:int;
      
      public var is_stealth:Boolean;
      
      public function TutorialEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
