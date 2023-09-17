package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class WindowSkin extends WindowSkinBase
   {
       
      
      protected var _titleBar:Box;
      
      public var titleLblBox:Box;
      
      public var titleLbl:Label;
      
      public var closeBtn:Button;
      
      private var _hasTitleIcon:Boolean;
      
      private var _titleBarLayout:Array;
      
      public function WindowSkin(param1:Component)
      {
         this._titleBarLayout = [{
            "CLASS":Box,
            "ID":"titleLblBox",
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"titleLbl"
            }]
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Button,
            "ID":"closeBtn",
            "STYLES":{"Skin":UIGlobals.getStyle("Window.CloseButton.Skin")},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onCloseButtonClick"
            }]
         }];
         super(param1);
         filters = [new DropShadowFilter(5,135,0,1,8,8,1)];
      }
      
      override public function get styleClassName() : String
      {
         return "WindowSkin";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         window.statusBar.layoutInvisibleChildren = false;
         window.content.horizontalAlign = Box.ALIGN_CENTER;
         window.content.verticalAlign = Box.ALIGN_MIDDLE;
         window.content.setStyle("PaddingLeft",getStyle("WindowContent.PaddingLeft",5));
         window.content.setStyle("PaddingRight",getStyle("WindowContent.PaddingRight",5));
         window.content.setStyle("PaddingTop",getStyle("WindowContent.PaddingTop",5));
         window.content.setStyle("PaddingBottom",getStyle("WindowContent.PaddingBottom",5));
         this._titleBar = new Box();
         this._titleBar.name = "WindowSkin._titleBar";
         this._titleBar.spreadProportionality = false;
         this._titleBar.verticalAlign = Box.ALIGN_MIDDLE;
         this._titleBar.layoutInvisibleChildren = false;
         this._titleBar.useMouseScreen = true;
         UIUtils.performLayout(this,this._titleBar,this._titleBarLayout);
         this.titleLbl.setStyle("FontColor",getStyle("WindowTitle.FontColor"));
         this.titleLbl.setStyle("FontWeight",getStyle("WindowTitle.FontWeight"));
         this.titleLbl.setStyle("FontSize",getStyle("WindowTitle.FontSize"));
         _layoutBox.addChild(this._titleBar);
         _layoutBox.addChild(window.content);
         _layoutBox.addChild(window.statusBar);
         window.setDragComponent(this._titleBar);
         this.closeBtn.visible = window.showCloseButton;
         this.refreshTitle(window.title);
         this.refreshIcon(window.titleIcon);
         this.refreshCloseButtonVisibility(window.showCloseButton);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(measuredWidth < this.titleLblBox.width + this.closeBtn.width + 5)
         {
            measuredWidth = this.titleLblBox.width + this.closeBtn.width + 5;
         }
      }
      
      override protected function refreshTitle(param1:*) : void
      {
         this.titleLbl.text = param1;
      }
      
      override protected function refreshIcon(param1:*) : void
      {
         if(window.titleIcon)
         {
            if(!this._hasTitleIcon)
            {
               this._hasTitleIcon = true;
            }
            else
            {
               this.titleLblBox.removeChildAt(this.titleLblBox.getChildIndex(this.titleLbl) - 1);
            }
            this.titleLblBox.addChildAt(window.titleIcon,this.titleLblBox.getChildIndex(this.titleLbl));
         }
         else if(this._hasTitleIcon)
         {
            this._hasTitleIcon = false;
            this.titleLblBox.removeChildAt(this.titleLblBox.getChildIndex(this.titleLbl) - 1);
         }
      }
      
      override protected function refreshCloseButtonVisibility(param1:Boolean) : void
      {
         this.closeBtn.visible = param1;
      }
      
      public function onCloseButtonClick(param1:MouseEvent) : void
      {
         window.doClose();
      }
   }
}
