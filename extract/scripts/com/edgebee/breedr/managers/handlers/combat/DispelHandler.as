package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.DispelEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class DispelHandler extends Handler
   {
      
      public static var DispelWav:Class = DispelHandler_DispelWav;
       
      
      public var data:DispelEvent;
      
      public var manager:EventProcessor;
      
      public function DispelHandler(param1:DispelEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoDispel(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.events.combat.DispelEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DispelHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoDispel extends CombatHandlerState
{
    
   
   public function DoDispel(param1:DispelHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc8_:SkillInstance = null;
      super.transitionInto(param1);
      var _loc2_:DispelEvent = (machine as DispelHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      var _loc6_:CreatureInstance = _loc3_.getCreatureById(_loc2_.inflictor_id);
      var _loc7_:ActorView = _loc3_.getViewById(_loc2_.inflictor_id);
      _loc5_.effectDisplay.showDispel();
      UIGlobals.playSound(DispelHandler.DispelWav);
      timer.delay = 500 / client.combatSpeedMultiplier;
      timer.start();
      if(!_loc2_.is_primary)
      {
         _loc8_ = _loc6_.findSkill(_loc2_.skill_id);
         _loc7_.showSkillIcons(_loc8_,false);
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new ShowDispelValue(machine as DispelHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.DispelEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.DispelHandler;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowDispelValue extends CombatHandlerState
{
    
   
   public function ShowDispelValue(param1:DispelHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:DispelEvent = (machine as DispelHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
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
