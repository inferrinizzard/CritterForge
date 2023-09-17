package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.CapsStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class ProgressIndicator extends Canvas
   {
      
      private static var _points:Array;
      
      private static var _anim:Animation;
       
      
      private var instance:AnimationInstance;
      
      private var _time:Number;
      
      private var _gfx:Sprite;
      
      private var _paused:Boolean = true;
      
      private var _onStage:Boolean = false;
      
      public function ProgressIndicator()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private static function get anim() : Animation
      {
         var _loc1_:Track = null;
         if(!_anim)
         {
            _anim = new Animation();
            _loc1_ = new Track("time");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _anim.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,10));
            _loc1_.addKeyframe(new Keyframe(1,0));
            _anim.addTrack(_loc1_);
            _anim.loop = true;
         }
         return _anim;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function set time(param1:Number) : void
      {
         this._time = param1;
         invalidateDisplayList();
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      public function set paused(param1:Boolean) : void
      {
         this._paused = param1;
         if(this.instance)
         {
            if(this.paused || !this._onStage)
            {
               this.instance.stop();
            }
            else
            {
               this.instance.play();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._gfx = new Sprite();
         addChild(this._gfx);
         if(!this.instance)
         {
            this.instance = controller.addAnimation(anim);
            if(!this.paused && this._onStage)
            {
               this.instance.play();
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc7_:Object = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("ThemeColor",0);
         var _loc4_:uint = UIUtils.adjustBrightness(_loc3_,35);
         filters = [new GlowFilter(UIUtils.adjustBrightness(_loc3_,-35),1,param1 / 3,param1 / 3)];
         var _loc5_:Number = param1 / 2;
         var _loc6_:Number = 2 * _loc5_ / 3;
         if(!_points)
         {
            _points = [{
               "p1":new Point(0,_loc6_),
               "p2":new Point(0,_loc5_)
            },{
               "p1":new Point(_loc6_ * Math.cos(Math.PI / 3),_loc6_ * Math.sin(Math.PI / 3)),
               "p2":new Point(_loc5_ * Math.cos(Math.PI / 3),_loc5_ * Math.sin(Math.PI / 3))
            },{
               "p1":new Point(_loc6_ * Math.cos(Math.PI / 6),_loc6_ * Math.sin(Math.PI / 6)),
               "p2":new Point(_loc5_ * Math.cos(Math.PI / 6),_loc5_ * Math.sin(Math.PI / 6))
            }];
            _points.push({
               "p1":new Point(_loc6_,0),
               "p2":new Point(_loc5_,0)
            });
            _points.push({
               "p1":new Point(_points[2].p1.x,-_points[2].p1.y),
               "p2":new Point(_points[2].p2.x,-_points[2].p2.y)
            });
            _points.push({
               "p1":new Point(_points[1].p1.x,-_points[1].p1.y),
               "p2":new Point(_points[1].p2.x,-_points[1].p2.y)
            });
            _points.push({
               "p1":new Point(0,-_loc6_),
               "p2":new Point(0,-_loc5_)
            });
            _points.push({
               "p1":new Point(-_points[1].p1.x,-_points[1].p1.y),
               "p2":new Point(-_points[1].p2.x,-_points[1].p2.y)
            });
            _points.push({
               "p1":new Point(-_points[2].p1.x,-_points[2].p1.y),
               "p2":new Point(-_points[2].p2.x,-_points[2].p2.y)
            });
            _points.push({
               "p1":new Point(-_loc6_,0),
               "p2":new Point(-_loc5_,0)
            });
            _points.push({
               "p1":new Point(-_points[2].p1.x,_points[2].p1.y),
               "p2":new Point(-_points[2].p2.x,_points[2].p2.y)
            });
            _points.push({
               "p1":new Point(-_points[1].p1.x,_points[1].p1.y),
               "p2":new Point(-_points[1].p2.x,_points[1].p2.y)
            });
         }
         this._gfx.graphics.clear();
         var _loc8_:Number = 0;
         while(_loc8_ < 12)
         {
            _loc7_ = _points[_loc8_];
            this._gfx.graphics.lineStyle(_loc5_ / 4,_loc4_,1 - (this.time * 12 + _loc8_) % 12 / 12,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
            this._gfx.graphics.moveTo(_loc7_.p1.x + _loc5_,_loc7_.p1.y + _loc5_);
            this._gfx.graphics.lineTo(_loc7_.p2.x + _loc5_,_loc7_.p2.y + _loc5_);
            _loc8_++;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._onStage = true;
         if(!this.instance)
         {
            this.instance = controller.addAnimation(anim);
            if(!this.paused && this._onStage)
            {
               this.instance.play();
            }
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this._onStage = false;
         this.instance.pause();
         controller.removeAnimation(this.instance);
         this.instance = null;
      }
   }
}
