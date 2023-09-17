package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.TricklingTextArea;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.data.world.DialogLine;
   import com.edgebee.breedr.data.world.NonPlayerCharacter;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import com.edgebee.breedr.ui.world.NpcView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   
   public class DialogView extends Box
   {
      
      public static var MousePng:Class = DialogView_MousePng;
      
      public static var MouseClickPng:Class = DialogView_MouseClickPng;
      
      public static var FemaleBlipWav:Class = DialogView_FemaleBlipWav;
      
      public static var MaleBlipWav:Class = DialogView_MaleBlipWav;
      
      private static var _mouseClick:Animation;
      
      private static const _bgColor1:Number = 4456533;
      
      private static const _bgColor2:Number = 85;
       
      
      private var _dialog:WeakReference;
      
      private var _npcView:WeakReference;
      
      private var _clickToContinueAlpha:Number = 0;
      
      public var nameLbl:Label;
      
      public var dialogTxt:TricklingTextArea;
      
      public var clickToContinueOn:BitmapComponent;
      
      public var clickToContinueOff:BitmapComponent;
      
      public var clickToContinueBox:Box;
      
      public var dialogBox:Box;
      
      private var _timer:Timer;
      
      private var _fade:AnimationInstance;
      
      private var _mouseClickInstance:AnimationInstance;
      
      private var _lineIndex:int = -1;
      
      public var globalParams:Object;
      
      private var _currentHighlight:com.edgebee.breedr.ui.UIHighlight;
      
      private var _previousY:Number;
      
      public var window:TransparentWindow;
      
      private var _layout:Array;
      
      private var _innerLayout:Array;
      
      public function DialogView()
      {
         var _loc1_:Track = null;
         this._dialog = new WeakReference(null,Dialog);
         this._npcView = new WeakReference(null,NpcView);
         this._timer = new Timer(3000);
         this.globalParams = {};
         this._layout = [{
            "CLASS":TransparentWindow,
            "ID":"window",
            "percentWidth":1,
            "percentHeight":1
         }];
         this._innerLayout = [{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "direction":Box.VERTICAL,
            "STYLES":{
               "Gap":UIGlobals.relativize(6),
               "Padding":UIGlobals.relativize(12)
            },
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"nameLbl",
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "FontColor":14539434,
                  "FontSize":UIGlobals.relativizeFont(18),
                  "FontWeight":"bold"
               }
            },{
               "CLASS":TricklingTextArea,
               "ID":"dialogTxt",
               "percentWidth":1,
               "percentHeight":1,
               "useHtml":true,
               "STYLES":{
                  "TricklingSpeed":80,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(19)
               },
               "filters":UIGlobals.fontOutline
            },{
               "CLASS":Box,
               "ID":"clickToContinueBox",
               "horizontalAlign":Box.ALIGN_RIGHT,
               "percentWidth":1,
               "CHILDREN":[{
                  "CLASS":Canvas,
                  "width":UIGlobals.relativize(20),
                  "height":UIGlobals.relativize(20),
                  "CHILDREN":[{
                     "CLASS":BitmapComponent,
                     "ID":"clickToContinueOff",
                     "source":MousePng,
                     "width":UIGlobals.relativize(20),
                     "height":UIGlobals.relativize(20),
                     "filters":UIGlobals.fontOutline
                  },{
                     "CLASS":BitmapComponent,
                     "ID":"clickToContinueOn",
                     "source":MouseClickPng,
                     "visible":false,
                     "width":UIGlobals.relativize(20),
                     "height":UIGlobals.relativize(20),
                     "filters":UIGlobals.fontOutline.concat(new GlowFilter(16777215,0.25,3,3,2))
                  }]
               }]
            }]
         }];
         super(Box.VERTICAL,Box.ALIGN_CENTER);
         mouseChildren = false;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         if(!_mouseClick)
         {
            _mouseClick = new Animation();
            _loc1_ = new Track("clickToContinueAlpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _mouseClick.addTrack(_loc1_);
            _mouseClick.loop = true;
            _mouseClick.speed = 0.5;
         }
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get dialog() : Dialog
      {
         return this._dialog.get() as Dialog;
      }
      
      public function set dialog(param1:Dialog) : void
      {
         if(Boolean(this.dialog) && Boolean(this.line))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         this._dialog.reset(param1);
         this.reset();
      }
      
      public function get npcView() : NpcView
      {
         return this._npcView.get() as NpcView;
      }
      
      public function set npcView(param1:NpcView) : void
      {
         if(this.npcView != param1)
         {
            this._npcView.reset(param1);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         UIUtils.performLayout(this,this.window.bg,this._innerLayout);
         this._mouseClickInstance = controller.addAnimation(_mouseClick);
         this.dialogTxt.addEventListener(TricklingTextArea.START_TRICKLING,this.onStartTrickling);
         this.dialogTxt.addEventListener(TricklingTextArea.TRICKLED,this.onStopTrickling);
         this.window.stopAnimation();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         if(param1)
         {
            mouseEnabled = true;
            super.doSetVisible(param1);
            this.window.startAnimation();
            if(this._fade)
            {
               this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
               this._fade.stop();
            }
            this._fade = controller.animateTo({"alpha":1});
            this._fade.speed = 4;
            this._fade.addEventListener(AnimationEvent.STOP,this.onFadeStop);
         }
         else
         {
            mouseEnabled = false;
            this.clickToContinueBox.visible = false;
            if(this._fade)
            {
               this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
               this._fade.stop();
            }
            this._fade = controller.animateTo({"alpha":0});
            this._fade.speed = 3;
            this._fade.addEventListener(AnimationEvent.STOP,this.onFadeStop);
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
      }
      
      public function get clickToContinueAlpha() : Number
      {
         return this._clickToContinueAlpha;
      }
      
      public function set clickToContinueAlpha(param1:Number) : void
      {
         this._clickToContinueAlpha = param1;
         this.clickToContinueOn.visible = this.clickToContinueAlpha > 0.75;
         this.clickToContinueOff.visible = this.clickToContinueAlpha <= 0.75;
      }
      
      public function reset() : void
      {
         this._lineIndex = -1;
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.dialogTxt.text = "";
         if(this._currentHighlight)
         {
            com.edgebee.breedr.ui.UIHighlight.removeHighlight(this._currentHighlight);
            this._currentHighlight = null;
         }
         if(this.isCutsceneDialog)
         {
            this.gameView.cutsceneView.bgImg.source = null;
         }
      }
      
      public function skipToLine(param1:String) : void
      {
         var _loc2_:int = this._lineIndex;
         while(_loc2_ < this.dialog.lines.length)
         {
            if(_loc2_ >= 0 && this.dialog.lines[_loc2_].uid == param1)
            {
               break;
            }
            ++this._lineIndex;
            _loc2_++;
         }
      }
      
      public function step(param1:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Component = null;
         ++this._lineIndex;
         if(!this.line)
         {
            visible = false;
            dispatchEvent(new Event(Event.COMPLETE,true));
            return;
         }
         visible = true;
         if(param1 == null)
         {
            param1 = this.globalParams;
         }
         if(this.line.flags & DialogLine.ALT_POSITION)
         {
            if(isNaN(this._previousY))
            {
               this._previousY = y;
               y -= height * 1.5;
            }
         }
         else if(!isNaN(this._previousY))
         {
            y = this._previousY;
            this._previousY = NaN;
         }
         var _loc2_:String = this.line.text.value;
         var _loc3_:Number = 0;
         if(this.line.flags & DialogLine.HAS_TTL)
         {
            if(!this.line.data.hasOwnProperty("ttl") || !(this.line.data.ttl is Number))
            {
               throw new Error("This dialog line has the ttl flag but no ttl data");
            }
            _loc3_ = Number(this.line.data.ttl);
         }
         if(this.line.flags & DialogLine.REQUIRES_PARAM)
         {
            if(param1 == null)
            {
               throw new Error("This dialog requires parameters " + this.line.data.params);
            }
            if(!this.line.data.hasOwnProperty("params") || !(this.line.data.params is Array))
            {
               throw new Error("This dialog line has the params flag but no params data");
            }
            for each(_loc4_ in this.line.data.params)
            {
               if(!param1.hasOwnProperty(_loc4_))
               {
                  throw new Error("Missing param " + _loc4_);
               }
            }
            _loc2_ = Utils.formatString(_loc2_,param1);
         }
         if(this.line.flags & DialogLine.SWAP_NPC)
         {
            this.npcView.setNpcAndExpression(this.line.npc,this.line.flags & DialogLine.EXPRESSIONS_MASK);
         }
         else
         {
            this.npcView.setNpcAndExpression(this.dialog.npc,this.line.flags & DialogLine.EXPRESSIONS_MASK);
         }
         if(this.line.flags & DialogLine.USE_BG)
         {
            if(this.isCutsceneDialog)
            {
               this.gameView.cutsceneView.bgImg.source = UIGlobals.getAssetPath(this.line.bg);
            }
         }
         if(this.line.flags & DialogLine.HIGHLIGHT_COMPONENT)
         {
            if(!this.line.data.hasOwnProperty("highlight"))
            {
               throw new Error("Dialog line data is missing highlight parameter");
            }
            if(this._currentHighlight)
            {
               com.edgebee.breedr.ui.UIHighlight.removeHighlight(this._currentHighlight);
               this._currentHighlight = null;
            }
            _loc5_ = UIGlobals.namedObjects.get(this.line.data.highlight) as Component;
            this._currentHighlight = com.edgebee.breedr.ui.UIHighlight.addHighlight(_loc5_);
         }
         else if(this._currentHighlight)
         {
            com.edgebee.breedr.ui.UIHighlight.removeHighlight(this._currentHighlight);
            this._currentHighlight = null;
         }
         this.print(this.line.npc,_loc2_,_loc3_,!(this.line.flags & DialogLine.NO_CLICK));
      }
      
      private function onFadeStop(param1:AnimationEvent) : void
      {
         this._fade.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
         this._fade = null;
         if(alpha < 0.1)
         {
            super.doSetVisible(false);
            this._mouseClickInstance.stop();
            this.window.stopAnimation();
            if(Boolean(this.line) && !(this.line.flags & DialogLine.PAUSE_ON_COMPLETE))
            {
               this.step();
            }
         }
      }
      
      private function get isCutsceneDialog() : Boolean
      {
         return this == this.gameView.cutsceneView.dialogView;
      }
      
      private function print(param1:NonPlayerCharacter, param2:String, param3:uint = 0, param4:Boolean = true) : void
      {
         visible = true;
         this.nameLbl.text = param1.name;
         if(param1.is_female)
         {
            this.dialogTxt.sound = FemaleBlipWav;
         }
         else
         {
            this.dialogTxt.sound = MaleBlipWav;
         }
         this.dialogTxt.text = param2;
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.stop();
         if(param3 > 0)
         {
            this._timer.delay = param3;
            this._timer.repeatCount = 1;
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._timer.start();
         }
         if(param4)
         {
            this._mouseClickInstance.play();
         }
         else
         {
            this._mouseClickInstance.stop();
         }
         this.clickToContinueBox.visible = param4;
      }
      
      private function get line() : DialogLine
      {
         if(this._lineIndex >= 0)
         {
            return this.dialog.lines[this._lineIndex];
         }
         return null;
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         if(this.line)
         {
            if(this.line.flags & DialogLine.EVENT_ON_COMPLETE)
            {
               dispatchEvent(new Event(this.line.data.event));
            }
            if(!(this.line.flags & DialogLine.PAUSE_ON_COMPLETE))
            {
               this.step();
            }
         }
         if(Boolean(this._currentHighlight) && (!this.line || !(this.line.flags & DialogLine.HIGHLIGHT_COMPONENT)))
         {
            com.edgebee.breedr.ui.UIHighlight.removeHighlight(this._currentHighlight);
            this._currentHighlight = null;
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(this.line.flags & DialogLine.NO_CLICK)
         {
            return;
         }
         this.clickToContinueBox.visible = false;
         if(this.dialogTxt.trickling)
         {
            this.dialogTxt.flush();
         }
         else
         {
            visible = false;
            if(this.line.flags & DialogLine.EVENT_ON_COMPLETE)
            {
               dispatchEvent(new Event(this.line.data.event));
            }
            if(this._currentHighlight)
            {
               com.edgebee.breedr.ui.UIHighlight.removeHighlight(this._currentHighlight);
               this._currentHighlight = null;
            }
         }
      }
      
      private function onStartTrickling(param1:Event) : void
      {
         if(Boolean(this.npcView) && Boolean(this.npcView.npcImg))
         {
            this.npcView.npcImg.talking = true;
         }
      }
      
      private function onStopTrickling(param1:Event) : void
      {
         if(Boolean(this.npcView) && Boolean(this.npcView.npcImg))
         {
            this.npcView.npcImg.talking = false;
         }
      }
   }
}
