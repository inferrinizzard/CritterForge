package com.edgebee.atlas.animation
{
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.EventDispatcher;
   
   public class AnimationInstance extends EventDispatcher
   {
       
      
      public var playing:Boolean = false;
      
      public var speed:Number;
      
      public var debug:Boolean = false;
      
      public var synchronized:Boolean = false;
      
      public var animation:com.edgebee.atlas.animation.Animation;
      
      private var _controller:WeakReference;
      
      private var _originalValues:Object;
      
      private var _time:Number = 0;
      
      private var _paused:Boolean = false;
      
      private var _index:uint;
      
      private var _skipping:Boolean = false;
      
      public function AnimationInstance(param1:Controller, param2:com.edgebee.atlas.animation.Animation)
      {
         super();
         this._controller = new WeakReference(param1);
         this.animation = param2;
         this.speed = param2.speed;
      }
      
      public function get duration() : Number
      {
         return this.animation.duration;
      }
      
      public function get isValid() : Boolean
      {
         return this.animation != null;
      }
      
      public function get loop() : Boolean
      {
         return this.animation.loop;
      }
      
      public function get reversed() : Boolean
      {
         return this.speed < 0;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function set time(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Track = null;
         var _loc6_:Callback = null;
         if(this._time != param1)
         {
            _loc2_ = param1 - this._time;
            _loc3_ = _loc2_;
            _loc4_ = false;
            if(this.debug)
            {
            }
            if(param1 < 0 || param1 > this.animation.duration)
            {
               if(!this.loop)
               {
                  if(param1 < 0)
                  {
                     _loc3_ = 0;
                     this._time = 0;
                  }
                  if(param1 > this.animation.duration)
                  {
                     _loc3_ = this.animation.duration - this._time;
                     this._time = this.animation.duration;
                  }
                  _loc4_ = true;
               }
               else
               {
                  this._time = param1 % this.animation.duration;
                  if(hasEventListener(AnimationEvent.LOOP))
                  {
                     dispatchEvent(new AnimationEvent(AnimationEvent.LOOP,this));
                  }
               }
            }
            else
            {
               this._time = param1;
            }
            if(this.animation.loop && this.synchronized)
            {
               if(!this.playing)
               {
                  return;
               }
            }
            for each(_loc5_ in this.animation.tracks)
            {
               _loc5_.apply(this.controller.target,this._time,_loc2_,this._index,this.getPropertyWeightAtTime(_loc5_.property,this._time),this._originalValues[_loc5_.property]);
               if(_loc5_.hasCallbacks)
               {
                  for each(_loc6_ in _loc5_.getCallbacksBetweenInterval(this._time - _loc3_,this._time))
                  {
                     if(!(this._skipping && _loc6_.skippable))
                     {
                        if(hasEventListener(AnimationEvent.CALLBACK))
                        {
                           dispatchEvent(new AnimationEvent(AnimationEvent.CALLBACK,this,_loc6_.data));
                        }
                     }
                  }
               }
            }
            if(hasEventListener(AnimationEvent.POST_FRAME))
            {
               dispatchEvent(new AnimationEvent(AnimationEvent.POST_FRAME,this));
            }
            if(_loc4_)
            {
               this.stop();
            }
         }
      }
      
      public function animate(param1:Number, param2:uint) : void
      {
         this._index = param2;
         this.time += param1 * this.speed;
      }
      
      public function play() : void
      {
         if(this._paused)
         {
            this.pause();
         }
         this.playing = true;
         this.saveOriginalValues();
         if(hasEventListener(AnimationEvent.START))
         {
            dispatchEvent(new AnimationEvent(AnimationEvent.START,this));
         }
      }
      
      public function reverse() : void
      {
         this.speed *= -1;
      }
      
      public function gotoStartAndPlay() : void
      {
         this.time = 0;
         if(this.speed < 0)
         {
            this.speed *= -1;
         }
         this.play();
      }
      
      public function gotoEndAndPlayReversed() : void
      {
         if(!this._originalValues)
         {
            this.saveOriginalValues();
         }
         this.time = this.duration;
         if(this.speed > 0)
         {
            this.speed *= -1;
         }
         this.play();
      }
      
      public function gotoStartAndStop() : void
      {
         if(!this._originalValues)
         {
            this.saveOriginalValues();
         }
         this._skipping = true;
         this.time = -1;
         this._skipping = false;
         this.stop();
      }
      
      public function gotoEndAndStop() : void
      {
         if(!this._originalValues)
         {
            this.saveOriginalValues();
         }
         this._skipping = true;
         this.time = this.duration;
         this._skipping = false;
         this.stop();
      }
      
      public function pause() : void
      {
         if(this.playing && !this._paused)
         {
            this.playing = false;
            this._paused = true;
            if(hasEventListener(AnimationEvent.PAUSE))
            {
               dispatchEvent(new AnimationEvent(AnimationEvent.PAUSE,this));
            }
         }
         else if(!this.playing && this._paused)
         {
            this.playing = true;
            this._paused = false;
            if(hasEventListener(AnimationEvent.UNPAUSE))
            {
               dispatchEvent(new AnimationEvent(AnimationEvent.UNPAUSE,this));
            }
         }
      }
      
      public function stop() : void
      {
         this.playing = false;
         this._time = 0;
         if(hasEventListener(AnimationEvent.STOP))
         {
            dispatchEvent(new AnimationEvent(AnimationEvent.STOP,this));
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function get controller() : Controller
      {
         return this._controller.get() as Controller;
      }
      
      private function saveOriginalValues() : void
      {
         var _loc1_:Track = null;
         this._originalValues = {};
         for each(_loc1_ in this.animation.tracks)
         {
            this._originalValues[_loc1_.property] = this.controller.target.getProperty(_loc1_.property);
         }
      }
      
      private function getPropertyWeightAtTime(param1:String, param2:Number) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:AnimationInstance = null;
         if(this.controller.instances.length > 1)
         {
            _loc3_ = 0;
            for each(_loc4_ in this.controller.instances)
            {
               if(Boolean(_loc4_.playing) && _loc4_.animation.tracks.hasOwnProperty(param1))
               {
                  _loc3_++;
               }
            }
            if(_loc3_ > 0)
            {
               return 1 / _loc3_;
            }
         }
         return 1;
      }
   }
}
