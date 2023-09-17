package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.world.Stall;
   
   public class PlayerCreaturesDirtyEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"PlayerCreaturesDirtyEvent",
         "cls":PlayerCreaturesDirtyEvent
      };
       
      
      public var stalls:DataArray;
      
      public function PlayerCreaturesDirtyEvent(param1:Object = null)
      {
         this.stalls = new DataArray(Stall.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
