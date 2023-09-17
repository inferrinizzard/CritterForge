package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class ValueMeter extends Canvas
   {
      
      public static const LEFT:String = "LEFT";
      
      public static const RIGHT:String = "RIGHT";
       
      
      private var _target:WeakReference;
      
      private var _orientation:String = "LEFT";
      
      private var _property:String;
      
      private var _maxProperty:String;
      
      private var _icon:Class;
      
      private var _color:Color;
      
      private var _anim:Animation;
      
      private var _pulseAnim:AnimationInstance;
      
      public var iconBmp:BitmapComponent;
      
      public var progressBar:ProgressBar;
      
      private var _layout:Array;
      
      public function ValueMeter()
      {
         this._target = new WeakReference(null,EventDispatcher);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "percentHeight":1,
            "isSquare":true
         },{
            "CLASS":ProgressBar,
            "ID":"progressBar",
            "percentWidth":0.85,
            "percentHeight":0.6,
            "STYLES":{
               "ShowLabel":true,
               "Animated":true,
               "FontSize":UIGlobals.relativizeFont(17),
               "BarOffset":-2,
               "LabelType":"value",
               "FontWeight":"bold"
            }
         }];
         super();
         this._color = new Color(16777215);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get target() : EventDispatcher
      {
         return this._target.get() as EventDispatcher;
      }
      
      public function set target(param1:EventDispatcher) : void
      {
         if(this.target != param1)
         {
            if(this.target)
            {
               this.target.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTargetChange);
            }
            this._target.reset(param1);
            if(this.target)
            {
               this.target.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTargetChange);
            }
            this.update();
         }
      }
      
      public function get orientation() : String
      {
         return this._orientation;
      }
      
      public function set orientation(param1:String) : void
      {
         if(this._orientation != param1)
         {
            this._orientation = param1;
            this.doLayout();
         }
      }
      
      public function get property() : String
      {
         return this._property;
      }
      
      public function set property(param1:String) : void
      {
         if(this._property != param1)
         {
            this._property = param1;
         }
      }
      
      public function get maxProperty() : String
      {
         return this._maxProperty;
      }
      
      public function set maxProperty(param1:String) : void
      {
         if(this._maxProperty != param1)
         {
            this._maxProperty = param1;
         }
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
            this.doLayout();
         }
      }
      
      public function get color() : Color
      {
         return this._color;
      }
      
      public function set color(param1:Color) : void
      {
         if(this._color.hex != param1.hex)
         {
            this._color.hex = param1.hex;
            this.doLayout();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.doLayout();
         this.update();
      }
      
      private function doLayout() : void
      {
         var _loc1_:ColorTransform = null;
         var _loc2_:Track = null;
         if(childrenCreated || childrenCreating)
         {
            this.progressBar.setStyle("ForegroundColor",this.color.hex);
            this.progressBar.setStyle("FontColor",this.color.brighter(85).hex);
            if(this.orientation == RIGHT)
            {
               this.progressBar.direction = ProgressBar.RIGHT;
               this.progressBar.x = width - this.progressBar.width;
            }
            else
            {
               this.progressBar.direction = ProgressBar.LEFT;
               this.progressBar.x = 0;
               removeChild(this.iconBmp);
               addChild(this.iconBmp);
            }
            this.iconBmp.source = this.icon;
            _loc1_ = new ColorTransform();
            _loc1_.redMultiplier = this.color.red;
            _loc1_.greenMultiplier = this.color.green;
            _loc1_.blueMultiplier = this.color.blue;
            _loc1_.redOffset = Math.max(150,this.color.red255);
            _loc1_.greenOffset = Math.max(150,this.color.green255);
            _loc1_.blueOffset = Math.max(150,this.color.blue255);
            this.iconBmp.bitmap.transform.colorTransform = _loc1_;
            this.iconBmp.glowProxy.color = this.color.brighter(-50).hex;
            this.iconBmp.glowProxy.alpha = 0.8;
            this.iconBmp.glowProxy.blur = 6;
            this.iconBmp.glowProxy.strength = 3;
            validateNow(true);
            this.progressBar.y = (height - this.progressBar.height) / 2;
            if(this.orientation == RIGHT)
            {
               this.progressBar.x = width - this.progressBar.width;
               this.iconBmp.x = 0;
            }
            else
            {
               this.progressBar.x = 0;
               this.iconBmp.x = width - this.iconBmp.width;
            }
            if(this._pulseAnim)
            {
               this.iconBmp.controller.removeAnimation(this._pulseAnim);
            }
            this._anim = new Animation();
            _loc2_ = new Track("x");
            _loc2_.addKeyframe(new Keyframe(0,this.iconBmp.x));
            _loc2_.addKeyframe(new Keyframe(0.25,this.iconBmp.x - this.iconBmp.width / 4));
            _loc2_.addKeyframe(new Keyframe(1,this.iconBmp.x));
            this._anim.addTrack(_loc2_);
            _loc2_ = new Track("scaleX");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(0.25,1.5));
            _loc2_.addKeyframe(new Keyframe(1,1));
            this._anim.addTrack(_loc2_);
            _loc2_ = new Track("y");
            _loc2_.addKeyframe(new Keyframe(0,this.iconBmp.y));
            _loc2_.addKeyframe(new Keyframe(0.25,this.iconBmp.y - this.iconBmp.height / 4));
            _loc2_.addKeyframe(new Keyframe(1,this.iconBmp.y));
            this._anim.addTrack(_loc2_);
            _loc2_ = new Track("scaleY");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(0.25,1.5));
            _loc2_.addKeyframe(new Keyframe(1,1));
            this._anim.addTrack(_loc2_);
            _loc2_ = new Track("colorTransformProxy.offset");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(0.25,100));
            _loc2_.addKeyframe(new Keyframe(1,0));
            this._anim.addTrack(_loc2_);
            this._pulseAnim = this.iconBmp.controller.addAnimation(this._anim);
            this._pulseAnim.speed = 2;
         }
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.target)
            {
               this.progressBar.setStyle("AnimationSpeed",2 * this.client.combatSpeedMultiplier);
               this.progressBar.setValueAndMaximum(this.target[this.property],this.target[this.maxProperty]);
            }
         }
      }
      
      private function onTargetChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == this.property)
         {
            this.update();
            this._pulseAnim.speed = 2 * this.client.combatSpeedMultiplier;
            this._pulseAnim.gotoStartAndPlay();
         }
      }
   }
}
