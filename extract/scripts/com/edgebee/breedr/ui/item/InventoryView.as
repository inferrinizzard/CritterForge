package com.edgebee.breedr.ui.item
{
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.data.world.FridgeLevel;
   import com.edgebee.breedr.managers.TutorialManager;
   import com.edgebee.breedr.managers.handlers.TrashItemHandler;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import com.edgebee.breedr.ui.world.UpgradeWindow;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InventoryView extends Box
   {
      
      public static const TrashOpenedPng:Class = InventoryView_TrashOpenedPng;
      
      public static const TrashClosedPng:Class = InventoryView_TrashClosedPng;
      
      private static const FILTER_FOOD:Number = 1;
      
      private static const FILTER_CARE:Number = 2;
      
      private static const FILTER_BREED:Number = 4;
       
      
      private var _disableCostCheck:Array;
      
      private var _lastThrashedItem:ItemInstance;
      
      private var _filtersGroup:RadioButtonGroup;
      
      private var _filterFlags:Number;
      
      public var inventoryList:TileList;
      
      public var optionsBox:Box;
      
      public var inventoryCapacity:ProgressBar;
      
      public var upgradeBtn:Button;
      
      public var foodFilterBtn:RadioButton;
      
      public var careFilterBtn:RadioButton;
      
      public var breedFilterBtn:RadioButton;
      
      public var allFilterBtn:RadioButton;
      
      public var trashCvs:Canvas;
      
      public var trashOpenedBmp:BitmapComponent;
      
      public var trashClosedBmp:BitmapComponent;
      
      private var _layout:Array;
      
      public function InventoryView()
      {
         this._filterFlags = FILTER_FOOD | FILTER_CARE | FILTER_BREED;
         this._layout = [{
            "CLASS":Box,
            "ID":"optionsBox",
            "direction":Box.HORIZONTAL,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "layoutInvisibleChildren":false,
            "filters":UIGlobals.fontOutline,
            "STYLES":{"Gap":UIGlobals.relativize(5)},
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("INVENTORY_CAPACITY"),
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":ProgressBar,
               "ID":"inventoryCapacity",
               "width":UIGlobals.relativize(128),
               "height":UIGlobals.relativize(18),
               "STYLES":{
                  "ForegroundColor":UIGlobals.getStyle("ThemeColor"),
                  "ShowLabel":true,
                  "FontColor":16777215,
                  "BarOffset":1,
                  "Animated":true,
                  "AnimationSpeed":1,
                  "AnimationInterpolation":Interpolation.linear,
                  "FontSize":UIGlobals.relativizeFont(11),
                  "LabelType":"fraction"
               }
            },{
               "CLASS":Button,
               "ID":"upgradeBtn",
               "name":"FridgeUpgradeButton",
               "label":Asset.getInstanceByName("UPGRADE"),
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onUpgradeClick"
               }]
            },{
               "CLASS":Spacer,
               "percentWidth":1
            },{
               "CLASS":Label,
               "text":Asset.getInstanceByName("FILTERS")
            },{
               "CLASS":RadioButton,
               "ID":"allFilterBtn",
               "label":Asset.getInstanceByName("ALL_SHORT"),
               "userData":0,
               "STYLES":{
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               }
            },{
               "CLASS":RadioButton,
               "ID":"foodFilterBtn",
               "label":Asset.getInstanceByName("FEED"),
               "userData":FILTER_FOOD,
               "STYLES":{
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               }
            },{
               "CLASS":RadioButton,
               "ID":"careFilterBtn",
               "label":Asset.getInstanceByName("USABLES"),
               "userData":FILTER_CARE,
               "STYLES":{
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               }
            },{
               "CLASS":RadioButton,
               "ID":"breedFilterBtn",
               "label":Asset.getInstanceByName("BREEDING"),
               "userData":FILTER_BREED,
               "STYLES":{
                  "Skin":BreedrButtonSkin,
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               }
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(12)
            },{
               "CLASS":Canvas,
               "ID":"trashCvs",
               "width":UIGlobals.relativize(32),
               "height":UIGlobals.relativize(32),
               "mouseChildren":false,
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "ID":"trashOpenedBmp",
                  "source":TrashOpenedPng,
                  "percentWidth":1,
                  "percentHeight":1,
                  "visible":false
               },{
                  "CLASS":BitmapComponent,
                  "ID":"trashClosedBmp",
                  "source":TrashClosedPng,
                  "percentWidth":1,
                  "percentHeight":1
               }]
            }]
         },{
            "CLASS":Box,
            "direction":Box.HORIZONTAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "percentWidth":1,
            "CHILDREN":[{
               "CLASS":TileList,
               "ID":"inventoryList",
               "filterFunc":"{filterItems}",
               "sortFunc":sortItems,
               "widthInColumns":13,
               "heightInRows":2,
               "direction":TileList.VERTICAL,
               "dataProvider":"{player.items}",
               "renderer":InventoryItemView,
               "STYLES":{"BackgroundAlpha":0.25}
            },{
               "CLASS":ScrollBar,
               "name":"ShopView:ShopPlayerItemsScrollBar",
               "height":InventoryItemView.SIZE * 2,
               "onlyShowWhenNeeded":false,
               "scrollable":"{inventoryList}"
            }]
         }];
         super(Box.VERTICAL);
         name = "InventoryView";
         width = UIGlobals.relativizeX(700);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this.client.service.addEventListener("BuyItem",this.onBuyItem);
         this.client.service.addEventListener("TrashItem",this.onTrashItem);
         this.client.service.addEventListener("UpgradeFridge",this.onUpgradeFridge);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.player.addEventListener(Data.UPDATED,this.onPlayerUpdated);
         this.player.items.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onItemsChange);
         setStyle("BackgroundColor",[16777215,6710886]);
         setStyle("BackgroundDirection",Math.PI / 2);
         setStyle("BackgroundAlpha",0.75);
         setStyle("CornerRadius",5);
         setStyle("BorderThickness",2);
         setStyle("BorderAlpha",0.65);
         setStyle("BorderColor",[16777215,6710886]);
         setStyle("BorderDirection",3 * Math.PI / 2);
      }
      
      private static function sortItems(param1:ItemInstance, param2:ItemInstance) : int
      {
         if(param1.priority < param2.priority)
         {
            return 1;
         }
         if(param1.priority > param2.priority)
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
      
      public function get disableCostCheck() : Array
      {
         return this._disableCostCheck;
      }
      
      public function set disableCostCheck(param1:Array) : void
      {
         this._disableCostCheck = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._filtersGroup = new RadioButtonGroup();
         this._filtersGroup.addButton(this.allFilterBtn);
         this._filtersGroup.addButton(this.foodFilterBtn);
         this._filtersGroup.addButton(this.careFilterBtn);
         this._filtersGroup.addButton(this.breedFilterBtn);
         this._filtersGroup.addEventListener(Event.CHANGE,this.onFiltersChange);
         this._filtersGroup.selected = this.allFilterBtn;
         this.inventoryList.addEventListener(DragEvent.DRAG_ENTER,this.onInventoryDragEnter);
         this.inventoryList.addEventListener(DragEvent.DRAG_EXIT,this.onInventoryDragExit);
         this.inventoryList.addEventListener(DragEvent.DRAG_DROP,this.onInventoryDragDrop);
         this.inventoryList.addEventListener(InventoryItemView.ITEM_DOUBLE_CLICKED,this.onItemDoubleClick);
         this.trashCvs.addEventListener(DragEvent.DRAG_ENTER,this.onTrashDragEnter);
         this.trashCvs.addEventListener(DragEvent.DRAG_EXIT,this.onTrashDragExit);
         this.trashCvs.addEventListener(DragEvent.DRAG_DROP,this.onTrashDragDrop);
         this.updateInventory();
         var _loc1_:BitmapComponent = new BitmapComponent();
         _loc1_.width = UIGlobals.relativize(12);
         _loc1_.height = UIGlobals.relativize(12);
         _loc1_.source = RanchView.UpgradeIconPng;
         this.upgradeBtn.icon = _loc1_;
      }
      
      private function onInventoryDragEnter(param1:DragEvent) : void
      {
         var _loc2_:Item = null;
         if(param1.dragInfo.hasOwnProperty("shop_item"))
         {
            _loc2_ = param1.dragInfo.shop_item as Item;
            UIGlobals.dragManager.acceptDragDrop(this.inventoryList);
         }
         else if(param1.dragInfo.hasOwnProperty("attachment_item"))
         {
            _loc2_ = param1.dragInfo.shop_item as Item;
            UIGlobals.dragManager.acceptDragDrop(this.inventoryList);
         }
      }
      
      private function onInventoryDragExit(param1:DragEvent) : void
      {
      }
      
      private function onInventoryDragDrop(param1:DragEvent) : void
      {
         var _loc2_:Item = null;
         if(this.client.criticalComms > 0)
         {
            return;
         }
         if(param1.dragInfo.hasOwnProperty("shop_item"))
         {
            _loc2_ = param1.dragInfo.shop_item as Item;
            this.doBuyItem(_loc2_);
         }
         else if(param1.dragInfo.hasOwnProperty("attachment_item"))
         {
            _loc2_ = param1.dragInfo.shop_item as Item;
            if(this.client.criticalComms == 0)
            {
               param1.dragInfo.success = true;
            }
         }
      }
      
      private function onConfirmBuyItem(param1:Event) : void
      {
         var _loc2_:AlertWindow = param1.target as AlertWindow;
         this.client.service.BuyItem(_loc2_.extraData);
         ++this.client.criticalComms;
      }
      
      public function doBuyItem(param1:Item) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:AlertWindow = null;
         if(this.client.criticalComms > 0)
         {
            return;
         }
         if(this.player.numInventoriedItems < this.player.fridge_level.capacity && (this.disableCostCheck && this.disableCostCheck.indexOf(param1.uid) >= 0 || param1.credits > 0 && this.player.credits >= param1.credits || param1.tokens > 0 && this.client.user.tokens >= param1.tokens))
         {
            _loc2_ = this.client.createInput();
            _loc2_.item_id = param1.id;
            if(!(this.disableCostCheck && this.disableCostCheck.indexOf(param1.uid) >= 0) && (param1.credits <= 0 || param1.credits > this.player.credits) && param1.tokens > 0 && this.client.user.tokens >= param1.tokens)
            {
               _loc3_ = Asset.getInstanceByName("CONFIRM_TOKEN_PURCHASE").value;
               _loc3_ = Utils.formatString(_loc3_,{"tokens":param1.tokens.toString()});
               (_loc4_ = AlertWindow.show(_loc3_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onConfirmBuyItem},true,true,false,false,true,true,ControlBar.TokenIcon32Png)).extraData = _loc2_;
            }
            else
            {
               this.client.service.BuyItem(_loc2_);
               ++this.client.criticalComms;
            }
         }
         else if(this.player.numInventoriedItems < this.player.fridge_level.capacity)
         {
            this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_not_enough_credits");
            this.gameView.dialogView.step();
         }
         else if(this.player.numInventoriedItems >= this.player.fridge_level.capacity)
         {
            this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_inventory_full");
            this.gameView.dialogView.step();
         }
      }
      
      private function onTrashDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.tutorialManager.currentTutorial)
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if(_loc2_.auction_id > 0)
            {
               return;
            }
            UIGlobals.dragManager.acceptDragDrop(this.trashCvs);
            this.trashOpenedBmp.visible = true;
            this.trashClosedBmp.visible = false;
         }
      }
      
      private function onTrashDragExit(param1:DragEvent) : void
      {
         this.trashOpenedBmp.visible = false;
         this.trashClosedBmp.visible = true;
      }
      
      private function onTrashDragDrop(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         var _loc3_:AlertWindow = null;
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.criticalComms)
         {
            this.trashOpenedBmp.visible = false;
            this.trashClosedBmp.visible = true;
            _loc2_ = param1.dragInfo.item as ItemInstance;
            _loc3_ = AlertWindow.show(Asset.getInstanceByName("ITEM_TRASH_CONFIRMATION"),Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
               "ALERT_WINDOW_YES":this.onConfirmTrash,
               "ALERT_WINDOW_NO":this.onCancelTrash
            },false,false,true,true,false,false,AlertWindow.WarningIconPng);
            _loc3_.extraData = _loc2_;
         }
      }
      
      private function onConfirmTrash(param1:Event) : void
      {
         var _loc2_:ItemInstance = (param1.currentTarget as AlertWindow).extraData as ItemInstance;
         this._lastThrashedItem = _loc2_;
         this.player.items.removeItem(_loc2_);
         UIGlobals.playSound(TrashItemHandler.ThrashWav);
         var _loc3_:Object = this.client.createInput();
         _loc3_.item_id = _loc2_.id;
         this.client.service.TrashItem(_loc3_);
      }
      
      private function onCancelTrash(param1:Event) : void
      {
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
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
      
      private function onPlayerUpdated(param1:Event) : void
      {
         this.updateInventory();
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "fridge_level")
         {
            this.updateInventory();
         }
         if(param1.property == "credits")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onItemsChange(param1:CollectionEvent) : void
      {
         this.updateInventory();
      }
      
      private function updateUpgradeButton() : void
      {
         var _loc1_:FridgeLevel = null;
         var _loc2_:Asset = null;
         if(Boolean(this.upgradeBtn) && Boolean(this.player.fridge_level))
         {
            _loc1_ = FridgeLevel.getInstanceByLevel(this.player.fridge_level.level + 1);
            this.upgradeBtn.enabled = this.client.criticalComms == 0 && Boolean(_loc1_) && (_loc1_.credits > 0 && this.player.credits >= _loc1_.credits || _loc1_.tokens > 0 && this.client.user.tokens >= _loc1_.tokens);
            if(_loc1_)
            {
               _loc2_ = Asset.getInstanceByName("INVENTORY_UPGRADE_TIP");
               if(_loc1_.credits < 0)
               {
                  _loc2_ = Asset.getInstanceByName("INVENTORY_UPGRADE_TIP_NO_CREDS");
               }
               this.upgradeBtn.toolTip = Utils.formatString(_loc2_.value,{
                  "credits":_loc1_.credits,
                  "tokens":_loc1_.tokens,
                  "capacity":_loc1_.capacity
               });
            }
            else
            {
               this.upgradeBtn.toolTip = "";
               this.upgradeBtn.visible = false;
            }
         }
      }
      
      private function updateInventory() : void
      {
         this.updateUpgradeButton();
         if(this.player.fridge_level)
         {
            this.inventoryCapacity.setValueAndMaximum(this.player.numInventoriedItems,this.player.fridge_level.capacity);
         }
      }
      
      private function onBuyItem(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onTrashItem(param1:ServiceEvent) : void
      {
         this._lastThrashedItem = null;
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onUpgradeWithCredits(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = false;
         this.client.service.UpgradeFridge(_loc2_);
         this.upgradeBtn.enabled = false;
         ++this.client.criticalComms;
      }
      
      private function onUpgradeWithTokens(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = true;
         this.client.service.UpgradeFridge(_loc2_);
         this.upgradeBtn.enabled = false;
         ++this.client.criticalComms;
      }
      
      public function onUpgradeClick(param1:MouseEvent) : void
      {
         var _loc2_:FridgeLevel = FridgeLevel.getInstanceByLevel(this.player.fridge_level.level + 1);
         var _loc3_:UpgradeWindow = new UpgradeWindow();
         _loc3_.titleIcon = UIUtils.createBitmapIcon(RanchView.UpgradeIconPng,UIGlobals.relativize(16),UIGlobals.relativize(16));
         _loc3_.credits = _loc2_.credits;
         _loc3_.tokens = _loc2_.tokens;
         _loc3_.addEventListener(UpgradeWindow.USE_CREDITS,this.onUpgradeWithCredits);
         _loc3_.addEventListener(UpgradeWindow.USE_TOKENS,this.onUpgradeWithTokens);
         UIGlobals.popUpManager.addPopUp(_loc3_,UIGlobals.root,true);
         UIGlobals.popUpManager.centerPopUp(_loc3_,null,false);
      }
      
      private function onUpgradeFridge(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onItemDoubleClick(param1:ExtendedEvent) : void
      {
         var _loc2_:ItemInstance = null;
         switch(this.player.area.type)
         {
            case Area.TYPE_RANCH:
               if(this.gameView.ranchView.selectedView)
               {
                  this.gameView.ranchView.selectedView.doUseItem(param1.data as ItemInstance);
               }
               break;
            case Area.TYPE_SHOP:
               if(this.client.tutorialManager.state == TutorialManager.STATE_COMPLETED)
               {
                  this.gameView.shopView.doSellItem(param1.data as ItemInstance);
               }
               break;
            case Area.TYPE_ARENA:
               _loc2_ = param1.data as ItemInstance;
               if((_loc2_.item.type == Item.TYPE_USE && (_loc2_.item.subtype == Item.USE_RESTORE_STAMINA || _loc2_.item.subtype == Item.USE_RESTORE_HEALTH || _loc2_.item.subtype == Item.USE_RESTORE_HAPPINESS) || (_loc2_.item.type == Item.TYPE_PLAY || _loc2_.item.type == Item.TYPE_NURTURE)) && _loc2_.canUseItem(this.gameView.arenaView.creature))
               {
                  this.gameView.arenaView.useItemOnCreature(_loc2_);
               }
               break;
            case Area.TYPE_SAFARI:
               _loc2_ = param1.data as ItemInstance;
               if(_loc2_.item.type == Item.TYPE_BREED && _loc2_.creature.id == 0)
               {
                  this.gameView.safariView.useItemOnSafariPreyCreature(_loc2_);
               }
               if((_loc2_.item.type == Item.TYPE_USE && (_loc2_.item.subtype == Item.USE_RESTORE_STAMINA || _loc2_.item.subtype == Item.USE_RESTORE_HEALTH || _loc2_.item.subtype == Item.USE_RESTORE_HAPPINESS) || (_loc2_.item.type == Item.TYPE_PLAY || _loc2_.item.type == Item.TYPE_NURTURE)) && _loc2_.canUseItem(this.player.safari_creature))
               {
                  this.gameView.safariView.useItemOnSafariCreature(_loc2_);
               }
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "TrashItem")
         {
            this.player.items.addItem(this._lastThrashedItem);
         }
         else if(param1.method == "BuyItem")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "UpgradeFridge")
         {
            --this.client.criticalComms;
         }
      }
      
      public function filterItems(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:ItemInstance = param1 as ItemInstance;
         if(this._filterFlags == 0)
         {
            return true;
         }
         if(Boolean(this._filterFlags & FILTER_FOOD) && _loc4_.item.type == Item.TYPE_FEED)
         {
            return true;
         }
         if(this._filterFlags & FILTER_CARE && (_loc4_.item.type == Item.TYPE_USE || _loc4_.item.type == Item.TYPE_PLAY || _loc4_.item.type == Item.TYPE_NURTURE) && (_loc4_.item.type != Item.TYPE_USE || _loc4_.item.subtype != Item.USE_ACCELERATE_GESTATION && _loc4_.item.subtype != Item.USE_CLONE && _loc4_.item.subtype != Item.USE_SEX_CHANGE))
         {
            return true;
         }
         if(Boolean(this._filterFlags & FILTER_BREED) && (_loc4_.item.type == Item.TYPE_BREED || _loc4_.item.type == Item.TYPE_USE && (_loc4_.item.subtype == Item.USE_ACCELERATE_GESTATION || _loc4_.item.subtype == Item.USE_CLONE || _loc4_.item.subtype == Item.USE_SEX_CHANGE)))
         {
            return true;
         }
         return false;
      }
      
      private function onFiltersChange(param1:ExtendedEvent) : void
      {
         this._filterFlags = param1.data as Number;
         this.player.items.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,null,0));
      }
   }
}
