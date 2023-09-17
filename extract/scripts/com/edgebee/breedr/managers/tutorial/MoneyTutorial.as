package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class MoneyTutorial extends TutorialMachine
   {
       
      
      public function MoneyTutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.MoneyTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:MoneyTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_money_dialog");
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
         return new Result(Result.TRANSITION,new WaitingForTravelToArena(machine as MoneyTutorial));
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
import com.edgebee.breedr.managers.tutorial.MoneyTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitingForTravelToArena extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitingForTravelToArena(param1:MoneyTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = true;
      gameView.navigationBar.areaTypeFilter = [Area.TYPE_ARENA];
      player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
   }
   
   private function onPlayerChange(param1:PropertyChangeEvent) : void
   {
      if(param1.property == "area" && player.area.type == Area.TYPE_ARENA)
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
      gameView.dialogView.step();
   }
}
