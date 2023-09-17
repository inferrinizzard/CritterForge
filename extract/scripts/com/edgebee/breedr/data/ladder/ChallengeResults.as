package com.edgebee.breedr.data.ladder
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.combat.CombatResult;
   
   public class ChallengeResults extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ChallengeResults",
         "cls":ChallengeResults
      };
       
      
      public var id:uint;
      
      public var ladder:com.edgebee.breedr.data.ladder.Ladder;
      
      public var challenger_name:String;
      
      public var defender_name:String;
      
      public var winner:int;
      
      public var results:DataArray;
      
      public function ChallengeResults(param1:Object = null)
      {
         this.ladder = new com.edgebee.breedr.data.ladder.Ladder();
         this.results = new DataArray(CombatResult.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
