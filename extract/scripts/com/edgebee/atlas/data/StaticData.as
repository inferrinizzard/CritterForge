package com.edgebee.atlas.data
{
   import com.edgebee.atlas.util.Utils;
   
   public class StaticData extends Data
   {
      
      private static var store:Object = {};
      
      private static const defaultIndices:Array = ["id"];
       
      
      private var indexes:Array;
      
      public var toReplace:Boolean = false;
      
      public function StaticData(param1:Object = null, param2:Object = null, param3:Array = null)
      {
         var _loc5_:String = null;
         if(!param3)
         {
            this.indexes = defaultIndices;
         }
         else
         {
            this.indexes = param3;
         }
         var _loc4_:String = String(param1.__type__);
         if(!store.hasOwnProperty(_loc4_))
         {
            store[_loc4_] = {};
         }
         for each(_loc5_ in this.indexes)
         {
            if(!store[_loc4_].hasOwnProperty(_loc5_))
            {
               store[_loc4_][_loc5_] = {};
            }
         }
         super(param1,param2);
      }
      
      public static function getInstance(param1:*, param2:String, param3:String) : *
      {
         if(!store.hasOwnProperty(param3))
         {
            store[param3] = {};
         }
         if(!store[param3].hasOwnProperty(param2))
         {
            store[param3][param2] = {};
         }
         if(!store[param3][param2].hasOwnProperty(param1))
         {
            return null;
         }
         return store[param3][param2][param1];
      }
      
      public static function getAllInstances(param1:String, param2:String) : Array
      {
         var _loc4_:* = undefined;
         var _loc3_:Array = new Array();
         for(_loc4_ in store[param1][param2])
         {
            _loc3_.push(store[param1][param2][_loc4_]);
         }
         return _loc3_;
      }
      
      public static function getStore(param1:String) : Object
      {
         return store[param1];
      }
      
      public static function clearStore(param1:String) : void
      {
         if(store.hasOwnProperty(param1))
         {
            store[param1] = {};
         }
      }
      
      public static function removeFromStore(param1:*, param2:Array, param3:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(store.hasOwnProperty(param3))
         {
            _loc4_ = store[param3];
            for each(_loc5_ in param2)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  delete (_loc6_ = _loc4_[_loc5_])[param1[_loc5_]];
               }
            }
         }
      }
      
      override protected function finalize() : void
      {
         var _loc3_:String = null;
         super.finalize();
         var _loc1_:String = Utils.getInstanceClassName(this);
         var _loc2_:StaticData = null;
         for each(_loc3_ in this.indexes)
         {
            if(store[_loc1_][_loc3_].hasOwnProperty(this[_loc3_]))
            {
               _loc2_ = store[_loc1_][_loc3_][this[_loc3_]];
               break;
            }
         }
         if(_loc2_ != null && _loc2_.toReplace)
         {
            this.copyTo(_loc2_);
            _loc2_.toReplace = false;
         }
         else
         {
            _loc2_ = this;
         }
         for each(_loc3_ in this.indexes)
         {
            if(!store[_loc1_][_loc3_].hasOwnProperty(_loc2_[_loc3_]))
            {
               store[_loc1_][_loc3_][_loc2_[_loc3_]] = _loc2_;
            }
         }
      }
   }
}
