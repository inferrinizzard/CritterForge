package com.edgebee.breedr.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.chat.ChatWindow;
   import flash.events.MouseEvent;
   
   public class BreedrChatWindowSkin extends BreedrWindowSkin
   {
       
      
      private var _toVerticalModeButton:Button;
      
      private var _fromVerticalModeButton:Button;
      
      public function BreedrChatWindowSkin(param1:Component)
      {
         super(param1);
         this.chatWindow.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onChatWindowChange);
      }
      
      public function get chatWindow() : ChatWindow
      {
         return window as ChatWindow;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _layoutBox.autoSizeChildren = false;
         _layoutBox.spreadProportionality = false;
         _titleBar.percentWidth = 1;
         this._toVerticalModeButton = new Button();
         this._toVerticalModeButton.addEventListener(MouseEvent.CLICK,this.onToLeftModeClick);
         this._toVerticalModeButton.setStyle("Skin",BreedrRightArrowButtonSkin);
         this._fromVerticalModeButton = new Button();
         this._fromVerticalModeButton.addEventListener(MouseEvent.CLICK,this.onFromLeftModeClick);
         this._fromVerticalModeButton.setStyle("Skin",BreedrLeftArrowButtonSkin);
         this.updateLayoutButtons();
         _titleBar.addChildAt(this._toVerticalModeButton,_titleBar.numChildren - 1);
         _titleBar.addChildAt(this._fromVerticalModeButton,_titleBar.numChildren - 1);
      }
      
      private function onToLeftModeClick(param1:MouseEvent) : void
      {
         var _loc2_:ChatWindow = this.chatWindow;
         _loc2_.layoutMode = ChatWindow.LAYOUT_MODE_VERTICAL;
      }
      
      private function onFromLeftModeClick(param1:MouseEvent) : void
      {
         var _loc2_:ChatWindow = this.chatWindow;
         _loc2_.layoutMode = ChatWindow.LAYOUT_MODE_NORMAL;
      }
      
      private function updateLayoutButtons() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this._toVerticalModeButton.visible = this.chatWindow.layoutMode != ChatWindow.LAYOUT_MODE_VERTICAL;
            this._fromVerticalModeButton.visible = this.chatWindow.layoutMode == ChatWindow.LAYOUT_MODE_VERTICAL;
         }
      }
      
      private function onChatWindowChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "layoutMode")
         {
            this.updateLayoutButtons();
         }
      }
   }
}
