package com.edgebee.atlas.events
{
   import flash.events.Event;
   
   public class CollectionEvent extends Event
   {
      
      public static const COLLECTION_CHANGE:String = "collectionChange";
      
      public static const ADD:String = "ADD";
      
      public static const REMOVE:String = "REMOVE";
      
      public static const RESET:String = "RESET";
      
      public static const REPLACED:String = "REPLACED";
      
      public static const ITEM_CHANGED:String = "ITEM_CHANGED";
       
      
      public var kind:String;
      
      public var subject:Object;
      
      public var index:int;
      
      public function CollectionEvent(param1:String, param2:String, param3:Object, param4:int, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.kind = param2;
         this.subject = param3;
         this.index = param4;
      }
   }
}
