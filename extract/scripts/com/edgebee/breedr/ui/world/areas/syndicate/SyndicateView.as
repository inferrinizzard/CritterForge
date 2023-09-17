package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.ladder.Team;
   import com.edgebee.breedr.data.player.Log;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.SyndicateLevel;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import com.edgebee.breedr.ui.world.UpgradeWindow;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   
   public class SyndicateView extends Canvas
   {
      
      private static const TEAMS:String = "TEAMS";
      
      private static const STATUS:String = "STATUS";
      
      private static const LOG:String = "LOG";
       
      
      public var upgradeBox:Box;
      
      public var createBox:Box;
      
      public var teamsBox:Box;
      
      public var statusBox:Box;
      
      public var logBox:Box;
      
      public var syndicateLevelLbl:Label;
      
      public var upgradeBtn:Button;
      
      public var refreshBtn:Button;
      
      public var quitBtn:Button;
      
      public var createBtn:Button;
      
      public var nameInput:TextInput;
      
      public var acronymInput:TextInput;
      
      public var teamList:TileList;
      
      public var inviteBox:Box;
      
      public var inviteInput:TextInput;
      
      private var _teamEditWindow:com.edgebee.breedr.ui.world.areas.syndicate.TeamEditWindow;
      
      private var _ladderViewWindow:com.edgebee.breedr.ui.world.areas.syndicate.LadderViewWindow;
      
      public var syndicateMaxLbl:Label;
      
      public var membersList:TileList;
      
      public var logList:TileList;
      
      public var panelsBox:Box;
      
      private var _panelsGroup:RadioButtonGroup;
      
      public var teamsBtn:RadioButton;
      
      public var statusBtn:RadioButton;
      
      public var logBtn:RadioButton;
      
      public var bg:TransparentWindow;
      
      private var _layout:Array;
      
      public function SyndicateView()
      {
         this._layout = [{
            "CLASS":Box,
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(450),
            "direction":Box.VERTICAL,
            "layoutInvisibleChildren":false,
            "STYLES":{"Padding":UIGlobals.relativize(12)},
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(450),
               "includeInLayout":false
            },{
               "CLASS":Box,
               "ID":"upgradeBox",
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "percentWidth":1,
               "percentHeight":1,
               "filters":UIGlobals.fontOutline,
               "CHILDREN":[{
                  "CLASS":Label,
                  "wordWrap":true,
                  "percentWidth":0.75,
                  "text":Asset.getInstanceByName("UPGRADE_SYNDICATE"),
                  "STYLES":{"FontSize":UIGlobals.relativizeFont(24)}
               }]
            },{
               "CLASS":Box,
               "ID":"createBox",
               "visible":false,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "percentWidth":1,
               "percentHeight":1,
               "filters":UIGlobals.fontOutline,
               "CHILDREN":[{
                  "CLASS":Box,
                  "direction":Box.VERTICAL,
                  "STYLES":{"Gap":UIGlobals.relativize(6)},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("CREATE_SYNDICATE_NAME"),
                     "wordWrap":true,
                     "percentWidth":0.75,
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(20)}
                  },{
                     "CLASS":TextInput,
                     "ID":"nameInput",
                     "percentWidth":0.5
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("CREATE_SYNDICATE_ACRONYM"),
                     "wordWrap":true,
                     "percentWidth":0.75,
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(20)}
                  },{
                     "CLASS":TextInput,
                     "ID":"acronymInput"
                  },{
                     "CLASS":Spacer,
                     "percentHeight":1
                  },{
                     "CLASS":Button,
                     "ID":"createBtn",
                     "label":Asset.getInstanceByName("CREATE_SYNDICATE"),
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":"onCreateClick"
                     }]
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"teamsBox",
               "visible":false,
               "direction":Box.VERTICAL,
               "STYLES":{"BackgroundAlpha":0.25},
               "CHILDREN":[{
                  "CLASS":Box,
                  "CHILDREN":[{
                     "CLASS":List,
                     "ID":"teamList",
                     "percentHeight":1,
                     "percentWidth":1,
                     "renderer":TeamListView,
                     "selectable":false,
                     "highlightable":false
                  },{
                     "CLASS":ScrollBar,
                     "name":"SyndicateView:TeamScrollBar",
                     "percentHeight":1,
                     "scrollable":"{teamList}"
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"statusBox",
               "visible":false,
               "direction":Box.VERTICAL,
               "CHILDREN":[{
                  "CLASS":Box,
                  "percentWidth":0.95,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("SYNDICATE_PLAYER_LABEL"),
                     "percentWidth":0.3,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":11184810
                     }
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("SYNDICATE_STATUS_LABEL"),
                     "percentWidth":0.1,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":11184810
                     }
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("LEVEL"),
                     "percentWidth":0.1,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":11184810
                     }
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("SYNDICATE_LAST_ACTIVITY_LABEL"),
                     "percentWidth":0.2,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":11184810
                     }
                  },{
                     "CLASS":Box,
                     "percentWidth":0.1,
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("SYNDICATE_CAN_CHALLENGE_LABEL"),
                        "alignment":TextFormatAlign.CENTER,
                        "STYLES":{
                           "FontSize":UIGlobals.relativizeFont(12),
                           "FontColor":11184810
                        }
                     }]
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("SYNDICATE_ACTIONS_LABEL"),
                     "percentWidth":0.2,
                     "alignment":TextFormatAlign.RIGHT,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":11184810
                     }
                  }]
               },{
                  "CLASS":Box,
                  "percentHeight":0.7,
                  "STYLES":{"BackgroundAlpha":0.25},
                  "CHILDREN":[{
                     "CLASS":List,
                     "ID":"membersList",
                     "percentHeight":1,
                     "percentWidth":1,
                     "selectable":false,
                     "highlightable":false,
                     "renderer":MemberListView
                  },{
                     "CLASS":ScrollBar,
                     "name":"SyndicateView:MembersScrollBar",
                     "percentHeight":1,
                     "scrollable":"{membersList}"
                  }]
               },{
                  "CLASS":Box,
                  "ID":"inviteBox",
                  "direction":Box.VERTICAL,
                  "percentHeight":0.2,
                  "filters":UIGlobals.fontOutline,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("SYNDICATE_INVITE_LABEL")
                  },{
                     "CLASS":Box,
                     "verticalAlign":Box.ALIGN_MIDDLE,
                     "STYLES":{"Gap":UIGlobals.relativize(5)},
                     "CHILDREN":[{
                        "CLASS":TextInput,
                        "ID":"inviteInput"
                     },{
                        "CLASS":Button,
                        "label":Asset.getInstanceByName("INVITE"),
                        "STYLES":{
                           "PaddingLeft":4,
                           "PaddingTop":4,
                           "PaddingRight":4,
                           "PaddingBottom":4
                        },
                        "EVENTS":[{
                           "TYPE":MouseEvent.CLICK,
                           "LISTENER":this.onInviteClick
                        }]
                     },{
                        "CLASS":Spacer,
                        "percentWidth":1
                     },{
                        "CLASS":Label,
                        "ID":"syndicateMaxLbl"
                     }]
                  }]
               }]
            },{
               "CLASS":Box,
               "ID":"logBox",
               "visible":false,
               "STYLES":{"BackgroundAlpha":0.25},
               "CHILDREN":[{
                  "CLASS":Box,
                  "CHILDREN":[{
                     "CLASS":List,
                     "ID":"logList",
                     "percentHeight":1,
                     "percentWidth":1,
                     "sortFunc":sortLogsDescending,
                     "selectable":false,
                     "highlightable":false,
                     "renderer":LogListView
                  },{
                     "CLASS":ScrollBar,
                     "name":"SyndicateView:LogScrollBar",
                     "percentHeight":1,
                     "scrollable":"{logList}"
                  }]
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(8)
            },{
               "CLASS":Box,
               "ID":"panelsBox",
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "visible":false,
               "STYLES":{"Gap":UIGlobals.relativize(10)},
               "CHILDREN":[{
                  "CLASS":RadioButton,
                  "ID":"teamsBtn",
                  "name":"SyndicateLadderTab",
                  "label":Asset.getInstanceByName("TEAMS"),
                  "userData":TEAMS,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "FontSize":UIGlobals.relativizeFont(12),
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"statusBtn",
                  "name":"SyndicateStatusTab",
                  "label":Asset.getInstanceByName("STATUS"),
                  "userData":STATUS,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "FontSize":UIGlobals.relativizeFont(12),
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"logBtn",
                  "name":"SyndicateLogTab",
                  "label":Asset.getInstanceByName("LOG"),
                  "userData":LOG,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "FontSize":UIGlobals.relativizeFont(12),
                     "Padding":UIGlobals.relativize(4)
                  }
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(8)
            },{
               "CLASS":Box,
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "STYLES":{
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12)
               },
               "CHILDREN":[{
                  "CLASS":Label,
                  "filters":UIGlobals.fontOutline,
                  "text":Asset.getInstanceByName("LEVEL")
               },{
                  "CLASS":Label,
                  "filters":UIGlobals.fontOutline,
                  "ID":"syndicateLevelLbl",
                  "STYLES":{
                     "FontWeight":"bold",
                     "FontColor":16776960
                  }
               },{
                  "CLASS":Spacer,
                  "width":UIGlobals.relativize(15)
               },{
                  "CLASS":Button,
                  "ID":"upgradeBtn",
                  "label":Asset.getInstanceByName("UPGRADE"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onUpgradeClick"
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":1
               },{
                  "CLASS":Button,
                  "ID":"refreshBtn",
                  "label":Asset.getInstanceByName("REFRESH"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onRefreshClick
                  }]
               },{
                  "CLASS":Button,
                  "ID":"quitBtn",
                  "label":Asset.getInstanceByName("SYNDICATE_LEAVE"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onQuitClick
                  }]
               }]
            }]
         }];
         super();
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.player.syndicate.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSyndicateChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("SyndicateCreate",this.onSyndicateCreate);
         this.client.service.addEventListener("SyndicateUpgrade",this.onSyndicateUpgrade);
         this.client.service.addEventListener("SyndicateLeave",this.onSyndicateLeave);
         this.client.service.addEventListener("SyndicateRefresh",this.onSyndicateRefresh);
         this.client.service.addEventListener("SyndicateInvitePlayer",this.onSyndicateInvitePlayer);
         this.client.service.addEventListener("SyndicateRemovePlayer",this.onSyndicateRemovePlayer);
         this.client.service.addEventListener("SyndicateDelegatePlayer",this.onSyndicateDelegatePlayer);
         this.client.service.addEventListener("SyndicateChangeMemberRights",this.onSyndicateChangeMemberRights);
         this.client.service.addEventListener("SyndicateActivateTeam",this.onSyndicateActivateTeam);
         this.client.service.addEventListener("SyndicateDeactivateTeam",this.onSyndicateDeactivateTeam);
      }
      
      private static function sortLogsDescending(param1:*, param2:*) : int
      {
         var _loc3_:Log = param1 as Log;
         var _loc4_:Log = param2 as Log;
         if(_loc3_.date.time < _loc4_.date.time)
         {
            return 1;
         }
         if(_loc3_.date.time > _loc4_.date.time)
         {
            return -1;
         }
         return 0;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get ladderViewWindow() : com.edgebee.breedr.ui.world.areas.syndicate.LadderViewWindow
      {
         return this._ladderViewWindow;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:BitmapComponent = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._panelsGroup = new RadioButtonGroup();
         this._panelsGroup.addButton(this.teamsBtn);
         this._panelsGroup.addButton(this.statusBtn);
         this._panelsGroup.addButton(this.logBtn);
         this._panelsGroup.addEventListener(Event.CHANGE,this.onPanelChange);
         this._panelsGroup.selected = this.teamsBtn;
         this.teamList.addEventListener(TeamListView.EDIT_CLICKED,this.onEditTeamClick);
         this.teamList.addEventListener(TeamListView.CHALLENGE_CLICKED,this.onChallengeClick);
         this.teamList.addEventListener(TeamListView.VIEW_CLICKED,this.onViewLadderClick);
         this.teamList.addEventListener(TeamListView.ACTIVATE_CLICKED,this.onActivateTeamClick);
         this.membersList.addEventListener(MemberListView.KICK_CLICKED,this.onKickMemberClick);
         this.membersList.addEventListener(MemberListView.DELEGATE_CLICKED,this.onDelegateMemberClick);
         this.membersList.addEventListener(MemberListView.TOGGLE_CAN_CHALLENGE,this.onToggleCanChallengeMemberClick);
         this.teamList.dataProvider = this.player.syndicate.teams;
         this.membersList.dataProvider = this.player.syndicate.members;
         this.logList.dataProvider = this.player.syndicate.activity;
         this._teamEditWindow = new com.edgebee.breedr.ui.world.areas.syndicate.TeamEditWindow();
         this._teamEditWindow.visible = false;
         UIGlobals.popUpManager.addPopUp(this._teamEditWindow,this.gameView);
         this._ladderViewWindow = new com.edgebee.breedr.ui.world.areas.syndicate.LadderViewWindow();
         this._ladderViewWindow.visible = false;
         UIGlobals.popUpManager.addPopUp(this._ladderViewWindow,this.gameView);
         _loc1_ = new BitmapComponent();
         _loc1_.width = UIGlobals.relativize(20);
         _loc1_.height = UIGlobals.relativize(20);
         _loc1_.source = RanchView.UpgradeIconPng;
         this.upgradeBtn.icon = _loc1_;
         this.gameView.dialogView.addEventListener("TUT_SYNDICATE_SHOW_STATUS",this.onDialogShowStatus);
         this.gameView.dialogView.addEventListener("TUT_SYNDICATE_SHOW_TEAMS",this.onDialogShowTeams);
         this.gameView.dialogView.addEventListener("TUT_SYNDICATE_SHOW_LOG",this.onDialogShowLog);
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.bg.startAnimation();
         }
         else
         {
            this.bg.stopAnimation();
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "syndicate_level")
         {
            this.update();
         }
         if(param1.property == "credits")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            enabled = this.client.criticalComms == 0;
            this.updateUpgradeButton();
         }
      }
      
      private function onSyndicateChange(param1:PropertyChangeEvent) : void
      {
         if(!(param1.currentTarget as Data).copying)
         {
            this.update();
         }
      }
      
      private function update() : void
      {
         if(this.syndicateLevelLbl)
         {
            this.syndicateLevelLbl.text = this.player.syndicate_level.level.toString();
            this.refreshBtn.enabled = this.player.syndicate_level.level > 1 && this.player.syndicate.id > 0;
            this.quitBtn.enabled = this.player.syndicate.id > 0;
            this.updateUpgradeButton();
            if(this.player.syndicate_level.level > 1 && this.player.syndicate.id > 0)
            {
               this.syndicateMaxLbl.text = Utils.formatString(Asset.getInstanceByName("MAX_SYNDICATE_MEMBERS").value,{"capacity":(this.player.id == this.player.syndicate.leader_id ? this.player.syndicate_level.capacity : this.player.syndicate.capacity)});
            }
            this.inviteBox.enabled = this.player.syndicate.leader_id == this.player.id && this.player.syndicate_level.capacity > this.player.syndicate.members.length;
            if(this.player.syndicate_level.level == 1)
            {
               this.panelsBox.visible = false;
               this.upgradeBox.visible = true;
               this.createBox.visible = false;
               this.teamsBox.visible = false;
               this.statusBox.visible = false;
               this.logBox.visible = false;
            }
            else if(this.player.syndicate.id == 0)
            {
               this.panelsBox.visible = false;
               this.upgradeBox.visible = false;
               this.createBox.visible = true;
               this.teamsBox.visible = false;
               this.statusBox.visible = false;
               this.logBox.visible = false;
            }
            else
            {
               this.upgradeBox.visible = false;
               this.createBox.visible = false;
               if(!this.panelsBox.visible)
               {
                  this._panelsGroup.selected = this.teamsBtn;
                  this.panelsBox.visible = true;
               }
            }
         }
      }
      
      private function onPanelChange(param1:ExtendedEvent) : void
      {
         switch(param1.data)
         {
            case TEAMS:
               this.teamsBox.visible = true;
               this.statusBox.visible = false;
               this.logBox.visible = false;
               break;
            case STATUS:
               this.teamsBox.visible = false;
               this.statusBox.visible = true;
               this.logBox.visible = false;
               break;
            case LOG:
               this.teamsBox.visible = false;
               this.statusBox.visible = false;
               this.logBox.visible = true;
         }
      }
      
      private function onDialogShowStatus(param1:Event) : void
      {
         this._panelsGroup.selected = this.statusBtn;
      }
      
      private function onDialogShowTeams(param1:Event) : void
      {
         this._panelsGroup.selected = this.teamsBtn;
      }
      
      private function onDialogShowLog(param1:Event) : void
      {
         this._panelsGroup.selected = this.logBtn;
      }
      
      private function onUpgradeWithCredits(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = false;
         this.client.service.SyndicateUpgrade(_loc2_);
         this.upgradeBtn.enabled = false;
         ++this.client.criticalComms;
      }
      
      private function onUpgradeWithTokens(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = true;
         this.client.service.SyndicateUpgrade(_loc2_);
         this.upgradeBtn.enabled = false;
         ++this.client.criticalComms;
      }
      
      public function onUpgradeClick(param1:MouseEvent) : void
      {
         var _loc2_:SyndicateLevel = SyndicateLevel.getInstanceByLevel(this.player.syndicate_level.level + 1);
         var _loc3_:UpgradeWindow = new UpgradeWindow();
         _loc3_.titleIcon = UIUtils.createBitmapIcon(RanchView.UpgradeIconPng,UIGlobals.relativize(16),UIGlobals.relativize(16));
         _loc3_.credits = _loc2_.credits;
         _loc3_.tokens = _loc2_.tokens;
         _loc3_.addEventListener(UpgradeWindow.USE_CREDITS,this.onUpgradeWithCredits);
         _loc3_.addEventListener(UpgradeWindow.USE_TOKENS,this.onUpgradeWithTokens);
         UIGlobals.popUpManager.addPopUp(_loc3_,UIGlobals.root,true);
         UIGlobals.popUpManager.centerPopUp(_loc3_,null,false);
      }
      
      public function onSyndicateUpgrade(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      public function onSyndicateLeave(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onRefreshClick(param1:MouseEvent) : void
      {
         this.client.service.SyndicateRefresh(this.client.createInput());
         ++this.client.criticalComms;
      }
      
      public function onSyndicateRefresh(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      public function onCreateClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_["name"] = this.nameInput.text;
         _loc2_["acronym"] = this.acronymInput.text;
         this.client.service.SyndicateCreate(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onSyndicateCreate(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onActivateTeamClick(param1:ExtendedEvent) : void
      {
         var _loc2_:Team = param1.data as Team;
         var _loc3_:Object = this.client.createInput();
         _loc3_.team_id = _loc2_.id;
         if(!_loc2_.active)
         {
            this.client.service.SyndicateActivateTeam(_loc3_);
         }
         else
         {
            this.client.service.SyndicateDeactivateTeam(_loc3_);
         }
         ++this.client.criticalComms;
      }
      
      private function onEditTeamClick(param1:ExtendedEvent) : void
      {
         this._teamEditWindow.team = param1.data as Team;
         UIGlobals.popUpManager.centerPopUp(this._teamEditWindow);
         this._teamEditWindow.creatureList.selectedItem = null;
         this._teamEditWindow.visible = true;
      }
      
      private function onChallengeClick(param1:ExtendedEvent) : void
      {
         var _loc2_:Team = param1.data as Team;
         if(_loc2_.frozen_until == 0 && _loc2_.challenge.id == 0)
         {
            this._ladderViewWindow.team = _loc2_;
            this._ladderViewWindow.ladder = (param1.data as Team).ladder;
            this._ladderViewWindow.teamList.selectedItem = null;
            UIGlobals.popUpManager.centerPopUp(this._ladderViewWindow);
            this._ladderViewWindow.visible = true;
         }
      }
      
      private function onViewLadderClick(param1:ExtendedEvent) : void
      {
         this._ladderViewWindow.team = null;
         this._ladderViewWindow.ladder = (param1.data as Team).ladder;
         this._ladderViewWindow.teamList.selectedItem = null;
         UIGlobals.popUpManager.centerPopUp(this._ladderViewWindow);
         this._ladderViewWindow.visible = true;
      }
      
      private function onKickMemberClick(param1:ExtendedEvent) : void
      {
         var _loc2_:String = Asset.getInstanceByName("KICK_MEMBER_CONFIRMATION").value;
         _loc2_ = Utils.formatString(_loc2_,{"member":(param1.data as Player).name});
         var _loc3_:AlertWindow = AlertWindow.show(_loc2_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
            "ALERT_WINDOW_YES":this.onConfirmKick,
            "ALERT_WINDOW_NO":this.onCancel
         },false,false,true,true,false,false,AlertWindow.WarningIconPng);
         _loc3_.extraData = param1.data;
      }
      
      private function onConfirmKick(param1:Event) : void
      {
         var _loc2_:Player = (param1.currentTarget as AlertWindow).extraData as Player;
         var _loc3_:Object = this.client.createInput();
         _loc3_.id = _loc2_.id;
         this.client.service.SyndicateRemovePlayer(_loc3_);
         ++this.client.criticalComms;
      }
      
      private function onCancel(param1:Event) : void
      {
      }
      
      private function onDelegateMemberClick(param1:ExtendedEvent) : void
      {
         var _loc2_:String = Asset.getInstanceByName("DELEGATE_CONFIRMATION").value;
         _loc2_ = Utils.formatString(_loc2_,{"member":(param1.data as Player).name});
         var _loc3_:AlertWindow = AlertWindow.show(_loc2_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
            "ALERT_WINDOW_YES":this.onConfirmDelegate,
            "ALERT_WINDOW_NO":this.onCancel
         },false,false,true,true,false,false,AlertWindow.WarningIconPng);
         _loc3_.extraData = param1.data;
      }
      
      private function onConfirmDelegate(param1:Event) : void
      {
         var _loc2_:Player = (param1.currentTarget as AlertWindow).extraData as Player;
         var _loc3_:Object = this.client.createInput();
         _loc3_.delegate = _loc2_.id;
         this.client.service.SyndicateDelegatePlayer(_loc3_);
         ++this.client.criticalComms;
      }
      
      private function onToggleCanChallengeMemberClick(param1:ExtendedEvent) : void
      {
         var _loc2_:Player = param1.data as Player;
         var _loc3_:Object = this.client.createInput();
         _loc3_.member_id = _loc2_.id;
         var _loc4_:* = _loc2_.syndicate_flags;
         if(_loc2_.canChallengeOtherSyndicates)
         {
            _loc4_ &= ~Player.SYN_CAN_CHALLENGE_FLAG;
         }
         else
         {
            _loc4_ |= Player.SYN_CAN_CHALLENGE_FLAG;
         }
         _loc3_.flags = _loc4_;
         this.client.service.SyndicateChangeMemberRights(_loc3_);
         ++this.client.criticalComms;
      }
      
      private function onInviteClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.inviteInput.text.length > 0)
         {
            _loc2_ = this.client.createInput();
            _loc2_.name = this.inviteInput.text;
            this.client.service.SyndicateInvitePlayer(_loc2_);
            ++this.client.criticalComms;
         }
      }
      
      private function onConfirmQuit(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         this.client.service.SyndicateLeave(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onQuitClick(param1:MouseEvent) : void
      {
         AlertWindow.show(Asset.getInstanceByName("QUIT_SYNDICATE_CONFIRMATION"),Asset.getInstanceByName("CONFIRMATION"),this.gameView,true,{"ALERT_WINDOW_YES":this.onConfirmQuit},true,false,true,true,false,true);
      }
      
      private function updateUpgradeButton() : void
      {
         var _loc1_:SyndicateLevel = null;
         var _loc2_:Asset = null;
         if(this.upgradeBtn)
         {
            _loc1_ = SyndicateLevel.getInstanceByLevel(this.player.syndicate_level.level + 1);
            this.upgradeBtn.enabled = this.client.criticalComms == 0 && Boolean(_loc1_) && (_loc1_.credits > 0 && this.player.credits >= _loc1_.credits || _loc1_.tokens > 0 && this.client.user.tokens >= _loc1_.tokens);
            if(_loc1_)
            {
               _loc2_ = Asset.getInstanceByName("SYNDICATE_UPGRADE_TIP");
               if(_loc1_.credits < 0)
               {
                  _loc2_ = Asset.getInstanceByName("SYNDICATE_UPGRADE_TIP_NO_CREDS");
               }
               this.upgradeBtn.toolTip = Utils.formatString(_loc2_.value,{
                  "credits":_loc1_.credits,
                  "tokens":_loc1_.tokens
               });
               this.upgradeBtn.visible = true;
            }
            else
            {
               this.upgradeBtn.toolTip = "";
               this.upgradeBtn.visible = false;
            }
         }
      }
      
      private function onSyndicateInvitePlayer(param1:ServiceEvent) : void
      {
         this.inviteInput.text = "";
         this.inviteInput.dispatchEvent(new Event(Event.CHANGE));
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSyndicateActivateTeam(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSyndicateDeactivateTeam(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSyndicateRemovePlayer(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSyndicateDelegatePlayer(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSyndicateChangeMemberRights(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SyndicateCreate")
         {
            --this.client.criticalComms;
            if(param1.exception.cls == "SyndicateNameInvalid")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_NAME_INVALID"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_NAME_INVALID_TITLE"),null,true,null,false,true);
            }
            else if(param1.exception.cls == "SyndicateNameInUse")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_NAME_IN_USE"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_NAME_IN_USE_TITLE"),null,true,null,false,true);
            }
            else if(param1.exception.cls == "SyndicateAcronymInvalid")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_ACRONYM_INVALID"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_ACRONYM_INVALID_TITLE"),null,true,null,false,true);
            }
            else if(param1.exception.cls == "SyndicateAcronymInUse")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_ACRONYM_IN_USE"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_ACRONYM_IN_USE_TITLE"),null,true,null,false,true);
            }
         }
         else if(param1.method == "SyndicateUpgrade")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateLeave")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateDelegate")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateRefresh")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateInvitePlayer")
         {
            --this.client.criticalComms;
            if(param1.exception.cls == "PlayerDoesNotExist")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_PLAYER_NOT_EXISTS"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_PLAYER_NOT_EXISTS_TITLE"),null,true,null,false,true);
            }
            else if(param1.exception.cls == "SyndicateLevelTooLow")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_EXCEPTION_PLAYER_LEVEL_TOO_LOW"),Asset.getInstanceByName("SYNDICATE_EXCEPTION_PLAYER_LEVEL_TOO__TITLE"),null,true,null,false,true);
            }
            else if(param1.exception.cls == "SyndicateFull")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_FULL"),Asset.getInstanceByName("SYNDICATE_FULL_TITLE"),null,true,null,true,true);
            }
         }
         else if(param1.method == "SyndicateChallenge")
         {
            if(param1.exception.cls == "StaleSyndicate")
            {
               this.client.service.SyndicateRefresh(this.client.createInput());
               ++this.client.criticalComms;
            }
         }
         else if(param1.method == "SyndicateRemovePlayer")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateChangeMemberRights")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateActivateTeam")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SyndicateDeactivateTeam")
         {
            --this.client.criticalComms;
         }
      }
   }
}
