package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class RanchTutorial extends TutorialMachine
   {
       
      
      public function RanchTutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.RanchTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:RanchTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_ranch_dialog");
      gameView.dialogView.globalParams = {"creature":(!player.creatures[0].isEgg ? player.creatures[0].name : player.creatures[1].name)};
      gameView.dialogView.addEventListener("DIALOG_NAV_BAR_ENABLE",this.onNavBarEnable);
      gameView.dialogView.step();
   }
   
   private function onNavBarEnable(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_NAV_BAR_ENABLE",this.onNavBarEnable);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitingForTravelToShop(machine as RanchTutorial));
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
import com.edgebee.breedr.managers.tutorial.RanchTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitingForTravelToShop extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitingForTravelToShop(param1:RanchTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = true;
      gameView.navigationBar.areaTypeFilter = [Area.TYPE_SHOP];
      player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
   }
   
   private function onPlayerChange(param1:PropertyChangeEvent) : void
   {
      if(param1.property == "area" && player.area.type == Area.TYPE_SHOP)
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
