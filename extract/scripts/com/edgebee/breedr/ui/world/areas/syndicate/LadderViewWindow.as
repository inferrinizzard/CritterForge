package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.ladder.Ladder;
   import com.edgebee.breedr.data.ladder.Team;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LadderViewWindow extends Window
   {
      
      public static const ArrowUpPng:Class = LadderViewWindow_ArrowUpPng;
      
      public static const ArrowDownPng:Class = LadderViewWindow_ArrowDownPng;
      
      public static const StopPng:Class = LadderViewWindow_StopPng;
      
      private static const NUM_TEAMS:uint = 19;
       
      
      private var _ladder:WeakReference;
      
      private var _team:WeakReference;
      
      public var teamList:List;
      
      public var challengeBtn:Button;
      
      public var upBtn:Button;
      
      public var downBtn:Button;
      
      private var _teamsArr:DataArray;
      
      private var _center:Number = -1;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function LadderViewWindow()
      {
         this._ladder = new WeakReference(null,Ladder);
         this._team = new WeakReference(null,Team);
         this._teamsArr = new DataArray(Team);
         this._contentLayout = [{
            "CLASS":Box,
            "direction":Box.HORIZONTAL,
            "percentWidth":1,
            "STYLES":{"BackgroundAlpha":0.05},
            "CHILDREN":[{
               "CLASS":List,
               "ID":"teamList",
               "selectable":true,
               "highlightable":false,
               "percentHeight":1,
               "percentWidth":1,
               "heightInRows":NUM_TEAMS,
               "renderer":LadderTeamView
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"upBtn",
            "label":Asset.getInstanceByName("GO_UP"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onUpClick
            }]
         },{
            "CLASS":Button,
            "ID":"challengeBtn",
            "label":Asset.getInstanceByName("MAKE_A_CHALLENGE"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onChallengeClick
            }]
         },{
            "CLASS":Button,
            "ID":"downBtn",
            "label":Asset.getInstanceByName("GO_DOWN"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onDownClick
            }]
         }];
         super();
         width = UIGlobals.relativize(650);
         rememberPositionId = "LadderViewWindow";
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.addEventListener("SyndicateGetLadder",this.onSyndicateGetLadder);
         client.service.addEventListener("SyndicateChallenge",this.onSyndicateChallenge);
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get ladder() : Ladder
      {
         return this._ladder.get() as Ladder;
      }
      
      public function set ladder(param1:Ladder) : void
      {
         if(this.ladder != param1)
         {
            if(this.ladder)
            {
               this.ladder.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLadderChange);
            }
            this._ladder.reset(param1);
            if(this.ladder)
            {
               this.ladder.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLadderChange);
            }
            if(this.team)
            {
               this.center = this.team.position;
            }
            else
            {
               this.center = 0;
            }
            this.update();
         }
      }
      
      public function get team() : Team
      {
         return this._team.get() as Team;
      }
      
      public function set team(param1:Team) : void
      {
         if(this.team != param1)
         {
            if(this.team)
            {
               this.team.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
            }
            this._team.reset(param1);
            if(this.team)
            {
               this.team.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
            }
            this._teamsArr.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,this._teamsArr,0));
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",UIGlobals.relativize(6));
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.teamList.addEventListener(Event.CHANGE,this.onSelectionChange);
         this.teamList.dataProvider = this._teamsArr;
         this.update();
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      private function get busy() : Boolean
      {
         return this.teamList.busyOverlayed;
      }
      
      private function set busy(param1:Boolean) : void
      {
         this.teamList.busyOverlayed = param1;
      }
      
      private function get center() : Number
      {
         return this._center;
      }
      
      private function set center(param1:Number) : void
      {
         this._center = param1;
         if(this._center < Math.ceil(NUM_TEAMS / 2))
         {
            this._center = Math.ceil(NUM_TEAMS / 2);
         }
         this.getTeamsNearCenter();
      }
      
      private function getTeamsNearCenter() : void
      {
         var _loc1_:Object = client.createInput();
         _loc1_.ladder_id = this.ladder.id;
         _loc1_.index = Math.max(1,this.center - Math.floor(NUM_TEAMS / 2));
         _loc1_.count = NUM_TEAMS;
         client.service.SyndicateGetLadder(_loc1_);
         this.teamList.selectedItem = null;
         this.busy = true;
      }
      
      private function get canScrollUp() : Boolean
      {
         return this._teamsArr.length > 0 && this._teamsArr[0].position > 1;
      }
      
      private function get canScrollDown() : Boolean
      {
         return this._teamsArr.length == NUM_TEAMS;
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            statusBar.enabled = client.criticalComms == 0;
         }
      }
      
      private function onSyndicateGetLadder(param1:ServiceEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.data.teams)
         {
            _loc2_.push(new Team(_loc3_));
         }
         this._teamsArr.source = _loc2_;
         this.busy = false;
      }
      
      private function onLadderChange(param1:PropertyChangeEvent) : void
      {
      }
      
      private function onTeamChange(param1:PropertyChangeEvent) : void
      {
      }
      
      private function onSelectionChange(param1:Event) : void
      {
         var _loc2_:Team = null;
         var _loc3_:Number = NaN;
         if(childrenCreated || childrenCreating)
         {
            _loc2_ = this.teamList.selectedItem as Team;
            if(_loc2_)
            {
               _loc3_ = this.team.position - _loc2_.position;
               this.challengeBtn.enabled = _loc3_ > 0 && _loc3_ <= this.ladder.max_challenge;
            }
            else
            {
               this.challengeBtn.enabled = false;
            }
         }
      }
      
      private function onUpClick(param1:MouseEvent) : void
      {
         if(this.canScrollUp && !this.busy)
         {
            this.center -= NUM_TEAMS;
         }
      }
      
      private function onDownClick(param1:MouseEvent) : void
      {
         if(this.canScrollDown && !this.busy)
         {
            this.center += NUM_TEAMS;
         }
      }
      
      private function onChallengeClick(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Team = this.teamList.selectedItem as Team;
         if(_loc2_)
         {
            _loc3_ = client.createInput();
            _loc3_.team_id = _loc2_.id;
            client.service.SyndicateChallenge(_loc3_);
            ++client.criticalComms;
            this.teamList.selectedItem = null;
            this.busy = true;
         }
      }
      
      private function onSyndicateChallenge(param1:ServiceEvent) : void
      {
         this.busy = false;
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SyndicateGetLadder")
         {
            this.busy = false;
         }
         if(param1.method == "SyndicateChallenge")
         {
            --client.criticalComms;
            this.busy = false;
            if(param1.exception.cls == "StaleLadder")
            {
               param1.handled = true;
               this.doClose();
               AlertWindow.show(Asset.getInstanceByName("STALE_LADDER"),Asset.getInstanceByName("STALE_LADDER_TITLE"),UIGlobals.root,true,null,true,true);
            }
            if(param1.exception.cls == "StaleSyndicate")
            {
               param1.handled = true;
               this.doClose();
            }
         }
      }
      
      private function update() : void
      {
         if((childrenCreated || childrenCreating) && Boolean(this.ladder))
         {
            visible = true;
            title = this.ladder.name;
            this.challengeBtn.visible = this.team != null;
            this.teamList.selectable = this.team != null;
            this.teamList.highlightable = this.team != null;
            this.onSelectionChange(null);
         }
         else
         {
            visible = false;
            this.teamList.selectable = false;
            this.teamList.highlightable = false;
            this.onSelectionChange(null);
         }
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.Listable;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.ui.world.areas.syndicate.LadderViewWindow;

class LadderTeamView extends Box implements Listable
{
    
   
   private var _selected:Boolean = false;
   
   private var _highlighted:Boolean = false;
   
   private var _team:WeakReference;
   
   public var box:Box;
   
   public var nameLbl:Label;
   
   public var positionLbl:Label;
   
   public var challengeLbl:Label;
   
   public var recordLbl:Label;
   
   public var iconBmp:BitmapComponent;
   
   private var _layout:Array;
   
   public function LadderTeamView()
   {
      this._team = new WeakReference(null,Team);
      this._layout = [{
         "CLASS":Box,
         "ID":"box",
         "verticalAlign":Box.ALIGN_MIDDLE,
         "percentHeight":1,
         "STYLES":{
            "BackgroundColor":0,
            "BackgroundAlpha":0.15,
            "CornerRadius":5,
            "BorderThickness":1,
            "BorderAlpha":0.25,
            "BorderColor":16777215
         },
         "CHILDREN":[{
            "CLASS":Label,
            "ID":"positionLbl",
            "filters":UIGlobals.fontSmallOutline,
            "percentWidth":0.1,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(12),
               "FontWeight":"bold"
            }
         },{
            "CLASS":Label,
            "ID":"nameLbl",
            "filters":UIGlobals.fontSmallOutline,
            "percentWidth":0.2,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "filters":UIGlobals.fontSmallOutline,
            "width":UIGlobals.relativize(16),
            "isSquare":true
         },{
            "CLASS":Label,
            "ID":"challengeLbl",
            "filters":UIGlobals.fontSmallOutline,
            "percentWidth":0.6,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(12),
               "FontStyle":"italic"
            }
         },{
            "CLASS":Label,
            "ID":"recordLbl",
            "filters":UIGlobals.fontSmallOutline,
            "percentWidth":0.1,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         }]
      }];
      super();
      percentWidth = 1;
      height = UIGlobals.relativize(26);
      layoutInvisibleChildren = false;
      setStyle("Padding",2);
   }
   
   public function get client() : Client
   {
      return UIGlobals.root.client as Client;
   }
   
   public function get player() : Player
   {
      return this.client.player;
   }
   
   public function get ladderWindow() : LadderViewWindow
   {
      return (UIGlobals.root as breedr_flash).rootView.gameView.syndicateView.ladderViewWindow;
   }
   
   public function get listElement() : Object
   {
      return this.team;
   }
   
   public function set listElement(param1:Object) : void
   {
      this.team = param1 as Team;
   }
   
   public function get selected() : Boolean
   {
      return this._selected;
   }
   
   public function set selected(param1:Boolean) : void
   {
      this._selected = param1;
   }
   
   public function get highlighted() : Boolean
   {
      return this._highlighted;
   }
   
   public function set highlighted(param1:Boolean) : void
   {
      this._highlighted = param1;
   }
   
   public function get team() : Team
   {
      return this._team.get() as Team;
   }
   
   public function set team(param1:Team) : void
   {
      if(this.team != param1)
      {
         if(this.team)
         {
            this.team.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
            this.team.challenge.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
         }
         this._team.reset(param1);
         if(this.team)
         {
            this.team.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
            this.team.challenge.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
         }
         if(childrenCreated)
         {
            this.update();
         }
      }
   }
   
   private function onTeamChange(param1:PropertyChangeEvent) : void
   {
      this.update();
   }
   
   private function update() : void
   {
      var _loc1_:Date = null;
      var _loc2_:Date = null;
      var _loc3_:Number = NaN;
      if(this.team)
      {
         visible = true;
         this.positionLbl.text = this.team.position.toString();
         this.nameLbl.text = this.team.name;
         this.recordLbl.text = this.team.wins.toString() + "-" + this.team.losses.toString() + "-" + this.team.ties.toString();
         this.iconBmp.source = null;
         this.iconBmp.visible = false;
         this.challengeLbl.visible = false;
         this.box.setStyle("BackgroundColor",0);
         this.box.setStyle("BorderColor",16777215);
         if(this.team.challenge.id > 0)
         {
            _loc1_ = new Date();
            _loc1_.time += this.team.challenge.fight_at;
            if(this.team.challenge.challenger_id == this.team.id)
            {
               this.iconBmp.source = LadderViewWindow.ArrowUpPng;
               this.iconBmp.visible = true;
               this.challengeLbl.text = this.team.challenge.defender_name + " (" + this.team.challenge.defender_position.toString() + ") @ " + Utils.getLocalDateTimeString(_loc1_);
               this.challengeLbl.visible = true;
            }
            else
            {
               this.iconBmp.source = LadderViewWindow.ArrowDownPng;
               this.iconBmp.visible = true;
               this.challengeLbl.text = this.team.challenge.challenger_name + " (" + this.team.challenge.challenger_position.toString() + ") @ " + Utils.getLocalDateTimeString(_loc1_);
               this.challengeLbl.visible = true;
            }
         }
         else if(this.team.frozen_until)
         {
            _loc2_ = new Date();
            _loc2_.time += this.team.frozen_until;
            this.iconBmp.source = LadderViewWindow.StopPng;
            this.iconBmp.visible = true;
            this.challengeLbl.text = Utils.formatString(Asset.getInstanceByName("CANT_CHALLENGE_FOR").value,{"delta":Utils.getLocalDateTimeString(_loc2_)});
            this.challengeLbl.visible = true;
         }
         if(this.ladderWindow.team)
         {
            if(this.ladderWindow.team.challenge.id == 0)
            {
               _loc3_ = this.team.position - this.ladderWindow.team.position;
               if(_loc3_ < 0 && Math.abs(_loc3_) <= this.ladderWindow.ladder.max_challenge)
               {
                  if(this.team.challenge.id > 0)
                  {
                     this.box.setStyle("BackgroundColor",5570560);
                     this.box.setStyle("BorderColor",16711680);
                  }
                  else
                  {
                     this.box.setStyle("BackgroundColor",21760);
                     this.box.setStyle("BorderColor",65280);
                  }
               }
               else
               {
                  this.box.setStyle("BackgroundColor",0);
                  this.box.setStyle("BorderColor",16777215);
               }
            }
         }
      }
      else
      {
         visible = false;
      }
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
      this.update();
   }
}
