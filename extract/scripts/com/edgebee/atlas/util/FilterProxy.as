package com.edgebee.atlas.util
{
   import flash.events.IEventDispatcher;
   import flash.filters.BitmapFilter;
   
   public interface FilterProxy extends IEventDispatcher
   {
       
      
      function get enabled() : Boolean;
      
      function get type() : Class;
      
      function get filter() : BitmapFilter;
      
      function reset() : void;
   }
}
