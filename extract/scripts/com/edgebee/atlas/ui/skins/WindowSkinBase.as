package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import flash.display.Bitmap;
   
   public class WindowSkinBase extends Skin
   {
       
      
      protected var _layoutBox:Box;
      
      public function WindowSkinBase(param1:Component)
      {
         super(param1);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChanged);
      }
      
      override public function get styleClassName() : String
      {
         return "WindowSkinBase";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      protected function get window() : Window
      {
         return component as Window;
      }
      
      override protected function onStyleChanged(param1:StyleChangedEvent) : void
      {
         super.onStyleChanged(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.window.statusBar.spreadProportionality = false;
         this._layoutBox = new Box(Box.VERTICAL);
         this._layoutBox.name = "WindowSkin:_layoutBox";
         this._layoutBox.setStyle("PaddingTop",getStyle("PaddingTop"));
         this._layoutBox.setStyle("PaddingBottom",getStyle("PaddingBottom"));
         this._layoutBox.setStyle("PaddingLeft",getStyle("PaddingLeft"));
         this._layoutBox.setStyle("PaddingRight",getStyle("PaddingRight"));
         this._layoutBox.autoSizeChildren = true;
         addChild(this._layoutBox);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(this.window.percentWidth) || Boolean(this.window.explicitWidth))
         {
            measuredWidth = this.window.width;
            this._layoutBox.percentWidth = 1;
         }
         else
         {
            measuredWidth = this._layoutBox.width;
         }
         if(Boolean(this.window.percentHeight) || Boolean(this.window.explicitHeight))
         {
            measuredHeight = this.window.height;
            this._layoutBox.percentHeight = 1;
         }
         else
         {
            measuredHeight = this._layoutBox.height;
         }
      }
      
      protected function refreshTitle(param1:*) : void
      {
      }
      
      protected function refreshIcon(param1:*) : void
      {
      }
      
      protected function refreshCloseButtonVisibility(param1:Boolean) : void
      {
      }
      
      private function onComponentChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "title")
         {
            this.refreshTitle(param1.newValue);
         }
         else if(param1.property == "titleIcon")
         {
            if(param1.newValue is Bitmap)
            {
               this.refreshIcon(param1.newValue as Bitmap);
            }
            else
            {
               this.refreshIcon(param1.newValue as String);
            }
         }
         else if(param1.property == "showCloseButton")
         {
            this.refreshCloseButtonVisibility(param1.newValue as Boolean);
         }
      }
   }
}
