package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.ui.Component;
   import flash.events.Event;
   
   public class ControlLayoutManager
   {
       
      
      public var count:Number = 0;
      
      private var _root:Component;
      
      private var _invalidSizeQueue:PriorityQueue;
      
      private var _invalidDisplayListQueue:PriorityQueue;
      
      private var _updateCompleteQueue:PriorityQueue;
      
      private var _hasInvalidSizes:Boolean = false;
      
      private var _hasNowInvalidSizes:Boolean = false;
      
      private var _hasInvalidDisplayLists:Boolean = false;
      
      private var _hasInvalidCompleted:Boolean = false;
      
      private var _targetLevel:int = 2147483647;
      
      private var _stable:Boolean = false;
      
      public function ControlLayoutManager(param1:Component)
      {
         this._invalidSizeQueue = new PriorityQueue();
         this._invalidDisplayListQueue = new PriorityQueue();
         this._updateCompleteQueue = new PriorityQueue();
         super();
         this._root = param1;
         this._root.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
      }
      
      public function traceContent() : void
      {
         this._invalidSizeQueue.traceContent();
      }
      
      public function invalidateSize(param1:Component) : void
      {
         this._invalidSizeQueue.addObject(param1,param1.nestLevel);
         this._hasInvalidSizes = true;
         if(this._targetLevel <= param1.nestLevel)
         {
            this._hasNowInvalidSizes = true;
         }
         this._stable = false;
      }
      
      public function invalidateDisplayList(param1:Component) : void
      {
         this._invalidDisplayListQueue.addObject(param1,param1.nestLevel);
         this._hasInvalidDisplayLists = true;
      }
      
      public function setVisible(param1:Component) : void
      {
      }
      
      public function renest(param1:Component, param2:int, param3:int) : void
      {
         this._invalidSizeQueue.renest(param1,param2,param3);
         this._invalidDisplayListQueue.renest(param1,param2,param3);
         this._updateCompleteQueue.renest(param1,param2,param3);
      }
      
      public function validateNow(param1:Component, param2:Boolean) : void
      {
         var _loc5_:Component = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = this._targetLevel;
         if(this._targetLevel == int.MAX_VALUE)
         {
            this._targetLevel = param1.nestLevel;
         }
         while(!_loc3_)
         {
            _loc3_ = true;
            this._stable = true;
            _loc5_ = this._invalidSizeQueue.removeSmallestChild(param1) as Component;
            while(_loc5_)
            {
               _loc5_.validateSize();
               if(!_loc5_.updateCompletePending)
               {
                  this._updateCompleteQueue.addObject(_loc5_,_loc5_.nestLevel);
                  _loc5_.updateCompletePending = true;
               }
               _loc5_ = this._invalidSizeQueue.removeSmallestChild(param1) as Component;
            }
            if(this._invalidSizeQueue.isEmpty())
            {
               this._hasInvalidSizes = false;
            }
            this._hasNowInvalidSizes = !this._stable;
            if(this._hasNowInvalidSizes)
            {
               _loc3_ = false;
            }
            if(!param2)
            {
               _loc5_ = this._invalidDisplayListQueue.removeSmallestChild(param1) as Component;
               while(_loc5_)
               {
                  _loc5_.validateDisplayList();
                  if(!_loc5_.updateCompletePending)
                  {
                     this._updateCompleteQueue.addObject(_loc5_,_loc5_.nestLevel);
                     _loc5_.updateCompletePending = true;
                  }
                  _loc5_ = this._invalidDisplayListQueue.removeSmallestChild(param1) as Component;
               }
               this._hasInvalidDisplayLists = !this._invalidDisplayListQueue.isEmpty();
            }
         }
         if(_loc4_ == int.MAX_VALUE)
         {
            this._targetLevel = int.MAX_VALUE;
            if(!param2)
            {
               _loc5_ = this._updateCompleteQueue.removeLargestChild(param1) as Component;
               while(_loc5_)
               {
                  if(!_loc5_.initialized && _loc5_.processedDescriptors)
                  {
                     _loc5_.initialized = true;
                  }
                  _loc5_.updateCompletePending = false;
                  _loc5_ = this._updateCompleteQueue.removeLargestChild(param1) as Component;
               }
            }
         }
      }
      
      private function validateSize() : void
      {
         var _loc1_:Component = this._invalidSizeQueue.removeLargest() as Component;
         while(_loc1_)
         {
            _loc1_.validateSize();
            if(!_loc1_.updateCompletePending)
            {
               this._updateCompleteQueue.addObject(_loc1_,_loc1_.nestLevel);
               _loc1_.updateCompletePending = true;
            }
            _loc1_ = this._invalidSizeQueue.removeLargest() as Component;
         }
         this._hasInvalidSizes = !this._invalidSizeQueue.isEmpty();
      }
      
      private function validateDisplayList() : void
      {
         var _loc1_:Component = this._invalidDisplayListQueue.removeLargest() as Component;
         while(_loc1_)
         {
            _loc1_.validateDisplayList();
            if(!_loc1_.updateCompletePending)
            {
               this._updateCompleteQueue.addObject(_loc1_,_loc1_.nestLevel);
               _loc1_.updateCompletePending = true;
            }
            _loc1_ = this._invalidDisplayListQueue.removeLargest() as Component;
         }
         this._hasInvalidDisplayLists = !this._invalidDisplayListQueue.isEmpty();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Component = null;
         if(this._hasInvalidSizes)
         {
            this.validateSize();
         }
         if(this._hasInvalidDisplayLists)
         {
            this.validateDisplayList();
         }
         if(!this._hasInvalidSizes && !this._hasInvalidDisplayLists)
         {
            _loc2_ = this._updateCompleteQueue.removeLargest() as Component;
            while(_loc2_)
            {
               if(!_loc2_.initialized && _loc2_.processedDescriptors)
               {
                  _loc2_.initialized = true;
               }
               _loc2_.updateCompletePending = false;
               _loc2_ = this._updateCompleteQueue.removeLargest() as Component;
            }
         }
      }
   }
}

import com.edgebee.atlas.ui.Component;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

class PriorityQueue
{
    
   
   private var arrayOfArrays:Array;
   
   private var minPriority:int = 0;
   
   private var maxPriority:int = -1;
   
   public function PriorityQueue()
   {
      this.arrayOfArrays = [];
      super();
   }
   
   public function get size() : uint
   {
      var _loc2_:Array = null;
      var _loc1_:uint = 0;
      for each(_loc2_ in this.arrayOfArrays)
      {
         _loc1_ += _loc2_.length;
      }
      return _loc1_;
   }
   
   public function traceContent() : void
   {
      var _loc2_:Array = null;
      var _loc3_:DisplayObject = null;
      var _loc4_:Component = null;
      var _loc1_:uint = 0;
      for each(_loc2_ in this.arrayOfArrays)
      {
         for each(_loc3_ in _loc2_)
         {
            if(!(_loc4_ = _loc3_ as Component))
            {
            }
         }
      }
   }
   
   private function getComponentName(param1:Component) : String
   {
      if(param1.parent)
      {
         if(param1.parent is Component)
         {
            return this.getComponentName(param1.parent as Component) + "." + param1.name;
         }
         return param1.parent.name + "." + param1.name;
      }
      return param1.name;
   }
   
   public function renest(param1:Object, param2:int, param3:int) : void
   {
      var _loc4_:Array = null;
      var _loc5_:uint = 0;
      if(param2 < this.arrayOfArrays.length)
      {
         if(_loc4_ = this.arrayOfArrays[param2])
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_] == param1)
               {
                  _loc4_.splice(_loc5_,1);
                  this.addObject(param1,param3);
                  if(this.minPriority > param3)
                  {
                     this.maxPriority = param3;
                  }
                  if(this.maxPriority < param3)
                  {
                     this.maxPriority = param3;
                  }
                  return;
               }
               _loc5_++;
            }
         }
      }
   }
   
   public function addObject(param1:Object, param2:int) : void
   {
      if(!this.arrayOfArrays[param2])
      {
         this.arrayOfArrays[param2] = [];
      }
      this.arrayOfArrays[param2].push(param1);
      if(this.maxPriority < this.minPriority)
      {
         this.minPriority = this.maxPriority = param2;
      }
      else
      {
         if(param2 < this.minPriority)
         {
            this.minPriority = param2;
         }
         if(param2 > this.maxPriority)
         {
            this.maxPriority = param2;
         }
      }
   }
   
   public function removeLargest() : Object
   {
      var _loc1_:Object = null;
      if(this.minPriority <= this.maxPriority)
      {
         while(!this.arrayOfArrays[this.maxPriority] || this.arrayOfArrays[this.maxPriority].length == 0)
         {
            --this.maxPriority;
            if(this.maxPriority < this.minPriority)
            {
               return null;
            }
         }
         _loc1_ = this.arrayOfArrays[this.maxPriority].shift();
         while(!this.arrayOfArrays[this.maxPriority] || this.arrayOfArrays[this.maxPriority].length == 0)
         {
            --this.maxPriority;
            if(this.maxPriority < this.minPriority)
            {
               break;
            }
         }
      }
      return _loc1_;
   }
   
   public function removeLargestChild(param1:Component) : Object
   {
      var _loc5_:int = 0;
      var _loc2_:Object = null;
      var _loc3_:int = int(this.maxPriority);
      var _loc4_:int = param1.nestLevel;
      while(_loc4_ <= _loc3_)
      {
         if(Boolean(this.arrayOfArrays[_loc3_]) && this.arrayOfArrays[_loc3_].length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < this.arrayOfArrays[_loc3_].length)
            {
               if(this.contains(DisplayObject(param1),this.arrayOfArrays[_loc3_][_loc5_]))
               {
                  _loc2_ = this.arrayOfArrays[_loc3_][_loc5_];
                  this.arrayOfArrays[_loc3_].splice(_loc5_,1);
                  return _loc2_;
               }
               _loc5_++;
            }
            _loc3_--;
         }
         else
         {
            if(_loc3_ == this.maxPriority)
            {
               --this.maxPriority;
            }
            _loc3_--;
            if(_loc3_ < _loc4_)
            {
               break;
            }
         }
      }
      return _loc2_;
   }
   
   public function removeSmallest() : Object
   {
      var _loc1_:Object = null;
      if(this.minPriority <= this.maxPriority)
      {
         while(!this.arrayOfArrays[this.minPriority] || this.arrayOfArrays[this.minPriority].length == 0)
         {
            ++this.minPriority;
            if(this.minPriority > this.maxPriority)
            {
               return null;
            }
         }
         _loc1_ = this.arrayOfArrays[this.minPriority].shift();
         while(!this.arrayOfArrays[this.minPriority] || this.arrayOfArrays[this.minPriority].length == 0)
         {
            ++this.minPriority;
            if(this.minPriority > this.maxPriority)
            {
               break;
            }
         }
      }
      return _loc1_;
   }
   
   public function removeSmallestChild(param1:Component) : Object
   {
      var _loc4_:int = 0;
      var _loc2_:Object = null;
      var _loc3_:int = param1.nestLevel;
      while(_loc3_ <= this.maxPriority)
      {
         if(Boolean(this.arrayOfArrays[_loc3_]) && this.arrayOfArrays[_loc3_].length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.arrayOfArrays[_loc3_].length)
            {
               if(this.contains(DisplayObject(param1),this.arrayOfArrays[_loc3_][_loc4_]))
               {
                  _loc2_ = this.arrayOfArrays[_loc3_][_loc4_];
                  this.arrayOfArrays[_loc3_].splice(_loc4_,1);
                  return _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         else
         {
            if(_loc3_ == this.minPriority)
            {
               ++this.minPriority;
            }
            _loc3_++;
            if(_loc3_ > this.maxPriority)
            {
               break;
            }
         }
      }
      return _loc2_;
   }
   
   public function removeAll() : void
   {
      this.arrayOfArrays.splice(0);
      this.minPriority = 0;
      this.maxPriority = -1;
   }
   
   public function isEmpty() : Boolean
   {
      return this.minPriority > this.maxPriority;
   }
   
   private function contains(param1:DisplayObject, param2:DisplayObject) : Boolean
   {
      if(param1 is DisplayObjectContainer)
      {
         return DisplayObjectContainer(param1).contains(param2);
      }
      return param1 == param2;
   }
}
