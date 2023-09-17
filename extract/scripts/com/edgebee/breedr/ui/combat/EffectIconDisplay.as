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
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class EffectIconDisplay extends Canvas
   {
      
      private static var _bounceAndFade:Animation;
       
      
      private var _skillName:String;
      
      private var _primary:EffectPiece;
      
      private var _secondary:EffectPiece;
      
      private var _isSecondary:Boolean;
      
      private var _color:int = 16777215;
      
      public var infoBox:Box;
      
      public var primaryFxBmp:BitmapComponent;
      
      public var secondaryFxBmp:BitmapComponent;
      
      public var infoLbl:GradientLabel;
      
      private var _fadeAnim:AnimationInstance;
      
      private var _layout:Array;
      
      public function EffectIconDisplay()
      {
         this._layout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "width":"{width}",
            "height":"{height}",
            "direction":Box.VERTICAL,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "horizontalAlign":Box.ALIGN_CENTER,
            "STYLES":{"Gap":UIGlobals.relativize(-12)},
            "CHILDREN":[{
               "CLASS":Box,
               "layoutInvisibleChildren":false,
               "STYLES":{
                  "Gap":UIGlobals.relativize(10),
                  "BackgroundAlpha":0.25,
                  "CornerRadius":10,
                  "Padding":UIGlobals.relativize(10)
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "ID":"primaryFxBmp",
                  "width":UIGlobals.relativize(64),
                  "isSquare":true
               },{
                  "CLASS":BitmapComponent,
                  "ID":"secondaryFxBmp",
                  "width":UIGlobals.relativize(64),
                  "isSquare":true,
                  "visible":false
               }]
            },{
               "CLASS":GradientLabel,
               "ID":"infoLbl",
               "colors":[16777215,10066329],
               "STYLES":{
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(36),
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
      
      public function setEffects(param1:String, param2:EffectPiece, param3:EffectPiece = null, param4:Boolean = false) : void
      {
         this._skillName = param1;
         this._primary = param2;
         this._secondary = param3;
         this._isSecondary = param4;
         this.update();
      }
      
      public function get skillName() : String
      {
         return this._skillName;
      }
      
      public function set skillName(param1:String) : void
      {
         if(this._skillName != param1)
         {
            this._skillName = param1;
            this.update();
         }
      }
      
      public function get primary() : EffectPiece
      {
         return this._primary;
      }
      
      public function set primary(param1:EffectPiece) : void
      {
         if(this._primary != param1)
         {
            this._primary = param1;
            this.update();
         }
      }
      
      public function get secondary() : EffectPiece
      {
         return this._secondary;
      }
      
      public function set secondary(param1:EffectPiece) : void
      {
         if(this._secondary != param1)
         {
            this._secondary = param1;
            this.update();
         }
      }
      
      public function get isSecondary() : Boolean
      {
         return this._isSecondary;
      }
      
      public function set isSecondary(param1:Boolean) : void
      {
         if(this._isSecondary != param1)
         {
            this._isSecondary = param1;
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
            _loc1_.addKeyframe(new Keyframe(0.85,-height / 4));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.15,1));
            _loc1_.addKeyframe(new Keyframe(1.05,1));
            _loc1_.addCallback(new Callback(0.85,"fadeStart"));
            _loc1_.addKeyframe(new Keyframe(1.25,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,100));
            _loc1_.addKeyframe(new Keyframe(0.35,0));
            _bounceAndFade.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.blurY");
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
         this._fadeAnim.speed = 1.35 * this.client.combatSpeedMultiplier;
         this._fadeAnim.gotoStartAndPlay();
      }
      
      private function update() : void
      {
         var _loc1_:EffectPiece = null;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(childrenCreated || childrenCreating)
         {
            this.primaryFxBmp.source = this.primary.icon;
            this.primaryFxBmp.alpha = this.isSecondary ? 0.35 : 1;
            this.secondaryFxBmp.source = !!this.secondary ? this.secondary.icon : null;
            this.secondaryFxBmp.visible = !!this.secondary ? true : false;
            this.secondaryFxBmp.alpha = this.isSecondary ? 1 : 0.35;
            _loc1_ = this.isSecondary ? this.secondary : this.primary;
            _loc2_ = this.isSecondary ? uint(this.secondary.color.hex) : uint(this.primary.color.hex);
            if(this.skillName != null)
            {
               if(this.skillName.length)
               {
                  _loc3_ = this.skillName;
               }
               else
               {
                  _loc3_ = _loc1_.name.value;
               }
               this.infoLbl.visible = true;
            }
            else
            {
               _loc3_ = _loc1_.name.value;
               this.infoLbl.visible = false;
            }
            this.infoLbl.text = _loc3_;
            this.infoLbl.setStyle("FontColor",UIUtils.adjustBrightness2(_loc2_,10));
            this.infoLbl.colors = [UIUtils.adjustBrightness2(_loc2_,50),_loc2_];
            _loc4_ = [new GlowFilter(UIUtils.adjustBrightness2(_loc2_,-50),1,5,5,5)];
            if(this.isSecondary)
            {
               this.primaryFxBmp.filters = null;
               this.secondaryFxBmp.filters = _loc4_;
            }
            else
            {
               this.primaryFxBmp.filters = _loc4_;
               this.secondaryFxBmp.filters = null;
            }
            this.infoLbl.filters = _loc4_;
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
