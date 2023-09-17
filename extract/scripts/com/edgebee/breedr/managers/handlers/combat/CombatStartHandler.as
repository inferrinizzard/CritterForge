package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.CombatStartEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class CombatStartHandler extends Handler
   {
      
      public static var FightWav:Class = CombatStartHandler_FightWav;
       
      
      public var data:CombatStartEvent;
      
      public var manager:EventProcessor;
      
      public function CombatStartHandler(param1:CombatStartEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new FadeToWhite(this));
      }
   }
}

import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;

class FadeToWhite extends CombatHandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeToWhite(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      this._faded = false;
      gameView.fadeOverlay.setStyle("BackgroundColor",16777215);
      gameView.fadeOverlay.visible = true;
      gameView.fadeInInstance.speed = 4;
      gameView.fadeInInstance.addEventListener(AnimationEvent.STOP,this.onAnimationComplete);
      gameView.fadeInInstance.gotoEndAndPlayReversed();
   }
   
   private function onAnimationComplete(param1:AnimationEvent) : void
   {
      gameView.fadeInInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationComplete);
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new FadeBackIn(machine as CombatStartHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.combat.CombatStartEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;
import com.edgebee.breedr.ui.combat.CombatView;

class FadeBackIn extends CombatHandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeBackIn(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CombatStartEvent = (machine as CombatStartHandler).data;
      gameView.combatView.creature1 = _loc2_.creature1;
      gameView.combatView.creature2 = _loc2_.creature2;
      gameView.combatView.rightActor.creatureView.alpha = 0;
      gameView.combatView.leftActor.creatureView.alpha = 0;
      gameView.hideAreaViews();
      gameView.npcView.visible = false;
      if(client.currentReplay.is_replay)
      {
         gameView.combatView.mode = CombatView.REPLAY_MODE;
      }
      else
      {
         gameView.combatView.mode = CombatView.NORMAL_MODE;
      }
      gameView.combatView.visible = true;
      gameView.navigationBar.visible = false;
      gameView.combatView.roundBar.setValueAndMaximum(0,client.currentReplay.rounds);
      gameView.backgroundImage.source = UIGlobals.getAssetPath(client.currentReplay.area.image_url);
      this._faded = false;
      gameView.fadeOverlay.visible = true;
      gameView.fadeInInstance.addEventListener(AnimationEvent.STOP,this.onAnimationComplete);
      gameView.fadeInInstance.speed = 4;
      gameView.fadeInInstance.gotoStartAndPlay();
   }
   
   private function onAnimationComplete(param1:AnimationEvent) : void
   {
      gameView.fadeOverlay.setStyle("BackgroundColor",0);
      gameView.fadeInInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationComplete);
      gameView.fadeOverlay.visible = false;
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new DoCombatStart(machine as CombatStartHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.combat.CombatStartEvent;
import com.edgebee.breedr.managers.TutorialManager;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;

class DoCombatStart extends CombatHandlerState
{
    
   
   public function DoCombatStart(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CombatStartEvent = (machine as CombatStartHandler).data;
      timer.delay = 250;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         if(client.tutorialManager.state == TutorialManager.STATE_COMBAT || client.tutorialManager.state == TutorialManager.STATE_COMBAT2)
         {
            return new Result(Result.TRANSITION,new CombatTutorial(machine as CombatStartHandler));
         }
         return new Result(Result.TRANSITION,new SpawnLeftActor(machine as CombatStartHandler));
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
import com.edgebee.breedr.events.combat.CombatStartEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;
import flash.events.Event;

class CombatTutorial extends CombatHandlerState
{
    
   
   private var _complete:Boolean = false;
   
   public function CombatTutorial(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CombatStartEvent = (machine as CombatStartHandler).data;
      client.eventProcessor.paused = true;
      gameView.combatView.enabled = false;
      gameView.npcView.visible = true;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_fight_dialog");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      client.eventProcessor.paused = false;
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new SpawnLeftActor(machine as CombatStartHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.npcView.npc = player.area.npc;
      gameView.npcView.visible = false;
      gameView.combatView.enabled = true;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;

class SpawnLeftActor extends CombatHandlerState
{
    
   
   public function SpawnLeftActor(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.combatView.leftActor.showSpawn();
      timer.delay = 500;
      timer.start();
      client.sndManager.playMusic(UIGlobals.getAssetPath("breedr/sounds/music/combat.mp3"),75,int.MAX_VALUE,0.5);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new SpawnRightActor(machine as CombatStartHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;

class SpawnRightActor extends CombatHandlerState
{
    
   
   public function SpawnRightActor(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.combatView.rightActor.showSpawn();
      timer.delay = 500;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return new Result(Result.TRANSITION,new Announce(machine as CombatStartHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.managers.handlers.combat.CombatStartHandler;

class Announce extends CombatHandlerState
{
    
   
   public function Announce(param1:CombatStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.combatView.announcer.color.hex = 16711680;
      gameView.combatView.announcer.start(Asset.getInstanceByName("COMBAT_START"));
      UIGlobals.playSound(CombatStartHandler.FightWav);
      timer.delay = 500;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
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
