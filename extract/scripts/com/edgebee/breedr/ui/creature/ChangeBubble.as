package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class ChangeBubble extends Box
   {
      
      public static const PositivePopWav:Class = ChangeBubble_PositivePopWav;
      
      public static const NegativePopWav:Class = ChangeBubble_NegativePopWav;
       
      
      private var _delta:Number;
      
      private var _icon:Class;
      
      private var _center:Point;
      
      private var _anim:Animation;
      
      private var _animInstance:AnimationInstance;
      
      private var _onStage:Boolean = false;
      
      private var _timer:Timer;
      
      public var iconBmp:BitmapComponent;
      
      public var deltaLbl:GradientLabel;
      
      private var _layout:Array;
      
      public function ChangeBubble()
      {
         this._timer = new Timer(0,1);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "isSquare":true,
            "width":UIGlobals.relativize(24),
            "filters":UIGlobals.fontOutline
         },{
            "CLASS":GradientLabel,
            "ID":"deltaLbl",
            "filters":UIGlobals.fontOutline,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(36),
               "FontWeight":"bold"
            }
         }];
         super(Box.HORIZONTAL,Box.ALIGN_CENTER,Box.ALIGN_MIDDLE);
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         dropShadowProxy.alpha = 1;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get delta() : Number
      {
         return this._delta;
      }
      
      public function set delta(param1:Number) : void
      {
         if(this._delta != param1)
         {
            this._delta = param1;
            this.update();
         }
      }
      
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(param1:Class) : void
      {
         if(this._icon != param1)
         {
            this._icon = param1;
            this.update();
         }
      }
      
      public function get center() : Point
      {
         return this._center;
      }
      
      public function set center(param1:Point) : void
      {
         if(this._center != param1)
         {
            this._center = param1;
         }
      }
      
      public function get delay() : Number
      {
         return this._timer.delay;
      }
      
      public function set delay(param1:Number) : void
      {
         if(this._timer.delay != param1)
         {
            this._timer.delay = param1;
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(this.center) && measuredWidth > 0)
         {
            x = this.center.x - measuredWidth / 2;
            y = this.center.y - measuredHeight / 2;
            this.center = null;
            this.start();
         }
      }
      
      private function start() : void
      {
         var _loc1_:Track = null;
         if((childrenCreated || childrenCreating) && this._onStage && this.center == null && !this._timer.running)
         {
            visible = true;
            this._anim = new Animation();
            _loc1_ = new Track("x",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.1,-measuredWidth * 0.05));
            _loc1_.addKeyframe(new Keyframe(0.2,0));
            _loc1_.addTransitionByKeyframeTime(0.1,Interpolation.bounce);
            this._anim.addTrack(_loc1_);
            _loc1_ = new Track("scaleX");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.1,1.1));
            _loc1_.addKeyframe(new Keyframe(0.2,1));
            _loc1_.addTransitionByKeyframeTime(0.1,Interpolation.bounce);
            this._anim.addTrack(_loc1_);
            _loc1_ = new Track("y",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.1,-measuredHeight * 0.1));
            _loc1_.addKeyframe(new Keyframe(0.2,0));
            _loc1_.addKeyframe(new Keyframe(1,-15));
            _loc1_.addTransitionByKeyframeTime(0.1,Interpolation.bounce);
            this._anim.addTrack(_loc1_);
            _loc1_ = new Track("scaleY");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.1,1.2));
            _loc1_.addKeyframe(new Keyframe(0.2,1));
            _loc1_.addTransitionByKeyframeTime(0.1,Interpolation.bounce);
            this._anim.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.5,1));
            _loc1_.addKeyframe(new Keyframe(1,0));
            this._anim.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,85));
            _loc1_.addKeyframe(new Keyframe(0.2,0));
            this._anim.addTrack(_loc1_);
            this._anim.speed = 0.75;
            this._animInstance = controller.addAnimation(this._anim);
            this._animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
            this._animInstance.gotoStartAndPlay();
            if(this.delta > 0)
            {
               UIGlobals.playSound(PositivePopWav);
            }
            else if(this.delta < 0)
            {
               UIGlobals.playSound(NegativePopWav);
            }
         }
      }
      
      private function update() : void
      {
         var _loc1_:String = null;
         if(childrenCreated || childrenCreating)
         {
            this.iconBmp.source = this.icon;
            if(this.delta > 0)
            {
               _loc1_ = "+";
               this.deltaLbl.colors = [65280,16777215];
            }
            else if(this.delta < 0)
            {
               _loc1_ = "";
               this.deltaLbl.colors = [16711680,16777215];
            }
            this.deltaLbl.text = _loc1_ + this.delta.toString();
            this.start();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         this.start();
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
         this._animInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationStop);
         if(Boolean(parent) && parent.getChildIndex(this) >= 0)
         {
            parent.removeChild(this);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._onStage = true;
         if(this._timer.delay > 0)
         {
            this._timer.start();
         }
         this.start();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this._onStage = false;
         if(this._animInstance.playing)
         {
            this._animInstance.stop();
         }
      }
   }
}
