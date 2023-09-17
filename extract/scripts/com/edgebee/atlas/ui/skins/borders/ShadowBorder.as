package com.edgebee.atlas.ui.skins.borders
{
   import com.edgebee.atlas.ui.Component;
   import flash.display.GradientType;
   import flash.geom.Matrix;
   
   public class ShadowBorder extends Border
   {
       
      
      public function ShadowBorder(param1:Component = null)
      {
         super(param1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:Matrix = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:* = getStyle("ShadowBorderEnabled",false);
         graphics.clear();
         if(_loc3_)
         {
            _loc4_ = getStyle("ShadowBorderColor",0);
            _loc5_ = getStyle("ShadowBorderRatios",null);
            _loc6_ = getStyle("ShadowBorderAlpha",1);
            _loc7_ = getStyle("ShadowBorderGradientSizeFactor",{
               "width":1,
               "height":1
            });
            (_loc8_ = new Matrix()).createGradientBox(component.width * _loc7_.width,component.height * _loc7_.height,0,-(component.width / 2) * (_loc7_.width - 1),-(component.height / 2) * (_loc7_.height - 1));
            _loc9_ = _loc4_ is Array ? _loc4_ : [_loc4_,_loc4_];
            _loc10_ = _loc6_ is Array ? _loc6_ : [0,_loc6_];
            _loc11_ = !!_loc5_ ? _loc5_ : [0,255];
            if(!(_loc9_.length == _loc10_.length && _loc9_.length == _loc11_.length))
            {
               throw new Error("Number of colors, alphas and ratios must match");
            }
            graphics.beginGradientFill(GradientType.RADIAL,_loc9_,_loc10_,_loc11_,_loc8_);
            graphics.drawRect(0,0,component.width,component.height);
            graphics.endFill();
         }
      }
   }
}
