package com.edgebee.atlas.util.fsm
{
   import com.edgebee.atlas.util.WeakReference;
   
   public class State
   {
       
      
      private var _machine:WeakReference;
      
      private var name:String;
      
      public function State(param1:Machine, param2:String = null)
      {
         super();
         this._machine = new WeakReference(param1,Machine);
         this.name = param2;
      }
      
      public function get machine() : Machine
      {
         return this._machine.get() as Machine;
      }
      
      public function transitionInto(param1:Boolean = false) : void
      {
         if(param1)
         {
         }
      }
      
      public function loop(param1:Boolean = false) : *
      {
         if(param1)
         {
         }
         return Result.CONTINUE;
      }
      
      public function transitionOut(param1:Boolean = false) : void
      {
         if(param1)
         {
         }
      }
   }
}
