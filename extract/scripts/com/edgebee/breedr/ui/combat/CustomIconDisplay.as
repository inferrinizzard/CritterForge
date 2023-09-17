package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import flash.events.Event;
   
   public class CustomIconDisplay extends Canvas
   {
      
      private static var _anim:Animation;
       
      
      private var _icon:Class;
      
      public var iconBmp:BitmapComponent;
      
      private var _fadeAnim:AnimationInstance;
      
      private var _layout:Array;
      
      public function CustomIconDisplay()
      {
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "centered":true,
            "width":UIGlobals.relativize(64),
            "isSquare":true
         }];
         super();
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
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
      
      override protected function createChildren() : void
      {
         var _loc1_:Track = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         if(!_anim)
         {
            _anim = new Animation();
            _loc1_ = new Track("scaleX");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.85,3));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            _anim.addTrack(_loc1_);
            _loc1_ = new Track("scaleY");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.85,3));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            _anim.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.1,0.5));
            _loc1_.addKeyframe(new Keyframe(1.05,0));
            _anim.addTrack(_loc1_);
            _loc1_ = new Track("colorTransformProxy.offset");
            _loc1_.addKeyframe(new Keyframe(0,255));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
            _anim.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.alpha");
            _loc1_.addKeyframe(new Keyframe(0,0.75));
            _loc1_.addKeyframe(new Keyframe(0.2,0.35));
            _anim.addTrack(_loc1_);
         }
         this._fadeAnim = this.iconBmp.controller.addAnimation(_anim);
         this._fadeAnim.addEventListener(AnimationEvent.STOP,this.onAnimationEnd);
         this._fadeAnim.speed = 0.75;
      }
      
      public function show() : void
      {
         this.iconBmp.scaleX = 1;
         this.iconBmp.scaleY = 1;
         this.iconBmp.colorTransformProxy.reset();
         this.iconBmp.glowProxy.reset();
         this.iconBmp.glowProxy.blur = 10;
         this.iconBmp.glowProxy.color = 11206570;
         this.iconBmp.glowProxy.alpha = 0.75;
         if(this._fadeAnim.playing)
         {
            this._fadeAnim.stop();
         }
         visible = true;
         this._fadeAnim.speed = 0.75 * this.client.combatSpeedMultiplier;
         this._fadeAnim.gotoStartAndPlay();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.iconBmp.source = this.icon;
         }
      }
      
      private function onAnimationEnd(param1:AnimationEvent) : void
      {
         visible = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
