package com.edgebee.atlas.data
{
   public class DataArray extends ArrayCollection
   {
       
      
      private var _types:Object;
      
      public function DataArray(... rest)
      {
         var _loc2_:Object = null;
         super(new Array());
         this._types = new Object();
         for each(_loc2_ in rest)
         {
            this.addType(_loc2_);
         }
      }
      
      public function hasType(param1:String) : Boolean
      {
         return this._types.hasOwnProperty(param1);
      }
      
      public function addType(param1:Object) : void
      {
         var _loc2_:String = String(param1.name);
         if(this._types.hasOwnProperty(_loc2_))
         {
            throw Error("DataArray : Type " + _loc2_ + " is already registered.");
         }
         this._types[_loc2_] = param1.cls;
      }
      
      public function update(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.initializeMember(param1[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         source = _loc2_;
         this.finalize();
      }
      
      public function append(param1:*) : void
      {
         var _loc2_:* = this.initializeMember(param1);
         addItem(_loc2_);
      }
      
      public function initializeMember(param1:*) : *
      {
         if(param1 is Object)
         {
            if(param1.hasOwnProperty("__type__"))
            {
               if(this._types.hasOwnProperty(param1.__type__))
               {
                  return new this._types[param1.__type__](param1);
               }
            }
         }
         return param1;
      }
      
      public function itemPropertyToArray(param1:String) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < length)
         {
            if((_loc4_ = getItemAt(_loc3_) as Object).hasOwnProperty(param1))
            {
               _loc2_.push(_loc4_[param1]);
            }
            else
            {
               _loc2_.push(null);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function finalize() : void
      {
      }
      
      public function reset() : void
      {
         removeAll();
      }
   }
}
