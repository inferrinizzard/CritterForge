package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.RoundEndEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class RoundEndHandler extends Handler
   {
       
      
      public var data:RoundEndEvent;
      
      public var manager:EventProcessor;
      
      public function RoundEndHandler(param1:RoundEndEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRoundEnd(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.RoundEndEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.RoundEndHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class DoRoundEnd extends CombatHandlerState
{
    
   
   public function DoRoundEnd(param1:RoundEndHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      var _loc2_:RoundEndEvent = (machine as RoundEndHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance;
      (_loc4_ = _loc3_.getCreatureById(_loc2_.creature_id)).pp = _loc2_.creature_pp;
      gameView.combatView.roundBar.setValueAndMaximum(_loc2_.round + 1,client.currentReplay.rounds);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
