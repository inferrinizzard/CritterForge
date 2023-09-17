package com.edgebee.atlas.data
{
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   public dynamic class ArrayCollection extends Proxy implements ICollection, IEventDispatcher
   {
       
      
      private var _silent:Boolean = false;
      
      private var _trackContentChanges:Boolean = false;
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _source:Array;
      
      public function ArrayCollection(param1:Array = null, param2:Boolean = false)
      {
         var _loc3_:Object = null;
         super();
         this._eventDispatcher = new EventDispatcher(this);
         if(param1)
         {
            this._source = param1;
         }
         else
         {
            this._source = new Array();
         }
         if(param2)
         {
            this.trackContentChanges = true;
            for each(_loc3_ in param1)
            {
               this.setupListeners(_loc3_);
            }
         }
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function set source(param1:Array) : void
      {
         var _loc2_:Object = null;
         if(!param1)
         {
            throw new Error("source cannot be set to null");
         }
         if(Boolean(this.source) && this.trackContentChanges)
         {
            for each(_loc2_ in this.source)
            {
               if(_loc2_ is EventDispatcher)
               {
                  this.setupListeners(_loc2_,true);
               }
            }
         }
         this._source = param1;
         if(Boolean(this.source) && this.trackContentChanges)
         {
            for each(_loc2_ in this.source)
            {
               this.setupListeners(_loc2_);
            }
         }
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this.source,-1));
      }
      
      public function get length() : int
      {
         return this.source.length;
      }
      
      public function get silent() : Boolean
      {
         return this._silent;
      }
      
      public function set silent(param1:Boolean) : void
      {
         this._silent = param1;
      }
      
      public function get trackContentChanges() : Boolean
      {
         return this._trackContentChanges;
      }
      
      public function set trackContentChanges(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(this._trackContentChanges != param1)
         {
            this._trackContentChanges = param1;
            for each(_loc2_ in this.source)
            {
               if(_loc2_ is EventDispatcher)
               {
                  if(this._trackContentChanges)
                  {
                     this.setupListeners(_loc2_);
                  }
                  else
                  {
                     this.setupListeners(_loc2_,true);
                  }
               }
            }
         }
      }
      
      public function contains(param1:Object) : Boolean
      {
         return this.getItemIndex(param1) != -1;
      }
      
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         return this.source[param1];
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.length)
         {
            if(this.source[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function findItemByProperty(param1:String, param2:*) : Object
      {
         var _loc4_:Object = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.length)
         {
            if((_loc4_ = this.getItemAt(_loc3_)).hasOwnProperty(param1) && _loc4_[param1] == param2)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function findItemsByProperty(param1:String, param2:*) : ArrayCollection
      {
         var _loc5_:Object = null;
         var _loc3_:ArrayCollection = new ArrayCollection();
         var _loc4_:uint = 0;
         while(_loc4_ < this.length)
         {
            if((_loc5_ = this.getItemAt(_loc4_)).hasOwnProperty(param1) && _loc5_[param1] == param2)
            {
               _loc3_.addItem(_loc5_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function findItem(param1:Function) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.length)
         {
            _loc3_ = this.getItemAt(_loc2_);
            if(param1(_loc3_))
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function findItems(param1:Function) : ArrayCollection
      {
         var _loc4_:Object = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         var _loc3_:uint = 0;
         while(_loc3_ < this.length)
         {
            _loc4_ = this.getItemAt(_loc3_);
            if(param1(_loc4_))
            {
               _loc2_.addItem(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addItem(param1:Object) : void
      {
         this.source.push(param1);
         this.setupListeners(param1);
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.ADD,param1,this.length - 1));
      }
      
      public function addItems(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            this.source.push(_loc2_);
            this.setupListeners(_loc2_);
         }
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this.source,-1));
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         this.source.splice(param2,0,param1);
         this.setupListeners(param1);
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.ADD,param1,param2));
      }
      
      public function removeAll() : void
      {
         var _loc1_:Object = null;
         while(this.length)
         {
            _loc1_ = this.source.pop();
            this.setupListeners(_loc1_,true);
         }
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this.source,-1));
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc2_:Array = this.source.splice(param1,1);
         var _loc3_:Object = _loc2_[0] as Object;
         this.setupListeners(_loc3_,true);
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.REMOVE,_loc2_[0],param1));
         return _loc2_[0];
      }
      
      public function removeItem(param1:Object) : Object
      {
         return this.removeItemAt(this.getItemIndex(param1));
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(param2 < this.length)
         {
            _loc3_ = this.source.splice(param2,1,param1);
            _loc4_ = _loc3_[0] as Object;
            this.setupListeners(_loc4_,true);
            this.setupListeners(param1);
            this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.REPLACED,_loc3_[0],param2));
            return _loc3_[0];
         }
         this.addItem(param1);
         return null;
      }
      
      public function get first() : Object
      {
         return this.source.length > 0 ? this.source[0] : null;
      }
      
      public function get last() : Object
      {
         return this.source.length > 0 ? this.source[this.source.length - 1] : null;
      }
      
      public function sort(param1:Function) : void
      {
         if(param1 != null)
         {
            Utils.quicksort(this,param1);
         }
      }
      
      public function reverse() : void
      {
         this.source = this.source.reverse();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(!this.silent)
         {
            return this._eventDispatcher.dispatchEvent(param1);
         }
         return false;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._eventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._eventDispatcher.willTrigger(param1);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var index:int;
         var n:Number = NaN;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         index = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            throw new Error("Unknown property: \'" + name + "\'");
         }
         return this.getItemAt(index);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var index:int;
         var n:Number = NaN;
         var name:* = param1;
         var value:* = param2;
         if(name is QName)
         {
            name = name.localName;
         }
         index = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            throw new Error("Unknown property: \'" + name + "\'");
         }
         this.setItemAt(value,index);
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         var index:int;
         var n:Number = NaN;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         index = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            return false;
         }
         return index >= 0 && index < this.length;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < this.length ? param1 + 1 : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return (param1 - 1).toString();
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.getItemAt(param1 - 1);
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return null;
      }
      
      private function onItemChange(param1:PropertyChangeEvent) : void
      {
         this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.ITEM_CHANGED,param1.source,this.getItemIndex(param1.source)));
      }
      
      private function setupListeners(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:EventDispatcher = null;
         if(this.trackContentChanges)
         {
            _loc3_ = param1 as EventDispatcher;
            if(_loc3_ != null && param2)
            {
               _loc3_.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChange);
            }
            if(_loc3_ != null && !param2)
            {
               _loc3_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChange,false,0,true);
            }
         }
      }
   }
}
