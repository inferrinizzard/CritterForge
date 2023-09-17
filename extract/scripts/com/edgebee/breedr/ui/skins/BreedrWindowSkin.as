package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.WindowSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.events.Event;
   
   public class BreedrWindowSkin extends WindowSkin
   {
       
      
      public var bg:com.edgebee.breedr.ui.skins.TransparentWindow;
      
      private var _layout:Array;
      
      public function BreedrWindowSkin(param1:Component)
      {
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.skins.TransparentWindow,
            "ID":"bg",
            "percentWidth":1,
            "percentHeight":1
         }];
         super(param1);
         filters = [];
         setStyle("BackgroundAlpha",0);
         setStyle("BorderThickness",0);
         setStyle("SoftBorderThickness",0);
         param1.addEventListener(Component.RESIZE,this.onWindowResized);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout,false,0);
         titleLbl.glowProxy.color = 24831;
         titleLbl.glowProxy.alpha = 0.85;
         titleLbl.glowProxy.blur = 5;
         titleLbl.glowProxy.strength = 2;
         titleLbl.glowProxy.quality = 1;
         _layoutBox.setStyle("Gap",UIGlobals.relativize(5));
         window.content.setStyle("BackgroundAlpha",0.25);
         window.content.setStyle("BackgroundColor",0);
         window.content.setStyle("CornerRadius",5);
         window.content.setStyle("BorderAlpha",0.75);
         window.content.setStyle("BorderThickness",2);
         window.content.setStyle("BorderColor",UIUtils.adjustBrightness2(UIGlobals.getStyle("ThemeColor"),-50));
         window.content.setStyle("Padding",15);
      }
      
      private function onWindowResized(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
