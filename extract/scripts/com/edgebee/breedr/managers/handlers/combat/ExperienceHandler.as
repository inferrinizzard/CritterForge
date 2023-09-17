package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.ExperienceEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class ExperienceHandler extends Handler
   {
       
      
      public var data:ExperienceEvent;
      
      public var manager:EventProcessor;
      
      public function ExperienceHandler(param1:ExperienceEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new ShowXpBar(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.combat.ExperienceEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ExperienceHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowXpBar extends CombatHandlerState
{
    
   
   public function ShowXpBar(param1:ExperienceHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ExperienceEvent = (machine as ExperienceHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      if(_loc3_.visible)
      {
         _loc3_.rightActor.xpBar.setStyle("Animated",false);
         _loc3_.rightActor.xpBar.setValueAndMaximum(_loc3_.rightActor.creature.level_progress,1);
         _loc3_.rightActor.xpBar.setStyle("Animated",true);
         _loc3_.rightActor.showXpBox();
      }
      timer.delay = 500;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new ShowProgress(machine as ExperienceHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.combat.ExperienceEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.ExperienceHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class ShowProgress extends CombatHandlerState
{
    
   
   public function ShowProgress(param1:ExperienceHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ExperienceEvent = (machine as ExperienceHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      if(_loc3_.visible)
      {
         if(_loc2_.level_progress == 0)
         {
            _loc3_.rightActor.xpBar.setValueAndMaximum(1,1);
         }
         else
         {
            _loc3_.rightActor.xpBar.setValueAndMaximum(_loc2_.level_progress,1);
         }
      }
      timer.delay = 1250;
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
      var _loc2_:CombatView = gameView.combatView;
      _loc2_.rightActor.hideXpBox();
   }
}
