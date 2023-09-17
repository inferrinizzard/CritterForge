package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class KongPackageWindow extends Window
   {
      
      public static var KredTokenPng:Class = KongPackageWindow_KredTokenPng;
      
      public static var TokenIcon32Png:Class = KongPackageWindow_TokenIcon32Png;
       
      
      public var option1Btn:Button;
      
      public var option2Btn:Button;
      
      public var option3Btn:Button;
      
      public var option4Btn:Button;
      
      public var option5Btn:Button;
      
      public var cancelBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function KongPackageWindow()
      {
         this._contentLayout = [{
            "CLASS":Button,
            "ID":"option1Btn",
            "userData":"option1",
            "STYLES":{
               "HTMLButton":true,
               "IconSide":"left"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOptionClick
            }]
         },{
            "CLASS":Button,
            "ID":"option2Btn",
            "userData":"option2",
            "STYLES":{
               "HTMLButton":true,
               "IconSide":"left"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOptionClick
            }]
         },{
            "CLASS":Button,
            "ID":"option3Btn",
            "userData":"option3",
            "STYLES":{
               "HTMLButton":true,
               "IconSide":"left"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOptionClick
            }]
         },{
            "CLASS":Button,
            "ID":"option4Btn",
            "userData":"option4",
            "STYLES":{
               "HTMLButton":true,
               "IconSide":"left"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOptionClick
            }]
         },{
            "CLASS":Button,
            "ID":"option5Btn",
            "userData":"option5",
            "STYLES":{
               "HTMLButton":true,
               "IconSide":"left"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOptionClick
            }]
         }];
         this._statusLayout = [{
            "CLASS":Button,
            "ID":"cancelBtn",
            "label":Asset.getInstanceByName("CANCEL"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onCancelClick
            }]
         }];
         super();
         title = Asset.getInstanceByName("ADD_TOKENS");
         titleIcon = UIUtils.createBitmapIcon(TokenIcon32Png,16,16);
         centered = true;
         draggable = false;
         showCloseButton = true;
         UIGlobals.l10nManager.addEventListener(Event.CHANGE,this.onLocaleChange);
      }
      
      private function onOptionClick(param1:MouseEvent) : void
      {
         enabled = false;
         switch((param1.target as Button).userData)
         {
            case "option1":
               client.kongregateApi.mtx.purchaseItems(["tokens_package_kong_100"],this.onPurchaseComplete);
               break;
            case "option2":
               client.kongregateApi.mtx.purchaseItems(["tokens_package_kong_500"],this.onPurchaseComplete);
               break;
            case "option3":
               client.kongregateApi.mtx.purchaseItems(["tokens_package_kong_1000"],this.onPurchaseComplete);
               break;
            case "option4":
               client.kongregateApi.mtx.purchaseItems(["tokens_package_kong_2500"],this.onPurchaseComplete);
               break;
            case "option5":
               client.kongregateApi.mtx.purchaseItems(["tokens_package_kong_5000"],this.onPurchaseComplete);
         }
      }
      
      private function onPurchaseComplete(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.success)
         {
            _loc2_ = client.createInput();
            _loc2_.user_id = client.kongregateApi.services.getUserId();
            _loc2_.game_auth_token = client.kongregateApi.services.getGameAuthToken();
            client.service.KongregatePurchase(_loc2_);
         }
         doClose();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         doClose();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.direction = Box.VERTICAL;
         content.horizontalAlign = Box.ALIGN_CENTER;
         content.verticalAlign = Box.ALIGN_MIDDLE;
         content.setStyle("PaddingLeft",15);
         content.setStyle("PaddingRight",15);
         content.setStyle("PaddingTop",15);
         content.setStyle("PaddingBottom",15);
         content.setStyle("Gap",20);
         UIUtils.performLayout(this,this.content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_RIGHT;
         statusBar.setStyle("Gap",20);
         UIUtils.performLayout(this,statusBar,this._statusLayout);
         this.update();
      }
      
      private function onLocaleChange(param1:Event) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.option1Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("KONGREGATE_PACKAGE").value,{
               "tokens":(100).toString(),
               "kreds":(10).toString()
            }),null,16777215,20,false,false,"center");
            this.option1Btn.icon = UIUtils.createBitmapIcon(KredTokenPng,64,32);
            this.option2Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("KONGREGATE_PACKAGE").value,{
               "tokens":(500).toString(),
               "kreds":(50).toString()
            }),null,16777215,20,false,false,"center");
            this.option2Btn.icon = UIUtils.createBitmapIcon(KredTokenPng,64,32);
            this.option3Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("KONGREGATE_PACKAGE").value,{
               "tokens":(1000).toString(),
               "kreds":(100).toString()
            }),null,16777215,20,false,false,"center");
            this.option3Btn.icon = UIUtils.createBitmapIcon(KredTokenPng,64,32);
            this.option4Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("KONGREGATE_PACKAGE").value,{
               "tokens":(2500).toString(),
               "kreds":(250).toString()
            }),null,16777215,20,false,false,"center");
            this.option4Btn.icon = UIUtils.createBitmapIcon(KredTokenPng,64,32);
            this.option5Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("KONGREGATE_PACKAGE").value,{
               "tokens":(5000).toString(),
               "kreds":(500).toString()
            }),null,16777215,20,false,false,"center");
            this.option5Btn.icon = UIUtils.createBitmapIcon(KredTokenPng,64,32);
         }
      }
   }
}
