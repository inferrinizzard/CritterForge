package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class ScrollEvent extends Event
   {
      
      public static const CONTENT_RESIZE:String = "SCROLL_CONTENT_RESIZE";
       
      
      public function ScrollEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
