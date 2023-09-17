package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.InterpolationMethod;
   import flash.display.SpreadMethod;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class BreedrButtonSkin extends Skin
   {
      
      private static var _animation:Animation;
       
      
      private var _animProgress:Number = 0;
      
      protected var _layoutBox:Box;
      
      protected var _label:Label;
      
      protected var _currentIcon:DisplayObject;
      
      private var _lastState:String = null;
      
      private var _animInstance:AnimationInstance;
      
      public function BreedrButtonSkin(param1:Component)
      {
         var _loc2_:Track = null;
         super(param1);
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         if(!_animation)
         {
            _animation = new Animation();
            _loc2_ = new Track("animProgress");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(0.05,0));
            _loc2_.addKeyframe(new Keyframe(0.1,1));
            _loc2_.addKeyframe(new Keyframe(0.2,0));
            _loc2_.addKeyframe(new Keyframe(0.3,1));
            _loc2_.addKeyframe(new Keyframe(1,0));
            _animation.addTrack(_loc2_);
            _animation.speed = 2;
         }
      }
      
      protected function get button() : Button
      {
         return component as Button;
      }
      
      protected function get currentIcon() : DisplayObject
      {
         return this._currentIcon;
      }
      
      protected function set currentIcon(param1:DisplayObject) : void
      {
         var _loc2_:String = null;
         if(this._currentIcon != param1)
         {
            if(this._currentIcon)
            {
               this._layoutBox.removeChild(this._currentIcon);
            }
            this._currentIcon = param1;
            if(this._currentIcon)
            {
               _loc2_ = component.getStyle("IconSide","left");
               switch(_loc2_)
               {
                  case "right":
                     this._layoutBox.direction = Box.HORIZONTAL;
                     this._layoutBox.addChild(this._currentIcon);
                     break;
                  case "left":
                     this._layoutBox.direction = Box.HORIZONTAL;
                     this._layoutBox.addChildAt(this._currentIcon,0);
                     break;
                  case "top":
                     this._layoutBox.direction = Box.VERTICAL;
                     this._layoutBox.addChild(this._currentIcon);
                     break;
                  case "bottom":
                     this._layoutBox.direction = Box.VERTICAL;
                     this._layoutBox.addChildAt(this._currentIcon,0);
               }
               this._currentIcon.filters = UIGlobals.fontOutline;
            }
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      protected function get label() : *
      {
         return this.button.label;
      }
      
      protected function set label(param1:*) : void
      {
         if(childrenCreated || childrenCreating)
         {
            this._label.text = param1;
            this._label.visible = !!param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get animProgress() : Number
      {
         return this._animProgress;
      }
      
      public function set animProgress(param1:Number) : void
      {
         if(param1 != this._animProgress)
         {
            this._animProgress = param1;
            invalidateDisplayList();
         }
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      protected function createLayoutContent() : void
      {
         this._label = new Label();
         this._label.setStyle("FontWeight","bold");
         this._label.setStyle("FontSize",component.getStyle("FontSize",12));
         this._label.useHtml = getStyle("HTMLButton",false);
         this.label = this.button.label;
         this._layoutBox.addChild(this._label);
         this.currentIcon = this.button.icon;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Number = NaN;
         super.createChildren();
         this._layoutBox = new Box(Box.HORIZONTAL,Box.ALIGN_CENTER,Box.ALIGN_MIDDLE);
         this._layoutBox.name = "_layoutBox";
         this._layoutBox.setStyle("Gap",UIGlobals.relativize(5));
         this._layoutBox.layoutInvisibleChildren = false;
         if(component.getStyle("Shape") == "circle")
         {
            this._layoutBox.setStyle("Padding",component.getStyle("Padding",6));
         }
         else
         {
            _loc1_ = component.getStyle("Padding",NaN);
            this._layoutBox.setStyle("PaddingLeft",component.getStyle("PaddingLeft",isNaN(_loc1_) ? UIGlobals.relativize(24) : _loc1_));
            this._layoutBox.setStyle("PaddingRight",component.getStyle("PaddingRight",isNaN(_loc1_) ? UIGlobals.relativize(24) : _loc1_));
            this._layoutBox.setStyle("PaddingTop",component.getStyle("PaddingTop",isNaN(_loc1_) ? UIGlobals.relativize(7) : _loc1_));
            this._layoutBox.setStyle("PaddingBottom",component.getStyle("PaddingBottom",isNaN(_loc1_) ? UIGlobals.relativize(7) : _loc1_));
         }
         this.createLayoutContent();
         addChild(this._layoutBox);
         this._animInstance = controller.addAnimation(_animation);
         this._animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(percentWidth == 0)
         {
            measuredWidth = this._layoutBox.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._layoutBox.height;
         }
         if(component.getStyle("Shape") == "circle")
         {
            measuredHeight = measuredWidth;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc19_:Point = null;
         var _loc20_:Number = NaN;
         super.updateDisplayList(param1,param2);
         this._layoutBox.x = component.width / 2 - this._layoutBox.width / 2;
         this._layoutBox.y = component.height / 2 - this._layoutBox.height / 2;
         var _loc3_:Boolean = component.getStyle("ShowBorder",true);
         var _loc4_:String = component.getStyle("Shape","rectangle");
         var _loc5_:Number = Math.max(0,UIGlobals.getStyle("CornerRadius",5));
         var _loc6_:uint = component.getStyle("Color",UIGlobals.getStyle("ThemeColor"));
         var _loc7_:uint = UIUtils.adjustBrightness2(_loc6_,85);
         var _loc8_:uint = UIUtils.adjustBrightness2(_loc6_,-85);
         var _loc9_:uint = component.getStyle("Color2",UIGlobals.getStyle("ThemeColor2"));
         var _loc10_:uint = UIUtils.adjustBrightness2(_loc9_,85);
         var _loc11_:uint = UIUtils.adjustBrightness2(_loc9_,-85);
         buttonMode = true;
         this._layoutBox.glowProxy.color = _loc6_;
         this._layoutBox.glowProxy.alpha = 1;
         this._layoutBox.glowProxy.blur = 5;
         this._layoutBox.glowProxy.strength = 3;
         this._layoutBox.glowProxy.quality = 2;
         this._layoutBox.colorMatrix.reset();
         this._layoutBox.alpha = 1;
         graphics.clear();
         var _loc12_:Matrix = new Matrix();
         var _loc18_:String = SpreadMethod.PAD;
         switch(this.button.state)
         {
            case "disabled":
               buttonMode = false;
               _loc13_ = 3355443;
               _loc14_ = 10066329;
               _loc15_ = 7829367;
               _loc16_ = 3355443;
               _loc17_ = 11184810;
               this._layoutBox.glowProxy.alpha = 0;
               this._layoutBox.alpha = 0.65;
               this._layoutBox.colorMatrix.saturation = -100;
               break;
            case "selected":
               this._layoutBox.glowProxy.color = _loc9_;
               _loc13_ = _loc10_;
               _loc14_ = _loc9_;
               _loc15_ = _loc9_;
               _loc16_ = _loc11_;
               _loc17_ = _loc10_;
               this._layoutBox.y += 1;
               if(this._lastState == "over")
               {
                  this._animInstance.gotoStartAndPlay();
               }
               else if(this._animProgress > 0)
               {
                  _loc15_ = new Color(_loc9_).interpolateTo(new Color(_loc11_),this._animProgress).hex;
                  _loc16_ = new Color(_loc11_).interpolateTo(new Color(_loc10_),this._animProgress).hex;
               }
               break;
            case "down":
               _loc13_ = _loc6_;
               _loc14_ = _loc7_;
               _loc15_ = _loc8_;
               _loc16_ = _loc6_;
               _loc17_ = _loc7_;
               this._layoutBox.y += 1;
               if(this._lastState == "over")
               {
                  this._animInstance.gotoStartAndPlay();
               }
               break;
            case "over":
               _loc13_ = UIUtils.adjustBrightness2(_loc7_,75);
               _loc14_ = UIUtils.adjustBrightness2(_loc6_,75);
               _loc15_ = UIUtils.adjustBrightness2(_loc6_,10);
               _loc16_ = _loc8_;
               _loc17_ = _loc7_;
               this._layoutBox.glowProxy.blur = 15;
               this._layoutBox.glowProxy.strength = 2;
               this._layoutBox.glowProxy.color = 16777215;
               if(this._animProgress > 0)
               {
                  _loc15_ = new Color(_loc15_).interpolateTo(new Color(_loc8_),this._animProgress).hex;
                  _loc16_ = new Color(_loc16_).interpolateTo(new Color(_loc7_),this._animProgress).hex;
               }
               break;
            case "up":
               _loc13_ = _loc7_;
               _loc14_ = _loc6_;
               _loc15_ = _loc6_;
               _loc16_ = _loc8_;
               _loc17_ = _loc7_;
               if(this._animProgress > 0)
               {
                  _loc15_ = new Color(_loc6_).interpolateTo(new Color(_loc8_),this._animProgress).hex;
                  _loc16_ = new Color(_loc8_).interpolateTo(new Color(_loc7_),this._animProgress).hex;
               }
         }
         this._lastState = this.button.state;
         if(_loc4_ == "circle")
         {
            _loc12_.createGradientBox(component.width,component.width,Math.PI / 2);
            graphics.beginGradientFill(GradientType.RADIAL,[_loc15_,_loc16_],[1,1],[0,255],_loc12_,_loc18_,InterpolationMethod.RGB,0);
            graphics.drawCircle(component.width / 2,component.width / 2,component.width / 2 - 1);
            graphics.endFill();
            graphics.beginFill(_loc17_,0.65);
            graphics.drawEllipse(component.width / 4,component.width / 16,component.width / 2,component.width / 4);
            graphics.endFill();
            if(_loc3_)
            {
               _loc12_.createGradientBox(component.width,component.width,Math.PI / 2);
               graphics.lineStyle(2,0);
               graphics.lineGradientStyle(GradientType.LINEAR,[_loc13_,_loc14_],[1,1],[25,255],_loc12_);
               graphics.drawCircle(component.width / 2,component.width / 2,component.width / 2);
            }
         }
         else
         {
            _loc19_ = new Point(component.mouseX,component.mouseY);
            _loc20_ = 0;
            if(_loc19_.x > 0 && _loc19_.x < component.width && _loc19_.y > 0 && _loc19_.y < component.height)
            {
               _loc20_ = _loc19_.x / component.width * 2 - 1;
            }
            _loc12_.createGradientBox(component.width * 1.5,component.height * 4,0,-component.width / 4,-component.height);
            graphics.beginGradientFill(GradientType.RADIAL,[_loc15_,_loc16_],[1,1],[0,255],_loc12_,_loc18_,InterpolationMethod.RGB,_loc20_);
            graphics.drawRoundRect(1,1,component.width - 2,component.height - 2,_loc5_,_loc5_);
            graphics.endFill();
            graphics.beginFill(_loc17_,0.65);
            graphics.drawRoundRect(4,4,component.width - 8,component.height - 8,_loc5_ / 2,_loc5_ / 2);
            graphics.drawRoundRect(4,4 + component.height / 6,component.width - 8,component.height - 8 - component.height / 6,_loc5_ / 2,_loc5_ / 2);
            graphics.endFill();
            if(_loc3_)
            {
               _loc12_.createGradientBox(component.width,component.height,Math.PI / 2);
               graphics.lineStyle(2,0);
               graphics.lineGradientStyle(GradientType.LINEAR,[_loc13_,_loc14_],[1,1],[25,255],_loc12_);
               graphics.drawRoundRect(1,1,component.width - 2,component.height - 2,_loc5_,_loc5_);
            }
         }
      }
      
      protected function onComponentChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            invalidateDisplayList();
         }
         else if(param1.property == "label")
         {
            this.label = param1.newValue;
         }
         else if(param1.property == "icon")
         {
            this.currentIcon = param1.newValue as DisplayObject;
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         invalidateDisplayList();
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
      }
   }
}
