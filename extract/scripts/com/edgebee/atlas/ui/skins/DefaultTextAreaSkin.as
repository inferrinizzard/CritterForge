package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   
   public class DefaultTextAreaSkin extends Skin
   {
       
      
      private var _borderColor:uint;
      
      private var _fillColor:uint;
      
      public function DefaultTextAreaSkin(param1:Component)
      {
         super(param1);
         this._fillColor = param1.getStyle("BackgroundColor");
         this._borderColor = param1.getStyle("BorderColor");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.beginFill(this._borderColor,1);
         graphics.drawRect(0,0,component.width,component.height);
         graphics.endFill();
         graphics.beginFill(this._fillColor,1);
         graphics.drawRect(2,2,component.width - 4,component.height - 4);
         graphics.endFill();
      }
   }
}
