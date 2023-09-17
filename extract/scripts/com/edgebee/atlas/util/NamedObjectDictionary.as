package com.edgebee.atlas.util
{
   import com.edgebee.atlas.interfaces.INamed;
   import flash.utils.Dictionary;
   
   public class NamedObjectDictionary
   {
       
      
      private var _components:Dictionary;
      
      public function NamedObjectDictionary()
      {
         super();
         this._components = new Dictionary();
      }
      
      public function add(param1:INamed, param2:String) : void
      {
         if(this._components.hasOwnProperty(param2))
         {
            delete this._components[param2];
         }
         this._components[param1.name] = new WeakReference(param1);
      }
      
      public function get(param1:String) : INamed
      {
         if(this._components.hasOwnProperty(param1))
         {
            return this._components[param1].get();
         }
         return null;
      }
   }
}
