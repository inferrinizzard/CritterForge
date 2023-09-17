package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class GreetingTutorial extends TutorialMachine
   {
       
      
      public var mcc:MovieClipComponent;
      
      public function GreetingTutorial()
      {
         super(TutorialManager.STATE_GREETING);
         start(new Wait(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.GreetingTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class Wait extends TutorialState
{
    
   
   public function Wait(param1:GreetingTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.cutsceneView.visible = true;
      timer.delay = 2000;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new Airplane(machine as GreetingTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.MovieClipComponent;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.SafariStartHandler;
import com.edgebee.breedr.managers.tutorial.GreetingTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.display.MovieClip;
import flash.events.Event;

class Airplane extends TutorialState
{
    
   
   private var _animComplete:Boolean = false;
   
   private var _layout:Array;
   
   public function Airplane(param1:GreetingTutorial)
   {
      this._layout = [{
         "CLASS":Canvas,
         "percentWidth":1,
         "percentHeight":1,
         "CHILDREN":[{
            "CLASS":MovieClipComponent,
            "ID":"mcc",
            "x":UIGlobals.relativize(480),
            "y":UIGlobals.relativize(360),
            "framerate":30
         }]
      }];
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc2_:GreetingTutorial = null;
      super.transitionInto(param1);
      _loc2_ = machine as GreetingTutorial;
      gameView.cutsceneView.visible = true;
      UIUtils.performLayout(_loc2_,gameView.cutsceneView.content,this._layout);
      var _loc3_:MovieClip = new SafariStartHandler.AirplaneMc();
      _loc3_.scaleX = -2;
      _loc3_.scaleY = 2;
      _loc2_.mcc.movieclip = _loc3_;
      _loc2_.mcc.addEventListener(Event.COMPLETE,this.onAnimationComplete);
      _loc2_.mcc.play();
      UIGlobals.playSound(SafariStartHandler.AirplaneWav);
   }
   
   private function onAnimationComplete(param1:Event) : void
   {
      var _loc2_:GreetingTutorial = machine as GreetingTutorial;
      _loc2_.mcc.removeEventListener(Event.COMPLETE,this.onAnimationComplete);
      this._animComplete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._animComplete)
      {
         return new Result(Result.TRANSITION,new Initialize(machine as GreetingTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.cutsceneView.reset();
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.GreetingTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:GreetingTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.cutsceneView.dialog = Dialog.getInstanceByName("greeting_dialog");
      gameView.cutsceneView.dialogView.globalParams = {"player":player.nicename};
      gameView.cutsceneView.dialogView.addEventListener("DIALOG_GREETINGS_COMPLETE",this.onDialogComplete);
      gameView.cutsceneView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.cutsceneView.dialogView.removeEventListener("DIALOG_GREETINGS_COMPLETE",this.onDialogComplete);
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
