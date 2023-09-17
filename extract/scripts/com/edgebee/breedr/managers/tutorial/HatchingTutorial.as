package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class HatchingTutorial extends TutorialMachine
   {
       
      
      public function HatchingTutorial()
      {
         super(TutorialManager.STATE_HATCHING);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.HatchingTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:HatchingTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.cutsceneView.addEventListener(Event.COMPLETE,this.onCutsceneComplete);
   }
   
   private function onCutsceneComplete(param1:Event) : void
   {
      gameView.cutsceneView.removeEventListener(Event.COMPLETE,this.onCutsceneComplete);
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
