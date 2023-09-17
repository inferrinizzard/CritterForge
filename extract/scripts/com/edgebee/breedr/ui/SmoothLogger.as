package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   
   public class SmoothLogger extends Canvas
   {
       
      
      private var _createLogContainer:Function;
      
      private var _animationOffset:Number = 0;
      
      private var _alignment:String = "left";
      
      private var _animInstance:AnimationInstance;
      
      private var _animation:Animation;
      
      private var _offset:Number;
      
      private var _initialPositions:Array;
      
      private var _children:ArrayCollection;
      
      private var _queue:Array;
      
      private var _idleTimer:Timer;
      
      public function SmoothLogger()
      {
         var _loc1_:Track = null;
         this._createLogContainer = this._createDefaultLogContainer;
         this._children = new ArrayCollection();
         this._queue = [];
         super();
         if(!this._animation)
         {
            this._animation = new Animation();
            _loc1_ = new Track("animationOffset");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(1,1));
            this._animation.addTrack(_loc1_);
         }
         this._animInstance = controller.addAnimation(this._animation);
         this._animInstance.speed = 5;
         this._animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
         this._idleTimer = new Timer(3000,1);
         UIGlobals.twentyfiveMsTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function _createDefaultLogContainer(param1:*) : *
      {
         var _loc2_:Label = new Label();
         _loc2_.useHtml = true;
         _loc2_.text = Utils.htmlWrap(param1,getStyle("FontFamily"),getStyle("FontColor"),getStyle("FontSize"));
         _loc2_.filters = UIGlobals.fontOutline;
         return _loc2_;
      }
      
      public function get createLogContainer() : Function
      {
         return this._createLogContainer;
      }
      
      public function set createLogContainer(param1:Function) : void
      {
         if(this._createLogContainer != param1)
         {
            this._createLogContainer = param1;
         }
      }
      
      public function get animationOffset() : Number
      {
         return this._animationOffset;
      }
      
      public function set animationOffset(param1:Number) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         if(this._animationOffset != param1)
         {
            this._animationOffset = param1;
            _loc3_ = 0;
            while(_loc3_ < this._children.length)
            {
               _loc2_ = this._children.getItemAt(_loc3_) as DisplayObject;
               _loc2_.y = this._initialPositions[_loc3_] + this._offset * param1;
               _loc2_.visible = _loc2_.width > 0;
               if(_loc2_.y < 0)
               {
                  _loc2_.alpha = Math.max(0,_loc2_.height + _loc2_.y) / _loc2_.height;
               }
               switch(this.alignment)
               {
                  case Box.ALIGN_LEFT:
                     _loc2_.x = 0;
                     break;
                  case Box.ALIGN_CENTER:
                     _loc2_.x = width / 2 - _loc2_.width / 2;
                     break;
                  case Box.ALIGN_RIGHT:
                     _loc2_.x = width - _loc2_.width;
                     break;
               }
               _loc3_++;
            }
         }
      }
      
      public function get alignment() : String
      {
         return this._alignment;
      }
      
      public function set alignment(param1:String) : void
      {
         this._alignment = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      public function print(param1:*) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Component = null;
         if(this._animInstance.playing)
         {
            this._queue.push(param1);
            this._idleTimer.reset();
            this._idleTimer.start();
         }
         else
         {
            _loc2_ = this._children.last as DisplayObject;
            if(Boolean(_loc2_) && _loc2_.height == 0)
            {
               this._queue.push(param1);
               this._idleTimer.reset();
               this._idleTimer.start();
            }
            else
            {
               if(param1 is DisplayObject)
               {
                  _loc3_ = param1;
               }
               else
               {
                  _loc3_ = this.createLogContainer(param1);
               }
               _loc3_.visible = false;
               addChild(_loc3_);
               validateNow(false);
               this._children.addItem(_loc3_);
               switch(this.alignment)
               {
                  case Box.ALIGN_LEFT:
                     _loc3_.x = 0;
                     break;
                  case Box.ALIGN_CENTER:
                     _loc3_.x = width / 2 - _loc3_.width / 2;
                     break;
                  case Box.ALIGN_RIGHT:
                     _loc3_.x = width - _loc3_.width;
               }
               _loc3_.y = !!_loc2_ ? _loc2_.y + _loc2_.height : 0;
               _loc3_.visible = _loc3_.width > 0;
               this.cleanup();
               this._idleTimer.reset();
               this._idleTimer.start();
            }
         }
      }
      
      public function flush() : void
      {
      }
      
      public function get idleTime() : Number
      {
         return this._idleTimer.delay;
      }
      
      public function set idleTime(param1:Number) : void
      {
         this._idleTimer.delay = param1;
      }
      
      private function cleanup() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if((this.spilling || this.idle) && !this._animInstance.playing)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this._children.length)
            {
               _loc1_ = this._children.getItemAt(_loc3_) as DisplayObject;
               _loc4_ = _loc1_.height;
               if(_loc1_.y < 0)
               {
                  _loc4_ += Math.max(_loc1_.y,-_loc1_.height);
               }
               _loc2_ += _loc4_;
               _loc3_++;
            }
            if(_loc2_ > height)
            {
               this._offset = -(_loc2_ - height);
            }
            else
            {
               this._offset = -_loc1_.height;
            }
            this._initialPositions = [];
            _loc3_ = 0;
            while(_loc3_ < this._children.length)
            {
               _loc1_ = this._children.getItemAt(_loc3_) as DisplayObject;
               this._initialPositions.push(_loc1_.y);
               _loc3_++;
            }
            this._animInstance.gotoStartAndPlay();
            this._idleTimer.reset();
            this._idleTimer.start();
         }
      }
      
      private function get spilling() : Boolean
      {
         var _loc1_:DisplayObject = null;
         if(this._children.length > 0)
         {
            _loc1_ = this._children.last as DisplayObject;
            return _loc1_.y + _loc1_.height > height;
         }
         return false;
      }
      
      private function get idle() : Boolean
      {
         return !this._idleTimer.running && this._children.length > 0;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.cleanup();
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this._children.length)
         {
            _loc2_ = this._children.getItemAt(_loc4_) as DisplayObject;
            if(_loc2_.y + _loc2_.height < 0)
            {
               _loc3_.push(_loc2_);
            }
            _loc4_++;
         }
         for each(_loc2_ in _loc3_)
         {
            removeChild(_loc2_);
            this._children.removeItem(_loc2_);
         }
         if(this._queue.length)
         {
            this.print(this._queue.shift());
         }
         this.cleanup();
         this._idleTimer.reset();
         this._idleTimer.start();
      }
   }
}
