package com.edgebee.atlas.data
{
   import flash.events.IEventDispatcher;
   
   public interface ICollection extends IEventDispatcher
   {
       
      
      function get length() : int;
      
      function contains(param1:Object) : Boolean;
      
      function addItem(param1:Object) : void;
      
      function addItemAt(param1:Object, param2:int) : void;
      
      function getItemAt(param1:int, param2:int = 0) : Object;
      
      function getItemIndex(param1:Object) : int;
      
      function removeAll() : void;
      
      function removeItemAt(param1:int) : Object;
      
      function setItemAt(param1:Object, param2:int) : Object;
      
      function sort(param1:Function) : void;
   }
}
