package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.ladder.Team;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TeamEditWindow extends Window
   {
       
      
      private var _team:WeakReference;
      
      public var infoBox:Box;
      
      public var creatureList:TileList;
      
      public var addBtn:Button;
      
      public var removeBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function TeamEditWindow()
      {
         this._team = new WeakReference(null,Team);
         this._contentLayout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "direction":Box.HORIZONTAL,
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "Gap":0,
               "Padding":2
            },
            "CHILDREN":[{
               "CLASS":Box,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "STYLES":{"BackgroundAlpha":0.05},
               "CHILDREN":[{
                  "CLASS":TileList,
                  "ID":"creatureList",
                  "filterFunc":filterTeamCreatures,
                  "widthInColumns":1,
                  "heightInRows":5,
                  "renderer":CreatureTeamView
               },{
                  "CLASS":ScrollBar,
                  "name":"CreateAuctionWindow:CreatureListScrollBar",
                  "percentHeight":1,
                  "scrollable":"{creatureList}"
               }]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"addBtn",
            "label":"Add",
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onAddClick"
            }]
         },{
            "CLASS":Button,
            "ID":"removeBtn",
            "label":"Remove",
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onRemoveClick"
            }]
         }];
         super();
         width = UIGlobals.relativize(400);
         height = UIGlobals.relativize(500);
         rememberPositionId = "TeamEditWindow";
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.addEventListener("SyndicateTeamAddCreature",this.onSyndicateTeamAddCreature);
         client.service.addEventListener("SyndicateTeamRemoveCreature",this.onSyndicateTeamRemoveCreature);
      }
      
      private static function filterTeamCreatures(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:CreatureInstance;
         return (_loc4_ = param1 as CreatureInstance).auction_id == 0 && !_loc4_.isEgg;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get team() : Team
      {
         return this._team.get() as Team;
      }
      
      public function set team(param1:Team) : void
      {
         if(param1 != this.team)
         {
            this._team.reset(param1);
            if(Boolean(this.team) && childrenCreated)
            {
               this.creatureList.selectedItem = this.player.creatures.findItemByProperty("team_id",this.team.id);
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         this.creatureList.dataProvider = this.player.creatures;
         this.creatureList.addEventListener(Event.CHANGE,this.onCreatureSelectionChange);
         if(this.team)
         {
            this.creatureList.selectedItem = this.player.creatures.findItemByProperty("team_id",this.team.id);
         }
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.onCreatureSelectionChange(null);
         }
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      public function onAddClick(param1:MouseEvent) : void
      {
         if(this.player.creatures.findItemByProperty("team_id",this.team.id))
         {
            AlertWindow.show(Asset.getInstanceByName("ALREADY_HAVE_CREATURE_IN_TEAM"),"",this,true,null,false,true,false,false,false,true);
            return;
         }
         var _loc2_:Object = client.createInput();
         _loc2_.team_id = this.team.id;
         _loc2_.creature_id = (this.creatureList.selectedItem as CreatureInstance).id;
         client.service.SyndicateTeamAddCreature(_loc2_);
         ++client.criticalComms;
      }
      
      public function onRemoveClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_.team_id = this.team.id;
         _loc2_.creature_id = (this.creatureList.selectedItem as CreatureInstance).id;
         client.service.SyndicateTeamRemoveCreature(_loc2_);
         ++client.criticalComms;
      }
      
      private function onCreatureSelectionChange(param1:Event) : void
      {
         var _loc2_:CreatureInstance = null;
         var _loc3_:Date = null;
         if(this.creatureList.selectedItem != null)
         {
            _loc2_ = this.creatureList.selectedItem as CreatureInstance;
            _loc3_ = new Date();
            this.addBtn.enabled = _loc2_.team_id == 0 && (!_loc2_.addToTeamTime || _loc2_.addToTeamTime.time < _loc3_.time);
            this.removeBtn.enabled = _loc2_.team_id == this.team.id;
         }
         else
         {
            this.addBtn.enabled = this.removeBtn.enabled = false;
         }
      }
      
      private function onSyndicateTeamAddCreature(param1:ServiceEvent) : void
      {
         visible = false;
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onSyndicateTeamRemoveCreature(param1:ServiceEvent) : void
      {
         visible = false;
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            statusBar.enabled = client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SyndicateTeamAddCreature")
         {
            --client.criticalComms;
         }
         else if(param1.method == "SyndicateTeamRemoveCreature")
         {
            --client.criticalComms;
         }
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.Listable;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.ui.creature.CreatureView;

class CreatureTeamView extends Canvas implements Listable
{
    
   
   private var _selected:Boolean = false;
   
   private var _highlighted:Boolean = false;
   
   private var _creature:WeakReference;
   
   public var creatureView:CreatureView;
   
   public var nameLbl:Label;
   
   public var currentLadderLbl:Label;
   
   public var levelLvl:Label;
   
   private var _layout:Array;
   
   public function CreatureTeamView()
   {
      this._creature = new WeakReference(null,CreatureInstance);
      this._layout = [{
         "CLASS":CreatureView,
         "ID":"creatureView",
         "width":UIGlobals.relativize(64),
         "height":UIGlobals.relativize(64)
      },{
         "CLASS":Box,
         "percentWidth":1,
         "percentHeight":1,
         "filters":UIGlobals.fontOutline,
         "horizontalAlign":Box.ALIGN_RIGHT,
         "verticalAlign":Box.ALIGN_TOP,
         "direction":Box.VERTICAL,
         "STYLES":{"Gap":-8},
         "CHILDREN":[{
            "CLASS":Label,
            "ID":"nameLbl",
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Box,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("LEVEL_ABR"),
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":Label,
               "ID":"levelLvl",
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            }]
         },{
            "CLASS":Label,
            "ID":"currentLadderLbl",
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         }]
      }];
      super();
      useMouseScreen = true;
      width = UIGlobals.relativize(320);
      height = UIGlobals.relativize(64);
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
      return this.creature;
   }
   
   public function set listElement(param1:Object) : void
   {
      this.creature = param1 as CreatureInstance;
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
   
   public function get creature() : CreatureInstance
   {
      return this._creature.get() as CreatureInstance;
   }
   
   public function set creature(param1:CreatureInstance) : void
   {
      if(this.creature != param1)
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
         if(childrenCreated)
         {
            this.update();
         }
      }
   }
   
   private function onCreatureChange(param1:PropertyChangeEvent) : void
   {
      this.update();
   }
   
   private function update() : void
   {
      var _loc1_:Team = null;
      var _loc2_:Date = null;
      if(this.creature)
      {
         visible = true;
         this.nameLbl.text = this.creature.name;
         this.creatureView.creature = this.creature;
         this.levelLvl.text = this.creature.level.toString();
         _loc1_ = this.player.syndicate.teams.findItemByProperty("id",this.creature.team_id) as Team;
         this.creatureView.alpha = !!_loc1_ ? 0.5 : 1;
         this.creatureView.colorMatrix.saturation = !!_loc1_ ? -100 : 0;
         _loc2_ = new Date();
         if(_loc1_)
         {
            this.currentLadderLbl.text = _loc1_.ladder.name;
         }
         else if(Boolean(this.creature.addToTeamTime) && this.creature.addToTeamTime.time > _loc2_.time)
         {
            this.currentLadderLbl.text = Utils.formatString(Asset.getInstanceByName("TEAM_CANT_ADD_UNTIL").value,{"time":Utils.getLocalDateTimeString(this.creature.addToTeamTime)});
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
