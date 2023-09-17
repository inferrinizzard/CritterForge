package com.edgebee.atlas.data
{
   public class Exception extends Data
   {
       
      
      public var cls:String;
      
      public var args:Array;
      
      public var traceback:Array;
      
      public var userdata:Object;
      
      public function Exception(param1:Object = null)
      {
         super(param1);
      }
      
      public function get short() : String
      {
         var _loc1_:* = null;
         _loc1_ = this.cls + ": ";
         var _loc2_:uint = 0;
         while(_loc2_ < this.args.length)
         {
            if(_loc2_ > 0 && _loc2_ < this.args.length - 1)
            {
               _loc1_ += ", ";
            }
            _loc1_ += this.args[_loc2_];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get render() : String
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         _loc1_ = "";
         if(this.traceback != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.traceback.length)
            {
               _loc1_ += "File " + this.traceback[_loc2_].file + ", ";
               _loc1_ += "line " + this.traceback[_loc2_].line + ", ";
               _loc1_ += "in " + this.traceback[_loc2_].func + "\n";
               _loc1_ += "  " + this.traceback[_loc2_].text + "\n";
               _loc2_++;
            }
         }
         return _loc1_ + this.short;
      }
   }
}
