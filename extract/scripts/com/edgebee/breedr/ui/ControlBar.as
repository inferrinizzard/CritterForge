package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.CheatWindow;
   import com.edgebee.atlas.ui.gadgets.FacebookPackageWindow;
   import com.edgebee.atlas.ui.gadgets.Hi5PackageWindow;
   import com.edgebee.atlas.ui.gadgets.KongPackageWindow;
   import com.edgebee.atlas.ui.gadgets.StarterKitWindow;
   import com.edgebee.atlas.ui.gadgets.chat.ChatWindow;
   import com.edgebee.atlas.ui.gadgets.messaging.InboxWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.ui.achievements.AchievementsWindow;
   import com.edgebee.breedr.ui.news.NewsWindow;
   import com.edgebee.breedr.ui.skins.BreedrCloseButtonSkin;
   import com.edgebee.breedr.ui.skins.BreedrTopArrowButtonSkin;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class ControlBar extends Box
   {
      
      public static var NewsIconPng:Class = ControlBar_NewsIconPng;
      
      public static var MailIconPng:Class = ControlBar_MailIconPng;
      
      public static var ChatIconPng:Class = ControlBar_ChatIconPng;
      
      public static var CreditsIconPng:Class = ControlBar_CreditsIconPng;
      
      public static var SettingsIconPng:Class = ControlBar_SettingsIconPng;
      
      public static var AddTokensIconPng:Class = ControlBar_AddTokensIconPng;
      
      public static var TokenIconPng:Class = ControlBar_TokenIconPng;
      
      public static var TokenIcon32Png:Class = ControlBar_TokenIcon32Png;
      
      public static var TrophyIconPng:Class = ControlBar_TrophyIconPng;
      
      public static var StarIconPng:Class = ControlBar_StarIconPng;
      
      public static const LOGOUT:String = "logout";
      
      private static var _cheatSequence:Array;
       
      
      public var tokensBox:Box;
      
      public var tokensIcon:BitmapComponent;
      
      public var tokensValueLbl:GradientLabel;
      
      public var creditsBox:Box;
      
      public var creditsIcon:BitmapComponent;
      
      public var creditsValueLbl:GradientLabel;
      
      public var inboxBtn:Button;
      
      public var chatBtn:Button;
      
      public var settingsBtn:Button;
      
      public var logoutBtn:Button;
      
      public var newsBtn:Button;
      
      public var achievementsBtn:Button;
      
      public var addTokensBtn:Button;
      
      public var starterKitBtn:Button;
      
      private var _inboxWindow:InboxWindow;
      
      private var _settingsWindow:com.edgebee.breedr.ui.SettingsWindow;
      
      private var _newsWindow:NewsWindow;
      
      private var _chatWindow:ChatWindow;
      
      private var _cheatWindow:CheatWindow;
      
      private var _achievementsWindow:AchievementsWindow;
      
      private var _msgBlinkAnimation:AnimationInstance;
      
      private var _newsBlinkAnimation:AnimationInstance;
      
      private var _chatBlinkAnimation:AnimationInstance;
      
      private var _cheatSequenceIndex:int = 0;
      
      private var _layout:Array;
      
      public function ControlBar()
      {
         this._layout = [{
            "CLASS":Box,
            "ID":"creditsBox",
            "name":"CreditsBox",
            "filters":[new DropShadowFilter()],
            "STYLES":{"Gap":2},
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"creditsIcon",
               "width":UIGlobals.relativize(20),
               "filters":UIGlobals.fontOutline,
               "isSquare":true,
               "source":CreditsIconPng
            },{
               "CLASS":GradientLabel,
               "ID":"creditsValueLbl",
               "filters":[new GlowFilter(UIUtils.adjustBrightness2(5635925,75),0.5,2,2,5,1,true),new GlowFilter(UIUtils.adjustBrightness2(5635925,-50),1,3,3,5)],
               "colors":[UIUtils.adjustBrightness2(5635925,-60),UIUtils.adjustBrightness2(5635925,70)],
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(24),
                  "FontWeight":"bold"
               }
            }]
         },{
            "CLASS":Spacer,
            "width":50
         },{
            "CLASS":Box,
            "ID":"tokensBox",
            "STYLES":{"Gap":2},
            "verticalAlign":Box.ALIGN_MIDDLE,
            "filters":[new DropShadowFilter()],
            "toolTip":Asset.getInstanceByName("TOKENS_TOOLTIP"),
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"tokensIcon",
               "width":UIGlobals.relativize(20),
               "filters":UIGlobals.fontOutline,
               "isSquare":true,
               "source":TokenIcon32Png
            },{
               "CLASS":GradientLabel,
               "ID":"tokensValueLbl",
               "filters":[new GlowFilter(UIUtils.adjustBrightness2(16769075,75),0.5,2,2,5,1,true),new GlowFilter(UIUtils.adjustBrightness2(16769075,-50),1,3,3,5)],
               "colors":[UIUtils.adjustBrightness(16769075,-60),UIUtils.adjustBrightness(16769075,70)],
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(24),
                  "FontWeight":"bold"
               }
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(20)
            }]
         },{
            "CLASS":Button,
            "ID":"addTokensBtn",
            "label":Asset.getInstanceByName("ADD_TOKENS"),
            "toolTip":Asset.getInstanceByName("ADD_TOKENS"),
            "icon":UIUtils.createBitmapIcon(AddTokensIconPng,UIGlobals.relativize(14)),
            "STYLES":{
               "Color":15977021,
               "FontSize":UIGlobals.relativizeFont(12),
               "PaddingLeft":6,
               "PaddingRight":4,
               "PaddingTop":2,
               "PaddingBottom":2
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onAddTokensClick
            }]
         },{
            "CLASS":Button,
            "ID":"starterKitBtn",
            "toolTip":Asset.getInstanceByName("SPECIAL_OFFERS"),
            "icon":UIUtils.createBitmapIcon(StarIconPng,UIGlobals.relativize(14)),
            "STYLES":{
               "Color":15977021,
               "Shape":"circle"
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onStarterKitsClick
            }]
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Button,
            "ID":"newsBtn",
            "toolTip":Asset.getInstanceByName("NEWS"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onNewsClick"
            }]
         },{
            "CLASS":Button,
            "ID":"inboxBtn",
            "toolTip":Asset.getInstanceByName("INBOX"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onInboxClick"
            }]
         },{
            "CLASS":Button,
            "ID":"chatBtn",
            "toolTip":Asset.getInstanceByName("CHAT"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onChatClick"
            }]
         },{
            "CLASS":Button,
            "ID":"achievementsBtn",
            "toolTip":Asset.getInstanceByName("PERSONAL_ACHIEVEMENTS"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onAchievementsClick"
            }]
         },{
            "CLASS":Button,
            "ID":"settingsBtn",
            "toolTip":Asset.getInstanceByName("SETTINGS"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onSettingsClick"
            }]
         },{
            "CLASS":Button,
            "toolTip":"Full Screen",
            "enabled":!UIGlobals.root.client.isKongregate,
            "STYLES":{
               "FontSize":10,
               "Skin":BreedrTopArrowButtonSkin
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onFullScreenClick"
            }]
         },{
            "CLASS":Button,
            "ID":"logoutBtn",
            "visible":UIGlobals.root.client.openSocialProvider != "hi5",
            "STYLES":{
               "FontSize":10,
               "Skin":BreedrCloseButtonSkin
            },
            "toolTip":Asset.getInstanceByName("QUIT"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onLogoutClick"
            }]
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         setStyle("PaddingTop",2);
         setStyle("PaddingBottom",2);
         setStyle("PaddingLeft",5);
         setStyle("PaddingRight",5);
         setStyle("Gap",5);
         setStyle("BackgroundAlpha",0.35);
         layoutInvisibleChildren = false;
         UIGlobals.root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         this.client.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         _cheatSequence = [Keyboard.BACKSPACE,Keyboard.BACKSPACE,Keyboard.BACKSPACE,Keyboard.BACKSPACE];
         UIGlobals.root.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onStageFullScreenChanged,false,0,true);
      }
      
      public function get client() : com.edgebee.breedr.Client
      {
         return UIGlobals.root.client as com.edgebee.breedr.Client;
      }
      
      public function get newsWindow() : NewsWindow
      {
         return this._newsWindow;
      }
      
      public function get inboxWindow() : InboxWindow
      {
         return this._inboxWindow;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:BitmapComponent = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.updateCredits();
         this.updateTokens();
         this.updateRegisteredButtons();
         _loc1_ = new BitmapComponent();
         _loc1_.source = NewsIconPng;
         _loc1_.width = UIGlobals.relativize(14);
         _loc1_.height = UIGlobals.relativize(14);
         this.newsBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = MailIconPng;
         _loc1_.width = UIGlobals.relativize(14);
         _loc1_.height = UIGlobals.relativize(14);
         this.inboxBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = ChatIconPng;
         _loc1_.width = UIGlobals.relativize(14);
         _loc1_.height = UIGlobals.relativize(14);
         this.chatBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = SettingsIconPng;
         _loc1_.width = UIGlobals.relativize(14);
         _loc1_.height = UIGlobals.relativize(14);
         this.settingsBtn.icon = _loc1_;
         _loc1_ = new BitmapComponent();
         _loc1_.source = TrophyIconPng;
         _loc1_.width = UIGlobals.relativize(14);
         _loc1_.height = UIGlobals.relativize(14);
         this.achievementsBtn.icon = _loc1_;
         this.inboxBtn.controller.updateType = Controller.UPDATE_ON_50MS;
         this._msgBlinkAnimation = this.inboxBtn.controller.addAnimation(UIGlobals.blinkAnimation);
         this._msgBlinkAnimation.synchronized = true;
         this.newsBtn.controller.updateType = Controller.UPDATE_ON_50MS;
         this._newsBlinkAnimation = this.newsBtn.controller.addAnimation(UIGlobals.blinkAnimation);
         this._newsBlinkAnimation.synchronized = true;
         this.chatBtn.controller.updateType = Controller.UPDATE_ON_50MS;
         this._chatBlinkAnimation = this.chatBtn.controller.addAnimation(UIGlobals.blinkAnimation);
         this._chatBlinkAnimation.synchronized = true;
         if(this.client.player.new_messages)
         {
            if(Boolean(this._inboxWindow) && this._inboxWindow.visible)
            {
               this._inboxWindow.fetchMessages();
            }
            else
            {
               this._msgBlinkAnimation.play();
            }
         }
         if(this.client.player.new_news)
         {
            if(Boolean(this._newsWindow) && this._newsWindow.visible)
            {
               this._newsWindow.fetchNews();
            }
            else
            {
               this._newsBlinkAnimation.play();
            }
         }
         this._cheatWindow = new CheatWindow();
         this._cheatWindow.width = 500;
         this._cheatWindow.height = 400;
         UIGlobals.popUpManager.addPopUp(this._cheatWindow,this.gameView);
         this._cheatWindow.setDefaultToCenter();
         this._chatWindow = new ChatWindow();
         UIGlobals.popUpManager.addPopUp(this._chatWindow,this.gameView);
         this._chatWindow.setDefaultToCenter();
         this._chatWindow.visible = false;
         this._settingsWindow = new com.edgebee.breedr.ui.SettingsWindow();
         this._settingsWindow.width = 500;
         UIGlobals.popUpManager.addPopUp(this._settingsWindow,this.gameView);
         this._settingsWindow.validateNow(false);
         this._settingsWindow.setDefaultToCenter();
         this._settingsWindow.visible = false;
      }
      
      public function closeAllWindows() : void
      {
         if(this._newsWindow)
         {
            UIGlobals.popUpManager.removePopUp(this._newsWindow);
         }
         if(this._inboxWindow)
         {
            UIGlobals.popUpManager.removePopUp(this._inboxWindow);
         }
         if(this._settingsWindow)
         {
            UIGlobals.popUpManager.removePopUp(this._settingsWindow);
         }
         if(this._cheatWindow)
         {
            this._cheatWindow.dispose();
            UIGlobals.popUpManager.removePopUp(this._cheatWindow);
         }
         if(this._chatWindow)
         {
            this._chatWindow.dispose();
            UIGlobals.popUpManager.removePopUp(this._chatWindow);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.target is TextField || this._cheatWindow.visible)
         {
            return;
         }
         if(param1.keyCode == _cheatSequence[this._cheatSequenceIndex])
         {
            ++this._cheatSequenceIndex;
         }
         else
         {
            this._cheatSequenceIndex = 0;
         }
         if(this._cheatSequenceIndex == _cheatSequence.length && this.client.user.canCheat)
         {
            this._cheatWindow.visible = true;
         }
      }
      
      private function updateCredits() : void
      {
         this.creditsValueLbl.text = this.client.player.credits.toString();
      }
      
      private function updateTokens() : void
      {
         this.tokensValueLbl.text = this.client.user.tokens.toString();
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "credits")
         {
            this.updateCredits();
         }
         if(param1.property == "starter_kit")
         {
            this.starterKitBtn.visible = !this.client.player.starter_kit;
         }
         if(param1.property == "new_messages")
         {
            if(param1.newValue == true)
            {
               this._msgBlinkAnimation.play();
            }
            else
            {
               this._msgBlinkAnimation.gotoStartAndStop();
               this.inboxBtn.colorTransformProxy.reset();
            }
         }
         if(param1.property == "new_news")
         {
            if(param1.newValue == true)
            {
               this._newsBlinkAnimation.play();
            }
            else
            {
               this._newsBlinkAnimation.gotoStartAndStop();
               this.newsBtn.colorTransformProxy.reset();
            }
         }
         if(param1.property == "new_whisper")
         {
            if(param1.newValue == true)
            {
               this._chatBlinkAnimation.play();
            }
            else
            {
               this._chatBlinkAnimation.gotoStartAndStop();
               this.chatBtn.colorTransformProxy.reset();
            }
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.updateTokens();
         }
         if(param1.property == "state")
         {
            this.updateRegisteredButtons();
         }
      }
      
      private function updateRegisteredButtons() : void
      {
         this.chatBtn.enabled = this.client.user.registered;
         if(this.client.user.registered)
         {
            this.chatBtn.toolTip = Asset.getInstanceByName("CHAT");
         }
         else
         {
            this.chatBtn.toolTip = Asset.getInstanceByName("MUST_BE_REGISTERED");
         }
      }
      
      public function onNewsClick(param1:MouseEvent) : void
      {
         this.toggleNews();
      }
      
      private function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function toggleNews() : void
      {
         if(!this._newsWindow)
         {
            this._newsWindow = new NewsWindow();
            this._newsWindow.width = UIGlobals.relativize(700);
            this._newsWindow.height = UIGlobals.relativize(550);
            UIGlobals.popUpManager.addPopUp(this._newsWindow,this.gameView);
            this._newsWindow.setDefaultToCenter();
            this._newsWindow.visible = true;
            this.client.player.new_news = false;
            return;
         }
         if(this.client.player.new_news && !this._newsWindow.visible)
         {
            this._newsWindow.fetchNews();
         }
         if(!this._newsWindow.visible)
         {
            UIGlobals.popUpManager.bringToFront(this._newsWindow);
         }
         this._newsWindow.visible = !this._newsWindow.visible;
      }
      
      public function onInboxClick(param1:MouseEvent) : void
      {
         if(!this._inboxWindow)
         {
            this._inboxWindow = new InboxWindow();
            this._inboxWindow.width = UIGlobals.relativize(700);
            this._inboxWindow.height = UIGlobals.relativize(550);
            UIGlobals.popUpManager.addPopUp(this._inboxWindow,this.gameView);
            this._inboxWindow.setDefaultToCenter();
         }
         else if(this.client.player.new_messages && !this._inboxWindow.visible)
         {
            this._inboxWindow.fetchMessages();
         }
         if(!this._inboxWindow.visible)
         {
            UIGlobals.popUpManager.bringToFront(this._inboxWindow);
         }
         this._inboxWindow.visible = !this._inboxWindow.visible;
      }
      
      public function onChatClick(param1:MouseEvent) : void
      {
         if(!this._chatWindow)
         {
            this._chatWindow = new ChatWindow();
            this._chatWindow.width = UIGlobals.relativize(750);
            this._chatWindow.height = UIGlobals.relativize(450);
            UIGlobals.popUpManager.addPopUp(this._chatWindow,this.gameView);
            this._chatWindow.setDefaultToCenter();
         }
         if(!this._chatWindow.visible)
         {
            UIGlobals.popUpManager.bringToFront(this._chatWindow);
         }
         this._chatWindow.visible = !this._chatWindow.visible;
      }
      
      public function onSettingsClick(param1:MouseEvent) : void
      {
         if(!this._settingsWindow)
         {
            this._settingsWindow = new com.edgebee.breedr.ui.SettingsWindow();
            this._settingsWindow.width = UIGlobals.relativize(400);
            UIGlobals.popUpManager.addPopUp(this._settingsWindow,this.gameView);
            this._settingsWindow.validateNow(false);
            this._settingsWindow.setDefaultToCenter();
         }
         if(!this._settingsWindow.visible)
         {
            UIGlobals.popUpManager.bringToFront(this._settingsWindow);
         }
         this._settingsWindow.visible = !this._settingsWindow.visible;
      }
      
      public function onFullScreenClick(param1:MouseEvent) : void
      {
         if(stage.displayState == StageDisplayState.NORMAL)
         {
            if(this.client.userCookie.fullScreenMode == com.edgebee.atlas.Client.FULLSCREEN_HW_SCALING)
            {
               stage.fullScreenSourceRect = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
            }
            else
            {
               stage.fullScreenSourceRect = null;
            }
            if(this.client.swfPlayerType == com.edgebee.atlas.Client.AIR_APPLICATION)
            {
               stage.displayState = "fullScreenInteractive";
            }
            else
            {
               stage.scaleMode = StageScaleMode.SHOW_ALL;
               stage.displayState = StageDisplayState.FULL_SCREEN;
            }
         }
         else
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      public function onAchievementsClick(param1:MouseEvent) : void
      {
         if(!this._achievementsWindow)
         {
            this._achievementsWindow = new AchievementsWindow();
            UIGlobals.popUpManager.addPopUp(this._achievementsWindow,this.gameView);
            this._achievementsWindow.validateNow(false);
            this._achievementsWindow.setDefaultToCenter();
         }
         if(!this._achievementsWindow.visible)
         {
            UIGlobals.popUpManager.bringToFront(this._achievementsWindow);
         }
         this._achievementsWindow.visible = !this._achievementsWindow.visible;
      }
      
      private function onStageFullScreenChanged(param1:FullScreenEvent) : void
      {
         if(!param1.fullScreen && Boolean(stage))
         {
            stage.align = StageAlign.TOP_LEFT;
            if(this.client.swfPlayerType == com.edgebee.atlas.Client.AIR_APPLICATION)
            {
               stage.scaleMode = StageScaleMode.NO_SCALE;
            }
            else
            {
               stage.scaleMode = StageScaleMode.EXACT_FIT;
            }
            stage.fullScreenSourceRect = null;
            this.client.genericCookie.fullScreen = false;
         }
         else
         {
            this.client.genericCookie.fullScreen = true;
         }
         this.client.saveCookie();
      }
      
      public function onLogoutClick(param1:MouseEvent) : void
      {
         AlertWindow.show(Asset.getInstanceByName("QUIT_WARNING"),Asset.getInstanceByName("QUIT"),UIGlobals.root,true,{
            "ALERT_WINDOW_YES":this.onQuitConfirm,
            "ALERT_WINDOW_NO":this.onQuitCancel
         },true,false,true,true,false);
      }
      
      private function onQuitConfirm(param1:Event) : void
      {
         (param1.currentTarget as AlertWindow).doClose();
         this.closeAllWindows();
         this.gameView.logout();
      }
      
      private function onQuitCancel(param1:Event) : void
      {
         (param1.currentTarget as AlertWindow).doClose();
      }
      
      private function onAddTokensClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:KongPackageWindow = null;
         var _loc4_:Hi5PackageWindow = null;
         var _loc5_:FacebookPackageWindow = null;
         if(this.client.isKongregate)
         {
            if(this.client.kongregateApi.services.isGuest())
            {
               this.client.kongregateApi.services.showSignInBox();
            }
            else
            {
               _loc3_ = new KongPackageWindow();
               UIGlobals.popUpManager.addPopUp(_loc3_,UIGlobals.root,true);
            }
         }
         else if(this.client.isOpenSocial && this.client.openSocialProvider == "hi5")
         {
            _loc4_ = new Hi5PackageWindow();
            UIGlobals.popUpManager.addPopUp(_loc4_,UIGlobals.root,true);
         }
         else if(this.client.isFacebook)
         {
            _loc5_ = new FacebookPackageWindow();
            UIGlobals.popUpManager.addPopUp(_loc5_,UIGlobals.root,true);
         }
         else if(this.client.isOpenSocial)
         {
            _loc2_ = new URLRequest("http://www.edgebee.com/store");
            if(this.client.mode == com.edgebee.atlas.Client.DEVELOPER)
            {
               _loc2_.url = "http://127.0.0.1:8000/store";
            }
            _loc2_.method = URLRequestMethod.POST;
            _loc2_.data = new URLVariables();
            _loc2_.data.username = this.client.username;
            _loc2_.data.password = this.client.password;
            _loc2_.data.remember = "on";
            navigateToURL(_loc2_,"_blank");
         }
         else
         {
            _loc2_ = new URLRequest("http://www.edgebee.com/store");
            if(this.client.mode == com.edgebee.atlas.Client.DEVELOPER)
            {
               _loc2_.url = "http://127.0.0.1:8000/store";
            }
            navigateToURL(_loc2_,"_blank");
         }
      }
      
      private function onStarterKitsClick(param1:MouseEvent) : void
      {
         var _loc2_:StarterKitWindow = new StarterKitWindow();
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root,true);
      }
   }
}
