package com.edgebee.atlas.util
{
   import flash.events.IEventDispatcher;
   
   public interface ITimer extends IEventDispatcher
   {
       
      
      function get currentCount() : int;
      
      function get running() : Boolean;
      
      function get delay() : Number;
      
      function set delay(param1:Number) : void;
      
      function get repeatCount() : int;
      
      function set repeatCount(param1:int) : void;
      
      function start() : void;
      
      function stop() : void;
      
      function reset() : void;
   }
}
