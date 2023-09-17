package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.breedr.events.SafariStopEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SafariStopHandler extends Handler
   {
       
      
      public var data:SafariStopEvent;
      
      public var manager:EventProcessor;
      
      public var mcc:MovieClipComponent;
      
      public function SafariStopHandler(param1:SafariStopEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Airplane(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.MovieClipComponent;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.SafariStopEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariStartHandler;
import com.edgebee.breedr.managers.handlers.SafariStopHandler;
import flash.display.MovieClip;
import flash.events.Event;

class Airplane extends HandlerState
{
    
   
   private var _animComplete:Boolean = false;
   
   private var _layout:Array;
   
   public function Airplane(param1:SafariStopHandler)
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
      var _loc2_:SafariStopHandler = null;
      super.transitionInto(param1);
      _loc2_ = machine as SafariStopHandler;
      var _loc3_:SafariStopEvent = _loc2_.data;
      gameView.cutsceneView.visible = true;
      UIUtils.performLayout(_loc2_,gameView.cutsceneView.content,this._layout);
      var _loc4_:MovieClip;
      (_loc4_ = new SafariStartHandler.AirplaneMc()).scaleX = -2;
      _loc4_.scaleY = 2;
      _loc2_.mcc.movieclip = _loc4_;
      _loc2_.mcc.addEventListener(Event.COMPLETE,this.onAnimationComplete);
      _loc2_.mcc.play();
      player.last_safari_prey.ref = null;
      UIGlobals.playSound(SafariStartHandler.AirplaneWav);
      client.sndManager.stopMusic();
   }
   
   private function onAnimationComplete(param1:Event) : void
   {
      var _loc2_:SafariStopHandler = machine as SafariStopHandler;
      _loc2_.mcc.removeEventListener(Event.COMPLETE,this.onAnimationComplete);
      this._animComplete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._animComplete)
      {
         return new Result(Result.TRANSITION,new DoSafariStop(machine as SafariStopHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.cutsceneView.visible = false;
      gameView.cutsceneView.reset();
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.SafariStopEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariStopHandler;
import flash.events.Event;

class DoSafariStop extends HandlerState
{
    
   
   public function DoSafariStop(param1:SafariStopHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      var _loc3_:Area = null;
      super.loop(param1);
      var _loc2_:SafariStopEvent = (machine as SafariStopHandler).data;
      player.safari_creature_id = 0;
      player.area = Area.getInstanceById(_loc2_.destination_id);
      gameView.npcView.npc = player.area.npc;
      gameView.backgroundImage.source = UIGlobals.getAssetPath(player.area.getImageForPlayer(player));
      _loc3_ = player.area;
      loggingBox.print(Asset.getInstanceByName("STOP_SAFARI_LOG").value);
      loggingBox.flush();
      gameView.hideAreaViews();
      gameView.navigationBar.visible = true;
      gameView.travelView.visible = true;
      gameView.dialogView.dialog = Dialog.getInstanceByName("travel_stop_safari");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.dialogView.step();
      client.sndManager.playMusic(_loc3_.music,0,int.MAX_VALUE);
      return Result.STOP;
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
