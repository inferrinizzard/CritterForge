package com.edgebee.breedr.ui.world.areas.travel
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Destination;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CreaturePickerWindow extends Window
   {
      
      public static const CREATURE_SELECTED:String = "CREATURE_SELECTED";
       
      
      public var infoBox:Box;
      
      public var creatureList:List;
      
      public var okBtn:Button;
      
      public var cancelBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function CreaturePickerWindow()
      {
         this._contentLayout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "direction":Box.HORIZONTAL,
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{"Padding":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":Box,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":List,
                  "ID":"creatureList",
                  "filterFunc":filterCreatures,
                  "percentHeight":1,
                  "percentWidth":1,
                  "renderer":CreaturePickerView
               },{
                  "CLASS":ScrollBar,
                  "name":"CreaturePickerWindow:CreatureListScrollBar",
                  "percentHeight":1,
                  "scrollable":"{creatureList}"
               }]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"okBtn",
            "label":Asset.getInstanceByName("OK"),
            "enabled":false,
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOkClick
            }]
         },{
            "CLASS":Button,
            "ID":"cancelBtn",
            "label":Asset.getInstanceByName("CANCEL"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onCancelClick
            }]
         }];
         super();
         width = UIGlobals.relativize(400);
         height = UIGlobals.relativize(425);
         title = Asset.getInstanceByName("SAFARI_CREATURE_PICKER");
         rememberPositionId = "CreaturePickerWindow";
         showCloseButton = true;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private static function filterCreatures(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:CreatureInstance;
         return (_loc4_ = param1 as CreatureInstance).auction_id == 0;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         this.creatureList.dataProvider = this.player.fightingCreatures;
         this.creatureList.addEventListener(Event.CHANGE,this.onCreatureSelectionChange);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",UIGlobals.relativize(6));
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      override public function doClose() : void
      {
         UIGlobals.popUpManager.removePopUp(this);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.creatureList.dataProvider = null;
            this.creatureList.dataProvider = this.player.fightingCreatures;
         }
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(CREATURE_SELECTED,this.creatureList.selectedItem));
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.doClose();
      }
      
      private function onCreatureSelectionChange(param1:Event) : void
      {
         var _loc2_:CreatureInstance = null;
         var _loc3_:Destination = null;
         if(this.creatureList.selectedItem != null)
         {
            _loc2_ = this.creatureList.selectedItem as CreatureInstance;
            _loc3_ = this.gameView.travelView.selectedView.destination;
            this.okBtn.enabled = _loc2_.stamina.index > 0 && (_loc3_.credits > 0 && _loc3_.creditsCostForCreature(_loc2_) <= this.player.credits || _loc3_.tokens <= client.user.tokens);
         }
         else
         {
            this.okBtn.enabled = false;
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            statusBar.enabled = client.criticalComms == 0;
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
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Destination;
import com.edgebee.breedr.ui.ControlBar;
import com.edgebee.breedr.ui.GameView;
import com.edgebee.breedr.ui.creature.CreatureView;
import com.edgebee.breedr.ui.creature.LevelView;
import com.edgebee.breedr.ui.world.areas.ranch.RanchView;

class CreaturePickerView extends Canvas implements Listable
{
    
   
   private var _selected:Boolean = false;
   
   private var _highlighted:Boolean = false;
   
   private var _creature:WeakReference;
   
   public var creatureView:CreatureView;
   
   public var nameLbl:Label;
   
   public var currentLadderLbl:Label;
   
   public var staminaLvl:LevelView;
   
   public var creditsBox:Box;
   
   public var creditsLbl:Label;
   
   public var orLbl:Label;
   
   public var tokensBox:Box;
   
   public var tokensLbl:Label;
   
   private var _layout:Array;
   
   public function CreaturePickerView()
   {
      this._creature = new WeakReference(null,CreatureInstance);
      this._layout = [{
         "CLASS":CreatureView,
         "ID":"creatureView",
         "width":UIGlobals.relativize(96),
         "height":UIGlobals.relativize(96)
      },{
         "CLASS":Box,
         "percentWidth":1,
         "percentHeight":1,
         "direction":Box.VERTICAL,
         "horizontalAlign":Box.ALIGN_RIGHT,
         "verticalAlign":Box.ALIGN_MIDDLE,
         "CHILDREN":[{
            "CLASS":Box,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"nameLbl",
               "STYLES":{"FontSize":UIGlobals.relativizeFont(24)}
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(10)
            },{
               "CLASS":LevelView,
               "ID":"staminaLvl",
               "width":UIGlobals.relativize(24),
               "height":UIGlobals.relativize(24),
               "toolTip":Asset.getInstanceByName("STAMINA_TOOLTIP"),
               "style":LevelView.VALUE,
               "property":"stamina",
               "icon":RanchView.StaminaIconPng,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(14)}
            }]
         },{
            "CLASS":Spacer,
            "height":UIGlobals.relativize(25)
         },{
            "CLASS":Box,
            "layoutInvisibleChildren":false,
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"creditsBox",
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "ID":"creditsLbl",
                  "STYLES":{
                     "FontSize":UIGlobals.relativizeFont(20),
                     "FontColor":16777215
                  }
               },{
                  "CLASS":Spacer,
                  "width":UIGlobals.relativize(3)
               },{
                  "CLASS":BitmapComponent,
                  "width":UIGlobals.relativize(24),
                  "source":ControlBar.CreditsIconPng,
                  "isSquare":true
               }]
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(10)
            },{
               "CLASS":Label,
               "ID":"orLbl",
               "text":Asset.getInstanceByName("OR"),
               "STYLES":{
                  "FontColor":10066329,
                  "CapitalizeFirst":false,
                  "FontSize":UIGlobals.relativize(16)
               }
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(10)
            },{
               "CLASS":Box,
               "ID":"tokensBox",
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "ID":"tokensLbl",
                  "STYLES":{
                     "FontSize":UIGlobals.relativizeFont(20),
                     "FontColor":16777215
                  }
               },{
                  "CLASS":Spacer,
                  "width":UIGlobals.relativize(3)
               },{
                  "CLASS":BitmapComponent,
                  "width":UIGlobals.relativize(24),
                  "source":ControlBar.TokenIcon32Png,
                  "isSquare":true
               }]
            }]
         }]
      },{
         "CLASS":Spacer,
         "width":UIGlobals.relativize(5)
      }];
      super();
      useMouseScreen = true;
      percentWidth = 1;
      height = UIGlobals.relativize(96);
   }
   
   public function get client() : Client
   {
      return UIGlobals.root.client as Client;
   }
   
   public function get gameView() : GameView
   {
      return (UIGlobals.root as breedr_flash).rootView.gameView;
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
      var _loc1_:Destination = null;
      if(this.creature)
      {
         visible = true;
         this.nameLbl.text = this.creature.name;
         this.creatureView.creature = this.creature;
         this.staminaLvl.creature = this.creature;
         _loc1_ = this.gameView.travelView.selectedView.destination;
         this.creditsBox.visible = _loc1_.credits > 0;
         this.creditsLbl.text = _loc1_.creditsCostForCreature(this.creature).toString();
         this.orLbl.visible = _loc1_.credits > 0 && _loc1_.tokens > 0;
         this.tokensBox.visible = _loc1_.tokens > 0;
         this.tokensLbl.text = _loc1_.tokens.toString();
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
