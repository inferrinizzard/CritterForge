package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class RoundEndEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RoundEndEvent",
         "cls":RoundEndEvent
      };
       
      
      public var round:int;
      
      public var creature_id:uint;
      
      public var creature_pp:int;
      
      public function RoundEndEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
