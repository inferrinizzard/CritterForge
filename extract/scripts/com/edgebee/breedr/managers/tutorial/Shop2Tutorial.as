package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class Shop2Tutorial extends TutorialMachine
   {
       
      
      public function Shop2Tutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new Wait(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.Shop2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class Wait extends TutorialState
{
    
   
   public function Wait(param1:Shop2Tutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      timer.delay = 500;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new Initialize(machine as Shop2Tutorial));
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
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.Shop2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:Shop2Tutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_shop2_dialog");
      gameView.dialogView.step();
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
      gameView.shopView.enabled = true;
      gameView.navigationBar.areaTypeFilter = null;
      gameView.inventoryView.optionsBox.enabled = true;
   }
}
