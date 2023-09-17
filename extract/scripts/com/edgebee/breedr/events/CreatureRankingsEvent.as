package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class CreatureRankingsEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CreatureRankingsEvent",
         "cls":CreatureRankingsEvent
      };
       
      
      public var rankings:Array;
      
      public function CreatureRankingsEvent(param1:Object = null)
      {
         this.rankings = [];
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
