package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class Announcer extends Box
   {
      
      private static var animation:Animation;
       
      
      public var textLbl:GradientLabel;
      
      public var subTextLbl:GradientLabel;
      
      private var animInstance:AnimationInstance;
      
      private var _color:Color;
      
      private var _layout:Array;
      
      public function Announcer()
      {
         var _loc1_:Track = null;
         this._color = new Color();
         this._layout = [{
            "CLASS":GradientLabel,
            "ID":"textLbl",
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(96),
               "FontColor":0,
               "FontWeight":"bold"
            }
         },{
            "CLASS":GradientLabel,
            "ID":"subTextLbl",
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(48),
               "FontColor":0,
               "FontWeight":"bold"
            }
         }];
         super();
         mouseEnabled = false;
         mouseChildren = false;
         layoutInvisibleChildren = false;
         direction = Box.VERTICAL;
         horizontalAlign = Box.ALIGN_CENTER;
         verticalAlign = Box.ALIGN_MIDDLE;
         if(!animation)
         {
            animation = new Animation();
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.35,1));
            _loc1_.addKeyframe(new Keyframe(1.85,1));
            _loc1_.addKeyframe(new Keyframe(2.5,0));
            animation.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,100));
            _loc1_.addKeyframe(new Keyframe(0.35,100));
            _loc1_.addKeyframe(new Keyframe(1,0));
            animation.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.blurX");
            _loc1_.addKeyframe(new Keyframe(0,50));
            _loc1_.addKeyframe(new Keyframe(0.45,50));
            _loc1_.addKeyframe(new Keyframe(0.85,0));
            animation.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.alpha");
            _loc1_.addKeyframe(new Keyframe(0,0.85));
            _loc1_.addKeyframe(new Keyframe(0.35,0.85));
            _loc1_.addKeyframe(new Keyframe(0.85,0));
            animation.addTrack(_loc1_);
         }
         this.animInstance = controller.addAnimation(animation);
         this.animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
         this.color.hex = 16777215;
         this.color.addEventListener(Event.CHANGE,this.onColorChange);
      }
      
      public function get color() : Color
      {
         return this._color;
      }
      
      public function start(param1:*, param2:* = null) : void
      {
         visible = true;
         glowProxy.color = 16777215;
         this.textLbl.text = param1;
         if(param2)
         {
            this.subTextLbl.visible = true;
            this.subTextLbl.text = param2;
         }
         else
         {
            this.subTextLbl.visible = false;
            this.subTextLbl.text = "";
         }
         if(!this.animInstance.playing)
         {
            this.animInstance.gotoStartAndPlay();
         }
      }
      
      public function skip() : void
      {
         if(this.animInstance.playing)
         {
            this.animInstance.gotoEndAndStop();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.onColorChange(null);
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
         visible = false;
         colorMatrix.reset();
         glowProxy.reset();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onColorChange(param1:Event) : void
      {
         this.textLbl.filters = [new GlowFilter(UIUtils.adjustBrightness2(this.color.hex,90),1,3,3,4,1,true),new GlowFilter(UIUtils.adjustBrightness2(this.color.hex,-75),1,4,4,5)];
         this.textLbl.colors = [UIUtils.adjustBrightness2(this.color.hex,50),UIUtils.adjustBrightness2(this.color.hex,-50)];
         this.textLbl.invalidateDisplayList();
         this.subTextLbl.filters = [new GlowFilter(UIUtils.adjustBrightness2(this.color.hex,90),1,3,3,4,1,true),new GlowFilter(UIUtils.adjustBrightness2(this.color.hex,-75),1,4,4,5)];
         this.subTextLbl.colors = [UIUtils.adjustBrightness2(this.color.hex,50),UIUtils.adjustBrightness2(this.color.hex,-50)];
         this.subTextLbl.invalidateDisplayList();
      }
   }
}
