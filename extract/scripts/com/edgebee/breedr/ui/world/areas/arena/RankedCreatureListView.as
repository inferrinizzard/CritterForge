package com.edgebee.breedr.ui.world.areas.arena
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.skins.borders.GradientLineBorder;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.creature.PropertyView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import com.edgebee.breedr.ui.world.areas.ranch.StallView;
   
   public class RankedCreatureListView extends Box implements Listable
   {
      
      private static const ICON_SIZE:Number = UIGlobals.relativize(20);
       
      
      private var _creature:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _animatedBorder:GradientLineBorder;
      
      public var containerBox:Box;
      
      public var nameLbl:GradientLabel;
      
      public var creatureView:CreatureView;
      
      public var playerLbl:PlayerLabel;
      
      public var levelView:PropertyView;
      
      public var rankView:PropertyView;
      
      public var deltaView:PropertyView;
      
      public var creditsLbl:Label;
      
      private var _layout:Array;
      
      public function RankedCreatureListView()
      {
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":Box,
            "ID":"containerBox",
            "CHILDREN":[{
               "CLASS":CreatureView,
               "ID":"creatureView",
               "width":"{height}",
               "height":"{height}",
               "layered":false
            },{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "percentHeight":1,
               "STYLES":{"Gap":UIGlobals.relativize(-1)},
               "CHILDREN":[{
                  "CLASS":Box,
                  "CHILDREN":[{
                     "CLASS":GradientLabel,
                     "ID":"nameLbl",
                     "filters":UIGlobals.fontOutline,
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontWeight":"bold"
                     }
                  },{
                     "CLASS":Spacer,
                     "percentWidth":1
                  },{
                     "CLASS":PlayerLabel,
                     "ID":"playerLbl",
                     "filters":UIGlobals.fontOutline,
                     "iconSize":ICON_SIZE,
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(10)}
                  }]
               },{
                  "CLASS":Spacer,
                  "percentHeight":1
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_RIGHT,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "filters":UIGlobals.fontOutline,
                  "CHILDREN":[{
                     "CLASS":PropertyView,
                     "ID":"levelView",
                     "icon":RanchView.LevelIconPng,
                     "toolTip":Asset.getInstanceByName("LEVEL_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(12)},
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "property":"level"
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(22)
                  },{
                     "CLASS":PropertyView,
                     "ID":"rankView",
                     "icon":RanchView.RankIconPng,
                     "toolTip":Asset.getInstanceByName("RANK_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(12)},
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "property":"rank"
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(22)
                  },{
                     "CLASS":PropertyView,
                     "ID":"deltaView",
                     "icon":StallView.ArrowPng,
                     "handleNegative":true,
                     "toolTip":Asset.getInstanceByName("RANK_DELTA_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(12)},
                     "handleNegative":true,
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "property":"rank_delta"
                  },{
                     "CLASS":Spacer,
                     "percentWidth":1
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("PURSE"),
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(18),
                        "FontColor":12303291
                     }
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(5)
                  },{
                     "CLASS":Label,
                     "ID":"creditsLbl",
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(22),
                        "FontColor":16777215
                     }
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(3)
                  },{
                     "CLASS":BitmapComponent,
                     "width":ICON_SIZE,
                     "isSquare":true,
                     "source":ControlBar.CreditsIconPng
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(3)
                  }]
               }]
            }]
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         width = UIGlobals.relativize(300);
         height = UIGlobals.relativize(336 / 6);
         horizontalAlign = Box.ALIGN_CENTER;
         verticalAlign = Box.ALIGN_MIDDLE;
         setStyle("Padding",1);
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
      
      public function get arenaView() : ArenaView
      {
         return this.gameView.arenaView;
      }
      
      public function get listElement() : Object
      {
         return this.creature;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.creature = param1 as CreatureInstance;
      }
      
      private function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      private function set creature(param1:CreatureInstance) : void
      {
         if(this.creature != param1)
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(childrenCreated)
            {
               this.update();
            }
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
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
         this.updateHighlight();
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         this.updateHighlight();
      }
      
      private function updateHighlight() : void
      {
         if(this.highlighted)
         {
            this._animatedBorder.setStyle("BorderColor",5635925);
            this._animatedBorder.visible = true;
         }
         else if(this.selected)
         {
            this._animatedBorder.setStyle("BorderColor",52224);
            this._animatedBorder.visible = true;
         }
         else
         {
            this._animatedBorder.visible = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._animatedBorder = new GradientLineBorder(this);
         this._animatedBorder.includeInLayout = false;
         this._animatedBorder.setStyle("BorderThickness",2);
         this._animatedBorder.setStyle("GradientLength",50);
         this._animatedBorder.setStyle("AnimationSpeed",0.5);
         this._animatedBorder.setStyle("BorderColor",65280);
         this.containerBox.addChild(this._animatedBorder);
         this._animatedBorder.visible = false;
         this.containerBox.setStyle("BackgroundColor",[16777215,5592405]);
         this.containerBox.setStyle("BackgroundAlpha",0.1);
         this.containerBox.setStyle("BackgroundDirection",Math.PI / 2);
         this.containerBox.setStyle("BorderAlpha",0.35);
         this.containerBox.setStyle("BorderThickness",1);
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function update() : void
      {
         if(this.creature)
         {
            visible = true;
            this.creatureView.visible = true;
            this.nameLbl.text = this.creature.name;
            this.creatureView.creature = this.creature;
            this.levelView.target = this.creature;
            this.rankView.target = this.creature;
            this.deltaView.target = this.creature;
            this.playerLbl.player = this.creature.owner;
            this.playerLbl.avatarImg.width = ICON_SIZE;
            this.playerLbl.avatarImg.height = ICON_SIZE;
            this.playerLbl.levelImg.width = ICON_SIZE;
            this.playerLbl.levelImg.height = ICON_SIZE;
            this.creditsLbl.text = this.creature.fight_credits.toString();
            if(this.creature.id == this.gameView.arenaView.creature.id)
            {
               this.nameLbl.colors = [16776960,16777215];
               setStyle("BackgroundColor",[65280,21760]);
            }
            else
            {
               this.nameLbl.colors = [10066329,16777215];
               setStyle("BackgroundColor",[16777215,5592405]);
            }
         }
         else
         {
            visible = false;
         }
      }
      
      public function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
   }
}
