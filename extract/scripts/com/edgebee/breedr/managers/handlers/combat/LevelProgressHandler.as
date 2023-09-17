package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.LevelProgressEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class LevelProgressHandler extends Handler
   {
       
      
      public var data:LevelProgressEvent;
      
      public var manager:EventProcessor;
      
      public function LevelProgressHandler(param1:LevelProgressEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.LevelProgressEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.LevelProgressHandler;

class Update extends CombatHandlerState
{
    
   
   public function Update(param1:LevelProgressHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LevelProgressEvent = (machine as LevelProgressHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      _loc3_.level_progress = _loc2_.level_progress;
      _loc3_.rank = _loc2_.rank;
      _loc3_.rank_delta = _loc2_.rank_delta;
      _loc3_.wins = _loc2_.wins;
      _loc3_.losses = _loc2_.losses;
      _loc3_.ties = _loc2_.ties;
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
