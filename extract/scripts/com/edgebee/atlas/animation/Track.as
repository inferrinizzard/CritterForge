package com.edgebee.atlas.animation
{
   import com.edgebee.atlas.util.Utils;
   import flash.utils.Dictionary;
   
   public class Track
   {
      
      public static const DELTA:String = "DELTA";
      
      public static const WORLD:String = "WORLD";
       
      
      public var property:String;
      
      public var type:String;
      
      public var hasCallbacks:Boolean = false;
      
      private var _trackItems:Array;
      
      private var _transitions:Dictionary;
      
      public function Track(param1:String, param2:String = "WORLD")
      {
         this._trackItems = [];
         this._transitions = new Dictionary(true);
         super();
         this.property = param1;
         this.type = param2;
      }
      
      private static function cmpTrackItems(param1:TrackItem, param2:TrackItem) : int
      {
         if(param1.time < param2.time)
         {
            return -1;
         }
         if(param1.time > param2.time)
         {
            return 1;
         }
         return 0;
      }
      
      public function get valid() : Boolean
      {
         return this.property != null && this._trackItems.length > 1 && this._trackItems[0].time == 0;
      }
      
      public function get startTime() : Number
      {
         return this._trackItems[0].time;
      }
      
      public function get endTime() : Number
      {
         return this._trackItems[this._trackItems.length - 1].time;
      }
      
      public function addKeyframe(param1:Keyframe) : Keyframe
      {
         this._trackItems.push(param1);
         this.sortTrackItems();
         return param1;
      }
      
      public function addCallback(param1:Callback) : Callback
      {
         this.hasCallbacks = true;
         this._trackItems.push(param1);
         this.sortTrackItems();
         return param1;
      }
      
      public function getCallbacksBetweenInterval(param1:Number, param2:Number) : Array
      {
         var _loc3_:Callback = null;
         var _loc5_:TrackItem = null;
         var _loc4_:Array = [];
         for each(_loc5_ in this._trackItems)
         {
            if(_loc5_ is Callback)
            {
               _loc3_ = _loc5_ as Callback;
               if(param2 > param1 && _loc3_.time > param1 && _loc3_.time <= param2 || param2 < param1 && _loc3_.time < param1 && _loc3_.time >= param2)
               {
                  _loc4_.push(_loc3_);
               }
            }
         }
         Utils.quicksort(_loc4_,cmpTrackItems);
         if(param1 > param2)
         {
            _loc4_.reverse();
         }
         return _loc4_;
      }
      
      public function addTransition(param1:Keyframe, param2:Function) : void
      {
         this._transitions[param1] = param2;
      }
      
      public function addTransitionByKeyframeTime(param1:Number, param2:Function) : void
      {
         var _loc3_:Keyframe = null;
         var _loc4_:TrackItem = null;
         for each(_loc4_ in this._trackItems)
         {
            if(_loc4_ is Keyframe)
            {
               _loc3_ = _loc4_ as Keyframe;
               if(_loc3_.time == param1)
               {
                  this._transitions[_loc3_] = param2;
                  return;
               }
            }
         }
         throw new Error("Track::addTransitionByKeyframeTime : Couldnt find key frame at time " + param1.toString());
      }
      
      public function apply(param1:IAnimatable, param2:Number, param3:Number, param4:uint, param5:Number, param6:Number) : void
      {
         var _loc17_:Number = NaN;
         var _loc7_:Number;
         if((_loc7_ = param2 - param3) < this.startTime && param2 < this.startTime || _loc7_ > this.endTime && param2 > this.endTime)
         {
            return;
         }
         if(param2 < this.startTime)
         {
            param2 = this.startTime;
         }
         if(param2 > this.endTime)
         {
            param2 = this.endTime;
         }
         var _loc8_:Array;
         var _loc9_:Keyframe = (_loc8_ = this.getKeyframesAtTime(param2))[0];
         var _loc10_:Keyframe = _loc8_[1];
         var _loc11_:Number = param2 - _loc9_.time / _loc10_.time - _loc9_.time;
         var _loc12_:Function = this.getTransitionForKeyframe(_loc9_);
         var _loc13_:Number = param2 - _loc9_.time;
         var _loc14_:Number = _loc9_.value;
         var _loc15_:Number = _loc10_.value - _loc9_.value;
         var _loc16_:Number = _loc10_.time - _loc9_.time;
         if(param2 == this.startTime)
         {
            _loc17_ = _loc9_.value;
         }
         else if(param2 == this.endTime)
         {
            _loc17_ = _loc10_.value;
         }
         else
         {
            _loc17_ = _loc12_(_loc13_,_loc14_,_loc15_,_loc16_) * param5;
         }
         if(this.type == DELTA)
         {
            if(param4 > 0)
            {
               param1.setProperty(this.property,param1.getProperty(this.property) + _loc17_ * param5);
            }
            else
            {
               param1.setProperty(this.property,param6 + _loc17_ * param5);
            }
         }
         else if(this.type == WORLD)
         {
            if(param5 != 1 && param4 > 0)
            {
               param1.setProperty(this.property,param1.getProperty(this.property) + _loc17_ * param5);
            }
            else
            {
               param1.setProperty(this.property,_loc17_ * param5);
            }
         }
      }
      
      private function getKeyframesAtTime(param1:Number) : Array
      {
         var _loc4_:TrackItem = null;
         var _loc2_:Keyframe = null;
         var _loc3_:Keyframe = null;
         for each(_loc4_ in this._trackItems)
         {
            if(_loc4_ is Keyframe)
            {
               _loc3_ = _loc4_ as Keyframe;
               if(_loc3_.time >= param1 && _loc2_ != null)
               {
                  return [_loc2_,_loc3_];
               }
               _loc2_ = _loc3_;
            }
         }
         return null;
      }
      
      private function getTransitionForKeyframe(param1:Keyframe) : Function
      {
         if(this._transitions[param1] != undefined)
         {
            return this._transitions[param1];
         }
         return Interpolation.linear;
      }
      
      private function sortTrackItems() : void
      {
         Utils.quicksort(this._trackItems,cmpTrackItems);
      }
   }
}
