package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.SpecialOffer;
   import com.edgebee.atlas.data.SpecialOfferOption;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StarterKitWindow extends Window
   {
      
      public static var TokenIcon32Png:Class = StarterKitWindow_TokenIcon32Png;
      
      private static const BUTTONS:Array = ["option1Btn","option2Btn","option3Btn"];
       
      
      private var starterKit:SpecialOffer;
      
      private var optionImages:Object;
      
      public var option1Btn:Button;
      
      public var option2Btn:Button;
      
      public var option3Btn:Button;
      
      private var _contentLayout:Array;
      
      public function StarterKitWindow()
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
         }];
         super();
         title = Asset.getInstanceByName("STARTER_KITS");
         titleIcon = UIUtils.createBitmapIcon(TokenIcon32Png,16,16);
         centered = true;
         draggable = false;
         showCloseButton = true;
      }
      
      private function onOptionClick(param1:MouseEvent) : void
      {
         var _loc3_:SpecialOfferOption = null;
         var _loc2_:Button = param1.currentTarget as Button;
         switch(_loc2_.userData)
         {
            case "option1":
               _loc3_ = this.starterKit.options[0];
               break;
            case "option2":
               _loc3_ = this.starterKit.options[1];
               break;
            case "option3":
               _loc3_ = this.starterKit.options[2];
         }
         var _loc4_:AlertWindow;
         (_loc4_ = AlertWindow.show(Utils.formatString(Asset.getInstanceByName("STARTER_KIT_PURCHASE_CONFIRMATION").value,{"tokens":_loc3_.cost}),Asset.getInstanceByName("CONFIRMATION"),null,true,{"ALERT_WINDOW_YES":this.onConfirmed},false,false,true,true,false,true)).yesBtn.enabled = client.user.tokens >= _loc3_.cost;
         _loc4_.extraData = _loc3_;
      }
      
      private function onConfirmed(param1:Event) : void
      {
         var _loc2_:AlertWindow = param1.currentTarget as AlertWindow;
         var _loc3_:Object = client.createInput();
         _loc3_["id"] = (_loc2_.extraData as SpecialOfferOption).id;
         client.service.addEventListener("PurchaseStarterKit",this.onKitPurchased);
         client.service.PurchaseStarterKit(_loc3_);
      }
      
      private function onKitPurchased(param1:ServiceEvent) : void
      {
         client.service.removeEventListener("PurchaseStarterKit",this.onKitPurchased);
         client.basePlayer.starter_kit = true;
         doClose();
         AlertWindow.show(Asset.getInstanceByName("STARTER_KIT_WARNING"),Asset.getInstanceByName("STARTER_KIT_WARNING_TITLE"));
         client.service.Logout(client.createInput());
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
         client.service.addEventListener("GetStarterKits",this.onGetStarterKits);
         client.service.GetStarterKits(client.createInput());
      }
      
      private function onGetStarterKits(param1:ServiceEvent) : void
      {
         var _loc2_:SpecialOfferOption = null;
         client.service.removeEventListener("GetStarterKits",this.onGetStarterKits);
         this.starterKit = new SpecialOffer(param1.data["starter_kits"]);
         this.optionImages = {};
         for each(_loc2_ in this.starterKit.options)
         {
            this.optionImages[_loc2_.id] = new SWFLoader();
            this.optionImages[_loc2_.id].addEventListener(Event.COMPLETE,this.onOptionImageLoaded);
            this.optionImages[_loc2_.id].source = UIGlobals.getAssetPath(_loc2_.image).replace(".jpg",".png");
         }
      }
      
      private function onOptionImageLoaded(param1:Event) : void
      {
         var _loc2_:SWFLoader = null;
         for each(_loc2_ in this.optionImages)
         {
            if(!_loc2_.loaded)
            {
               return;
            }
         }
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:Button = null;
         var _loc4_:SpecialOfferOption = null;
         if(childrenCreated || childrenCreating)
         {
            _loc1_ = 0;
            for each(_loc2_ in BUTTONS)
            {
               _loc3_ = this[_loc2_];
               _loc4_ = this.starterKit.options[_loc1_];
               _loc3_.icon = UIUtils.createBitmapIcon(this.optionImages[_loc4_.id].content as Bitmap,UIGlobals.relativize(128));
               _loc3_.label = Utils.htmlWrap(Utils.htmlWrap(_loc4_.name.value,null,null,UIGlobals.relativizeFont(16),true) + "<br>" + Utils.htmlWrap(_loc4_.description.value,null,null,UIGlobals.relativize(12)) + "<br>" + Utils.htmlWrap(_loc4_.cost.toString() + " " + Asset.getInstanceByName("TOKENS_ABV").value,null,16770183,UIGlobals.relativizeFont(16),true,true,"right"));
               _loc1_++;
            }
         }
      }
   }
}
