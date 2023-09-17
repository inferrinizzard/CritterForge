package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class CombatTutorial extends TutorialMachine
   {
       
      
      public function CombatTutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new WaitForArenaViewCreated(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.CombatTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitForArenaViewCreated extends TutorialState
{
    
   
   public function WaitForArenaViewCreated(param1:com.edgebee.breedr.managers.tutorial.CombatTutorial)
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
      if(gameView.arenaView.optionsBox)
      {
         return new Result(Result.TRANSITION,new Initialize(machine as com.edgebee.breedr.managers.tutorial.CombatTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.CombatTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:com.edgebee.breedr.managers.tutorial.CombatTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.arenaView.optionsBox.enabled = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_arena_dialog");
      gameView.dialogView.addEventListener("DIALOG_ENABLE_FIGHT",this.onEnableFight);
      gameView.dialogView.step();
   }
   
   private function onEnableFight(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_ENABLE_FIGHT",this.onEnableFight);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitForFight(machine as com.edgebee.breedr.managers.tutorial.CombatTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.CombatTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class WaitForFight extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitForFight(param1:com.edgebee.breedr.managers.tutorial.CombatTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.combatView.stopBtn.visible = false;
      gameView.arenaView.optionsBox.enabled = true;
      gameView.arenaView.prevBtn.enabled = false;
      gameView.arenaView.nextBtn.enabled = false;
      gameView.arenaView.refreshBtn.enabled = false;
      gameView.arenaView.autofightBtn.enabled = false;
      client.service.addEventListener("Fight",this.onFight);
   }
   
   private function onFight(param1:Event) : void
   {
      client.service.removeEventListener("Fight",this.onFight);
      gameView.arenaView.autofightBtn.enabled = true;
      gameView.arenaView.prevBtn.enabled = true;
      gameView.arenaView.nextBtn.enabled = true;
      gameView.arenaView.refreshBtn.enabled = true;
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.dialogView.step();
      gameView.dialogView.reset();
   }
}
