package com.edgebee.atlas.data
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Data extends EventDispatcher
   {
      
      public static const UPDATED:String = "UPDATED";
       
      
      public var __explicit_properties:Object;
      
      private var _uid:String;
      
      private var _finalized:Boolean;
      
      private var _copying:Boolean;
      
      public function Data(param1:Object = null, param2:Object = null)
      {
         super();
         this.__explicit_properties = param2;
         if(param1)
         {
            this.update(param1);
         }
      }
      
      public static function get classinfo() : Object
      {
         throw new Error("Must setup classinfo!");
      }
      
      public function get classinfo() : Object
      {
         return Data.classinfo;
      }
      
      public function update(param1:Object) : void
      {
         Utils.updateAllPropertiesDeep(param1,this);
         this.finalize();
         dispatchEvent(new Event(UPDATED));
      }
      
      public function copyTo(param1:*) : void
      {
         throw Error("Copy function has not been implemented. You must override and implement the member by member copy.");
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      protected function finalize() : void
      {
         this._finalized = true;
      }
      
      public function reset() : void
      {
      }
      
      public function initializeProperty(param1:String, param2:*) : void
      {
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function equals(param1:Data) : Boolean
      {
         throw Error("Equals function has not been implemented. You must override and implement equality.");
      }
      
      public function get copying() : Boolean
      {
         return this._copying;
      }
      
      public function set copying(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this.copying != param1)
         {
            _loc2_ = this._copying;
            this._copying = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"copying",_loc2_,param1));
         }
      }
   }
}
