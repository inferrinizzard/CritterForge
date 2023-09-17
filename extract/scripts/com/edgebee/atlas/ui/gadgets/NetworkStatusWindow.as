package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.utils.UIUtils;
   
   public class NetworkStatusWindow extends Window
   {
       
      
      private var _client:Client;
      
      public var statusView:com.edgebee.atlas.ui.gadgets.NetworkStatus;
      
      private var _contentLayout:Array;
      
      public function NetworkStatusWindow(param1:Client)
      {
         this._contentLayout = [{
            "CLASS":com.edgebee.atlas.ui.gadgets.NetworkStatus,
            "ID":"statusView",
            "percentWidth":1,
            "percentHeight":1
         }];
         super();
         this._client = param1;
         showCloseButton = false;
         width = 300;
         height = 150;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         title = Asset.getInstanceByName("WAITING_FOR_SERVER");
         titleIcon = UIUtils.createBitmapIcon(ServerConnectionView.TransferIconPng,16,16);
         content.setStyle("PaddingTop",10);
         content.setStyle("PaddingBottom",10);
         content.setStyle("PaddingLeft",10);
         content.setStyle("PaddingRight",10);
         UIUtils.performLayout(this,content,this._contentLayout);
         this.statusView.service = this._client.service;
         this.statusView.setStyle("FontSize",12);
      }
   }
}
