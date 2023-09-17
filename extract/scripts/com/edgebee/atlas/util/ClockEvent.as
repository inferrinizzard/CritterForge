package com.edgebee.atlas.util
{
   import flash.events.Event;
   
   public class ClockEvent extends Event
   {
      
      public static const TICK:String = "tick";
       
      
      public var defaultDeltaTime:Number;
      
      public var deltaTime:Number;
      
      public var gameTime:Number;
      
      public function ClockEvent(param1:Number, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false)
      {
         super(TICK,param4,param5);
         this.defaultDeltaTime = param1;
         this.deltaTime = param2;
         this.gameTime = param3;
      }
   }
}
