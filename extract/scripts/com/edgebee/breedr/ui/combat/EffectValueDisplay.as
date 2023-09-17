package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class EffectValueDisplay extends Canvas
   {
      
      private static var _bounceAndFade:Animation;
       
      
      private var _label:String;
      
      private var _color:int = 16777215;
      
      public var useCombatSpeedMultiplier:Boolean = true;
      
      public var infoBox:Box;
      
      public var valueLbl:GradientLabel;
      
      public var infoLbl:GradientLabel;
      
      private var _fadeAnim:AnimationInstance;
      
      private var _layout:Array;
      
      public function EffectValueDisplay()
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
               "CLASS":GradientLabel,
               "ID":"infoLbl",
               "visible":false,
               "colors":[16777215,10066329],
               "STYLES":{
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(48),
                  "FontWeight":"bold"
               }
            },{
               "CLASS":GradientLabel,
               "ID":"valueLbl",
               "colors":[16777215,10066329],
               "STYLES":{
                  "FontColor":16777164,
                  "FontSize":UIGlobals.relativizeFont(64),
                  "FontWeight":"bold"
               }
            }]
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
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(this._label != param1)
         {
            this._label = param1;
            this.update();
         }
      }
      
      public function get color() : int
      {
         return this._color;
      }
      
      public function set color(param1:int) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
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
            _loc1_.addKeyframe(new Keyframe(0.65,-height / 6));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.15,1));
            _loc1_.addKeyframe(new Keyframe(0.85,1));
            _loc1_.addCallback(new Callback(0.75,"fadeStart"));
            _loc1_.addKeyframe(new Keyframe(1.05,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,100));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.blur");
            _loc1_.addKeyframe(new Keyframe(0,3));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.alpha");
            _loc1_.addKeyframe(new Keyframe(0,0.35));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
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
         glowProxy.reset();
         glowProxy.color = 16777215;
         visible = true;
         if(this.useCombatSpeedMultiplier)
         {
            this._fadeAnim.speed = 1.35 * this.client.combatSpeedMultiplier;
         }
         else
         {
            this._fadeAnim.speed = 1.35;
         }
         this._fadeAnim.gotoStartAndPlay();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.valueLbl.text = this.label;
            this.valueLbl.setStyle("FontColor",UIUtils.adjustBrightness2(this.color,10));
            this.valueLbl.colors = [UIUtils.adjustBrightness2(this.color,50),UIUtils.adjustBrightness2(this.color,-50)];
            this.valueLbl.filters = [new GlowFilter(UIUtils.adjustBrightness2(this.color,90),1,3,3,5,1,true),new GlowFilter(UIUtils.adjustBrightness2(this.color,-75),1,5,5,5)];
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
