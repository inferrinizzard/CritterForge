package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.LevelUpEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class LevelUpHandler extends Handler
   {
      
      public static var LevelUpWav:Class = LevelUpHandler_LevelUpWav;
       
      
      public var data:LevelUpEvent;
      
      public var manager:EventProcessor;
      
      public function LevelUpHandler(param1:LevelUpEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoLevelUp(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.LevelUpEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.LevelUpHandler;
import com.edgebee.breedr.ui.combat.ActorView;

class DoLevelUp extends CombatHandlerState
{
    
   
   public function DoLevelUp(param1:LevelUpHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:ActorView = null;
      super.transitionInto(param1);
      var _loc2_:LevelUpEvent = (machine as LevelUpHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      if(isInQuickCombat)
      {
         gameView.arenaView.showLevelUp();
         gameView.arenaView.creature.level = _loc2_.level;
      }
      else
      {
         (_loc4_ = gameView.combatView.rightActor).showLevelUp();
         _loc4_.creature.level = _loc2_.level;
      }
      _loc3_.skill_points = _loc2_.skill_points;
      _loc3_.level = _loc2_.level;
      UIGlobals.playSound(LevelUpHandler.LevelUpWav);
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_LEVELUP_LOG").value,{"name":decorateName(_loc3_.name)}));
      timer.delay = 3000;
      if(isInQuickCombat)
      {
         timer.delay = 100;
      }
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      var _loc2_:LevelUpEvent = (machine as LevelUpHandler).data;
      if(timerComplete)
      {
         if(_loc2_.trait_choices.length > 0)
         {
            return new Result(Result.TRANSITION,new UnlockNewTrait(machine as LevelUpHandler));
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

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.LevelUpEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.LevelUpHandler;
import com.edgebee.breedr.ui.creature.TraitPickerWindow;
import flash.events.Event;

class UnlockNewTrait extends CombatHandlerState
{
    
   
   private var _pickerDone:Boolean = false;
   
   private var _pickerWindow:TraitPickerWindow;
   
   public function UnlockNewTrait(param1:LevelUpHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LevelUpEvent = (machine as LevelUpHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      this._pickerWindow = new TraitPickerWindow();
      this._pickerWindow.levelUpEvent = _loc2_;
      this._pickerWindow.addEventListener(Event.CLOSE,this.onPickerClosed);
      UIGlobals.popUpManager.addPopUp(this._pickerWindow,gameView,true);
      UIGlobals.popUpManager.centerPopUp(this._pickerWindow);
   }
   
   private function onPickerClosed(param1:Event) : void
   {
      this._pickerWindow.removeEventListener(Event.CLOSE,this.onPickerClosed);
      this._pickerWindow = null;
      this._pickerDone = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._pickerDone)
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
