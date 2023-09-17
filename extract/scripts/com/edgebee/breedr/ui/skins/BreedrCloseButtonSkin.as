package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Canvas;
   
   public class BreedrCloseButtonSkin extends BreedrButtonSkin
   {
       
      
      private var _content:Canvas;
      
      public function BreedrCloseButtonSkin(param1:Component)
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
         this._content.width = 8;
         this._content.height = 8;
         this._content.glowProxy.blur = 3;
         this._content.glowProxy.color = 0;
         this._content.glowProxy.alpha = 1;
         this._content.glowProxy.strength = 4;
         _layoutBox.addChild(this._content);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = button.state == "over" ? 16724787 : 16711680;
         this._content.graphics.clear();
         this._content.graphics.lineStyle(3,_loc3_,1,true);
         this._content.graphics.moveTo(0,0);
         this._content.graphics.lineTo(7,7);
         this._content.graphics.moveTo(0,7);
         this._content.graphics.lineTo(7,0);
      }
   }
}
