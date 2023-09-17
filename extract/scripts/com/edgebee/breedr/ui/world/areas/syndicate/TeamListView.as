package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.ladder.Team;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   
   public class TeamListView extends Box implements Listable
   {
      
      public static const EDIT_CLICKED:String = "EDIT_CLICKED";
      
      public static const CHALLENGE_CLICKED:String = "CHALLENGE_CLICKED";
      
      public static const VIEW_CLICKED:String = "VIEW_CLICKED";
      
      public static const ACTIVATE_CLICKED:String = "ACTIVATE_CLICKED";
      
      private static const views:Array = ["creatureView01","creatureView02","creatureView03","creatureView04","creatureView05","creatureView06","creatureView07","creatureView08","creatureView09","creatureView10","creatureView11"];
       
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _team:WeakReference;
      
      private var _mouseDown:Boolean = false;
      
      public var ladderLbl:Label;
      
      public var statusLbl:Label;
      
      public var positionLbl:Label;
      
      public var creatuveViewBox:Box;
      
      public var activateBtn:Button;
      
      public var editBtn:Button;
      
      public var challengeBtn:Button;
      
      public var viewBtn:Button;
      
      public var creatureView01:TeamMemberView;
      
      public var creatureView02:TeamMemberView;
      
      public var creatureView03:TeamMemberView;
      
      public var creatureView04:TeamMemberView;
      
      public var creatureView05:TeamMemberView;
      
      public var creatureView06:TeamMemberView;
      
      public var creatureView07:TeamMemberView;
      
      public var creatureView08:TeamMemberView;
      
      public var creatureView09:TeamMemberView;
      
      public var creatureView10:TeamMemberView;
      
      public var creatureView11:TeamMemberView;
      
      private var _layout:Array;
      
      public function TeamListView()
      {
         this._team = new WeakReference(null,Team);
         this._layout = [{
            "CLASS":Box,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{"BackgroundAlpha":0.25},
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"ladderLbl",
               "filters":UIGlobals.fontOutline,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":Label,
               "ID":"positionLbl",
               "filters":UIGlobals.fontOutline,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":Spacer,
               "percentWidth":1
            },{
               "CLASS":Button,
               "ID":"activateBtn",
               "filters":UIGlobals.fontOutline,
               "label":Asset.getInstanceByName("SYNDICATE_TEAM_ACTIVATE"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onActivateClick
               }]
            },{
               "CLASS":Button,
               "ID":"editBtn",
               "filters":UIGlobals.fontOutline,
               "label":Asset.getInstanceByName("EDIT"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onEditClick
               }]
            },{
               "CLASS":Button,
               "ID":"challengeBtn",
               "filters":UIGlobals.fontOutline,
               "label":Asset.getInstanceByName("CHALLENGE"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onChallengeClick
               }]
            },{
               "CLASS":Button,
               "ID":"viewBtn",
               "filters":UIGlobals.fontOutline,
               "label":Asset.getInstanceByName("VIEW"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onViewClick
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "horizontalAlign":Box.ALIGN_CENTER,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"statusLbl",
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(12),
                  "FontStyle":"italic"
               }
            }]
         },{
            "CLASS":Box,
            "ID":"creatuveViewBox",
            "CHILDREN":[{
               "CLASS":TeamMemberView,
               "ID":"creatureView01"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView02"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView03"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView04"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView05"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView06"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView07"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView08"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView09"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView10"
            },{
               "CLASS":TeamMemberView,
               "ID":"creatureView11"
            }]
         },{
            "CLASS":Spacer,
            "height":UIGlobals.relativize(5)
         }];
         super(Box.VERTICAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         percentWidth = 1;
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         UIGlobals.oneSecTimer.addEventListener(TimerEvent.TIMER,this.updateActivateButton);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get listElement() : Object
      {
         return this.team;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.team = param1 as Team;
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
               this.team.members.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMembersChange);
            }
            this._team.reset(param1);
            if(this.team)
            {
               this.team.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
               this.team.challenge.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTeamChange);
               this.team.members.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMembersChange);
            }
            if(childrenCreated)
            {
               this.update();
            }
         }
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         visible = false;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function onTeamChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "syndicate_level")
         {
            this.update();
         }
      }
      
      private function onMembersChange(param1:CollectionEvent) : void
      {
         var _loc2_:TeamMemberView = null;
         var _loc3_:int = 0;
         if(this.team)
         {
            _loc3_ = 0;
            while(_loc3_ < views.length)
            {
               _loc2_ = this[views[_loc3_]] as TeamMemberView;
               if(_loc3_ < this.team.ladder.max_team_size)
               {
                  _loc2_.visible = true;
                  if(_loc3_ < this.team.members.length)
                  {
                     _loc2_.border.setStyle("BorderAlpha",0);
                     _loc2_.creature = this.team.members[_loc3_];
                  }
                  else
                  {
                     _loc2_.border.setStyle("BorderAlpha",0.25);
                     _loc2_.creature = null;
                  }
               }
               else
               {
                  _loc2_.visible = false;
                  _loc2_.creature = null;
               }
               _loc3_++;
            }
         }
      }
      
      private function update() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         if(this.team)
         {
            visible = true;
            this.ladderLbl.text = this.team.ladder.name;
            if(this.team.active)
            {
               this.positionLbl.text = "#" + this.team.position.toString();
            }
            else
            {
               this.positionLbl.text = "";
            }
            this.challengeBtn.enabled = false;
            if(this.team.challenge.id)
            {
               _loc1_ = new Date();
               _loc1_.time += this.team.challenge.fight_at * 1000;
               if(this.team.challenge.challenger_id == this.team.id)
               {
                  this.statusLbl.text = Utils.formatString(Asset.getInstanceByName("LADDER_CHALLENGED_AT").value,{
                     "team":this.team.challenge.defender_name,
                     "time":Utils.getLocalDateTimeString(_loc1_)
                  });
               }
               else
               {
                  this.statusLbl.text = Utils.formatString(Asset.getInstanceByName("LADDER_DEFENDS_AT").value,{
                     "team":this.team.challenge.challenger_name,
                     "time":Utils.getLocalDateTimeString(_loc1_)
                  });
               }
            }
            else if(this.team.frozen_until > 0)
            {
               _loc2_ = new Date();
               _loc2_.time += this.team.frozen_until * 1000;
               this.statusLbl.text = Utils.formatString(Asset.getInstanceByName("LADDER_FROZEN_UNTIL").value,{"time":Utils.getLocalDateTimeString(_loc2_)});
            }
            else if(!this.team.active)
            {
               _loc3_ = new Date();
               this.challengeBtn.enabled = false;
               if(Boolean(this.team.activateTime) && this.team.activateTime.time > _loc3_.time)
               {
                  this.statusLbl.text = Utils.formatString(Asset.getInstanceByName("SYNDICATE_TEAM_INACTIVE_UNTIL").value,{"time":Utils.getLocalDateTimeString(this.team.activateTime)});
               }
               else
               {
                  this.statusLbl.text = Asset.getInstanceByName("SYNDICATE_TEAM_INACTIVE");
               }
            }
            else
            {
               this.statusLbl.text = Asset.getInstanceByName("IDLE");
               this.challengeBtn.enabled = this.player.canChallengeOtherSyndicates;
            }
            if(this.team.active)
            {
               this.activateBtn.label = Asset.getInstanceByName("SYNDICATE_TEAM_DEACTIVATE");
            }
            else
            {
               this.activateBtn.label = Asset.getInstanceByName("SYNDICATE_TEAM_ACTIVATE");
            }
            this.updateActivateButton();
            this.editBtn.enabled = this.player.syndicate_level.capacity >= this.team.ladder.max_team_size;
            if(this.editBtn.enabled)
            {
               this.editBtn.toolTip = Asset.getInstanceByName("EDIT");
            }
            else
            {
               this.editBtn.toolTip = Asset.getInstanceByName("SYNDICATE_LEVEL_TOO_LOW_FOR_LADDER");
            }
            this.onMembersChange(null);
         }
         else
         {
            visible = false;
         }
      }
      
      private function updateActivateButton(param1:TimerEvent = null) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Boolean = false;
         if((childrenCreated || childrenCreating) && this.team && !this.team.active)
         {
            _loc2_ = new Date();
            _loc3_ = this.activateBtn.enabled;
            this.activateBtn.enabled = (!this.team.activateTime || this.team.activateTime.time < _loc2_.time) && this.team.ladder.max_team_size <= this.player.syndicate.leader.syndicate_level.capacity && this.player.canChallengeOtherSyndicates;
            if(this.activateBtn.enabled != _loc3_)
            {
               if(Boolean(this.team.activateTime) && this.team.activateTime.time > _loc2_.time)
               {
                  this.statusLbl.text = Utils.formatString(Asset.getInstanceByName("SYNDICATE_TEAM_INACTIVE_UNTIL").value,{"time":Utils.getLocalDateTimeString(this.team.activateTime)});
               }
               else
               {
                  this.statusLbl.text = Asset.getInstanceByName("SYNDICATE_TEAM_INACTIVE");
               }
            }
         }
      }
      
      public function onEditClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(EDIT_CLICKED,this.team,true));
      }
      
      public function onChallengeClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(CHALLENGE_CLICKED,this.team,true));
      }
      
      public function onViewClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(VIEW_CLICKED,this.team,true));
      }
      
      public function onActivateClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ACTIVATE_CLICKED,this.team,true));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.PlayerLabel;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.ui.creature.CreatureView;
import com.edgebee.breedr.ui.creature.PropertyView;
import com.edgebee.breedr.ui.world.areas.ranch.RanchView;

class TeamMemberView extends Canvas
{
    
   
   private var _creature:WeakReference;
   
   public var creatureView:CreatureView;
   
   public var levelView:PropertyView;
   
   public var rankView:PropertyView;
   
   private var _layout:Array;
   
   public function TeamMemberView()
   {
      this._creature = new WeakReference(null,CreatureInstance);
      this._layout = [{
         "CLASS":CreatureView,
         "ID":"creatureView",
         "layered":false,
         "width":UIGlobals.relativize(48),
         "height":UIGlobals.relativize(48)
      },{
         "CLASS":Box,
         "percentWidth":1,
         "horizontalAlign":Box.ALIGN_CENTER,
         "filters":UIGlobals.fontOutline,
         "CHILDREN":[{
            "CLASS":PropertyView,
            "ID":"levelView",
            "width":UIGlobals.relativize(16),
            "height":UIGlobals.relativize(16),
            "toolTip":Asset.getInstanceByName("LEVEL_TOOLTIP"),
            "property":"level",
            "icon":RanchView.LevelIconPng,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(9)}
         },{
            "CLASS":Spacer,
            "width":UIGlobals.relativize(5)
         },{
            "CLASS":PropertyView,
            "ID":"rankView",
            "width":UIGlobals.relativize(16),
            "height":UIGlobals.relativize(16),
            "toolTip":Asset.getInstanceByName("RANK_TOOLTIP"),
            "property":"rank",
            "icon":RanchView.RankIconPng,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(9)}
         }]
      }];
      super();
      width = UIGlobals.relativize(48);
      height = UIGlobals.relativize(48);
      setStyle("BorderThickness",1);
      setStyle("BorderColor",16777215);
      setStyle("BorderAlpha",0.25);
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
      this.update();
   }
   
   public function get client() : Client
   {
      return UIGlobals.root.client as Client;
   }
   
   public function get player() : Player
   {
      return this.client.player;
   }
   
   public function get creature() : CreatureInstance
   {
      return this._creature.get() as CreatureInstance;
   }
   
   public function set creature(param1:CreatureInstance) : void
   {
      if(!this.creature || !this.creature.equals(param1))
      {
         if(this.creature)
         {
            this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
         }
         this._creature.reset(param1);
         if(this.creature)
         {
            this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
         }
         this.update();
      }
   }
   
   private function onCreatureChange(param1:PropertyChangeEvent) : void
   {
      this.update();
   }
   
   private function update() : void
   {
      var _loc1_:Box = null;
      var _loc2_:Label = null;
      var _loc3_:Player = null;
      var _loc4_:PlayerLabel = null;
      if(Boolean(childrenCreated) || Boolean(childrenCreating))
      {
         this.creatureView.visible = this.creature != null;
         this.creatureView.creature = this.creature;
         this.levelView.visible = this.creature != null;
         this.levelView.target = this.creature;
         this.rankView.visible = this.creature != null;
         this.rankView.target = this.creature;
         if(this.creature)
         {
            _loc1_ = new Box(Box.VERTICAL);
            _loc2_ = new Label();
            _loc2_.text = this.creature.name;
            _loc1_.addChild(_loc2_);
            for each(_loc3_ in this.player.syndicate.members)
            {
               if(_loc3_.id == this.creature.owner.id)
               {
                  (_loc4_ = new PlayerLabel()).player = _loc3_;
                  _loc1_.addChild(_loc4_);
                  break;
               }
            }
            toolTip = _loc1_;
         }
         else
         {
            toolTip = null;
         }
      }
   }
}
