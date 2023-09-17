package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.NewEggEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class NewEggHandler extends Handler
   {
      
      public static var BreedSuccessWav:Class = NewEggHandler_BreedSuccessWav;
      
      public static var BreedFailureWav:Class = NewEggHandler_BreedFailureWav;
       
      
      public var data:NewEggEvent;
      
      public var manager:EventProcessor;
      
      public function NewEggHandler(param1:NewEggEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         if(param1.instant)
         {
            start(new DoNewEgg(this));
         }
         else
         {
            start(new FadeOutElements(this));
         }
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.NewEggEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewEggHandler;

class DoNewEgg extends HandlerState
{
    
   
   public function DoNewEgg(param1:NewEggHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:NewEggEvent = (machine as NewEggHandler).data;
      var _loc3_:Stall = player.stalls.findItemByProperty("id",_loc2_.stall_id) as Stall;
      _loc2_.creature_instance.copyTo(_loc3_.creature);
      if(_loc2_.instant)
      {
         UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.animation.AnimationInstance;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewEggHandler;
import com.edgebee.breedr.ui.world.areas.lab.LabView;

class FadeOutElements extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeOutElements(param1:NewEggHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LabView = gameView.labView;
      var _loc3_:AnimationInstance = _loc2_.parent1Box.controller.animateTo({"alpha":0},null,true,4);
      _loc3_.addEventListener(AnimationEvent.STOP,this.onFaded);
      _loc2_.parent2Box.controller.animateTo({"alpha":0},null,true,4);
      _loc2_.selectorsBox.controller.animateTo({"alpha":0},null,true,4);
   }
   
   private function onFaded(param1:AnimationEvent) : void
   {
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new FadeInEgg(machine as NewEggHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      var _loc2_:LabView = null;
      super.transitionOut(param1);
      _loc2_ = gameView.labView;
      _loc2_.parent1Box.visible = false;
      _loc2_.parent2Box.visible = false;
      _loc2_.selectorsBox.visible = false;
   }
}

import com.edgebee.atlas.animation.AnimationInstance;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.events.NewEggEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewEggHandler;
import com.edgebee.breedr.ui.world.areas.lab.LabView;

class FadeInEgg extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeInEgg(param1:NewEggHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc2_:LabView = null;
      var _loc3_:NewEggEvent = null;
      super.transitionInto(param1);
      _loc2_ = gameView.labView;
      _loc3_ = (machine as NewEggHandler).data;
      _loc2_.eggBox.alpha = 0;
      _loc2_.eggBox.colorTransformProxy.offset = 255;
      _loc2_.eggBox.visible = true;
      _loc2_.eggView.creature = _loc3_.creature_instance;
      var _loc4_:AnimationInstance;
      (_loc4_ = _loc2_.eggBox.controller.animateTo({
         "colorTransformProxy.offset":0,
         "alpha":1
      },null,true,3)).addEventListener(AnimationEvent.STOP,this.onFaded);
      timer.delay = 2000;
      timer.start();
      UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
   }
   
   private function onFaded(param1:AnimationEvent) : void
   {
      this._faded = true;
      gameView.dialogView.dialog = Dialog.getInstanceByName("lab_new_egg");
      gameView.dialogView.step();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(Boolean(this._faded) && Boolean(timerComplete))
      {
         return new Result(Result.TRANSITION,new FadeOutEgg(machine as NewEggHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.animation.AnimationInstance;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewEggHandler;
import com.edgebee.breedr.ui.world.areas.lab.LabView;

class FadeOutEgg extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeOutEgg(param1:NewEggHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LabView = gameView.labView;
      var _loc3_:AnimationInstance = _loc2_.eggBox.controller.animateTo({"alpha":0},null,true,4);
      _loc3_.addEventListener(AnimationEvent.STOP,this.onFaded);
   }
   
   private function onFaded(param1:AnimationEvent) : void
   {
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new FadeInElements(machine as NewEggHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      var _loc2_:LabView = null;
      super.transitionOut(param1);
      _loc2_ = gameView.labView;
      _loc2_.eggBox.visible = false;
      _loc2_.eggView.creature = null;
   }
}

import com.edgebee.atlas.animation.AnimationInstance;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewEggHandler;
import com.edgebee.breedr.ui.world.areas.lab.LabView;

class FadeInElements extends HandlerState
{
    
   
   private var _faded:Boolean = false;
   
   public function FadeInElements(param1:NewEggHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:LabView = gameView.labView;
      _loc2_.parent1Box.visible = true;
      _loc2_.parent2Box.visible = true;
      _loc2_.selectorsBox.visible = true;
      var _loc3_:AnimationInstance = _loc2_.parent1Box.controller.animateTo({"alpha":1},null,true,4);
      _loc3_.addEventListener(AnimationEvent.STOP,this.onFaded);
      _loc2_.parent2Box.controller.animateTo({"alpha":1},null,true,4);
      _loc2_.selectorsBox.controller.animateTo({"alpha":1},null,true,4);
   }
   
   private function onFaded(param1:AnimationEvent) : void
   {
      this._faded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._faded)
      {
         return new Result(Result.TRANSITION,new DoNewEgg(machine as NewEggHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
