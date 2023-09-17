package com.edgebee.breedr.ui.world
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.ui.ControlBar;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UpgradeWindow extends Window
   {
      
      public static const USE_CREDITS:String = "USE_CREDITS";
      
      public static const USE_TOKENS:String = "USE_TOKENS";
       
      
      public var extraData;
      
      private var _credits:int;
      
      private var _tokens:int;
      
      public var textArea:TextArea;
      
      public var useCreditsBtn:Button;
      
      public var useTokensBtn:Button;
      
      public var spacer:Spacer;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function UpgradeWindow()
      {
         this._contentLayout = [{
            "CLASS":TextArea,
            "ID":"textArea",
            "useHtml":true,
            "wordWrap":true,
            "percentWidth":1
         }];
         this._statusLayout = [{
            "CLASS":Button,
            "ID":"useCreditsBtn",
            "percentWidth":0.3,
            "icon":UIUtils.createBitmapIcon(ControlBar.CreditsIconPng,UIGlobals.relativize(24)),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onUseCreditsClick
            }]
         },{
            "CLASS":Spacer,
            "ID":"spacer",
            "percentWidth":0.2
         },{
            "CLASS":Button,
            "ID":"useTokensBtn",
            "percentWidth":0.3,
            "icon":UIUtils.createBitmapIcon(ControlBar.TokenIcon32Png,UIGlobals.relativize(24)),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onUseTokensClick
            }]
         }];
         super();
         title = Asset.getInstanceByName("UPGRADE");
         showCloseButton = true;
         width = UIGlobals.relativize(400);
         this.client.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get credits() : int
      {
         return this._credits;
      }
      
      public function set credits(param1:int) : void
      {
         if(this.credits != param1)
         {
            this._credits = param1;
            this.update();
         }
      }
      
      public function get tokens() : int
      {
         return this._tokens;
      }
      
      public function set tokens(param1:int) : void
      {
         if(this.tokens != param1)
         {
            this._tokens = param1;
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_CENTER;
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,statusBar,this._statusLayout);
         this.textArea.text = Asset.getInstanceByName("UPGRADE_DECISION");
         this.update();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.useCreditsBtn.visible = this.credits > 0;
            this.useCreditsBtn.enabled = this.client.player.credits >= this.credits;
            this.useCreditsBtn.label = this.credits.toString();
            this.useTokensBtn.visible = this.tokens > 0;
            this.useTokensBtn.enabled = this.client.user.tokens >= this.tokens;
            this.useTokensBtn.label = this.tokens.toString();
            this.spacer.visible = this.useTokensBtn.visible && this.useCreditsBtn.visible;
         }
      }
      
      private function onUseCreditsClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(USE_CREDITS));
         doClose();
      }
      
      private function onUseTokensClick(param1:MouseEvent) : void
      {
         var _loc2_:String = Asset.getInstanceByName("CONFIRM_TOKEN_PURCHASE").value;
         _loc2_ = Utils.formatString(_loc2_,{"tokens":this.tokens});
         var _loc3_:AlertWindow = AlertWindow.show(_loc2_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onUseTokensConfirmed},true,true,false,false,true,true,ControlBar.TokenIcon32Png);
      }
      
      private function onUseTokensConfirmed(param1:Event) : void
      {
         dispatchEvent(new Event(USE_TOKENS));
         doClose();
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "credits")
         {
            this.update();
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.update();
         }
      }
   }
}
