package com.edgebee.atlas.events
{
   import com.edgebee.atlas.ui.Component;
   import flash.events.Event;
   
   public class DragEvent extends Event
   {
      
      public static const DRAG_ENTER:String = "dragEnter";
      
      public static const DRAG_OVER:String = "dragOver";
      
      public static const DRAG_EXIT:String = "dragExit";
      
      public static const DRAG_DROP:String = "dragDrop";
      
      public static const DRAG_COMPLETE:String = "dragComplete";
       
      
      public var dragInitiator:Component;
      
      public var dragInfo:Object;
      
      public var dragProxy:Component;
      
      public function DragEvent(param1:String, param2:Component, param3:Object, param4:Component, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.dragInitiator = param2;
         this.dragInfo = param3;
         this.dragProxy = param4;
      }
   }
}
