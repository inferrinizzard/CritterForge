package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.ladder.Challenge;
   
   public class ChallengeEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ChallengeEvent",
         "cls":ChallengeEvent
      };
       
      
      public var challenge:Challenge;
      
      public function ChallengeEvent(param1:Object = null)
      {
         this.challenge = new Challenge();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
