package com.edgebee.atlas.ui
{
   import flash.events.IEventDispatcher;
   
   public interface Listable extends IComponent, IEventDispatcher
   {
       
      
      function get listElement() : Object;
      
      function set listElement(param1:Object) : void;
      
      function get selected() : Boolean;
      
      function set selected(param1:Boolean) : void;
      
      function get highlighted() : Boolean;
      
      function set highlighted(param1:Boolean) : void;
   }
}
