package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.world.Area;
   
   public class Replay extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Replay",
         "cls":Replay
      };
       
      
      public var id:uint;
      
      public var date:Date;
      
      public var area_id:uint;
      
      public var is_replay:Boolean;
      
      public var rounds:uint;
      
      public var max_rounds:uint;
      
      public var events:Array;
      
      public var player1_id:uint;
      
      public var player1_name:String;
      
      public var player2_id:uint;
      
      public var player2_name:String;
      
      public function Replay(param1:Object = null)
      {
         this.events = [];
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get area() : Area
      {
         return Area.getInstanceById(this.area_id);
      }
   }
}
