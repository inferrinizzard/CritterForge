package com.edgebee.breedr.ui.world.areas.safari
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.Category;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Level;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.player.TokenPackage;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.ChangeBubble;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.creature.LevelView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SafariView extends Canvas
   {
      
      private static const ICON_SIZE:int = UIGlobals.relativize(32);
       
      
      public var creatureBox:Box;
      
      public var creatureView:CreatureView;
      
      public var staminaLevelView:LevelView;
      
      public var happinessLevelView:LevelView;
      
      public var healthLevelView:LevelView;
      
      public var preyBox:Box;
      
      public var preyView:CreatureView;
      
      public var optionsBox:Box;
      
      public var quitBtn:Button;
      
      public var genderIcon:BitmapComponent;
      
      public var genderLbl:Label;
      
      public var creatureBox2:Box;
      
      public var gridView:com.edgebee.breedr.ui.world.areas.safari.SafariGridView;
      
      public var nameBtn:Button;
      
      private var _safariCreature:WeakReference;
      
      private var _lastPopTime:Number = 0;
      
      private var _layout:Array;
      
      public function SafariView()
      {
         this._safariCreature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":Box,
            "ID":"creatureBox",
            "x":UIGlobals.relativize(25),
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "STYLES":{"Gap":UIGlobals.relativize(5)},
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"creatureBox2",
               "direction":Box.VERTICAL,
               "spreadProportionality":false,
               "doubleClickEnabled":true,
               "STYLES":{
                  "Padding":UIGlobals.relativize(12),
                  "CornerRadius":10,
                  "BackgroundAlpha":0.25
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.DOUBLE_CLICK,
                  "LISTENER":this.onMouseDoubleClick
               }],
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"nameBtn",
                  "filters":UIGlobals.fontOutline,
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onMouseDoubleClick
                  }],
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontSize":UIGlobals.relativizeFont(14),
                     "FontColor":16777215
                  }
               },{
                  "CLASS":CreatureView,
                  "ID":"creatureView",
                  "width":UIGlobals.relativize(128),
                  "height":UIGlobals.relativize(128)
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "filters":UIGlobals.fontOutline,
                  "STYLES":{"Gap":UIGlobals.relativize(3)},
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
               }]
            },{
               "CLASS":Box,
               "ID":"preyBox",
               "name":"SafariPreyView",
               "direction":Box.VERTICAL,
               "visible":false,
               "toolTip":Asset.getInstanceByName("YOUR_PREY_TIP"),
               "spreadProportionality":false,
               "STYLES":{
                  "Padding":UIGlobals.relativize(12),
                  "CornerRadius":10,
                  "BackgroundAlpha":0.25
               },
               "CHILDREN":[{
                  "CLASS":Label,
                  "filters":UIGlobals.fontOutline,
                  "text":Asset.getInstanceByName("YOUR_PREY"),
                  "STYLES":{"FontWeight":"bold"}
               },{
                  "CLASS":CreatureView,
                  "ID":"preyView",
                  "width":UIGlobals.relativize(128),
                  "height":UIGlobals.relativize(128)
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "filters":UIGlobals.fontOutline,
                  "STYLES":{"Gap":UIGlobals.relativize(3)},
                  "CHILDREN":[{
                     "CLASS":BitmapComponent,
                     "ID":"genderIcon",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "toolTip":Asset.getInstanceByName("GENDER_TOOLTIP")
                  },{
                     "CLASS":Label,
                     "ID":"genderLbl",
                     "STYLES":{
                        "FontColor":16777215,
                        "FontWeight":"bold"
                     }
                  }]
               }]
            },{
               "CLASS":Button,
               "ID":"quitBtn",
               "label":"Quit",
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onQuitClick
               }]
            }]
         },{
            "CLASS":Box,
            "ID":"optionsBox",
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "percentWidth":1,
            "percentHeight":0.75,
            "CHILDREN":[{
               "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariGridView,
               "ID":"gridView",
               "name":"SafariGridView",
               "width":5 * SafariCardView.SIZE,
               "height":5 * SafariCardView.SIZE
            }]
         }];
         super();
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.player.last_safari_prey.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLastSafariPreyChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("SafariStop",this.onSafariStop);
         this.client.service.addEventListener("SafariTrack",this.onSafariTrack);
         this.client.service.addEventListener("SafariExtractSeed",this.onSafariExtractSeed);
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.creatureView.addEventListener(DragEvent.DRAG_ENTER,this.onCreatureDragEnter);
         this.creatureView.addEventListener(DragEvent.DRAG_EXIT,this.onCreatureDragExit);
         this.creatureView.addEventListener(DragEvent.DRAG_DROP,this.onCreatureDragDrop);
         this.preyView.addEventListener(DragEvent.DRAG_ENTER,this.onPreyDragEnter);
         this.preyView.addEventListener(DragEvent.DRAG_EXIT,this.onPreyDragExit);
         this.preyView.addEventListener(DragEvent.DRAG_DROP,this.onPreyDragDrop);
         this.safariCreature = this.player.safari_creature;
         addEventListener(SafariCardView.CARD_CLICKED,this.onCardClicked);
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.gridView.alpha = 0;
            this.gridView.controller.animateTo({"alpha":1});
         }
      }
      
      private function get safariCreature() : CreatureInstance
      {
         return this._safariCreature.get() as CreatureInstance;
      }
      
      private function set safariCreature(param1:CreatureInstance) : void
      {
         if(param1 != this.safariCreature)
         {
            if(this.safariCreature)
            {
               this.safariCreature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._safariCreature.reset(param1);
            if(this.safariCreature)
            {
               this.safariCreature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this.update();
         }
      }
      
      private function onCardClicked(param1:ExtendedEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.index = param1.data as Number;
         this.client.service.SafariTrack(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onSafariTrack(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onQuitClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         if(this.gameView.statusWindow.visible)
         {
            this.gameView.statusWindow.doClose();
         }
         this.client.service.SafariStop(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onSafariStop(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSafariExtractSeed(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function update() : void
      {
         if((childrenCreated || childrenCreating) && this.creatureView != null)
         {
            this.nameBtn.label = !!this.safariCreature ? this.safariCreature.name : "";
            this.creatureView.creature = this.safariCreature;
            this.staminaLevelView.creature = this.safariCreature;
            this.happinessLevelView.creature = this.safariCreature;
            this.healthLevelView.creature = this.safariCreature;
            this.gridView.enabled = !!this.safariCreature ? this.safariCreature.stamina.index > 0 : false;
            this.quitBtn.enabled = true;
            if(this.player.last_safari_prey.ref)
            {
               this.preyView.creature = this.player.last_safari_prey.ref;
               this.genderIcon.source = this.preyView.creature.is_male ? RanchView.MaleIconPng : RanchView.FemaleIconPng;
               this.genderLbl.text = this.preyView.creature.is_male ? Asset.getInstanceByName("MALE") : Asset.getInstanceByName("FEMALE");
               this.preyBox.visible = true;
            }
            else
            {
               this.preyBox.visible = false;
            }
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(this.player.area.type == Area.TYPE_SAFARI)
            {
               this.update();
            }
         }
         if(param1.property == "safari_creature")
         {
            this.safariCreature = param1.newValue as CreatureInstance;
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
               _loc3_ = this.creatureBox2.localToGlobal(_loc3_);
               _loc3_ = globalToLocal(_loc3_);
               _loc2_.center = _loc3_;
               if((_loc5_ = (_loc4_ = new Date().time) - this._lastPopTime) < 1500)
               {
                  _loc2_.delay = 1500 - _loc5_;
               }
               this._lastPopTime = _loc4_;
               this._lastPopTime += _loc2_.delay;
               addChild(_loc2_);
            }
         }
         this.update();
      }
      
      private function onLastSafariPreyChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "ref")
         {
            this.update();
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.optionsBox))
         {
            this.optionsBox.enabled = this.client.criticalComms == 0;
            this.quitBtn.enabled = this.client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SafariTrack")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SafariQuit")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "SafariExtractSeed")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onCreatureDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if((_loc2_.item.type == Item.TYPE_USE && (_loc2_.item.subtype == Item.USE_RESTORE_STAMINA || _loc2_.item.subtype == Item.USE_RESTORE_HEALTH || _loc2_.item.subtype == Item.USE_RESTORE_HAPPINESS) || (_loc2_.item.type == Item.TYPE_PLAY || _loc2_.item.type == Item.TYPE_NURTURE)) && _loc2_.canUseItem(this.safariCreature))
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
            this.useItemOnSafariCreature(_loc2_);
         }
      }
      
      public function useItemOnSafariCreature(param1:ItemInstance) : void
      {
         if(this.client.criticalComms > 0)
         {
            return;
         }
         var _loc2_:Object = this.client.createInput();
         _loc2_ = this.client.createInput();
         _loc2_.creature_id = this.creatureView.creature.id;
         _loc2_.item_id = param1.id;
         this.client.service.UseItem(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onPreyDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if(_loc2_.item.type == Item.TYPE_BREED && _loc2_.creature.id == 0)
            {
               UIGlobals.dragManager.acceptDragDrop(this.preyView);
               this.preyView.colorMatrix.brightness = 25;
            }
         }
      }
      
      private function onPreyDragExit(param1:DragEvent) : void
      {
         this.preyView.colorMatrix.reset();
      }
      
      private function onPreyDragDrop(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.criticalComms)
         {
            this.preyView.colorMatrix.reset();
            _loc2_ = param1.dragInfo.item as ItemInstance;
            this.useItemOnSafariPreyCreature(_loc2_);
         }
      }
      
      public function useItemOnSafariPreyCreature(param1:ItemInstance) : void
      {
         var _loc2_:TokenPackage = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AlertWindow = null;
         if(this.client.criticalComms > 0)
         {
            return;
         }
         if(!this.player.last_safari_prey.ref)
         {
            return;
         }
         if(param1.creature.id != 0)
         {
            return;
         }
         if(!(this.player.last_safari_prey.ref as CreatureInstance).is_quest && ((this.player.last_safari_prey.ref as CreatureInstance).creature.category.type == Category.CATEGORY_LEGEND || (this.player.last_safari_prey.ref as CreatureInstance).creature.category.type == Category.CATEGORY_MYSTIC))
         {
            _loc3_ = (this.player.last_safari_prey.ref as CreatureInstance).creature.category.type;
            if(_loc3_ == Category.CATEGORY_LEGEND)
            {
               _loc2_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_EXTRACT_FOURTH_TIER);
            }
            else if(_loc3_ == Category.CATEGORY_MYSTIC)
            {
               _loc2_ = TokenPackage.getInstanceByType(TokenPackage.TYPE_EXTRACT_FIFTH_TIER);
            }
            _loc4_ = Asset.getInstanceByName("EXTRACT_LEGENDARY_CONFIRMATION").value;
            _loc4_ = Utils.formatString(_loc4_,{"tokens":_loc2_.tokens.toString()});
            (_loc5_ = AlertWindow.show(_loc4_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_YES":this.onConfirmExtract},false,false,true,true,false,true,AlertWindow.WarningIconPng)).extraData = param1;
         }
         else
         {
            this.doExtract(param1);
         }
      }
      
      private function onConfirmExtract(param1:Event) : void
      {
         var _loc2_:AlertWindow = param1.target as AlertWindow;
         var _loc3_:ItemInstance = _loc2_.extraData;
         _loc2_.extraData = null;
         this.doExtract(_loc3_);
      }
      
      private function doExtract(param1:ItemInstance) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_ = this.client.createInput();
         _loc2_.item_id = param1.id;
         this.client.service.SafariExtractSeed(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         this.gameView.statusWindow.locked = false;
         this.gameView.statusWindow.visible = true;
         this.gameView.statusWindow.stall = null;
         this.gameView.statusWindow.creature = this.safariCreature;
      }
   }
}
