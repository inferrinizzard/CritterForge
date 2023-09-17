package com.edgebee.atlas.ui.skins.borders
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class SoftBorder extends Border
   {
       
      
      private var cornerRadiusMask:Sprite;
      
      public function SoftBorder(param1:Component = null)
      {
         this.cornerRadiusMask = new Sprite();
         super(param1);
         mouseEnabled = false;
      }
      
      public static function drawSoftEdge(param1:Graphics, param2:Rectangle, param3:uint, param4:Number, param5:Number, param6:Number = 0, param7:Boolean = false) : void
      {
         var _loc8_:uint = uint(param5 * 255 / param2.width);
         var _loc9_:uint = uint(param5 * 255 / param2.height);
         var _loc10_:Matrix;
         (_loc10_ = new Matrix()).createGradientBox(param2.width,param2.height,0,param2.x,param2.y);
         param1.beginGradientFill(GradientType.LINEAR,[param3,param3,param3,param3],[param4,0,0,param4],[0,_loc8_,255 - _loc8_,255],_loc10_);
         if(param6 == 0)
         {
            param1.drawRect(param2.x,param2.y,param2.width,param2.height);
         }
         else if(param7)
         {
            param1.drawRoundRect(param2.x,param2.y,param2.width,param2.height,param6,param6);
         }
         else
         {
            UIUtils.drawCorneredRect(param1,param2.x,param2.y,param2.width,param2.height,param6);
         }
         param1.endFill();
         _loc10_.createGradientBox(param2.width,param2.height,Math.PI / 2,param2.x,param2.y);
         param1.beginGradientFill(GradientType.LINEAR,[param3,param3,param3,param3],[param4,0,0,param4],[0,_loc9_,255 - _loc9_,255],_loc10_);
         if(param6 == 0)
         {
            param1.drawRect(param2.x,param2.y,param2.width,param2.height);
         }
         else if(param7)
         {
            param1.drawRoundRect(param2.x,param2.y,param2.width,param2.height,param6,param6);
         }
         else
         {
            UIUtils.drawCorneredRect(param1,param2.x,param2.y,param2.width,param2.height,param6);
         }
         param1.endFill();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:Number = getStyle("SoftBorderThickness",0);
         if(_loc3_ > 0)
         {
            _loc4_ = uint(_loc3_ * 255 / component.width);
            _loc5_ = uint(_loc3_ * 255 / component.height);
            _loc6_ = getStyle("BorderEdgeAlpha",0.25);
            _loc7_ = getStyle("SoftBorderColor",0);
            _loc8_ = getStyle("CornerRadius",0);
            if(_loc4_ > 0 && _loc5_ > 0)
            {
               drawSoftEdge(graphics,new Rectangle(0,0,component.width,component.height),_loc7_,_loc6_,_loc3_);
            }
            if(_loc8_ > 0)
            {
               this.cornerRadiusMask.graphics.clear();
               this.cornerRadiusMask.graphics.beginFill(16777215,1);
               this.cornerRadiusMask.graphics.drawRoundRect(0,0,component.width,component.height,_loc8_,_loc8_);
               this.cornerRadiusMask.graphics.endFill();
               if(!mask)
               {
                  addChild(this.cornerRadiusMask);
                  mask = this.cornerRadiusMask;
               }
            }
            else if(mask)
            {
               mask = null;
               removeChild(this.cornerRadiusMask);
            }
         }
         else if(mask)
         {
            mask = null;
            removeChild(this.cornerRadiusMask);
         }
      }
   }
}
