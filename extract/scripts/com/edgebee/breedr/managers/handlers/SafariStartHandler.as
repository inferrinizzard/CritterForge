package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.breedr.events.SafariStartEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SafariStartHandler extends Handler
   {
      
      public static var AirplaneWav:Class = SafariStartHandler_AirplaneWav;
      
      public static var AirplaneMc:Class = SafariStartHandler_AirplaneMc;
       
      
      public var data:SafariStartEvent;
      
      public var manager:EventProcessor;
      
      public var mcc:MovieClipComponent;
      
      public function SafariStartHandler(param1:SafariStartEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.events.SafariStartEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariStartHandler;
import flash.events.Event;

class Initialize extends HandlerState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:SafariStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SafariStartHandler = machine as SafariStartHandler;
      var _loc3_:SafariStartEvent = _loc2_.data;
      gameView.dialogView.dialog = Dialog.getInstanceByName("travel_start_safari");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.dialogView.step();
      player.resetSafari();
      ++client.criticalComms;
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      --client.criticalComms;
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new Airplane(machine as SafariStartHandler));
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
import com.edgebee.breedr.events.SafariStartEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariStartHandler;
import flash.display.MovieClip;
import flash.events.Event;

class Airplane extends HandlerState
{
    
   
   private var _animComplete:Boolean = false;
   
   private var _layout:Array;
   
   public function Airplane(param1:SafariStartHandler)
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
      var _loc2_:SafariStartHandler = null;
      super.transitionInto(param1);
      _loc2_ = machine as SafariStartHandler;
      var _loc3_:SafariStartEvent = _loc2_.data;
      gameView.cutsceneView.visible = true;
      UIUtils.performLayout(_loc2_,gameView.cutsceneView.content,this._layout);
      var _loc4_:MovieClip;
      (_loc4_ = new SafariStartHandler.AirplaneMc()).scaleX = 2;
      _loc4_.scaleY = 2;
      _loc2_.mcc.movieclip = _loc4_;
      _loc2_.mcc.addEventListener(Event.COMPLETE,this.onAnimationComplete);
      _loc2_.mcc.play();
      UIGlobals.playSound(SafariStartHandler.AirplaneWav);
   }
   
   private function onAnimationComplete(param1:Event) : void
   {
      var _loc2_:SafariStartHandler = machine as SafariStartHandler;
      _loc2_.mcc.removeEventListener(Event.COMPLETE,this.onAnimationComplete);
      this._animComplete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._animComplete)
      {
         return new Result(Result.TRANSITION,new DoTravelTo(machine as SafariStartHandler));
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
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.SafariStartEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariStartHandler;
import flash.events.Event;

class DoTravelTo extends HandlerState
{
    
   
   public function DoTravelTo(param1:SafariStartHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SafariStartEvent = (machine as SafariStartHandler).data;
      player.area = Area.getInstanceById(_loc2_.destination_id);
      player.safari_creature_id = _loc2_.creature_id;
      gameView.npcView.npc = player.area.npc;
      gameView.backgroundImage.source = UIGlobals.getAssetPath(player.area.getImageForPlayer(player));
      var _loc3_:Area = player.area;
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("START_SAFARI_TO_LOG").value,{"destination":_loc3_.name.value}));
      gameView.hideAreaViews();
      gameView.safariView.visible = true;
      gameView.inventoryView.visible = true;
      gameView.navigationBar.visible = false;
      client.sndManager.playMusic(_loc3_.music,0,int.MAX_VALUE);
      if(!(player.event_flags & Player.EV_FIRST_SAFARI))
      {
         ++client.criticalComms;
         player.event_flags |= Player.EV_FIRST_SAFARI;
         gameView.dialogView.dialog = Dialog.getInstanceByName("tut_first_safari_dialog");
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onFirstSafariComplete,false,0,false);
         gameView.dialogView.step();
      }
   }
   
   private function onFirstSafariComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onFirstSafariComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_FIRST_SAFARI;
      client.service.SetPlayerEventFlag(_loc2_);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
