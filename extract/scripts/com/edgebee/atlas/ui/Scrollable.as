package com.edgebee.atlas.ui
{
   import flash.events.IEventDispatcher;
   
   public interface Scrollable extends IComponent, IEventDispatcher
   {
       
      
      function get scrollStepSize() : Number;
      
      function get scrollPosition() : Number;
      
      function set scrollPosition(param1:Number) : void;
      
      function get scrollMinPosition() : Number;
      
      function get scrollVisibleSize() : Number;
      
      function get scrollMaxPosition() : Number;
   }
}
