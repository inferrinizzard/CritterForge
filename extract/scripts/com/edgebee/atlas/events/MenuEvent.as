package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class MenuEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "ITEM_CLICK";
      
      public static const CLOSED:String = "CLOSED";
       
      
      public var data:Object;
      
      public function MenuEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.data = param2;
      }
   }
}
