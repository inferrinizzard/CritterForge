package com.edgebee.breedr.ui.world.areas.arena
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.controls.AAGradientLabel;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.combat.CombatResult;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Level;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Stall;
   import com.edgebee.breedr.ui.combat.CombatResultsWindow;
   import com.edgebee.breedr.ui.combat.EffectValueDisplay;
   import com.edgebee.breedr.ui.creature.ChangeBubble;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.creature.LevelView;
   import com.edgebee.breedr.ui.creature.PropertyView;
   import com.edgebee.breedr.ui.skins.BreedrLeftArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.BreedrRightArrowButtonSkin;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import com.edgebee.breedr.ui.world.areas.ranch.StallView;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class ArenaView extends Box
   {
      
      private static const ICON_SIZE:int = UIGlobals.relativize(32);
       
      
      public var optionsBox:Box;
      
      public var refreshBtn:Button;
      
      public var fightBtn:Button;
      
      public var autofightBtn:Button;
      
      public var prevBtn:Button;
      
      public var nextBtn:Button;
      
      public var nameLbl:AAGradientLabel;
      
      public var winsLbl:Label;
      
      public var lossesLbl:Label;
      
      public var tiesLbl:Label;
      
      public var creatureView:CreatureView;
      
      public var effectValueDisplay:EffectValueDisplay;
      
      public var bg:TransparentWindow;
      
      public var rankNeighborsList:List;
      
      public var staminaLevelView:LevelView;
      
      public var happinessLevelView:LevelView;
      
      public var healthLevelView:LevelView;
      
      public var levelView:PropertyView;
      
      public var rankView:PropertyView;
      
      public var deltaView:PropertyView;
      
      public var creatureBox:Box;
      
      private var _index:int = -1;
      
      private var _creature:WeakReference;
      
      private var _lastPopTime:Number = 0;
      
      private var _lastLength:uint = 0;
      
      private var _layout:Array;
      
      public function ArenaView()
      {
         this._creature = new WeakReference(null,CreatureInstance);
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
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "percentHeight":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "CHILDREN":[{
                  "CLASS":Box,
                  "CHILDREN":[{
                     "CLASS":List,
                     "ID":"rankNeighborsList",
                     "name":"ArenaNeighborsList",
                     "highlightable":true,
                     "selectable":true,
                     "showHighlight":false,
                     "showSelection":false,
                     "width":UIGlobals.relativize(300),
                     "heightInRows":6,
                     "renderer":RankedCreatureListView,
                     "STYLES":{"BackgroundAlpha":0.2}
                  },{
                     "CLASS":Box,
                     "ID":"creatureBox",
                     "direction":Box.VERTICAL,
                     "horizontalAlign":Box.ALIGN_CENTER,
                     "width":UIGlobals.relativize(256),
                     "CHILDREN":[{
                        "CLASS":Canvas,
                        "width":UIGlobals.relativize(200),
                        "height":UIGlobals.relativize(200),
                        "CHILDREN":[{
                           "CLASS":CreatureView,
                           "ID":"creatureView",
                           "width":UIGlobals.relativize(200),
                           "height":UIGlobals.relativize(200)
                        },{
                           "CLASS":EffectValueDisplay,
                           "ID":"effectValueDisplay",
                           "width":UIGlobals.relativize(200),
                           "height":UIGlobals.relativize(200)
                        }]
                     },{
                        "CLASS":AAGradientLabel,
                        "ID":"nameLbl",
                        "colors":[7829367,16777215,11184810,0],
                        "alphas":[1,1,1,1],
                        "ratios":[0,100,200,255],
                        "filters":[new GlowFilter(16777215,0.5,2,2,5,1,true),new GlowFilter(0,1,4,4,5)],
                        "STYLES":{
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(30)
                        }
                     },{
                        "CLASS":Box,
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{"Gap":UIGlobals.relativize(20)},
                        "CHILDREN":[{
                           "CLASS":LevelView,
                           "ID":"staminaLevelView",
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "style":LevelView.VALUE,
                           "property":"stamina",
                           "icon":RanchView.StaminaIconPng,
                           "toolTip":Asset.getInstanceByName("STAMINA_TOOLTIP"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                        },{
                           "CLASS":LevelView,
                           "ID":"happinessLevelView",
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "style":LevelView.VALUE,
                           "property":"happiness",
                           "icon":RanchView.HappinessIconPng,
                           "toolTip":Asset.getInstanceByName("HAPPINESS_TOOLTIP"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                        },{
                           "CLASS":LevelView,
                           "ID":"healthLevelView",
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "toolTip":Asset.getInstanceByName("HEALTH_TOOLTIP"),
                           "style":LevelView.VALUE,
                           "property":"health",
                           "icon":RanchView.HealthIconPng,
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                        }]
                     },{
                        "CLASS":Spacer,
                        "height":UIGlobals.relativize(5)
                     },{
                        "CLASS":Box,
                        "filters":UIGlobals.fontOutline,
                        "STYLES":{"Gap":UIGlobals.relativize(20)},
                        "CHILDREN":[{
                           "CLASS":PropertyView,
                           "ID":"levelView",
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "toolTip":Asset.getInstanceByName("LEVEL_TOOLTIP"),
                           "property":"level",
                           "icon":RanchView.LevelIconPng,
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                        },{
                           "CLASS":PropertyView,
                           "ID":"rankView",
                           "icon":RanchView.RankIconPng,
                           "toolTip":Asset.getInstanceByName("RANK_TOOLTIP"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)},
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "property":"rank"
                        },{
                           "CLASS":PropertyView,
                           "ID":"deltaView",
                           "icon":StallView.ArrowPng,
                           "toolTip":Asset.getInstanceByName("RANK_DELTA_TOOLTIP"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(16)},
                           "handleNegative":true,
                           "width":ICON_SIZE,
                           "height":ICON_SIZE,
                           "property":"rank_delta"
                        }]
                     },{
                        "CLASS":Spacer,
                        "height":UIGlobals.relativize(10)
                     },{
                        "CLASS":Box,
                        "filters":UIGlobals.fontOutline,
                        "CHILDREN":[{
                           "CLASS":Label,
                           "text":Asset.getInstanceByName("WINS"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
                        },{
                           "CLASS":Label,
                           "ID":"winsLbl",
                           "STYLES":{
                              "FontColor":16776960,
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "width":2
                        },{
                           "CLASS":Label,
                           "text":Asset.getInstanceByName("LOSSES"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
                        },{
                           "CLASS":Label,
                           "ID":"lossesLbl",
                           "STYLES":{
                              "FontColor":16776960,
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        },{
                           "CLASS":Spacer,
                           "width":2
                        },{
                           "CLASS":Label,
                           "text":Asset.getInstanceByName("TIES"),
                           "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
                        },{
                           "CLASS":Label,
                           "ID":"tiesLbl",
                           "STYLES":{
                              "FontColor":16776960,
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(12)
                           }
                        }]
                     }]
                  }]
               },{
                  "CLASS":Spacer,
                  "percentHeight":1
               },{
                  "CLASS":Box,
                  "ID":"optionsBox",
                  "name":"ArenaViewOptionsBox",
                  "direction":Box.HORIZONTAL,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "layoutInvisibleChildren":false,
                  "STYLES":{
                     "BackgroundAlpha":0.5,
                     "CornerRadius":15,
                     "Padding":UIGlobals.relativize(12)
                  },
                  "CHILDREN":[{
                     "CLASS":Button,
                     "ID":"prevBtn",
                     "toolTip":Asset.getInstanceByName("PREVIOUS_CREATURE"),
                     "STYLES":{"Skin":BreedrLeftArrowButtonSkin},
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onPreviousClick
                     }]
                  },{
                     "CLASS":Spacer,
                     "percentWidth":0.2
                  },{
                     "CLASS":Button,
                     "ID":"fightBtn",
                     "name":"ArenaFightButton",
                     "label":Asset.getInstanceByName("MAKE_A_CHALLENGE"),
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onFightClick
                     }]
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
                     "ID":"autofightBtn",
                     "label":Asset.getInstanceByName("AUTOFIGHT"),
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onAutofightClick
                     }]
                  },{
                     "CLASS":Spacer,
                     "percentWidth":0.2
                  },{
                     "CLASS":Button,
                     "ID":"nextBtn",
                     "toolTip":Asset.getInstanceByName("NEXT_CREATURE"),
                     "STYLES":{"Skin":BreedrRightArrowButtonSkin},
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onNextClick
                     }]
                  }]
               }]
            }]
         }];
         super(Box.VERTICAL);
         this.player.fightingCreatures.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCreaturesChanged);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("Fight",this.onFight);
         this.client.service.addEventListener("AutoFight",this.onAutoFight);
         this.client.service.addEventListener("RefreshFightCandidates",this.onRefreshFightCandidates);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.creatureView.addEventListener(DragEvent.DRAG_ENTER,this.onCreatureDragEnter);
         this.creatureView.addEventListener(DragEvent.DRAG_EXIT,this.onCreatureDragExit);
         this.creatureView.addEventListener(DragEvent.DRAG_DROP,this.onCreatureDragDrop);
         this.index = 0;
         this._lastLength = this.player.fightingCreatures.length;
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.bg.startAnimation();
            this.update();
         }
         else
         {
            this.bg.stopAnimation();
         }
      }
      
      public function showLevelUp() : void
      {
         this.effectValueDisplay.color = UIGlobals.getStyle("XPColor");
         this.effectValueDisplay.label = Asset.getInstanceByName("LEVELUP").value;
         this.effectValueDisplay.useCombatSpeedMultiplier = false;
         this.effectValueDisplay.show();
         this.effectValueDisplay.useCombatSpeedMultiplier = true;
      }
      
      private function get index() : int
      {
         return this._index;
      }
      
      private function set index(param1:int) : void
      {
         if(this.index != param1)
         {
            if(this.player.fightingCreatures.length == 0)
            {
               this._index = 0;
               this.creature = null;
               return;
            }
            if(param1 >= this.player.fightingCreatures.length)
            {
               this._index = 0;
            }
            else if(param1 < 0)
            {
               this._index = this.player.fightingCreatures.length - 1;
            }
            else
            {
               this._index = param1;
            }
            this.creature = this.player.fightingCreatures[this.index];
            this.update();
         }
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
               this.creature.rankingNeighbours.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onNeighborsChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               this.creature.rankingNeighbours.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onNeighborsChange);
            }
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:ChangeBubble = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(visible)
         {
            switch(param1.property)
            {
               case "happiness":
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Number) - (param1.oldValue as Number);
                  _loc2_.icon = RanchView.HappinessIconPng;
                  break;
               case "stamina":
                  if(!param1.oldValue || !param1.newValue)
                  {
                     break;
                  }
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Level).index - (param1.oldValue as Level).index;
                  _loc2_.icon = RanchView.StaminaIconPng;
                  break;
               case "health":
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Number) - (param1.oldValue as Number);
                  _loc2_.icon = RanchView.HealthIconPng;
            }
            if(_loc2_)
            {
               _loc3_ = new Point(this.creatureView.x + this.creatureView.width / 2,this.creatureView.y + this.creatureView.height);
               _loc3_ = this.creatureBox.localToGlobal(_loc3_);
               _loc3_ = parent.globalToLocal(_loc3_);
               _loc2_.center = _loc3_;
               if((_loc5_ = (_loc4_ = new Date().time) - this._lastPopTime) < 750)
               {
                  _loc2_.delay = 750 - _loc5_;
               }
               this._lastPopTime = _loc4_;
               this._lastPopTime += _loc2_.delay;
               parent.addChild(_loc2_);
            }
         }
         this.update();
      }
      
      private function onNeighborsChange(param1:CollectionEvent) : void
      {
         var _loc2_:uint = 0;
         if(Boolean(this.creature) && Boolean(this.rankNeighborsList))
         {
            if(this.creature.rankingNeighbours.length > 0)
            {
               _loc2_ = uint(Math.ceil(this.creature.rankingNeighbours.length / 2));
               this.rankNeighborsList.selectedItem = this.creature.rankingNeighbours[_loc2_];
            }
            if(!this.rankNeighborsList.selectedItem && this.creature.rankingNeighbours.length > 0)
            {
               UIGlobals.fiftyMsTimer.addEventListener(TimerEvent.TIMER,this.onWaitForNeighborsReady);
            }
         }
      }
      
      private function onWaitForNeighborsReady(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         if(Boolean(this.creature) && this.creature.rankingNeighbours.length > 0)
         {
            _loc2_ = uint(Math.ceil(this.creature.rankingNeighbours.length / 2));
            this.rankNeighborsList.selectedItem = this.creature.rankingNeighbours[_loc2_];
         }
         if(!this.creature || Boolean(this.rankNeighborsList.selectedItem))
         {
            UIGlobals.fiftyMsTimer.removeEventListener(TimerEvent.TIMER,this.onWaitForNeighborsReady);
         }
      }
      
      private function onRefreshClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.creature_instance_id = this.creature.id;
         this.client.service.RefreshFightCandidates(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onFightClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput(true,true);
         _loc2_.creature_instance_id = this.creature.id;
         var _loc3_:CreatureInstance = this.rankNeighborsList.selectedItem as CreatureInstance;
         if(_loc3_)
         {
            _loc2_.target_id = _loc3_.id;
         }
         this.client.service.Fight(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onPreviousClick(param1:MouseEvent) : void
      {
         --this.index;
      }
      
      private function onNextClick(param1:MouseEvent) : void
      {
         ++this.index;
      }
      
      private function onAutofightClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput(true,true);
         _loc2_.creature_instance_id = this.creature.id;
         var _loc3_:CreatureInstance = this.rankNeighborsList.selectedItem as CreatureInstance;
         if(_loc3_)
         {
            _loc2_.target_id = _loc3_.id;
         }
         this.client.service.AutoFight(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onFight(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onAutoFight(param1:ServiceEvent) : void
      {
         var _loc2_:CombatResultsWindow = (UIGlobals.root as breedr_flash).rootView.gameView.combatResultsWindow;
         var _loc3_:DataArray = new DataArray(CombatResult.classinfo);
         _loc3_.update(param1.data.results);
         _loc2_.results = _loc3_;
         this.creature.stamina_id = param1.data.stamina_id;
         this.creature.level = param1.data.level;
         this.creature.level_progress = param1.data.level_progress;
         this.creature.max_level = param1.data.max_level;
         this.creature.rank = param1.data.rank;
         this.creature.rank_delta = param1.data.rank_delta;
         this.creature.happiness = param1.data.happiness;
         this.creature.health = param1.data.health;
         this.creature.wins = param1.data.wins;
         this.creature.ties = param1.data.ties;
         this.creature.losses = param1.data.losses;
         this.creature.sleep_time_left = param1.data.sleep_time_left;
         this.client.actionDispatcher.actions = param1.data.events;
      }
      
      private function onRefreshFightCandidates(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
         --this.client.criticalComms;
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "Fight" || param1.method == "AutoFight")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.optionsBox))
         {
            this.updateOptions();
         }
      }
      
      private function updateOptions() : void
      {
         this.refreshBtn.enabled = this.autofightBtn.enabled = this.fightBtn.enabled = this.client.criticalComms == 0 && Boolean(this.creature) && this.creature.stamina.index > 0;
         this.prevBtn.enabled = this.client.criticalComms == 0 && Boolean(this.creature);
         this.nextBtn.enabled = this.client.criticalComms == 0 && Boolean(this.creature);
      }
      
      private function onCreatureDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if((_loc2_.item.type == Item.TYPE_USE && (_loc2_.item.subtype == Item.USE_RESTORE_STAMINA || _loc2_.item.subtype == Item.USE_RESTORE_HEALTH || _loc2_.item.subtype == Item.USE_RESTORE_HAPPINESS) || (_loc2_.item.type == Item.TYPE_PLAY || _loc2_.item.type == Item.TYPE_NURTURE)) && _loc2_.canUseItem(this.creature))
            {
               UIGlobals.dragManager.acceptDragDrop(this.creatureView);
               this.creatureView.colorMatrix.brightness = 25;
            }
         }
      }
      
      private function onCreatureDragExit(param1:DragEvent) : void
      {
         this.creatureView.colorMatrix.reset();
      }
      
      private function onCreatureDragDrop(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.criticalComms)
         {
            this.creatureView.colorMatrix.reset();
            _loc2_ = param1.dragInfo.item as ItemInstance;
            this.useItemOnCreature(_loc2_);
         }
      }
      
      public function useItemOnCreature(param1:ItemInstance) : void
      {
         if(this.client.criticalComms > 0)
         {
            return;
         }
         var _loc2_:Object = this.client.createInput();
         _loc2_ = this.client.createInput();
         var _loc3_:Stall = this.player.stalls.findItemByProperty("creature_id",this.creatureView.creature.id) as Stall;
         _loc2_.stall_id = _loc3_.id;
         _loc2_.creature_id = this.creatureView.creature.id;
         _loc2_.item_id = param1.id;
         this.client.service.UseItem(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(!this.optionsBox)
            {
               return;
            }
            if(this.creature)
            {
               if(this.creature.id <= 0)
               {
                  return;
               }
               this.nameLbl.text = this.creature.name;
               this.creatureView.creature = this.creature;
               this.rankNeighborsList.dataProvider = this.creature.rankingNeighbours;
               this.winsLbl.text = this.creature.wins.toString();
               this.lossesLbl.text = this.creature.losses.toString();
               this.tiesLbl.text = this.creature.ties.toString();
               this.staminaLevelView.creature = this.creature;
               this.happinessLevelView.creature = this.creature;
               this.healthLevelView.creature = this.creature;
               this.levelView.target = this.creature;
               this.rankView.target = this.creature;
               this.deltaView.target = this.creature;
               this.onNeighborsChange(null);
            }
            else
            {
               this.rankNeighborsList.dataProvider = null;
            }
            this.updateOptions();
         }
      }
      
      private function onCreaturesChanged(param1:CollectionEvent) : void
      {
         if(this.player.fightingCreatures.length != this._lastLength || this.creature && this.player.fightingCreatures[this.index].id != this.creature.id)
         {
            this._lastLength = this.player.fightingCreatures.length;
            this._index = -1;
            this.index = 0;
         }
      }
   }
}
