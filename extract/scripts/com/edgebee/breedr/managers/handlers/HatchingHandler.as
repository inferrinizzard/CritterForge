package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.breedr.events.HatchingEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.TutorialManager;
   import com.edgebee.breedr.ui.creature.CreatureView;
   
   public class HatchingHandler extends Handler
   {
      
      public static var HatchingWav:Class = HatchingHandler_HatchingWav;
      
      public static const HATCH_FRAME:int = 48;
       
      
      public var data:HatchingEvent;
      
      public var manager:EventProcessor;
      
      public var cvs:Canvas;
      
      public var cv:CreatureView;
      
      public var mcc:MovieClipComponent;
      
      public var nameBox:Box;
      
      public var nameLbl:Label;
      
      public var nameTxt:TextInput;
      
      public var nameSubmitButton:Button;
      
      public var nameExceptionLbl:Label;
      
      public var genderIcon:BitmapComponent;
      
      public var genderLbl:Label;
      
      public function HatchingHandler(param1:HatchingEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         if(client.hatchedCreatureIds.indexOf(this.data.creature_instance.id) >= 0)
         {
            start(new Skip(this));
         }
         else
         {
            client.hatchedCreatureIds.push(this.data.creature_instance.id);
            if(this.data.creature_instance.isNamed && client.tutorialManager.state == TutorialManager.STATE_HATCHING)
            {
               start(new ResumeCreateSkillsTutorial(this));
            }
            else
            {
               start(new Initialize(this));
            }
         }
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;

class Skip extends HandlerState
{
    
   
   public function Skip(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Button;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.MovieClipComponent;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.controls.TextInput;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.ColorMatrix;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.Category;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.events.HatchingEvent;
import com.edgebee.breedr.managers.TutorialManager;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import com.edgebee.breedr.ui.creature.CreatureView;
import flash.display.MovieClip;
import flash.events.Event;

class Initialize extends HandlerState
{
   
   private static var HatchMc:Class = Initialize_HatchMc;
   
   private static var Hatch2Mc:Class = Initialize_Hatch2Mc;
   
   private static var Hatch3Mc:Class = Initialize_Hatch3Mc;
   
   private static var Hatch4Mc:Class = Initialize_Hatch4Mc;
   
   private static var Hatch5Mc:Class = Initialize_Hatch5Mc;
    
   
   private var _loaded:Boolean = false;
   
   private var _layout:Array;
   
   public function Initialize(param1:HatchingHandler)
   {
      this._layout = [{
         "CLASS":Canvas,
         "ID":"cvs",
         "width":UIGlobals.relativize(307),
         "height":UIGlobals.relativize(307),
         "visible":false,
         "CHILDREN":[{
            "CLASS":CreatureView,
            "ID":"cv",
            "width":UIGlobals.relativize(307),
            "height":UIGlobals.relativize(307),
            "visible":false
         },{
            "CLASS":MovieClipComponent,
            "ID":"mcc",
            "width":UIGlobals.relativize(307),
            "height":UIGlobals.relativize(307),
            "x":UIGlobals.relativize(154),
            "y":UIGlobals.relativize(200),
            "framerate":30
         },{
            "CLASS":Box,
            "ID":"nameBox",
            "y":UIGlobals.relativize(-96),
            "direction":Box.VERTICAL,
            "percentWidth":1,
            "horizontalAlign":Box.ALIGN_CENTER,
            "visible":false,
            "name":"HatchCreatureNameBox",
            "STYLES":{"Gap":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"nameLbl",
               "text":"Choose a name for your creature:",
               "STYLES":{"FontColor":16777215}
            },{
               "CLASS":TextInput,
               "ID":"nameTxt",
               "maxChars":CreatureInstance.MAX_NAME_LENGTH
            },{
               "CLASS":Button,
               "ID":"nameSubmitButton",
               "label":"Submit",
               "enabled":false
            },{
               "CLASS":Box,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "ID":"genderIcon",
                  "width":UIGlobals.relativize(24),
                  "isSquare":true
               },{
                  "CLASS":Spacer,
                  "width":UIGlobals.relativize(4)
               },{
                  "CLASS":Label,
                  "ID":"genderLbl",
                  "STYLES":{
                     "FontColor":16777215,
                     "FontWeight":"bold"
                  }
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(10)
            },{
               "CLASS":Label,
               "ID":"nameExceptionLbl",
               "STYLES":{
                  "FontColor":16711680,
                  "FontWeight":"bold"
               }
            }]
         }]
      }];
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:HatchingEvent = _loc2_.data;
      gameView.cutsceneView.reset();
      gameView.cutsceneView.forceVisible();
      UIUtils.performLayout(_loc2_,gameView.cutsceneView.content,this._layout);
      _loc2_.cv.addEventListener(Event.COMPLETE,this.onCreatureLoadComplete);
      _loc2_.cv.creature = _loc3_.creature_instance;
      switch(_loc3_.creature_instance.creature.category.type)
      {
         case Category.CATEGORY_COMMON:
            _loc2_.mcc.movieclip = new HatchMc() as MovieClip;
            break;
         case Category.CATEGORY_UNCOMMON:
            _loc2_.mcc.movieclip = new Hatch2Mc() as MovieClip;
            break;
         case Category.CATEGORY_RARE:
            _loc2_.mcc.movieclip = new Hatch3Mc() as MovieClip;
            break;
         case Category.CATEGORY_LEGEND:
            _loc2_.mcc.movieclip = new Hatch4Mc() as MovieClip;
            break;
         case Category.CATEGORY_MYSTIC:
            _loc2_.mcc.movieclip = new Hatch5Mc() as MovieClip;
      }
      var _loc4_:ColorMatrix;
      (_loc4_ = new ColorMatrix()).hue = _loc3_.creature_instance.hue;
      _loc2_.mcc.movieclip.filters = [_loc4_.filter];
      _loc2_.mcc.movieclip.scaleX = UIGlobals.relativize(1);
      _loc2_.mcc.movieclip.scaleY = UIGlobals.relativize(1);
      if(client.tutorialManager.state == TutorialManager.STATE_HATCHING)
      {
         gameView.cutsceneView.dialog = Dialog.getInstanceByName("tut_hatch_dialog");
      }
      else
      {
         gameView.cutsceneView.dialog = _loc3_.dialog;
      }
      timer.delay = 500;
      timer.start();
   }
   
   private function onCreatureLoadComplete(param1:Event) : void
   {
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.cv.removeEventListener(Event.COMPLETE,this.onCreatureLoadComplete);
      this._loaded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(Boolean(this._loaded) && Boolean(timerComplete))
      {
         return new Result(Result.TRANSITION,new NpcIntroduce(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.cvs.visible = true;
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.HatchingEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;

class NpcIntroduce extends HandlerState
{
    
   
   private var dialogComplete:Boolean = false;
   
   public function NpcIntroduce(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:HatchingEvent = _loc2_.data;
      gameView.cutsceneView.dialogView.globalParams = {"family":_loc3_.creature_instance.creature.name.value};
      gameView.cutsceneView.dialogView.addEventListener("DIALOG_HATCH_COMPLETE",this.onDialogComplete);
      gameView.cutsceneView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.cutsceneView.dialogView.removeEventListener("DIALOG_HATCH_COMPLETE",this.onDialogComplete);
      this.dialogComplete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this.dialogComplete)
      {
         return new Result(Result.TRANSITION,new Hatch(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.animation.Animation;
import com.edgebee.atlas.animation.AnimationInstance;
import com.edgebee.atlas.animation.Keyframe;
import com.edgebee.atlas.animation.Track;
import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;
import flash.events.TimerEvent;

class Hatch extends HandlerState
{
    
   
   private var _complete:Boolean = false;
   
   private var _anim:AnimationInstance;
   
   public function Hatch(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc2_:HatchingHandler = null;
      var _loc4_:Track = null;
      super.transitionInto(param1);
      _loc2_ = machine as HatchingHandler;
      _loc2_.mcc.addEventListener(Event.COMPLETE,this.onAnimationComplete);
      _loc2_.mcc.play();
      timer.delay = 1000 / _loc2_.mcc.framerate * HatchingHandler.HATCH_FRAME;
      timer.start();
      var _loc3_:Animation = new Animation();
      (_loc4_ = new Track("alpha")).addKeyframe(new Keyframe(0,0));
      _loc4_.addKeyframe(new Keyframe(0.25,1));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("colorTransformProxy.offset")).addKeyframe(new Keyframe(0,255));
      _loc4_.addKeyframe(new Keyframe(0.5,255));
      _loc4_.addKeyframe(new Keyframe(0.75,0));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("glowProxy.alpha")).addKeyframe(new Keyframe(0,1));
      _loc4_.addKeyframe(new Keyframe(0.75,0));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("x")).addKeyframe(new Keyframe(0,UIGlobals.relativize(307) / 2));
      _loc4_.addKeyframe(new Keyframe(0.45,0));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("scaleX")).addKeyframe(new Keyframe(0,0));
      _loc4_.addKeyframe(new Keyframe(0.45,1));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("y")).addKeyframe(new Keyframe(0,UIGlobals.relativize(307) / 2));
      _loc4_.addKeyframe(new Keyframe(0.45,0));
      _loc3_.addTrack(_loc4_);
      (_loc4_ = new Track("scaleY")).addKeyframe(new Keyframe(0,0));
      _loc4_.addKeyframe(new Keyframe(0.45,1));
      _loc3_.addTrack(_loc4_);
      _loc2_.cv.visible = true;
      _loc2_.cv.alpha = 0;
      if(_loc2_.cv.layers.hasOwnProperty("shadow"))
      {
         _loc2_.cv.layers["shadow"].visible = false;
      }
      _loc2_.cv.glowProxy.color = 11184810;
      _loc2_.cv.glowProxy.blur = _loc2_.cv.width / 10;
      this._anim = _loc2_.cv.controller.addAnimation(_loc3_);
      this._anim.addEventListener(AnimationEvent.STOP,this.onCreatureAnimComplete,false,0,false);
   }
   
   override protected function onTimerComplete(param1:TimerEvent) : void
   {
      super.onTimerComplete(param1);
      UIGlobals.playSound(HatchingHandler.HatchingWav);
      this._anim.gotoStartAndPlay();
   }
   
   private function onAnimationComplete(param1:Event) : void
   {
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.mcc.removeEventListener(Event.COMPLETE,this.onAnimationComplete);
      this._complete = true;
   }
   
   private function onCreatureAnimComplete(param1:AnimationEvent) : void
   {
      this._anim.removeEventListener(AnimationEvent.STOP,this.onCreatureAnimComplete);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.cv.controller.removeAnimation(this._anim);
      if(_loc2_.cv.layers.hasOwnProperty("shadow"))
      {
         _loc2_.cv.layers["shadow"].visible = true;
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new SelectName(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.mcc.visible = false;
   }
}

import com.adobe.utils.StringUtil;
import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.HatchingEvent;
import com.edgebee.breedr.managers.TutorialManager;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
import flash.events.Event;
import flash.events.MouseEvent;

class SelectName extends HandlerState
{
    
   
   private var _creatureNamed:Boolean = false;
   
   public function SelectName(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.nameBox.visible = true;
      _loc2_.nameTxt.addEventListener(Event.CHANGE,this.onInputChange);
      _loc2_.nameSubmitButton.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
      _loc2_.genderIcon.source = _loc2_.data.creature_instance.is_male ? RanchView.MaleIconPng : RanchView.FemaleIconPng;
      _loc2_.genderLbl.text = _loc2_.data.creature_instance.is_male ? Asset.getInstanceByName("CREATURE_MALE") : Asset.getInstanceByName("CREATURE_FEMALE");
      _loc2_.cv.visible = true;
      gameView.cutsceneView.dialogView.step();
   }
   
   private function onInputChange(param1:Event) : void
   {
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:String = StringUtil.trim(_loc2_.nameTxt.text);
      _loc2_.nameSubmitButton.enabled = _loc3_.length >= CreatureInstance.MIN_NAME_LENGTH;
   }
   
   private function onSubmitClick(param1:MouseEvent) : void
   {
      var _loc3_:Object = null;
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      if(_loc2_.nameTxt.text.length)
      {
         _loc3_ = client.createInput();
         _loc3_.creature_instance_id = _loc2_.data.creature_instance.id;
         _loc3_.name = _loc2_.nameTxt.text;
         _loc2_.nameBox.enabled = false;
         _loc2_.nameExceptionLbl.text = "";
         client.service.addEventListener("RenameCreature",this.onCreatureNamed);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onCreatureNameException);
         client.service.RenameCreature(_loc3_);
      }
   }
   
   private function onCreatureNameException(param1:ExceptionEvent) : void
   {
      var _loc2_:HatchingHandler = null;
      if(param1.method == "RenameCreature")
      {
         if(param1.exception.cls == "CreatureNameInUse")
         {
            param1.handled = true;
            _loc2_ = machine as HatchingHandler;
            _loc2_.nameBox.enabled = true;
            _loc2_.nameTxt.text = "";
            _loc2_.nameExceptionLbl.text = param1.exception.short;
         }
      }
   }
   
   private function onCreatureNamed(param1:ServiceEvent) : void
   {
      this._creatureNamed = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._creatureNamed)
      {
         if(client.tutorialManager.state == TutorialManager.STATE_HATCHING)
         {
            return new Result(Result.TRANSITION,new CreateSkillsTutorial(machine as HatchingHandler));
         }
         return new Result(Result.TRANSITION,new CreateSkillsNotMandatory(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.nameTxt.removeEventListener(Event.CHANGE,this.onInputChange);
      _loc2_.nameSubmitButton.removeEventListener(MouseEvent.CLICK,this.onSubmitClick);
      client.service.removeEventListener("RenameCreature",this.onCreatureNamed);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onCreatureNameException);
      var _loc3_:HatchingEvent = _loc2_.data;
      var _loc4_:CreatureInstance = player.creatures.findItemByProperty("id",_loc3_.creature_instance.id) as CreatureInstance;
      _loc3_.creature_instance.name = _loc2_.nameTxt.text;
      _loc3_.creature_instance.copyTo(_loc4_);
   }
}

import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;

class CreateSkillsNotMandatory extends HandlerState
{
    
   
   private var _skillsCreated:Boolean = false;
   
   public function CreateSkillsNotMandatory(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc2_:HatchingHandler = null;
      super.transitionInto(param1);
      _loc2_ = machine as HatchingHandler;
      _loc2_.nameBox.visible = false;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.data.creature_instance.id) as CreatureInstance;
      gameView.skillEditorWindow.creature = _loc3_;
      gameView.skillEditorWindow.visible = true;
      gameView.skillEditorWindow.nonCritical = true;
      UIGlobals.popUpManager.addPopUp(gameView.skillEditorWindow,gameView);
      gameView.skillEditorWindow.x = UIGlobals.relativize(50);
      gameView.skillEditorWindow.y = UIGlobals.relativize(50);
      client.service.addEventListener("SetSkills",this.onSkillSaved,false,1);
      gameView.skillEditorWindow.addEventListener(Event.CLOSE,this.onEditorClosed);
      gameView.cutsceneView.dialogView.step();
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      if(param1.method == "SetSkills")
      {
         gameView.skillEditorWindow.visible = true;
      }
   }
   
   private function onSkillSaved(param1:ServiceEvent) : void
   {
      var _loc2_:Object = null;
      for each(_loc2_ in param1.data.events)
      {
         if(_loc2_.hasOwnProperty("__type__") && _loc2_.__type__ == "SkillUpdateEvent")
         {
            _loc2_.stealth = true;
         }
      }
      this._skillsCreated = true;
   }
   
   private function onEditorClosed(param1:Event) : void
   {
      this._skillsCreated = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._skillsCreated)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.skillEditorWindow.doClose();
      gameView.cutsceneView.dialogView.step();
      client.service.removeEventListener("SetSkills",this.onSkillSaved);
      gameView.skillEditorWindow.removeEventListener(Event.CLOSE,this.onEditorClosed);
      gameView.skillEditorWindow.nonCritical = false;
      gameView.cutsceneView.visible = false;
   }
}

import com.adobe.crypto.MD5;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.events.HatchingEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import com.edgebee.breedr.ui.creature.CreatureView;
import flash.events.Event;

class ResumeCreateSkillsTutorial extends HandlerState
{
    
   
   private var _loaded:Boolean = false;
   
   private var _layout:Array;
   
   public function ResumeCreateSkillsTutorial(param1:HatchingHandler)
   {
      this._layout = [{
         "CLASS":Canvas,
         "ID":"cvs",
         "width":UIGlobals.relativize(307),
         "height":UIGlobals.relativize(307),
         "visible":false,
         "CHILDREN":[{
            "CLASS":CreatureView,
            "ID":"cv",
            "width":UIGlobals.relativize(307),
            "height":UIGlobals.relativize(307),
            "visible":false
         }]
      }];
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:HatchingEvent = _loc2_.data;
      gameView.cutsceneView.reset();
      gameView.cutsceneView.forceVisible();
      UIUtils.performLayout(_loc2_,gameView.cutsceneView.content,this._layout);
      _loc2_.cv.addEventListener(Event.COMPLETE,this.onCreatureLoadComplete);
      _loc2_.cv.creature = _loc3_.creature_instance;
      gameView.cutsceneView.dialog = Dialog.getInstanceByName("tut_hatch_dialog");
      gameView.cutsceneView.dialogView.globalParams = {"family":_loc3_.creature_instance.creature.name.value};
      gameView.cutsceneView.dialogView.skipToLine(MD5.hash("DialogLine:tut_hatch_dialog_02"));
      timer.delay = 500;
      timer.start();
   }
   
   private function onCreatureLoadComplete(param1:Event) : void
   {
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.cv.removeEventListener(Event.COMPLETE,this.onCreatureLoadComplete);
      this._loaded = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(Boolean(this._loaded) && Boolean(timerComplete))
      {
         return new Result(Result.TRANSITION,new CreateSkillsTutorial(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      _loc2_.cvs.visible = true;
      _loc2_.cv.visible = true;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;

class CreateSkillsTutorial extends HandlerState
{
    
   
   private var _firstAttackVisible:Boolean = false;
   
   public function CreateSkillsTutorial(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      if(_loc2_.nameBox)
      {
         _loc2_.nameBox.visible = false;
      }
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.data.creature_instance.id) as CreatureInstance;
      gameView.skillEditorWindow.creature = _loc3_;
      gameView.skillEditorWindow.visible = true;
      UIGlobals.popUpManager.addPopUp(gameView.skillEditorWindow,gameView);
      gameView.skillEditorWindow.x = UIGlobals.relativize(50);
      gameView.skillEditorWindow.y = UIGlobals.relativize(50);
      gameView.skillEditorWindow.enabled = false;
      gameView.skillEditorWindow.draggable = false;
      gameView.skillEditorWindow.showCloseButton = false;
      gameView.skillEditorWindow.pieceBox.enabled = false;
      gameView.skillEditorWindow.addEventListener("SKILL_EDITOR_FIRST_ATTACK_EFFECT_LISTED",this.onFirstAttackEffectVisible);
      gameView.cutsceneView.dialogView.step();
      timer.delay = 3000;
      timer.start();
   }
   
   private function onFirstAttackEffectVisible(param1:Event) : void
   {
      this._firstAttackVisible = true;
      gameView.skillEditorWindow.removeEventListener("SKILL_EDITOR_FIRST_ATTACK_EFFECT_LISTED",this.onFirstAttackEffectVisible);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(Boolean(this._firstAttackVisible) && Boolean(timerComplete))
      {
         return new Result(Result.TRANSITION,new ShowAttackEffect(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;

class ShowAttackEffect extends HandlerState
{
    
   
   private var _complete:Boolean = false;
   
   public function ShowAttackEffect(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.cutsceneView.dialogView.addEventListener("DIALOG_ENABLE_ADD_EFFECT",this.onDialogComplete);
      gameView.cutsceneView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      this._complete = true;
      gameView.cutsceneView.dialogView.removeEventListener("DIALOG_ENABLE_ADD_EFFECT",this.onDialogComplete);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitForEffectAdded(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.util.DelayedCallback;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.effect.Effect;
import com.edgebee.breedr.data.skill.EffectPieceInstance;
import com.edgebee.breedr.data.skill.SkillInstance;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;

class WaitForEffectAdded extends HandlerState
{
    
   
   private var _effectAdded:Boolean = false;
   
   private var _cb:DelayedCallback;
   
   public function WaitForEffectAdded(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.data.creature_instance.id) as CreatureInstance;
      var _loc4_:SkillInstance;
      (_loc4_ = _loc3_.modifiable_skills[0]).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
      gameView.skillEditorWindow.enabled = true;
      gameView.skillEditorWindow.selectorBox.enabled = false;
      gameView.skillEditorWindow.optionsBox.enabled = false;
      gameView.skillEditorWindow.statusBar.enabled = false;
      gameView.skillEditorWindow.pieceBox.enabled = true;
      this._cb = new DelayedCallback(3000,this.onSkillChange);
      this._cb.touch();
   }
   
   private function onSkillChange(param1:PropertyChangeEvent = null) : void
   {
      var _loc5_:EffectPieceInstance = null;
      this._cb = null;
      var _loc2_:HatchingHandler = machine as HatchingHandler;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.data.creature_instance.id) as CreatureInstance;
      var _loc4_:SkillInstance;
      if((_loc4_ = _loc3_.modifiable_skills[0]).pieces.length > 0 && Boolean(_loc4_.pieces[0] as EffectPieceInstance))
      {
         if((Boolean(_loc5_ = _loc4_.pieces[0] as EffectPieceInstance)) && _loc5_.effect_piece.effect.type == Effect.TYPE_ATTACK)
         {
            this._effectAdded = true;
            _loc4_.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
         }
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._effectAdded)
      {
         return new Result(Result.TRANSITION,new ShowInfo(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;
import flash.events.Event;

class ShowInfo extends HandlerState
{
    
   
   private var _complete:Boolean = false;
   
   public function ShowInfo(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.cutsceneView.dialogView.addEventListener("DIALOG_ENABLE_SAVE",this.onDialogComplete);
      gameView.cutsceneView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      this._complete = true;
      gameView.cutsceneView.dialogView.removeEventListener("DIALOG_ENABLE_SAVE",this.onDialogComplete);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitForSave(machine as HatchingHandler));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.HatchingHandler;

class WaitForSave extends HandlerState
{
    
   
   private var _skillsSaved:Boolean = false;
   
   public function WaitForSave(param1:HatchingHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.skillEditorWindow.statusBar.enabled = true;
      gameView.skillEditorWindow.pieceBox.enabled = false;
      client.service.addEventListener("SetSkills",this.onSetSkills);
   }
   
   private function onSetSkills(param1:ServiceEvent) : void
   {
      client.service.removeEventListener("SetSkills",this.onSetSkills);
      gameView.skillEditorWindow.doClose();
      this._skillsSaved = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._skillsSaved)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.cutsceneView.dialogView.step();
      gameView.cutsceneView.dialogView.reset();
      gameView.skillEditorWindow.selectorBox.enabled = true;
      gameView.skillEditorWindow.optionsBox.enabled = true;
      gameView.skillEditorWindow.pieceBox.enabled = true;
      gameView.skillEditorWindow.draggable = true;
      gameView.skillEditorWindow.showCloseButton = true;
      UIGlobals.popUpManager.centerPopUp(gameView.skillEditorWindow);
      gameView.cutsceneView.visible = false;
   }
}
