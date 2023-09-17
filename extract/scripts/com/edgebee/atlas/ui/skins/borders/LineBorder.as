package com.edgebee.atlas.ui.skins.borders
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.ui.utils.types.CornerType;
   import com.edgebee.atlas.util.Color;
   import flash.display.GradientType;
   import flash.geom.Matrix;
   
   public class LineBorder extends Border
   {
       
      
      public function LineBorder(param1:Component = null)
      {
         super(param1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:* = undefined;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Matrix = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Color = null;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:* = getStyle("BorderAlpha",1);
         var _loc4_:* = getStyle("BorderThickness",0);
         if(_loc3_ && _loc4_)
         {
            _loc5_ = getStyle("BorderColor",0);
            _loc6_ = getStyle("BorderDirection",0);
            _loc7_ = getStyle("BorderRatios",null);
            _loc8_ = getStyle("BorderCornerRadius",getStyle("CornerRadius",0));
            _loc9_ = getStyle("CornerType",CornerType.ROUND);
            _loc10_ = getStyle("BorderOffset",0);
            _loc11_ = getStyle("BeveledBorder",false);
            _loc12_ = getStyle("PixelHinting",true);
            (_loc13_ = new Matrix()).createGradientBox(component.width + _loc10_,component.height + _loc10_,_loc6_);
            if(_loc5_ is Array)
            {
               if(_loc5_.length < 2)
               {
                  throw new Error("Must specify at least two colors in BackgroundColor array.");
               }
               _loc14_ = _loc7_;
               if(_loc3_ is Array && _loc3_.length == _loc5_.length)
               {
                  _loc15_ = _loc3_;
               }
               else
               {
                  _loc15_ = [];
                  _loc16_ = 0;
                  while(_loc16_ < _loc5_.length)
                  {
                     _loc15_.push(_loc3_);
                     _loc16_++;
                  }
               }
               if(!_loc14_)
               {
                  _loc14_ = [];
                  _loc17_ = 0;
                  while(_loc17_ < _loc5_.length)
                  {
                     _loc14_.push(_loc17_ / (_loc5_.length - 1) * 255);
                     _loc17_++;
                  }
               }
               if(!_loc11_)
               {
                  graphics.lineStyle(_loc4_,0,1,_loc12_);
                  graphics.lineGradientStyle(GradientType.LINEAR,_loc5_,_loc15_,_loc14_,_loc13_);
               }
            }
            else if(!_loc11_)
            {
               graphics.lineStyle(_loc4_,_loc5_,_loc3_,_loc12_);
            }
            if(_loc11_)
            {
               _loc19_ = new Color();
               _loc21_ = 0;
               while(_loc21_ < _loc4_)
               {
                  _loc18_ = 1 - ((_loc21_ + 1) / _loc4_ * 0.95 + 0.05);
                  if(_loc5_ is Array)
                  {
                     _loc20_ = [];
                     for each(_loc22_ in _loc5_)
                     {
                        _loc19_.hex = _loc22_;
                        _loc19_.brighten(-_loc18_ * 100 + 10);
                        _loc20_.push(_loc19_.hex);
                     }
                     graphics.lineStyle(_loc4_ - _loc21_,0,1,_loc12_);
                     graphics.lineGradientStyle(GradientType.LINEAR,_loc20_,_loc15_,_loc14_,_loc13_);
                  }
                  else
                  {
                     _loc19_.hex = _loc5_;
                     _loc19_.brighten(-_loc18_ * 100 + 10);
                     graphics.lineStyle(_loc4_ - _loc21_,_loc19_.hex,_loc3_,_loc12_);
                  }
                  if(_loc9_ == CornerType.SQUARE)
                  {
                     UIUtils.drawCorneredRect(graphics,-_loc10_,-_loc10_,component.width + _loc10_ * 2,component.height + _loc10_ * 2,_loc8_);
                  }
                  else
                  {
                     graphics.drawRoundRect(-_loc10_,-_loc10_,component.width + _loc10_ * 2,component.height + _loc10_ * 2,_loc8_,_loc8_);
                  }
                  _loc21_ += 2;
               }
            }
            else if(_loc9_ == CornerType.SQUARE)
            {
               UIUtils.drawCorneredRect(graphics,-_loc10_,-_loc10_,component.width + _loc10_ * 2,component.height + _loc10_ * 2,_loc8_);
            }
            else
            {
               graphics.drawRoundRect(-_loc10_,-_loc10_,component.width + _loc10_ * 2,component.height + _loc10_ * 2,_loc8_,_loc8_);
            }
         }
      }
   }
}
