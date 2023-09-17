package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   
   public class DefaultListOverStateSkin extends Skin
   {
       
      
      private var _fillColor:uint;
      
      private var _alpha:Number;
      
      public function DefaultListOverStateSkin(param1:Component)
      {
         super(param1);
         this._fillColor = param1.getStyle("OverState.Color");
         this._alpha = param1.getStyle("OverState.Alpha");
         includeInLayout = false;
         mouseEnabled = false;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.clear();
         graphics.beginFill(this._fillColor,this._alpha);
         graphics.lineStyle(1,this._fillColor,Math.min(1,this._alpha * 2),true);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
