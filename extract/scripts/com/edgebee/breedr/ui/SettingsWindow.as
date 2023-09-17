package com.edgebee.breedr.ui
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.controls.ToggleButton;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.skins.CheckBoxSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.ui.skins.BreedrLeftArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.BreedrRightArrowButtonSkin;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SettingsWindow extends Window
   {
       
      
      public var fullScreenOptions:RadioButtonGroup;
      
      public var localeGroup:RadioButtonGroup;
      
      private var _alert:AlertWindow;
      
      public var decreaseSfxVolumeBtn:Button;
      
      public var increaseSfxVolumeBtn:Button;
      
      public var sfxVolumeBar:ProgressBar;
      
      public var decreaseMusicVolumeBtn:Button;
      
      public var increaseMusicVolumeBtn:Button;
      
      public var musicVolumeBar:ProgressBar;
      
      public var showChatJoinLeaveBtn:ToggleButton;
      
      public var abdicateBox:Box;
      
      public var abdicateBtn:Button;
      
      public var abdicateTxt:TextInput;
      
      public var pwdTxt:Label;
      
      public var combatSpeedLbl:Label;
      
      public var decreaseCombatSpeedBtn:Button;
      
      public var increaseCombatSpeedBtn:Button;
      
      public var combatSpeedBar:ProgressBar;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function SettingsWindow()
      {
         this.fullScreenOptions = new RadioButtonGroup();
         this.localeGroup = new RadioButtonGroup();
         this._statusBarLayout = [];
         this._contentLayout = [{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("SOUNDS"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":Box,
               "STYLES":{"Gap":2},
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"decreaseSfxVolumeBtn",
                  "STYLES":{"Skin":BreedrLeftArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onDecreaseSfxVolume"
                  }]
               },{
                  "CLASS":ProgressBar,
                  "ID":"sfxVolumeBar",
                  "width":100,
                  "height":24
               },{
                  "CLASS":Button,
                  "ID":"increaseSfxVolumeBtn",
                  "STYLES":{"Skin":BreedrRightArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onIncreaseSfxVolume"
                  }]
               }]
            },{
               "CLASS":Label,
               "text":Asset.getInstanceByName("MUSIC"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":Box,
               "STYLES":{"Gap":2},
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"decreaseMusicVolumeBtn",
                  "STYLES":{"Skin":BreedrLeftArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onDecreaseMusicVolume"
                  }]
               },{
                  "CLASS":ProgressBar,
                  "ID":"musicVolumeBar",
                  "width":100,
                  "height":24
               },{
                  "CLASS":Button,
                  "ID":"increaseMusicVolumeBtn",
                  "STYLES":{"Skin":BreedrRightArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onIncreaseMusicVolume"
                  }]
               }]
            }]
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("OPTIONS"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":ToggleButton,
               "ID":"showChatJoinLeaveBtn",
               "STYLES":{"Skin":CheckBoxSkin},
               "label":Asset.getInstanceByName("SHOW_CHAT_JOIN_LEAVE"),
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onShowChatJoinLeaveBtn"
               }]
            },{
               "CLASS":Label,
               "text":Asset.getInstanceByName("COMBAT_SPEED"),
               "STYLES":{"FontWeight":"bold"}
            },{
               "CLASS":Box,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"decreaseCombatSpeedBtn",
                  "STYLES":{"Skin":BreedrLeftArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onDecreaseCombatSpeed"
                  }]
               },{
                  "CLASS":ProgressBar,
                  "ID":"combatSpeedBar",
                  "width":100,
                  "height":24
               },{
                  "CLASS":Button,
                  "ID":"increaseCombatSpeedBtn",
                  "STYLES":{"Skin":BreedrRightArrowButtonSkin},
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onIncreaseCombatSpeed"
                  }]
               },{
                  "CLASS":Spacer,
                  "width":UIGlobals.relativize(5)
               },{
                  "CLASS":Label,
                  "ID":"combatSpeedLbl",
                  "STYLES":{"FontWeight":"bold"}
               }]
            }]
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("FULLSCREEN_OPTIONS"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":RadioButton,
               "group":"{fullScreenOptions}",
               "label":Asset.getInstanceByName("FULLSCREEN_HW_SCALING"),
               "userData":com.edgebee.atlas.Client.FULLSCREEN_HW_SCALING
            },{
               "CLASS":RadioButton,
               "group":"{fullScreenOptions}",
               "label":Asset.getInstanceByName("FULLSCREEN_FP_SCALING"),
               "userData":com.edgebee.atlas.Client.FULLSCREEN_FP_SCALING
            }]
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("LANGUAGE"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":RadioButton,
               "group":"{localeGroup}",
               "label":Asset.getInstanceByName("ENGLISH"),
               "userData":"en_us"
            },{
               "CLASS":RadioButton,
               "group":"{localeGroup}",
               "label":Asset.getInstanceByName("FRENCH"),
               "userData":"fr_fr",
               "enabled":!UIGlobals.root.client.hasEmbeddedData
            }]
         },{
            "CLASS":Box,
            "ID":"abdicateBox",
            "STYLES":{
               "Gap":10,
               "FontWeight":"bold"
            },
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Button,
               "ID":"abdicateBtn",
               "label":Asset.getInstanceByName("ABDICATE"),
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onAbdicateClick"
               }]
            },{
               "CLASS":Label,
               "ID":"pwdTxt",
               "text":Asset.getInstanceByName("PASSWORD"),
               "STYLES":{
                  "FontSize":14,
                  "FontWeight":"bold"
               }
            },{
               "CLASS":TextInput,
               "ID":"abdicateTxt",
               "width":UIGlobals.relativizeX(200),
               "displayAsPassword":true,
               "EVENTS":[{
                  "TYPE":Event.CHANGE,
                  "LISTENER":"onAbdicatePasswordChange"
               }]
            }]
         },{
            "CLASS":Box,
            "STYLES":{"Gap":5},
            "horizontalAlign":Box.ALIGN_RIGHT,
            "CHILDREN":[{
               "CLASS":Label,
               "text":"Server: " + this.gameClient.serverVersion.toString(),
               "STYLES":{"FontSize":10}
            },{
               "CLASS":Label,
               "text":"Min client: " + this.gameClient.minClientVersion.toString(),
               "STYLES":{"FontSize":10}
            },{
               "CLASS":Label,
               "text":"Client: " + UIGlobals.root.buildVersion,
               "STYLES":{"FontSize":10}
            }]
         }];
         super();
         rememberPositionId = "SettingsWindow";
         visible = false;
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      public function get gameClient() : com.edgebee.breedr.Client
      {
         return client as com.edgebee.breedr.Client;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         title = Asset.getInstanceByName("SETTINGS");
         titleIcon = UIUtils.createBitmapIcon(ControlBar.SettingsIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         this.localeGroup.selectedItem = this.gameClient.locale;
         this.localeGroup.addEventListener(Event.CHANGE,this.onLocaleChange);
         this.fullScreenOptions.selectedItem = this.gameClient.userCookie.fullScreenMode;
         this.fullScreenOptions.addEventListener(Event.CHANGE,this.onFullscreenChange);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.showChatJoinLeaveBtn.selected = this.gameClient.showChatJoinLeave;
         if(this.gameClient.isKongregate || this.gameClient.isOpenSocial || this.gameClient.isFacebook)
         {
            this.pwdTxt.visible = false;
            this.abdicateTxt.visible = false;
            this.abdicateBtn.enabled = true;
         }
         this.updateVolumeBars();
         this.updateCombatSpeedBar();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.updateVolumeBars();
            this.updateCombatSpeedBar();
         }
      }
      
      private function update() : void
      {
         invalidateDisplayList();
      }
      
      private function onLocaleChange(param1:ExtendedEvent) : void
      {
         if(this.gameClient.userCookie._last_locale != this.localeGroup.selectedItem)
         {
            this.gameClient.locale = this.localeGroup.selectedItem as String;
         }
      }
      
      private function onOkClick(param1:Event) : void
      {
         UIGlobals.popUpManager.removePopUp(this._alert);
         this._alert = null;
      }
      
      private function onFullscreenChange(param1:ExtendedEvent) : void
      {
         var _loc2_:Object = null;
         this.gameClient.userCookie.fullScreenMode = this.fullScreenOptions.selectedItem as String;
         this.gameClient.genericCookie.fullScreenMode = this.fullScreenOptions.selectedItem as String;
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            _loc2_ = {};
            _loc2_[AlertWindow.RESULT_OK] = this.onOkClick;
            _loc2_[AlertWindow.RESULT_CLOSE] = this.onOkClick;
            this._alert = AlertWindow.show(Asset.getInstanceByName("FULLSCREEN_NOTICE"),null,null,true,_loc2_,false,true);
         }
      }
      
      public function onIncreaseSfxVolume(param1:MouseEvent) : void
      {
         this.gameClient.sndManager.sfxVolume += 0.1;
         this.updateVolumeBars();
      }
      
      public function onDecreaseSfxVolume(param1:MouseEvent) : void
      {
         this.gameClient.sndManager.sfxVolume -= 0.1;
         this.updateVolumeBars();
      }
      
      public function onIncreaseMusicVolume(param1:MouseEvent) : void
      {
         this.gameClient.sndManager.musicVolume += 0.1;
         this.updateVolumeBars();
      }
      
      public function onDecreaseMusicVolume(param1:MouseEvent) : void
      {
         this.gameClient.sndManager.musicVolume -= 0.1;
         this.updateVolumeBars();
      }
      
      public function updateVolumeBars() : void
      {
         this.sfxVolumeBar.setValueAndMaximum(this.gameClient.sndManager.sfxVolume,1);
         this.musicVolumeBar.setValueAndMaximum(this.gameClient.sndManager.musicVolume,1);
      }
      
      public function onShowChatJoinLeaveBtn(param1:MouseEvent) : void
      {
         this.gameClient.showChatJoinLeave = this.showChatJoinLeaveBtn.selected;
      }
      
      public function onIncreaseCombatSpeed(param1:MouseEvent) : void
      {
         this.gameClient.combatSpeedMultiplier += com.edgebee.breedr.Client.COMBAT_SPEED_INCREMENT;
         this.updateCombatSpeedBar();
      }
      
      public function onDecreaseCombatSpeed(param1:MouseEvent) : void
      {
         this.gameClient.combatSpeedMultiplier -= com.edgebee.breedr.Client.COMBAT_SPEED_INCREMENT;
         this.updateCombatSpeedBar();
      }
      
      public function updateCombatSpeedBar() : void
      {
         this.combatSpeedLbl.text = this.gameClient.combatSpeedMultiplier.toFixed(1) + "x";
         this.combatSpeedBar.setValueAndMaximum(this.gameClient.combatSpeedMultiplier - 1,com.edgebee.breedr.Client.MAX_COMBAT_SPEED - 1);
      }
      
      public function onAbdicateClick(param1:MouseEvent) : void
      {
         AlertWindow.show(Asset.getInstanceByName("ABDICATE_WARNING"),Asset.getInstanceByName("ABDICATE"),this,true,{
            "ALERT_WINDOW_OK":this.onAbdicateConfirm,
            "ALERT_WINDOW_CANCEL":this.onAbdicateCancel
         },true,true,false,false,true);
      }
      
      private function onAbdicateConfirm(param1:Event) : void
      {
         UIGlobals.root.enabled = false;
         var _loc2_:Object = this.gameClient.createInput();
         _loc2_.password = MD5.hash(this.abdicateTxt.text);
         this.gameClient.service.addEventListener("Abdicate",this.onAbdicate);
         this.gameClient.service.Abdicate(_loc2_);
         (param1.currentTarget as AlertWindow).doClose();
      }
      
      private function onAbdicateCancel(param1:Event) : void
      {
         (param1.currentTarget as AlertWindow).doClose();
      }
      
      private function onAbdicate(param1:ServiceEvent) : void
      {
         if(param1.data.success)
         {
            UIGlobals.root.enabled = true;
            (UIGlobals.root as breedr_flash).rootView.gameView.logout();
            if(this.gameClient.genericCookie.hasOwnProperty("anonymous_id"))
            {
               delete this.gameClient.genericCookie["anonymous_id"];
               this.gameClient.saveCookie();
            }
         }
         else
         {
            UIGlobals.root.enabled = true;
            this.abdicateTxt.text = "";
            this.abdicateBtn.enabled = false;
            AlertWindow.show(Asset.getInstanceByName("ABDICATE_WRONG_PASSWORD_MESSAGE"),Asset.getInstanceByName("ABDICATE_WRONG_PASSWORD_MESSAGE"),this,true,null,true,true,false,false,false,false);
         }
      }
      
      public function onAbdicatePasswordChange(param1:Event) : void
      {
         this.abdicateBtn.enabled = this.abdicateTxt.text.length > 0;
      }
   }
}
