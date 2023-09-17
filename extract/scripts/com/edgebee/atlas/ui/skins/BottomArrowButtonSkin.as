package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.Button;
   import flash.filters.DropShadowFilter;
   
   public class BottomArrowButtonSkin extends CustomizableButtonSkin
   {
       
      
      public function BottomArrowButtonSkin(param1:Component)
      {
         super(param1);
         width = height = 16;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _customShape.filters = [new DropShadowFilter(2,45,0,0.5)];
      }
      
      override protected function drawContent() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = component.width * 0.2;
         var _loc3_:Number = _loc2_;
         var _loc4_:Number;
         var _loc5_:Number = _loc4_ = component.height * 0.2;
         if((component as Button).state == "disabled")
         {
            _loc1_ = getStyle("DisabledColor");
         }
         else
         {
            _loc1_ = getStyle("FontColor",734012);
         }
         _customShape.graphics.clear();
         _customShape.graphics.beginFill(_loc1_,1);
         _customShape.graphics.moveTo(_loc2_,_loc4_);
         _customShape.graphics.lineTo(component.width / 2,component.height - _loc5_);
         _customShape.graphics.lineTo(component.width - _loc3_,_loc4_);
         _customShape.graphics.lineTo(_loc2_,_loc4_);
         _customShape.graphics.endFill();
      }
   }
}
