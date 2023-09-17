package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.CreatureRankingsEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class CreatureRankingsHandler extends Handler
   {
       
      
      public var data:CreatureRankingsEvent;
      
      public var manager:EventProcessor;
      
      public function CreatureRankingsHandler(param1:CreatureRankingsEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRankings(this));
      }
   }
}

import com.edgebee.atlas.data.DataArray;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.CreatureRankingsEvent;
import com.edgebee.breedr.managers.handlers.CreatureRankingsHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoRankings extends HandlerState
{
    
   
   public function DoRankings(param1:CreatureRankingsHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Object = null;
      var _loc4_:uint = 0;
      var _loc5_:CreatureInstance = null;
      var _loc6_:DataArray = null;
      super.transitionInto(param1);
      var _loc2_:CreatureRankingsEvent = (machine as CreatureRankingsHandler).data;
      for each(_loc3_ in _loc2_.rankings)
      {
         _loc4_ = uint(_loc3_.id);
         _loc5_ = player.creatures.findItemByProperty("id",_loc4_) as CreatureInstance;
         (_loc6_ = new DataArray(CreatureInstance.classinfo)).update(_loc3_.rankings);
         _loc5_.rankingNeighbours.source = _loc6_.source;
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
