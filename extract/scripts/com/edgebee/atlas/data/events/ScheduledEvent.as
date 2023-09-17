package com.edgebee.atlas.data.events
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.ui.UIGlobals;
   
   public class ScheduledEvent extends Data implements IExecutable
   {
      
      public static const TYPE_MILLISECONDS:uint = 0;
      
      public static const TYPE_TICKS:uint = 1;
      
      public static const TYPE_TICK_FRACTIONS:uint = 2;
       
      
      public var conditionFunc:Function;
      
      public function ScheduledEvent(param1:Object)
      {
         super(param1);
      }
      
      public function execute() : void
      {
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client;
      }
      
      public function get active() : Boolean
      {
         return false;
      }
   }
}
