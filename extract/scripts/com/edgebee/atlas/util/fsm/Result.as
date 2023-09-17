package com.edgebee.atlas.util.fsm
{
   public class Result
   {
      
      public static const CONTINUE:uint = 0;
      
      public static const STOP:uint = 1;
      
      public static const TRANSITION:uint = 2;
       
      
      private var _type:uint;
      
      private var _next:com.edgebee.atlas.util.fsm.State;
      
      public function Result(param1:uint = 0, param2:com.edgebee.atlas.util.fsm.State = null)
      {
         super();
         this._type = param1;
         this._next = param2;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get state() : com.edgebee.atlas.util.fsm.State
      {
         return this._next;
      }
   }
}
