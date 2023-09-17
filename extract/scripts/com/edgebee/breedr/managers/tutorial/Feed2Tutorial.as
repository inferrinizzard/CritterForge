package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class Feed2Tutorial extends TutorialMachine
   {
       
      
      public function Feed2Tutorial()
      {
         super(TutorialManager.STATE_GREETING);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.Feed2Tutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:Feed2Tutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_feed2_dialog");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
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
   }
}
