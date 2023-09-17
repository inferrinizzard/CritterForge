package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import flash.events.Event;
   
   public class IdleDisplay extends Canvas
   {
      
      public static const IDLE:String = "IDLE";
      
      public static const NOT_ENOUGH_PP:String = "NOT_ENOUGH_PP";
      
      public static var NotEnoughPPPng:Class = IdleDisplay_NotEnoughPPPng;
      
      public static var IdlePng:Class = IdleDisplay_IdlePng;
      
      private static var _bounceAndFade:Animation;
       
      
      private var _idle:String;
      
      public var infoBox:Box;
      
      public var idleBmp:BitmapComponent;
      
      private var _fadeAnim:AnimationInstance;
      
      private var _layout:Array;
      
      public function IdleDisplay()
      {
         this._layout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "width":"{width}",
            "height":"{height}",
            "direction":Box.VERTICAL,
            "layoutInvisibleChildren":false,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "horizontalAlign":Box.ALIGN_CENTER,
            "STYLES":{"Gap":UIGlobals.relativize(-12)},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"idleBmp",
               "width":UIGlobals.relativize(64),
               "isSquare":true
            }]
         }];
         super();
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
         glowProxy.color = 0;
         glowProxy.alpha = 0.35;
         glowProxy.blur = 4;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get idle() : String
      {
         return this._idle;
      }
      
      public function set idle(param1:String) : void
      {
         if(this._idle != param1)
         {
            this._idle = param1;
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Track = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         if(!_bounceAndFade)
         {
            _bounceAndFade = new Animation();
            _loc1_ = new Track("y",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(1.25,-height / 4));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.25,1));
            _loc1_.addKeyframe(new Keyframe(1.05,1));
            _loc1_.addCallback(new Callback(0.85,"fadeStart"));
            _loc1_.addKeyframe(new Keyframe(1.25,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,100));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.25,0.35));
            _loc1_.addKeyframe(new Keyframe(1.05,0.35));
            _loc1_.addKeyframe(new Keyframe(1.2,0));
            _bounceAndFade.addTrack(_loc1_);
         }
         this._fadeAnim = this.infoBox.controller.addAnimation(_bounceAndFade);
         this._fadeAnim.addEventListener(AnimationEvent.STOP,this.onAnimationEnd);
         this._fadeAnim.addEventListener(AnimationEvent.CALLBACK,this.onAnimationCallback);
         this._fadeAnim.speed = 1.35;
      }
      
      public function show() : void
      {
         this.infoBox.y = -height / 6;
         colorMatrix.reset();
         visible = true;
         this._fadeAnim.speed = 1.35 * this.client.combatSpeedMultiplier;
         this._fadeAnim.gotoStartAndPlay();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.idle == NOT_ENOUGH_PP)
            {
               this.idleBmp.source = NotEnoughPPPng;
            }
            else
            {
               this.idleBmp.source = IdlePng;
            }
         }
      }
      
      private function onAnimationCallback(param1:AnimationEvent) : void
      {
         if(param1.data == "fadeStart")
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onAnimationEnd(param1:AnimationEvent) : void
      {
      }
   }
}
