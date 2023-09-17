package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.DoNothingEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class DoNothingHandler extends Handler
   {
       
      
      public var data:DoNothingEvent;
      
      public var manager:EventProcessor;
      
      public function DoNothingHandler(param1:DoNothingEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoNothing(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.DoNothingEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DoNothingHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;
import com.edgebee.breedr.ui.combat.IdleDisplay;

class DoNothing extends CombatHandlerState
{
    
   
   public function DoNothing(param1:DoNothingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc6_:Asset = null;
      super.transitionInto(param1);
      var _loc2_:DoNothingEvent = (machine as DoNothingHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.user_id);
      var _loc5_:ActorView;
      (_loc5_ = _loc3_.getViewById(_loc2_.user_id)).showIdle(IdleDisplay.IDLE);
      switch(_loc2_.what)
      {
         case 0:
         default:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING1_LOG");
            break;
         case 1:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING2_LOG");
            break;
         case 2:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING3_LOG");
            break;
         case 3:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING4_LOG");
            break;
         case 4:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING5_LOG");
            break;
         case 5:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING6_LOG");
            break;
         case 6:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING7_LOG");
            break;
         case 7:
            _loc6_ = Asset.getInstanceByName("BREED_COMBAT_NOTHING8_LOG");
      }
      loggingBox.print(Utils.formatString(_loc6_.value,{"name":decorateName(_loc4_.name)}));
      timer.delay = 1000 / client.combatSpeedMultiplier;
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
