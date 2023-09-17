package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.RestorationEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class RestorationHandler extends Handler
   {
      
      public static var RestoreHPWav:Class = RestorationHandler_RestoreHPWav;
      
      public static var RestorePPWav:Class = RestorationHandler_RestorePPWav;
       
      
      public var data:RestorationEvent;
      
      public var manager:EventProcessor;
      
      public function RestorationHandler(param1:RestorationEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRestoration(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.combat.Restoration;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.RestorationEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.RestorationHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoRestoration extends CombatHandlerState
{
    
   
   public function DoRestoration(param1:RestorationHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc8_:SkillInstance = null;
      super.transitionInto(param1);
      var _loc2_:RestorationEvent = (machine as RestorationHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      var _loc6_:CreatureInstance = _loc3_.getCreatureById(_loc2_.inflictor_id);
      var _loc7_:ActorView = _loc3_.getViewById(_loc2_.inflictor_id);
      _loc5_.effectDisplay.showRestoration(_loc2_.restorations[0]);
      _loc5_.showRestoration();
      if(!_loc2_.is_primary)
      {
         _loc8_ = _loc6_.findSkill(_loc2_.skill_id);
         _loc7_.showSkillIcons(_loc8_,false);
      }
      switch((_loc2_.restorations[0] as Restoration).type)
      {
         case Restoration.HP:
            UIGlobals.playSound(RestorationHandler.RestoreHPWav);
            break;
         case Restoration.PP:
            UIGlobals.playSound(RestorationHandler.RestorePPWav);
      }
      timer.delay = 500 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new ShowRestorationValue(machine as RestorationHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.RestorationEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.RestorationHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowRestorationValue extends CombatHandlerState
{
    
   
   public function ShowRestorationValue(param1:RestorationHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:RestorationEvent = (machine as RestorationHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      var _loc6_:int = _loc2_.totalHP;
      var _loc7_:int = _loc2_.totalPP;
      if(_loc6_ > 0)
      {
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_RESTORE_HP_LOG").value,{
            "name":decorateName(_loc4_.name),
            "amount":_loc6_
         }));
      }
      if(_loc7_ > 0)
      {
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_RESTORE_PP_LOG").value,{
            "name":decorateName(_loc4_.name),
            "amount":_loc7_
         }));
      }
      _loc4_.hp += _loc2_.totalHP;
      _loc4_.pp += _loc2_.totalPP;
      if(_loc2_.totalHP > 0 && _loc2_.totalPP > 0)
      {
         _loc5_.effectValueDisplay.color = 65535;
      }
      else if(_loc2_.totalHP > 0)
      {
         _loc5_.effectValueDisplay.color = UIGlobals.getStyle("HPColor");
      }
      else if(_loc2_.totalPP)
      {
         _loc5_.effectValueDisplay.color = UIGlobals.getStyle("PPColor");
      }
      _loc5_.effectValueDisplay.label = _loc2_.total.toString();
      _loc5_.effectValueDisplay.show();
      timer.delay = 250 / client.combatSpeedMultiplier;
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
