package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   
   public class TransparentWindow extends Canvas
   {
      
      private static const _bgColor1:Number = UIUtils.adjustBrightness2(UIGlobals.getStyle("ThemeColor"),-50);
      
      private static const _bgColor2:Number = UIUtils.adjustBrightness2(UIGlobals.getStyle("ThemeColor"),-85);
      
      private static const _borderColor:Number = UIUtils.adjustBrightness2(UIGlobals.getStyle("ThemeColor"),50);
      
      private static var _bgAnim:Animation;
       
      
      private var _bgCycle:Number = 0;
      
      private var _bgAnimInstance:AnimationInstance;
      
      public var bg:Canvas;
      
      private var _layout:Array;
      
      public function TransparentWindow()
      {
         var _loc1_:Track = null;
         this._layout = [{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":Canvas,
               "ID":"bg",
               "percentWidth":0.99,
               "percentHeight":1,
               "STYLES":{
                  "Gap":UIGlobals.relativize(6),
                  "BackgroundAlpha":0.85,
                  "CornerRadius":20,
                  "BorderThickness":2,
                  "BorderColor":_borderColor,
                  "BorderAlpha":1,
                  "BackgroundDirection":Math.PI / 2,
                  "BackgroundColor":[_bgColor1,_bgColor2],
                  "BackgroundRatios":[20,255],
                  "BackgroundSpread":SpreadMethod.REFLECT
               }
            }]
         }];
         super();
         if(!_bgAnim)
         {
            _bgAnim = new Animation();
            _loc1_ = new Track("bgCycle");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _bgAnim.addTrack(_loc1_);
            _bgAnim.loop = true;
            _bgAnim.speed = 0.2;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedFromStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function get bgCycle() : Number
      {
         return this._bgCycle;
      }
      
      public function set bgCycle(param1:Number) : void
      {
         this._bgCycle = param1;
         this.updateBg();
      }
      
      public function startAnimation() : void
      {
         if(Boolean(this._bgAnimInstance) && !this._bgAnimInstance.playing)
         {
            this._bgAnimInstance.play();
         }
      }
      
      public function stopAnimation() : void
      {
         if(this._bgAnimInstance)
         {
            this._bgAnimInstance.stop();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout,false,0);
         this._bgAnimInstance = controller.addAnimation(_bgAnim);
         controller.updateType = Controller.UPDATE_ON_50MS;
         this._bgAnimInstance.play();
         this.bg.border.glowProxy.color = UIGlobals.getStyle("ThemeColor");
         this.bg.border.glowProxy.alpha = 0.85;
         this.bg.border.glowProxy.blur = 15;
         this.bg.border.glowProxy.strength = 4;
         this.bg.border.glowProxy.quality = 2;
      }
      
      private function updateBg() : void
      {
         this.bg.setStyle("BackgroundOffsetY",Interpolation.linear(this.bgCycle,-this.bg.height,this.bg.height * 2,1));
      }
      
      private function onAddedFromStage(param1:Event) : void
      {
         this.startAnimation();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.stopAnimation();
      }
   }
}
