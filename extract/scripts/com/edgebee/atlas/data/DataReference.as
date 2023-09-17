package com.edgebee.atlas.data
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import flash.events.EventDispatcher;
   
   public class DataReference extends EventDispatcher
   {
       
      
      private var _reference:com.edgebee.atlas.data.Data;
      
      private var _types:Object;
      
      public function DataReference(... rest)
      {
         var _loc2_:Object = null;
         super();
         this._types = new Object();
         for each(_loc2_ in rest)
         {
            this.addType(_loc2_);
         }
      }
      
      public function addType(param1:Object) : void
      {
         var _loc2_:String = String(param1.name);
         if(this._types.hasOwnProperty(_loc2_))
         {
            throw Error("DataReference : Type " + _loc2_ + " is already registered.");
         }
         this._types[_loc2_] = param1.cls;
      }
      
      public function update(param1:Object) : void
      {
         if(param1.hasOwnProperty("__type__"))
         {
            if(this._types.hasOwnProperty(param1.__type__))
            {
               this.ref = new this._types[param1.__type__](param1);
               return;
            }
            throw Error("DataReference source\'s __type__ \"" + param1.__type__ + "\" not known");
         }
         throw Error("DataReference source missing __type__");
      }
      
      public function reset() : void
      {
         if(this._reference)
         {
            this._reference.reset();
         }
      }
      
      public function initializeProperty(param1:String, param2:*) : void
      {
         this._reference.initializeProperty(param1,param2);
      }
      
      public function get ref() : *
      {
         return this._reference;
      }
      
      public function set ref(param1:com.edgebee.atlas.data.Data) : void
      {
         var _loc2_:com.edgebee.atlas.data.Data = this._reference;
         this._reference = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"ref",_loc2_,this.ref));
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}
