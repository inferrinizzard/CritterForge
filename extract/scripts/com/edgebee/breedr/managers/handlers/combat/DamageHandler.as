package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.DamageEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class DamageHandler extends Handler
   {
      
      public static var ClawWav:Class = DamageHandler_ClawWav;
      
      public static var BiteWav:Class = DamageHandler_BiteWav;
      
      public static var CrushWav:Class = DamageHandler_CrushWav;
      
      public static var FireWav:Class = DamageHandler_FireWav;
      
      public static var IceWav:Class = DamageHandler_IceWav;
      
      public static var ThunderWav:Class = DamageHandler_ThunderWav;
      
      public static var EarthWav:Class = DamageHandler_EarthWav;
      
      public static var DeathWav:Class = DamageHandler_DeathWav;
      
      public static var BlockWav:Class = DamageHandler_BlockWav;
      
      public static var PPDamageWav:Class = DamageHandler_PPDamageWav;
       
      
      public var data:DamageEvent;
      
      public var manager:EventProcessor;
      
      public function DamageHandler(param1:DamageEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoDamage(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.combat.Damage;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.DamageEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DamageHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoDamage extends CombatHandlerState
{
    
   
   public function DoDamage(param1:DamageHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:DamageEvent = (machine as DamageHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView;
      (_loc5_ = _loc3_.getViewById(_loc2_.afflicted_id)).effectDisplay.showDamage(_loc2_);
      if((_loc2_.damages[0] as Damage).type != Damage.DAMAGE_PP)
      {
         _loc5_.showDamage();
      }
      if(_loc2_.blocked)
      {
         UIGlobals.playSound(DamageHandler.BlockWav);
      }
      switch(_loc2_.damages[0].type)
      {
         case Damage.DAMAGE_BITE:
         case Damage.DAMAGE_SPEAR:
            UIGlobals.playSound(DamageHandler.BiteWav);
            break;
         case Damage.DAMAGE_CLAW:
            UIGlobals.playSound(DamageHandler.ClawWav);
            break;
         case Damage.DAMAGE_CRUSH:
            UIGlobals.playSound(DamageHandler.CrushWav);
            break;
         case Damage.DAMAGE_FIRE:
            UIGlobals.playSound(DamageHandler.FireWav);
            break;
         case Damage.DAMAGE_ICE:
            UIGlobals.playSound(DamageHandler.IceWav);
            break;
         case Damage.DAMAGE_THUNDER:
            UIGlobals.playSound(DamageHandler.ThunderWav);
            break;
         case Damage.DAMAGE_EARTH:
            UIGlobals.playSound(DamageHandler.EarthWav);
            break;
         case Damage.DAMAGE_PP:
            UIGlobals.playSound(DamageHandler.PPDamageWav);
      }
      timer.delay = 750 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new ShowDamageValue(machine as DamageHandler));
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
import com.edgebee.breedr.data.combat.Condition;
import com.edgebee.breedr.data.combat.Damage;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.DamageEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DamageHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowDamageValue extends CombatHandlerState
{
    
   
   public function ShowDamageValue(param1:DamageHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc6_:Condition = null;
      super.transitionInto(param1);
      var _loc2_:DamageEvent = (machine as DamageHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      if(_loc2_.condition_id != 0)
      {
         _loc6_ = _loc4_.findCondition(_loc2_.condition_id);
         loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_DAMAGE_CONDITION_LOG").value,{
            "name":decorateName(_loc4_.name),
            "damage":_loc2_.total,
            "condition":_loc6_.afflict_text.value
         }));
      }
      if((_loc2_.damages[0] as Damage).type == Damage.DAMAGE_PP)
      {
         _loc4_.pp -= _loc2_.total;
         _loc5_.effectValueDisplay.color = UIGlobals.getStyle("PPDamageColor");
         if(_loc2_.condition_id == 0)
         {
            loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_PP_DAMAGE_LOG").value,{
               "name":decorateName(_loc4_.name),
               "damage":_loc2_.total
            }));
         }
      }
      else
      {
         _loc4_.hp -= _loc2_.total;
         _loc5_.effectValueDisplay.color = UIGlobals.getStyle("DamageColor");
         if(_loc2_.condition_id == 0)
         {
            loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_DAMAGE_LOG").value,{
               "name":decorateName(_loc4_.name),
               "damage":_loc2_.total
            }));
         }
      }
      if(_loc2_.lucky)
      {
         _loc5_.showLucky();
         if(_loc4_.hp == 0)
         {
            _loc4_.hp = 1;
            loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_LUCKY_SURVIVE_LOG").value,{"name":decorateName(_loc4_.name)}));
         }
         else
         {
            loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_LUCKY_HALF_DAMAGE_LOG").value,{"name":decorateName(_loc4_.name)}));
         }
      }
      loggingBox.flush();
      _loc5_.effectValueDisplay.label = _loc2_.total.toString();
      _loc5_.effectValueDisplay.show();
      timer.delay = 450 / client.combatSpeedMultiplier;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      var _loc2_:DamageEvent = null;
      super.loop(param1);
      if(timerComplete)
      {
         _loc2_ = (machine as DamageHandler).data;
         if(_loc2_.status == "dead")
         {
            return new Result(Result.TRANSITION,new ShowDeath(machine as DamageHandler));
         }
         return Result.STOP;
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
import com.edgebee.breedr.events.combat.DamageEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DamageHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowDeath extends CombatHandlerState
{
    
   
   public function ShowDeath(param1:DamageHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:DamageEvent = (machine as DamageHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_KO_LOG").value,{"name":decorateName(_loc4_.name)}));
      UIGlobals.playSound(DamageHandler.DeathWav);
      _loc5_.showDeath();
      timer.delay = 750 / client.combatSpeedMultiplier;
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
