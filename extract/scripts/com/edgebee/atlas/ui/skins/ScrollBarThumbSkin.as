package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import flash.events.Event;
   
   public class ScrollBarThumbSkin extends Skin
   {
       
      
      public function ScrollBarThumbSkin(param1:Component = null)
      {
         super(param1);
         includeInLayout = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         parent.addEventListener(Component.RESIZE,this.onParentResize);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.beginFill(0,0.5);
         graphics.drawRect(0,0,parent.width,parent.height);
         graphics.endFill();
      }
      
      private function onParentResize(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
