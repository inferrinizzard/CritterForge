package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.text.TextFormatAlign;
   
   public class BreedrProgressBarSkin extends Skin
   {
      
      private static var _anim:Animation;
       
      
      private var _displayedValue:Number = 0;
      
      private var _barColorOffset:Number = 0;
      
      private var _track:Sprite;
      
      private var _bar:Shape;
      
      private var _label:Label;
      
      private var _bgColor:uint;
      
      private var _bgAlpha:Number;
      
      private var _fgColor:uint;
      
      private var _fgAlpha:Number;
      
      private var _offset:Number;
      
      private var _showLabel:Boolean;
      
      private var _labelType:String;
      
      private var _animated:Boolean;
      
      private var _animationSpeed:Number;
      
      private var _animationInterpolation:Function;
      
      private var _sound:Class;
      
      private var _currentAnim:AnimationInstance;
      
      private var _soundChannel:SoundChannel;
      
      private var _barAnim:AnimationInstance;
      
      public function BreedrProgressBarSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChanged);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onComponentStyleChanged);
         this._bgColor = getStyle("BackgroundColor",0);
         this._bgAlpha = getStyle("BackgroundAlpha",1);
         this._fgColor = getStyle("ForegroundColor",0);
         this._fgAlpha = getStyle("ForegroundAlpha",1);
         this._offset = getStyle("BarOffset",0);
         this._showLabel = getStyle("ShowLabel",false);
         this._labelType = getStyle("LabelType","fraction");
         this._animated = getStyle("Animated",false);
         this._sound = getStyle("Sound",null);
         this._animationSpeed = getStyle("AnimationSpeed",2);
         this._animationInterpolation = getStyle("AnimationInterpolation",Interpolation.cubicOut);
      }
      
      protected function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      protected function get progressBar() : ProgressBar
      {
         return component as ProgressBar;
      }
      
      public function get displayedValue() : Number
      {
         return this._displayedValue;
      }
      
      public function set displayedValue(param1:Number) : void
      {
         if(this._displayedValue != param1)
         {
            this._displayedValue = param1;
            invalidateDisplayList();
         }
      }
      
      public function get barColorOffset() : Number
      {
         return this._barColorOffset;
      }
      
      public function set barColorOffset(param1:Number) : void
      {
         if(this._barColorOffset != param1)
         {
            this._barColorOffset = param1;
            this._bar.transform.colorTransform = new ColorTransform(1,1,1,1,param1,param1,param1);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._track = new Sprite();
         addChild(this._track);
         this._bar = new Shape();
         this._track.addChild(this._bar);
         this._bar.filters = [new GlowFilter(new Color(this._fgColor).brighter(-10).hex,0.85,7,4,2)];
         this._label = new Label();
         if(this._showLabel)
         {
            addChild(this._label);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Rectangle = new Rectangle();
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Number = this._offset;
         if(this.progressBar.orientation == ProgressBar.HORIZONTAL)
         {
            _loc3_.width = this.progressBar.width;
            _loc3_.height = this.progressBar.height;
            if(this.progressBar.maximum > 0)
            {
               _loc4_.width = Math.max(0,this.displayedValue / this.progressBar.maximum * (_loc3_.width - 2 * _loc5_));
               _loc4_.width = Math.min(_loc4_.width,_loc3_.width - 2 * _loc5_);
            }
            else
            {
               _loc4_.width = 0;
            }
            _loc4_.height = Math.max(0,_loc3_.height - 2 * _loc5_);
            if(this.progressBar.direction == ProgressBar.RIGHT)
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_;
            }
            else
            {
               _loc4_.x = _loc5_ + (_loc3_.width - 2 * _loc5_ - _loc4_.width);
               _loc4_.y = _loc5_;
            }
            if(this._showLabel)
            {
               this._label.visible = true;
               _loc10_ = UIUtils.adjustBrightness2(getStyle("FontColor"),-85);
               if(this._labelType == "fraction")
               {
                  this._label.text = Utils.formatString("{v} / {m}",{
                     "v":Utils.abreviateNumber(int(Math.round(this.displayedValue)),0),
                     "m":Utils.abreviateNumber(this.progressBar.maximum,0)
                  });
               }
               else if(this._labelType == "percentage")
               {
                  _loc11_ = 0;
                  if(this.progressBar.maximum > 0)
                  {
                     _loc11_ = 100 * (this.displayedValue / this.progressBar.maximum);
                  }
                  this._label.text = int(_loc11_).toString() + "%";
               }
               else if(this._labelType == "value")
               {
                  this._label.text = int(Math.round(this.displayedValue)).toString();
               }
               this._label.alignment = TextFormatAlign.CENTER;
               if(this.progressBar.direction == ProgressBar.RIGHT)
               {
                  if(this._label.width < _loc3_.width - _loc4_.width)
                  {
                     this._label.x = _loc4_.x + _loc4_.width + 3;
                  }
                  else
                  {
                     this._label.x = _loc4_.x + _loc4_.width - this._label.width;
                  }
               }
               else if(this._label.width < _loc3_.width - _loc4_.width)
               {
                  this._label.x = _loc4_.x - (this._label.width + 3);
               }
               else
               {
                  this._label.x = _loc4_.x;
               }
               this._label.y = this.progressBar.height / 2 - this._label.height / 2;
               this._label.setStyle("FontColor",getStyle("FontColor"));
               this._label.setStyle("FontWeight",getStyle("FontWeight"));
               this._label.setStyle("FontSize",getStyle("FontSize"));
               this._label.filters = [new GlowFilter(_loc10_,1,2,2,8,1)];
            }
            else
            {
               this._label.visible = false;
               this._label.filters = null;
            }
         }
         else
         {
            _loc3_.width = this.progressBar.width;
            _loc3_.height = this.progressBar.height;
            _loc4_.width = Math.max(0,_loc3_.width - 2 * _loc5_);
            if(this.progressBar.maximum > 0)
            {
               _loc4_.height = Math.max(0,this.displayedValue / this.progressBar.maximum * (_loc3_.height - 2 * _loc5_));
            }
            else
            {
               _loc4_.height = 0;
            }
            if(this.progressBar.direction == ProgressBar.UP)
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_ + (_loc3_.height - 2 * _loc5_ - _loc4_.height);
            }
            else
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_;
            }
         }
         var _loc6_:Number = component.getStyle("CornerRadius",0);
         var _loc7_:uint = component.getStyle("ThemeColor");
         var _loc8_:uint = component.getStyle("ThemeColor");
         if(this._fgColor != 0)
         {
            _loc8_ = this._fgColor;
         }
         var _loc9_:Matrix = new Matrix();
         _loc6_ = Math.min(component.height,_loc6_);
         this._track.graphics.clear();
         _loc9_.createGradientBox(_loc3_.width,_loc3_.height,Math.PI / 2);
         this._track.graphics.beginGradientFill(GradientType.LINEAR,[this._bgColor,UIUtils.adjustBrightness2(this._bgColor,35)],[this._bgAlpha,this._bgAlpha],[0,255],_loc9_);
         this._track.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,_loc6_,_loc6_);
         this._track.graphics.endFill();
         this._track.graphics.lineStyle(2,0);
         _loc9_.createGradientBox(_loc3_.width,_loc3_.height,Math.PI / 2);
         this._track.graphics.lineGradientStyle(GradientType.LINEAR,[UIUtils.adjustBrightness2(this._bgColor,35),this._bgColor],[this._bgAlpha,this._bgAlpha],[0,255],_loc9_);
         this._track.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,_loc6_,_loc6_);
         this._track.graphics.lineStyle(0,0);
         this._bar.graphics.clear();
         if(_loc4_.width > 2)
         {
            _loc9_.createGradientBox(_loc4_.width,_loc4_.height,Math.PI / 2);
            this._bar.graphics.beginGradientFill(GradientType.LINEAR,[UIUtils.adjustBrightness2(_loc8_,-25),UIUtils.adjustBrightness2(_loc8_,25)],[this._fgAlpha,this._fgAlpha],[0,255],_loc9_);
            this._bar.graphics.drawRoundRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height,_loc6_,_loc6_);
            this._bar.graphics.endFill();
            this._bar.graphics.beginFill(16777215,0.25);
            this._bar.graphics.drawRoundRect(_loc4_.x + 1,_loc4_.y + 1,_loc4_.width - 2,_loc4_.height,_loc6_,_loc6_);
            this._bar.graphics.drawRoundRect(_loc4_.x + 1,_loc4_.y + 1 + _loc4_.height / 2,_loc4_.width - 2,_loc4_.height - _loc4_.height / 2,_loc6_,_loc6_);
            this._bar.graphics.endFill();
         }
      }
      
      private function onComponentChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Track = null;
         if(param1.property == "value" && this._animated)
         {
            if(Boolean(this._currentAnim) && this._currentAnim.playing)
            {
               this._currentAnim.stop();
            }
            this._currentAnim = controller.animateTo({"displayedValue":param1.newValue},{"displayedValue":this._animationInterpolation},false);
            this._currentAnim.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
            this._currentAnim.speed = this._animationSpeed;
            this._currentAnim.play();
            if(!_anim)
            {
               _anim = new Animation();
               _loc2_ = new Track("barColorOffset");
               _loc2_.addKeyframe(new Keyframe(0,100));
               _loc2_.addKeyframe(new Keyframe(0.5,0));
               _anim.addTrack(_loc2_);
            }
            if(!this._barAnim)
            {
               this._barAnim = controller.addAnimation(_anim);
            }
            this._barAnim.play();
            if(this._sound)
            {
               this._soundChannel = this.client.sndManager.play(this._sound,0,9999);
            }
         }
         else
         {
            if(param1.property == "value")
            {
               this.displayedValue = param1.newValue as Number;
            }
            invalidateDisplayList();
         }
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
         if(this._soundChannel)
         {
            this._soundChannel.stop();
         }
      }
      
      private function onComponentStyleChanged(param1:StyleChangedEvent) : void
      {
         switch(param1.style)
         {
            case "BackgroundColor":
               this._bgColor = param1.newValue;
               break;
            case "BackgroundAlpha":
               this._bgAlpha = param1.newValue;
               break;
            case "ForegroundColor":
               this._fgColor = param1.newValue;
               break;
            case "ForegroundAlpha":
               this._fgAlpha = param1.newValue;
               break;
            case "BarOffset":
               this._offset = param1.newValue;
               break;
            case "LabelType":
               this._labelType = param1.newValue;
               break;
            case "Animated":
               this._animated = param1.newValue;
               break;
            case "AnimationSpeed":
               this._animationSpeed = param1.newValue;
               break;
            case "AnimationInterpolation":
               this._animationInterpolation = param1.newValue;
               break;
            case "Sound":
               this._sound = param1.newValue;
               break;
            case "ShowLabel":
               this._showLabel = param1.newValue;
               if(this._showLabel && !getChildIndex(this._label))
               {
                  addChild(this._label);
               }
               if(!this._showLabel && Boolean(getChildIndex(this._label)))
               {
                  removeChild(this._label);
               }
         }
      }
   }
}
