package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.skins.borders.FocusBorder;
   import com.edgebee.atlas.util.Color;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class UIHighlight extends Component
   {
      
      public static var PointerPng:Class = UIHighlight_PointerPng;
      
      public static const PADDING:int = 3;
      
      private static var _last:com.edgebee.breedr.ui.UIHighlight;
      
      private static var _pointerAnim:Animation;
       
      
      private var _target:Component;
      
      private var _interactive:Boolean;
      
      private var _pointer:BitmapComponent;
      
      private var _pointerAnimInstance:AnimationInstance;
      
      public function UIHighlight()
      {
         var _loc1_:Track = null;
         super();
         mouseEnabled = false;
         mouseChildren = false;
         if(!_pointerAnim)
         {
            _pointerAnim = new Animation();
            _loc1_ = new Track("x",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,-5));
            _loc1_.addKeyframe(new Keyframe(1,0));
            _loc1_.addTransitionByKeyframeTime(0.5,Interpolation.quadIn);
            _loc1_.addTransitionByKeyframeTime(1,Interpolation.quadOut);
            _pointerAnim.addTrack(_loc1_);
            _loc1_ = new Track("y",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,5));
            _loc1_.addKeyframe(new Keyframe(1,0));
            _loc1_.addTransitionByKeyframeTime(0.5,Interpolation.quadIn);
            _loc1_.addTransitionByKeyframeTime(1,Interpolation.quadOut);
            _pointerAnim.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,20));
            _loc1_.addKeyframe(new Keyframe(1,0));
            _loc1_.addTransitionByKeyframeTime(0.5,Interpolation.quadIn);
            _loc1_.addTransitionByKeyframeTime(1,Interpolation.quadOut);
            _pointerAnim.addTrack(_loc1_);
            _pointerAnim.loop = true;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedFromStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public static function addHighlight(param1:Component, param2:Boolean = false) : com.edgebee.breedr.ui.UIHighlight
      {
         if(Boolean(_last) && _last.target == param1)
         {
            _last.interactive = param2;
            return _last;
         }
         _last = new com.edgebee.breedr.ui.UIHighlight();
         _last.target = param1;
         _last.interactive = param2;
         layer.addChild(_last);
         return _last;
      }
      
      public static function removeHighlight(param1:com.edgebee.breedr.ui.UIHighlight) : void
      {
         layer.removeChild(param1);
         if(param1 == _last)
         {
            _last = null;
         }
      }
      
      public static function removeLast() : void
      {
         if(_last)
         {
            layer.removeChild(_last);
            _last = null;
         }
      }
      
      private static function get layer() : Component
      {
         return UIGlobals.tooltipLayer;
      }
      
      public function get target() : Component
      {
         return this._target;
      }
      
      public function set target(param1:Component) : void
      {
         if(this._target != param1)
         {
            if(this._target)
            {
               this._target.removeEventListener(Component.RESIZE,this.onTargetResize);
               this._target.removeEventListener(Component.X_CHANGED,this.onTargetMove);
               this._target.removeEventListener(Component.Y_CHANGED,this.onTargetMove);
            }
            this._target = param1;
            if(this._target)
            {
               this._target.addEventListener(Component.RESIZE,this.onTargetResize);
               this._target.addEventListener(Component.X_CHANGED,this.onTargetMove);
               this._target.addEventListener(Component.Y_CHANGED,this.onTargetMove);
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }
      
      public function get interactive() : Boolean
      {
         return this._interactive;
      }
      
      public function set interactive(param1:Boolean) : void
      {
         this._interactive = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:FocusBorder = new FocusBorder(this);
         _loc1_.setStyle("BorderThickness",12);
         if(this.interactive)
         {
            _loc1_.setStyle("BorderColor",16746496);
         }
         else
         {
            _loc1_.setStyle("BorderColor",16746496);
         }
         addChild(_loc1_);
         var _loc2_:Color = new Color(16746496);
         this._pointer = new BitmapComponent();
         this._pointer.source = PointerPng;
         this._pointer.width = UIGlobals.relativize(48);
         this._pointer.height = UIGlobals.relativize(48);
         this._pointer.x = this.target.width + PADDING + 5;
         this._pointer.y = -(this._pointer.height + PADDING + 5);
         if(this.interactive)
         {
            this._pointer.glowProxy.color = 10044416;
         }
         else
         {
            this._pointer.glowProxy.color = 10044416;
         }
         this._pointer.glowProxy.alpha = 1;
         this._pointer.glowProxy.blur = 10;
         this._pointer.glowProxy.strength = 6;
         this._pointer.glowProxy.quality = 2;
         this._pointer.transform.colorTransform = _loc2_.toColorTransform();
         addChild(this._pointer);
         this._pointerAnimInstance = this._pointer.controller.addAnimation(_pointerAnim);
         this._pointerAnimInstance.speed = 1.5;
         this._pointerAnimInstance.play();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.target)
         {
            measuredHeight = this.target.height + PADDING * 2;
            measuredWidth = this.target.width + PADDING * 2;
         }
         else
         {
            measuredHeight = 0;
            measuredWidth = 0;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(!this.target || !stage)
         {
            return;
         }
         var _loc3_:Point = new Point(this.target.x,this.target.y);
         _loc3_ = parent.globalToLocal(this.target.parent.localToGlobal(_loc3_));
         this.x = _loc3_.x - PADDING;
         y = _loc3_.y - PADDING;
         var _loc4_:Point = localToGlobal(new Point(this._pointer.x,this._pointer.y));
         var _loc5_:Matrix = new Matrix();
         if(_loc4_.y < -this._pointer.height / 2)
         {
            _loc5_.scale(1,-1);
            _loc5_.translate(x,y + param2);
            transform.matrix = _loc5_;
         }
         else if(_loc4_.x >= stage.stageWidth + this._pointer.width / 2)
         {
            _loc5_.scale(-1,1);
            _loc5_.translate(x + param1,y);
            transform.matrix = _loc5_;
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
      }
      
      private function onAddedFromStage(param1:Event) : void
      {
         if(Boolean(this._pointerAnimInstance) && !this._pointerAnimInstance.playing)
         {
            this._pointerAnimInstance.play();
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         if(Boolean(this._pointerAnimInstance) && this._pointerAnimInstance.playing)
         {
            this._pointerAnimInstance.stop();
         }
      }
      
      private function onTargetResize(param1:Event) : void
      {
         invalidateSize();
      }
      
      private function onTargetMove(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
