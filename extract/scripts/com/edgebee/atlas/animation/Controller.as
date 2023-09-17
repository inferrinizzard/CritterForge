package com.edgebee.atlas.animation
{
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   
   public class Controller
   {
      
      public static const UPDATE_ON_ENTER_FRAME:String = "UPDATE_ENTER_FRAME";
      
      public static const UPDATE_ON_50MS:String = "UPDATE_50MS";
      
      public static const UPDATE_ON_25MS:String = "UPDATE_25MS";
       
      
      public var instances:Array;
      
      private var _target:WeakReference;
      
      private var _last:Number = NaN;
      
      private var _updating:Boolean = false;
      
      private var _updateType:String = "UPDATE_ENTER_FRAME";
      
      public function Controller(param1:IAnimatable)
      {
         this.instances = [];
         super();
         this._target = new WeakReference(param1);
      }
      
      public function get target() : IAnimatable
      {
         return this._target.get() as IAnimatable;
      }
      
      public function get updateType() : String
      {
         return this._updateType;
      }
      
      public function set updateType(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(this._updateType != param1)
         {
            _loc2_ = this._updating;
            if(_loc2_)
            {
               this.stopUpdating();
            }
            this._updateType = param1;
            if(_loc2_)
            {
               this.startUpdating();
            }
         }
      }
      
      public function get hasActiveAnimations() : Boolean
      {
         var _loc1_:AnimationInstance = null;
         for each(_loc1_ in this.instances)
         {
            if(_loc1_.playing || _loc1_.loop && _loc1_.synchronized)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addAnimation(param1:Animation) : AnimationInstance
      {
         if(param1.numTracks == 0)
         {
            throw Error("Instantiating an animation with no tracks!");
         }
         var _loc2_:AnimationInstance = new AnimationInstance(this,param1);
         this.instances.push(_loc2_);
         if(isNaN(this._last))
         {
            this._last = getTimer();
         }
         if(this.instances.length == 1)
         {
            this.startUpdating();
         }
         return _loc2_;
      }
      
      public function animateTo(param1:Object, param2:Object = null, param3:Boolean = true, param4:Number = 1) : AnimationInstance
      {
         var _loc6_:Track = null;
         var _loc7_:String = null;
         var _loc8_:AnimationInstance = null;
         var _loc5_:Animation = new Animation();
         for(_loc7_ in param1)
         {
            (_loc6_ = new Track(_loc7_,Track.WORLD)).addKeyframe(new Keyframe(0,this.target.getProperty(_loc7_)));
            _loc6_.addKeyframe(new Keyframe(1,Utils.getPropertyFromPath(param1,_loc7_)));
            if(Boolean(param2) && param2.hasOwnProperty(_loc7_))
            {
               _loc6_.addTransitionByKeyframeTime(0,param2[_loc7_]);
            }
            _loc5_.addTrack(_loc6_);
         }
         (_loc8_ = this.addAnimation(_loc5_)).speed = param4;
         _loc8_.addEventListener(AnimationEvent.STOP,this.onAnimateToComplete);
         if(param3)
         {
            _loc8_.play();
         }
         return _loc8_;
      }
      
      public function removeAnimation(param1:AnimationInstance) : void
      {
         var _loc2_:int = this.instances.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.instances.splice(_loc2_,1);
         }
         if(this.instances.length == 0)
         {
            this._last = NaN;
            this.stopUpdating();
         }
      }
      
      public function removeAll() : void
      {
         this.instances = [];
         this._last = NaN;
         this.stopUpdating();
      }
      
      private function startUpdating() : void
      {
         this._updating = true;
         if(this._updateType == UPDATE_ON_50MS)
         {
            UIGlobals.fiftyMsTimer.addEventListener(TimerEvent.TIMER,this.update);
         }
         else if(this._updateType == UPDATE_ON_25MS)
         {
            UIGlobals.twentyfiveMsTimer.addEventListener(TimerEvent.TIMER,this.update);
         }
         else
         {
            UIGlobals.root.addEventListener(Event.ENTER_FRAME,this.update);
         }
      }
      
      private function stopUpdating() : void
      {
         this._updating = false;
         if(this._updateType == UPDATE_ON_50MS)
         {
            UIGlobals.fiftyMsTimer.removeEventListener(TimerEvent.TIMER,this.update);
         }
         else if(this._updateType == UPDATE_ON_25MS)
         {
            UIGlobals.twentyfiveMsTimer.removeEventListener(TimerEvent.TIMER,this.update);
         }
         else
         {
            UIGlobals.root.removeEventListener(Event.ENTER_FRAME,this.update);
         }
      }
      
      private function onAnimateToComplete(param1:AnimationEvent) : void
      {
         param1.instance.removeEventListener(AnimationEvent.STOP,this.onAnimateToComplete);
         this.removeAnimation(param1.instance);
      }
      
      private function update(param1:Event) : void
      {
         var _loc4_:Number = NaN;
         var _loc7_:AnimationInstance = null;
         var _loc8_:AnimationInstance = null;
         var _loc2_:Object = this.target;
         if(!_loc2_)
         {
            this.removeAll();
            return;
         }
         var _loc3_:Number = getTimer();
         var _loc5_:uint = 0;
         var _loc6_:Array = [];
         for each(_loc7_ in this.instances)
         {
            if(_loc7_.animation == null)
            {
               _loc6_.push(_loc7_);
            }
            else if(_loc7_.playing || _loc7_.animation.loop && _loc7_.synchronized)
            {
               if(isNaN(_loc4_))
               {
                  _loc4_ = (_loc3_ - this._last) / 1000;
               }
               _loc7_.animate(_loc4_,_loc5_);
               _loc5_++;
            }
         }
         for each(_loc8_ in _loc6_)
         {
            this.removeAnimation(_loc8_);
         }
         if(!isNaN(this._last))
         {
            this._last = _loc3_;
         }
         _loc2_ = null;
      }
   }
}
