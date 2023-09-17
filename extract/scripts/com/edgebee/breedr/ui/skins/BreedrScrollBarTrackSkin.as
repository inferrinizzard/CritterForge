package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.skins.Skin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class BreedrScrollBarTrackSkin extends Skin
   {
       
      
      public function BreedrScrollBarTrackSkin(param1:Component = null)
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
         var _loc3_:uint = 0;
         var _loc4_:uint = UIUtils.adjustBrightness2(_loc3_,35);
         var _loc5_:uint = UIUtils.adjustBrightness(_loc3_,10);
         var _loc6_:Matrix;
         (_loc6_ = new Matrix()).createGradientBox(parent.width,parent.height,0);
         graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc4_],[1,1],[0,255],_loc6_);
         graphics.drawRect(2,2,parent.width - 4,parent.height - 4);
         graphics.endFill();
         _loc6_.createGradientBox(parent.width,parent.height,0);
         graphics.lineStyle(1,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc4_,_loc5_],[1,1],[0,255],_loc6_);
         graphics.moveTo(2,0);
         graphics.lineTo(2,parent.height);
         graphics.moveTo(parent.width - 2,0);
         graphics.lineTo(parent.width - 2,parent.height);
         graphics.lineStyle(0,0);
      }
      
      private function onParentResize(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
