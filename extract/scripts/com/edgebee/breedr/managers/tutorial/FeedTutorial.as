package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class FeedTutorial extends TutorialMachine
   {
       
      
      public function FeedTutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.FeedTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:FeedTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.inventoryView.enabled = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_feed1_dialog");
      gameView.dialogView.addEventListener("DIALOG_UNLOCK_INVENTORY",this.onUnlockInventory);
      gameView.dialogView.step();
   }
   
   private function onUnlockInventory(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_UNLOCK_INVENTORY",this.onUnlockInventory);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitForUseFeed(machine as FeedTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.FeedTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class WaitForUseFeed extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitForUseFeed(param1:FeedTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.inventoryView.enabled = true;
      client.service.addEventListener("UseItem",this.onUseItem);
   }
   
   private function onUseItem(param1:Event) : void
   {
      client.service.removeEventListener("UseItem",this.onUseItem);
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
   }
}
