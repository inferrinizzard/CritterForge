package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.CreditEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class CreditHandler extends Handler
   {
       
      
      public var data:CreditEvent;
      
      public var manager:EventProcessor;
      
      public function CreditHandler(param1:CreditEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new GiveCredits(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.combat.CreditEvent;
import com.edgebee.breedr.managers.handlers.CreditsUpdateHandler;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CreditHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class GiveCredits extends CombatHandlerState
{
    
   
   public function GiveCredits(param1:CreditHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CreditEvent = (machine as CreditHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_CREDITS_LOG").value,{
         "name":decorateName(_loc2_.owner1.name),
         "credits":_loc2_.creature1_credits.toString()
      }));
      player.credits += _loc2_.creature1_credits;
      UIGlobals.playSound(CreditsUpdateHandler.CreditsChangeWav);
      timer.delay = 2500;
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
