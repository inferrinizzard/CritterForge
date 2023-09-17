package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.display.InterpolationMethod;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   
   public class BreedrScrollBarThumbSkin extends Skin
   {
       
      
      private var _mouseIsOver:Boolean = false;
      
      public function BreedrScrollBarThumbSkin(param1:Component = null)
      {
         super(param1);
         includeInLayout = false;
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         parent.addEventListener(Component.RESIZE,this.onParentResize);
         parent.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         parent.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = Math.max(0,UIGlobals.getStyle("CornerRadius",5));
         var _loc4_:uint = UIGlobals.getStyle("ThemeColor",3355630);
         var _loc5_:uint = UIUtils.adjustBrightness2(_loc4_,65);
         var _loc6_:uint = UIUtils.adjustBrightness2(_loc4_,-65);
         graphics.clear();
         var _loc7_:Matrix = new Matrix();
         if(!component.enabled)
         {
            colorMatrix.saturation = -100;
         }
         else
         {
            colorMatrix.reset();
         }
         if(component.enabled && this._mouseIsOver)
         {
            _loc8_ = UIUtils.adjustBrightness2(_loc5_,50);
            _loc9_ = UIUtils.adjustBrightness2(_loc4_,50);
            _loc10_ = UIUtils.adjustBrightness2(_loc4_,20);
            _loc11_ = _loc6_;
            _loc12_ = _loc5_;
         }
         else
         {
            _loc8_ = _loc5_;
            _loc9_ = _loc4_;
            _loc10_ = _loc4_;
            _loc11_ = _loc6_;
            _loc12_ = _loc5_;
         }
         _loc7_.createGradientBox(parent.width,parent.height,0);
         graphics.beginGradientFill(GradientType.LINEAR,[_loc10_,_loc11_],[1,1],[0,255],_loc7_,SpreadMethod.PAD,InterpolationMethod.RGB,0);
         graphics.drawRoundRect(1,1,parent.width - 2,parent.height - 2,_loc3_,_loc3_);
         graphics.endFill();
         graphics.beginFill(_loc12_,0.65);
         graphics.drawRoundRect(4,4,parent.width - 8,parent.height - 8,_loc3_ / 2,_loc3_ / 2);
         graphics.drawRoundRect(4 + parent.width / 6,4,parent.width - 8 - parent.width / 6,parent.height - 8,_loc3_ / 2,_loc3_ / 2);
         graphics.endFill();
         _loc7_.createGradientBox(parent.width,parent.height,Math.PI / 2);
         graphics.lineStyle(2,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc8_,_loc9_],[1,1],[25,255],_loc7_);
         graphics.drawRoundRect(1,1,parent.width - 2,parent.height - 2,_loc3_,_loc3_);
      }
      
      private function onParentResize(param1:Event) : void
      {
         invalidateDisplayList();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._mouseIsOver = true;
         invalidateDisplayList();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._mouseIsOver = false;
         invalidateDisplayList();
      }
   }
}
