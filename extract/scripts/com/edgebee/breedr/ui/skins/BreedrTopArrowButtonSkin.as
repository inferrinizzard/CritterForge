package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.CapsStyle;
   import flash.display.GradientType;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.geom.Matrix;
   
   public class BreedrTopArrowButtonSkin extends BreedrButtonSkin
   {
       
      
      private var _content:Canvas;
      
      public function BreedrTopArrowButtonSkin(param1:Component)
      {
         super(param1);
      }
      
      override protected function createLayoutContent() : void
      {
         _layoutBox.setStyle("PaddingLeft",component.getStyle("PaddingLeft",10));
         _layoutBox.setStyle("PaddingRight",component.getStyle("PaddingRight",10));
         _layoutBox.setStyle("PaddingTop",component.getStyle("PaddingTop",8));
         _layoutBox.setStyle("PaddingBottom",component.getStyle("PaddingBottom",8));
         this._content = new Canvas();
         this._content.width = 6;
         this._content.height = 6;
         this._content.glowProxy.blur = 3;
         this._content.glowProxy.color = 0;
         this._content.glowProxy.alpha = 1;
         this._content.glowProxy.strength = 4;
         _layoutBox.addChild(this._content);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Matrix = new Matrix();
         var _loc4_:uint = UIGlobals.getStyle("ThemeColor2");
         _loc4_ = button.state == "over" ? UIUtils.adjustBrightness(_loc4_,50) : _loc4_;
         this._content.graphics.clear();
         _loc3_.createGradientBox(12,12,0,-3);
         this._content.graphics.lineStyle(0,_loc4_,1,true,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER);
         this._content.graphics.beginFill(_loc4_,1);
         this._content.graphics.beginGradientFill(GradientType.RADIAL,[UIUtils.adjustBrightness2(_loc4_,50),UIUtils.adjustBrightness2(_loc4_,-35)],[1,1],[0,255],_loc3_);
         this._content.graphics.moveTo(-3,7);
         this._content.graphics.lineTo(3,0);
         this._content.graphics.lineTo(9,7);
         this._content.graphics.lineTo(-3,7);
         this._content.graphics.endFill();
      }
   }
}
