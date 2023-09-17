package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Hi5PackageWindow extends Window
   {
      
      public static var Hi5CoinTokenPng:Class = Hi5PackageWindow_Hi5CoinTokenPng;
      
      public static var TokenIcon32Png:Class = Hi5PackageWindow_TokenIcon32Png;
       
      
      public var option1Btn:Button;
      
      public var option2Btn:Button;
      
      public var option3Btn:Button;
      
      public var option4Btn:Button;
      
      public var option5Btn:Button;
      
      public var cancelBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function Hi5PackageWindow()
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
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onPurchaseException);
         client.service.addEventListener("Hi5Purchase",this.onPurchaseComplete);
      }
      
      override public function doClose() : void
      {
         super.doClose();
         client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onPurchaseException);
         client.service.removeEventListener("Hi5Purchase",this.onPurchaseComplete);
      }
      
      private function onOptionClick(param1:MouseEvent) : void
      {
         enabled = false;
         var _loc2_:Object = client.createInput();
         switch((param1.target as Button).userData)
         {
            case "option1":
               _loc2_["package"] = "tokens_package_hi5_100";
               break;
            case "option2":
               _loc2_["package"] = "tokens_package_hi5_500";
               break;
            case "option3":
               _loc2_["package"] = "tokens_package_hi5_1000";
               break;
            case "option4":
               _loc2_["package"] = "tokens_package_hi5_2500";
               break;
            case "option5":
               _loc2_["package"] = "tokens_package_hi5_5000";
         }
         client.service.Hi5Purchase(_loc2_);
         ++client.criticalComms;
      }
      
      private function onPurchaseException(param1:ExceptionEvent) : void
      {
         if(param1.method == "Hi5Purchase")
         {
            --client.criticalComms;
            enabled = true;
         }
      }
      
      private function onPurchaseComplete(param1:ServiceEvent) : void
      {
         --client.criticalComms;
         this.doClose();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.doClose();
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
            this.option1Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("HI5_PACKAGE").value,{
               "tokens":(100).toString(),
               "coins":(100).toString()
            }),null,16777215,20,false,false,"center");
            this.option1Btn.icon = UIUtils.createBitmapIcon(Hi5CoinTokenPng,64,32);
            this.option2Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("HI5_PACKAGE").value,{
               "tokens":(500).toString(),
               "coins":(500).toString()
            }),null,16777215,20,false,false,"center");
            this.option2Btn.icon = UIUtils.createBitmapIcon(Hi5CoinTokenPng,64,32);
            this.option3Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("HI5_PACKAGE").value,{
               "tokens":(1000).toString(),
               "coins":(1000).toString()
            }),null,16777215,20,false,false,"center");
            this.option3Btn.icon = UIUtils.createBitmapIcon(Hi5CoinTokenPng,64,32);
            this.option4Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("HI5_PACKAGE").value,{
               "tokens":(2500).toString(),
               "coins":(2500).toString()
            }),null,16777215,20,false,false,"center");
            this.option4Btn.icon = UIUtils.createBitmapIcon(Hi5CoinTokenPng,64,32);
            this.option5Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("HI5_PACKAGE").value,{
               "tokens":(5000).toString(),
               "coins":(5000).toString()
            }),null,16777215,20,false,false,"center");
            this.option5Btn.icon = UIUtils.createBitmapIcon(Hi5CoinTokenPng,64,32);
         }
      }
   }
}
