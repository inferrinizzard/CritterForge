package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class Combat2Tutorial extends TutorialMachine
   {
       
      
      public function Combat2Tutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new WaitForArenaViewCreated(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.Combat2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitForArenaViewCreated extends TutorialState
{
    
   
   public function WaitForArenaViewCreated(param1:Combat2Tutorial)
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
         return new Result(Result.TRANSITION,new Initialize(machine as Combat2Tutorial));
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
import com.edgebee.breedr.managers.tutorial.Combat2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:Combat2Tutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.arenaView.optionsBox.enabled = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_arena2_dialog");
      gameView.dialogView.addEventListener("DIALOG_SHOW_NAV",this.onNavBarEnable);
      gameView.dialogView.step();
   }
   
   private function onNavBarEnable(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_SHOW_NAV",this.onNavBarEnable);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitingForTravelToRanch(machine as Combat2Tutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.managers.tutorial.Combat2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitingForTravelToRanch extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitingForTravelToRanch(param1:Combat2Tutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = true;
      gameView.navigationBar.areaTypeFilter = [Area.TYPE_RANCH];
      player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
   }
   
   private function onPlayerChange(param1:PropertyChangeEvent) : void
   {
      if(param1.property == "area" && player.area.type == Area.TYPE_RANCH)
      {
         player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this._complete = true;
      }
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
      gameView.navigationBar.areaTypeFilter = null;
      gameView.arenaView.optionsBox.enabled = true;
      gameView.dialogView.step();
   }
}
