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
   import flash.external.ExternalInterface;
   
   public class FacebookPackageWindow extends Window
   {
      
      public static var FacebookCreditTokenPng:Class = FacebookPackageWindow_FacebookCreditTokenPng;
      
      public static var TokenIcon32Png:Class = FacebookPackageWindow_TokenIcon32Png;
       
      
      public var option1Btn:Button;
      
      public var option2Btn:Button;
      
      public var option3Btn:Button;
      
      public var option4Btn:Button;
      
      public var option5Btn:Button;
      
      public var cancelBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function FacebookPackageWindow()
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
         ExternalInterface.addCallback("payPromptComplete",this.onPayPromptComplete);
      }
      
      override public function doClose() : void
      {
         super.doClose();
      }
      
      private function onOptionClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         enabled = false;
         switch((param1.target as Button).userData)
         {
            case "option1":
               _loc2_ = "tokens_package_fb_100";
               break;
            case "option2":
               _loc2_ = "tokens_package_fb_500";
               break;
            case "option3":
               _loc2_ = "tokens_package_fb_1000";
               break;
            case "option4":
               _loc2_ = "tokens_package_fb_2500";
               break;
            case "option5":
               _loc2_ = "tokens_package_fb_5000";
         }
         ExternalInterface.call("payPrompt",_loc2_,client.user.id,client.user.locale);
         ++client.criticalComms;
      }
      
      private function onPayPromptComplete(param1:String, param2:String, param3:String) : void
      {
         --client.criticalComms;
         if(param1)
         {
            client.service.EmptyCall(client.createInput());
         }
         else if(Boolean(param2) && param2 != "1383010")
         {
            AlertWindow.show("Error #" + param2 + " : " + param3);
         }
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
            this.option1Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FACEBOOK_PACKAGE").value,{
               "tokens":(100).toString(),
               "coins":(100).toString()
            }),null,16777215,20,false,false,"center");
            this.option1Btn.icon = UIUtils.createBitmapIcon(FacebookCreditTokenPng,64,32);
            this.option2Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FACEBOOK_PACKAGE").value,{
               "tokens":(500).toString(),
               "coins":(500).toString()
            }),null,16777215,20,false,false,"center");
            this.option2Btn.icon = UIUtils.createBitmapIcon(FacebookCreditTokenPng,64,32);
            this.option3Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FACEBOOK_PACKAGE").value,{
               "tokens":(1000).toString(),
               "coins":(1000).toString()
            }),null,16777215,20,false,false,"center");
            this.option3Btn.icon = UIUtils.createBitmapIcon(FacebookCreditTokenPng,64,32);
            this.option4Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FACEBOOK_PACKAGE").value,{
               "tokens":(2500).toString(),
               "coins":(2500).toString()
            }),null,16777215,20,false,false,"center");
            this.option4Btn.icon = UIUtils.createBitmapIcon(FacebookCreditTokenPng,64,32);
            this.option5Btn.label = Utils.htmlWrap(Utils.formatString(Asset.getInstanceByName("FACEBOOK_PACKAGE").value,{
               "tokens":(5000).toString(),
               "coins":(5000).toString()
            }),null,16777215,20,false,false,"center");
            this.option5Btn.icon = UIUtils.createBitmapIcon(FacebookCreditTokenPng,64,32);
         }
      }
   }
}
