package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import flash.filters.DropShadowFilter;
   
   public class CloseButtonSkin extends CustomizableButtonSkin
   {
       
      
      public function CloseButtonSkin(param1:Component)
      {
         super(param1);
         width = 16;
         height = 16;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _customShape.filters = [new DropShadowFilter(2,45,0,0.5)];
      }
      
      override protected function drawContent() : void
      {
         _customShape.graphics.clear();
         _customShape.graphics.lineStyle(3,0,1,true);
         _customShape.graphics.moveTo(3,3);
         _customShape.graphics.lineTo(width - 4,height - 4);
         _customShape.graphics.moveTo(3,height - 4);
         _customShape.graphics.lineTo(width - 4,3);
      }
   }
}
