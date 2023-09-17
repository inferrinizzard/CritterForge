package com.edgebee.atlas.util
{
   import flash.utils.Dictionary;
   
   public class WeakReference
   {
       
      
      private var dictionary:Dictionary;
      
      private var restricted:Class;
      
      private var isSet:Boolean;
      
      public function WeakReference(param1:* = null, param2:Class = null)
      {
         super();
         this.restricted = param2;
         this.reset(param1);
      }
      
      public function get() : Object
      {
         var _loc1_:Object = null;
         if(this.isSet)
         {
            var _loc2_:int = 0;
            var _loc3_:* = this.dictionary;
            for(_loc1_ in _loc3_)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function reset(param1:*) : void
      {
         if(param1 && this.restricted && !(param1 is this.restricted))
         {
            throw new Error("WeakReference is configured only to store type " + Utils.getClassName(this.restricted) + ".");
         }
         if(param1)
         {
            this.isSet = true;
            this.dictionary = new Dictionary(true);
            this.dictionary[param1] = null;
         }
         else
         {
            this.isSet = false;
            this.dictionary = new Dictionary(true);
         }
      }
   }
}
