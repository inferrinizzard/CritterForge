package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class PropertyChangeEvent extends Event
   {
      
      public static const PROPERTY_CHANGE:String = "propertyChange";
       
      
      public var source:Object;
      
      public var property:String;
      
      public var oldValue:Object;
      
      public var newValue:Object;
      
      public function PropertyChangeEvent(param1:String, param2:Object, param3:String, param4:Object, param5:Object, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,param6,param7);
         this.source = param2;
         this.property = param3;
         this.oldValue = param4;
         this.newValue = param5;
      }
      
      public static function create(param1:Object, param2:String, param3:Object, param4:Object, param5:Boolean = false, param6:Boolean = false) : PropertyChangeEvent
      {
         return new PropertyChangeEvent(PROPERTY_CHANGE,param1,param2,param3,param4,param5,param6);
      }
   }
}
