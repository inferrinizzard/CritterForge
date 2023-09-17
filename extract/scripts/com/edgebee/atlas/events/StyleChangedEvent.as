package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class StyleChangedEvent extends Event
   {
      
      public static const STYLE_CHANGED:String = "STYLE_CHANGED";
       
      
      public var style:String;
      
      public var oldValue;
      
      public var newValue;
      
      public function StyleChangedEvent(param1:String, param2:*, param3:*, param4:Boolean = false, param5:Boolean = false)
      {
         super(STYLE_CHANGED,param4,param5);
         this.style = param1;
         this.oldValue = param2;
         this.newValue = param3;
      }
   }
}
