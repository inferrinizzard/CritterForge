package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.Exception;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.TextWindow;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.events.Event;
   
   public class ExceptionWindow extends TextWindow
   {
       
      
      private var ExclamationIconBitmap:Class;
      
      private var _exception:Exception;
      
      public function ExceptionWindow()
      {
         this.ExclamationIconBitmap = ExceptionWindow_ExclamationIconBitmap;
         super();
         width = UIGlobals.relativizeX(800);
         height = UIGlobals.relativizeY(600);
         setStyle("Padding",10);
         var _loc1_:BitmapComponent = UIUtils.createBitmapIcon(this.ExclamationIconBitmap,16,16);
         titleIcon = _loc1_;
         centered = true;
      }
      
      public function get exception() : Exception
      {
         return this._exception;
      }
      
      public function set exception(param1:Exception) : void
      {
         this._exception = param1;
         title = this.exception.cls;
         text = this.exception.render;
      }
      
      override protected function onSBChildrenCreated(param1:Event) : void
      {
         super.onSBChildrenCreated(param1);
         update();
      }
   }
}
