package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.MissEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class MissHandler extends Handler
   {
       
      
      public var data:MissEvent;
      
      public var manager:EventProcessor;
      
      public function MissHandler(param1:MissEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoMiss(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.MissEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.MissHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoMiss extends CombatHandlerState
{
    
   
   public function DoMiss(param1:MissHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc5_:ActorView = null;
      super.transitionInto(param1);
      var _loc2_:MissEvent = (machine as MissHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.inflictor_id);
      if(_loc2_.on_self)
      {
         _loc5_ = _loc3_.getViewById(_loc2_.inflictor_id);
      }
      else
      {
         _loc5_ = _loc3_.getViewById(_loc2_.afflicted_id);
      }
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_MISS_LOG").value,{"name":decorateName(_loc4_.name)}));
      _loc5_.showMiss();
      timer.delay = 500 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
