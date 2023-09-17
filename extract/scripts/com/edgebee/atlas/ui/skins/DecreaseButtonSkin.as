package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import flash.filters.DropShadowFilter;
   
   public class DecreaseButtonSkin extends CustomizableButtonSkin
   {
       
      
      public function DecreaseButtonSkin(param1:Component)
      {
         super(param1);
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
         _customShape.graphics.moveTo(6,component.height / 2);
         _customShape.graphics.lineTo(component.width - 6,component.height / 2);
      }
   }
}
