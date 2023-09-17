package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class LevelProgressEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"LevelProgressEvent",
         "cls":LevelProgressEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var level_progress:Number;
      
      public var rank:uint;
      
      public var rank_delta:int;
      
      public var wins:int;
      
      public var losses:int;
      
      public var ties:int;
      
      public function LevelProgressEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
