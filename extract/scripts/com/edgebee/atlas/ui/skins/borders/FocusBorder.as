package com.edgebee.atlas.ui.skins.borders
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.utils.UIUtils;
   
   public class FocusBorder extends Border
   {
      
      private static var _pulseAnimation:Animation;
       
      
      private var _borderColor:uint;
      
      private var _animation:AnimationInstance;
      
      public function FocusBorder(param1:Component)
      {
         var _loc2_:Track = null;
         super(param1);
         this._borderColor = getStyle("BorderColor",0);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChanged);
         if(!_pulseAnimation)
         {
            _pulseAnimation = new Animation();
            _loc2_ = new Track("glowProxy.blur");
            _loc2_.addKeyframe(new Keyframe(0,10));
            _loc2_.addKeyframe(new Keyframe(0.5,15));
            _loc2_.addKeyframe(new Keyframe(1,10));
            _loc2_.addTransitionByKeyframeTime(0.5,Interpolation.quadIn);
            _loc2_.addTransitionByKeyframeTime(1,Interpolation.quadOut);
            _pulseAnimation.addTrack(_loc2_);
            _loc2_ = new Track("colorTransformProxy.offset");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(0.5,50));
            _loc2_.addKeyframe(new Keyframe(1,0));
            _loc2_.addTransitionByKeyframeTime(0.5,Interpolation.quadIn);
            _loc2_.addTransitionByKeyframeTime(1,Interpolation.quadOut);
            _pulseAnimation.addTrack(_loc2_);
            _pulseAnimation.loop = true;
         }
         this._animation = controller.addAnimation(_pulseAnimation);
         this._animation.speed = 1.5;
         this._animation.play();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         glowProxy.strength = 5;
         glowProxy.blur = 10;
         glowProxy.alpha = 0.75;
         glowProxy.color = UIUtils.adjustBrightness2(this._borderColor,75);
         glowProxy.quality = 2;
         graphics.clear();
         graphics.lineStyle(2,glowProxy.color,0.75);
         graphics.drawRoundRect(-1,-1,component.width + 2,component.height + 2,5,5);
         graphics.lineStyle(0,0,0);
      }
      
      override protected function onStyleChanged(param1:StyleChangedEvent) : void
      {
         super.onStyleChanged(param1);
         switch(param1.style)
         {
            case "BorderColor":
               this._borderColor = param1.newValue;
         }
         invalidateDisplayList();
      }
   }
}
