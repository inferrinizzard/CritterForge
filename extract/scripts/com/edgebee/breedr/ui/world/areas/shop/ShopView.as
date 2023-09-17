package com.edgebee.breedr.ui.world.areas.shop
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.data.world.NonPlayerCharacter;
   import com.edgebee.breedr.managers.TutorialManager;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import flash.events.Event;
   
   public class ShopView extends Box
   {
      
      public static const STALLS_VIEW:uint = 0;
      
      public static const FEEDER_VIEW:uint = 1;
      
      public static const NURTURE_VIEW:uint = 2;
      
      public static const BREED_VIEW:uint = 3;
      
      public static const FILTER_FOOD:Number = 1;
      
      public static const FILTER_PLAY:Number = 2;
      
      public static const FILTER_NURTURE:Number = 4;
      
      public static const FILTER_BREED:Number = 8;
      
      public static const FILTER_USE:Number = 16;
       
      
      public var shopBox:Box;
      
      public var shopList:TileList;
      
      public var shopListScrollBar:ScrollBar;
      
      public var filtersBox:Box;
      
      public var foodFilterBtn:RadioButton;
      
      public var playFilterBtn:RadioButton;
      
      public var nurtureFilterBtn:RadioButton;
      
      public var breedFilterBtn:RadioButton;
      
      public var useFilterBtn:RadioButton;
      
      public var bg:TransparentWindow;
      
      private var _filterGroup:RadioButtonGroup;
      
      private var _firstPanelChange:Boolean = true;
      
      private var _filterFlags:Number;
      
      private var _layout:Array;
      
      public function ShopView()
      {
         this._layout = [{
            "CLASS":Box,
            "ID":"shopBox",
            "name":"ShopView",
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(450),
            "STYLES":{"Padding":UIGlobals.relativize(12)},
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(450),
               "includeInLayout":false
            },{
               "CLASS":Box,
               "CHILDREN":[{
                  "CLASS":TileList,
                  "ID":"shopList",
                  "filterFunc":"{filterItems}",
                  "widthInColumns":2,
                  "percentHeight":0.95,
                  "direction":TileList.VERTICAL,
                  "renderer":ShopItemView,
                  "selectable":false
               },{
                  "CLASS":ScrollBar,
                  "ID":"shopListScrollBar",
                  "name":"ShopView:ShopItemsScrollBar",
                  "percentHeight":0.95,
                  "scrollable":"{shopList}"
               }]
            },{
               "CLASS":Box,
               "ID":"filtersBox",
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "STYLES":{
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12),
                  "Gap":UIGlobals.relativize(6)
               },
               "CHILDREN":[{
                  "CLASS":RadioButton,
                  "ID":"foodFilterBtn",
                  "label":Asset.getInstanceByName("FEED"),
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "PaddingLeft":4,
                     "PaddingRight":4
                  },
                  "userData":FILTER_FOOD
               },{
                  "CLASS":RadioButton,
                  "ID":"useFilterBtn",
                  "label":Asset.getInstanceByName("USABLES"),
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "PaddingLeft":4,
                     "PaddingRight":4
                  },
                  "userData":FILTER_USE
               },{
                  "CLASS":RadioButton,
                  "ID":"playFilterBtn",
                  "label":Asset.getInstanceByName("TOYS"),
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "PaddingLeft":4,
                     "PaddingRight":4
                  },
                  "userData":FILTER_PLAY
               },{
                  "CLASS":RadioButton,
                  "ID":"nurtureFilterBtn",
                  "label":Asset.getInstanceByName("NURTURE"),
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "PaddingLeft":4,
                     "PaddingRight":4
                  },
                  "userData":FILTER_NURTURE
               },{
                  "CLASS":RadioButton,
                  "ID":"breedFilterBtn",
                  "label":Asset.getInstanceByName("BREEDING"),
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "PaddingLeft":4,
                     "PaddingRight":4
                  },
                  "userData":FILTER_BREED
               }]
            }]
         }];
         super(Box.VERTICAL);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("SellItem",this.onSellItem);
         setStyle("Gap",UIGlobals.relativize(10));
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
         this._filterGroup = new RadioButtonGroup();
         this._filterGroup.addButton(this.foodFilterBtn);
         this._filterGroup.addButton(this.useFilterBtn);
         this._filterGroup.addButton(this.playFilterBtn);
         this._filterGroup.addButton(this.nurtureFilterBtn);
         this._filterGroup.addButton(this.breedFilterBtn);
         this._filterGroup.addEventListener(Event.CHANGE,this.onPanelChange);
         this._filterGroup.selected = this.foodFilterBtn;
         this._filterFlags = FILTER_FOOD;
         if(this.player.area.type == Area.TYPE_SHOP)
         {
            this.shopList.dataProvider = this.player.area.items;
         }
         this.shopBox.addEventListener(DragEvent.DRAG_ENTER,this.onShopDragEnter);
         this.shopBox.addEventListener(DragEvent.DRAG_EXIT,this.onShopDragExit);
         this.shopBox.addEventListener(DragEvent.DRAG_DROP,this.onShopDragDrop);
         this.shopList.addEventListener(ShopItemView.ITEM_DOUBLE_CLICKED,this.onShopItemDoubleClick);
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
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(this.shopList)
            {
               if(this.player.area.type == Area.TYPE_SHOP)
               {
                  this.shopList.dataProvider = this.player.area.items;
               }
               else
               {
                  this.shopList.dataProvider = null;
               }
            }
         }
      }
      
      private function onShopDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.tutorialManager.currentTutorial)
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            UIGlobals.dragManager.acceptDragDrop(this.shopBox);
         }
      }
      
      private function onShopDragExit(param1:DragEvent) : void
      {
      }
      
      private function onShopDragDrop(param1:DragEvent) : void
      {
         if(param1.dragInfo.hasOwnProperty("item") && !this.client.criticalComms)
         {
            this.doSellItem(param1.dragInfo.item);
         }
      }
      
      private function onSellConfirm(param1:Event) : void
      {
         var _loc2_:ItemInstance = (param1.currentTarget as AlertWindow).extraData as ItemInstance;
         var _loc3_:Object = this.client.createInput();
         _loc3_.item_id = _loc2_.id;
         this.client.service.SellItem(_loc3_);
         ++this.client.criticalComms;
      }
      
      private function onSellCancel(param1:Event) : void
      {
      }
      
      public function doSellItem(param1:ItemInstance) : void
      {
         var _loc2_:AlertWindow = null;
         var _loc3_:Object = null;
         if(this.client.criticalComms > 0)
         {
            return;
         }
         if(param1.auction_id > 0)
         {
            return;
         }
         if(param1.item.credits <= 0)
         {
            return;
         }
         if(param1.item.type == Item.TYPE_BREED || param1.item.type == Item.TYPE_USE)
         {
            _loc2_ = AlertWindow.show(Utils.formatString(Asset.getInstanceByName("ITEM_SELL_CONFIRMATION").value,{
               "item":param1.item.name.value,
               "credits":param1.sellPrice.toString()
            }),Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
               "ALERT_WINDOW_YES":this.onSellConfirm,
               "ALERT_WINDOW_NO":this.onSellCancel
            },false,false,true,true,false,false,AlertWindow.WarningIconPng);
            _loc2_.extraData = param1;
         }
         else
         {
            _loc3_ = this.client.createInput();
            _loc3_.item_id = param1.id;
            this.client.service.SellItem(_loc3_);
            ++this.client.criticalComms;
         }
      }
      
      private function onSellItem(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onShopItemDoubleClick(param1:ExtendedEvent) : void
      {
         this.gameView.inventoryView.doBuyItem(param1.data as Item);
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SellItem")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onPanelChange(param1:ExtendedEvent) : void
      {
         this._filterFlags = param1.data as Number;
         this.player.area.items.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,null,0));
         if(!this.gameView.fadeInInstance.playing && !this._firstPanelChange && this.client.tutorialManager.state == TutorialManager.STATE_COMPLETED)
         {
            switch(this._filterFlags)
            {
               case FILTER_FOOD:
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_select_feed");
                  this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
                  this.gameView.dialogView.step();
                  break;
               case FILTER_PLAY:
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_select_play");
                  this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
                  this.gameView.dialogView.step();
                  break;
               case FILTER_NURTURE:
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_select_nurture");
                  this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
                  this.gameView.dialogView.step();
                  break;
               case FILTER_BREED:
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_select_breed");
                  this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
                  this.gameView.dialogView.step();
                  break;
               case FILTER_USE:
                  this.gameView.dialogView.dialog = Dialog.getInstanceByName("shop_select_usables");
                  this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
                  this.gameView.dialogView.step();
            }
         }
         this._firstPanelChange = false;
      }
      
      private function onDialogComplete(param1:Event) : void
      {
         this.gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
         this.gameView.npcView.setNpcAndExpression(this.player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      }
      
      public function filterItems(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:Item = param1 as Item;
         if(Boolean(this._filterFlags & FILTER_FOOD) && _loc4_.type == Item.TYPE_FEED)
         {
            return true;
         }
         if(Boolean(this._filterFlags & FILTER_PLAY) && _loc4_.type == Item.TYPE_PLAY)
         {
            return true;
         }
         if(Boolean(this._filterFlags & FILTER_NURTURE) && _loc4_.type == Item.TYPE_NURTURE)
         {
            return true;
         }
         if(Boolean(this._filterFlags & FILTER_BREED) && (_loc4_.type == Item.TYPE_BREED || _loc4_.type == Item.TYPE_USE && (_loc4_.subtype == Item.USE_ACCELERATE_GESTATION || _loc4_.subtype == Item.USE_CLONE || _loc4_.subtype == Item.USE_SEX_CHANGE || _loc4_.subtype == Item.USE_RESTORE_SEEDS)))
         {
            return true;
         }
         if(this._filterFlags & FILTER_USE && _loc4_.type == Item.TYPE_USE && _loc4_.subtype != Item.USE_ACCELERATE_GESTATION && _loc4_.subtype != Item.USE_CLONE && _loc4_.subtype != Item.USE_SEX_CHANGE && _loc4_.subtype != Item.USE_RESTORE_SEEDS)
         {
            return true;
         }
         return false;
      }
   }
}
