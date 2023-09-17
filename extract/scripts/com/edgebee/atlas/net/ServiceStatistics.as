package com.edgebee.atlas.net
{
   import com.edgebee.atlas.util.Utils;
   
   public class ServiceStatistics
   {
       
      
      private var _requests:uint = 0;
      
      private var _timeouts:uint = 0;
      
      private var _totalLatency:uint = 0;
      
      private var _details:Object;
      
      public function ServiceStatistics()
      {
         this._details = {};
         super();
      }
      
      private static function compareDetails(param1:Object, param2:Object) : int
      {
         if(param1.totalLatency / param1.requests < param2.totalLatency / param2.requests)
         {
            return 1;
         }
         if(param1.totalLatency / param1.requests > param2.totalLatency / param2.requests)
         {
            return -1;
         }
         return 0;
      }
      
      public function get requests() : uint
      {
         return this._requests;
      }
      
      public function get timeouts() : uint
      {
         return this._timeouts;
      }
      
      public function get averageLatency() : uint
      {
         return uint(this._totalLatency / this._requests);
      }
      
      public function get details() : Object
      {
         return this._details;
      }
      
      public function addRequest(param1:String, param2:uint) : void
      {
         ++this._requests;
         this._totalLatency += param2;
         if(!this.details.hasOwnProperty(param1))
         {
            this.details[param1] = {
               "name":param1,
               "requests":0,
               "totalLatency":0
            };
         }
         ++this.details[param1].requests;
         this.details[param1].totalLatency += param2;
      }
      
      public function addTimeout(param1:String) : void
      {
         ++this._timeouts;
      }
      
      public function dump() : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.details)
         {
            _loc1_.push(_loc2_);
         }
         Utils.quicksort(_loc1_,compareDetails);
         _loc3_ = 0;
         while(_loc3_ < 10 && _loc3_ < _loc1_.length)
         {
            _loc2_ = _loc1_[_loc3_];
            _loc4_ = Utils.formatString("{name:-32} {requests:-16} {latency} ms",{
               "name":_loc2_.name,
               "requests":_loc2_.requests,
               "latency":uint(_loc2_.totalLatency / _loc2_.requests)
            });
            _loc3_++;
         }
      }
   }
}
