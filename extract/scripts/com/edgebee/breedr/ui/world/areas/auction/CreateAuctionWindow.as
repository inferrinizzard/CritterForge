package com.edgebee.breedr.ui.world.areas.auction
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
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Bid;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CreateAuctionWindow extends Window
   {
       
      
      public var infoBox:Box;
      
      public var creatureList:TileList;
      
      public var itemList:TileList;
      
      public var bidAmount:TextInput;
      
      public var createAuctionBtn:Button;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function CreateAuctionWindow()
      {
         this._contentLayout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "direction":Box.HORIZONTAL,
            "percentWidth":1,
            "percentHeight":1,
            "filters":UIGlobals.fontOutline,
            "STYLES":{
               "Gap":0,
               "Padding":2
            },
            "CHILDREN":[{
               "CLASS":Box,
               "direction":Box.HORIZONTAL,
               "percentWidth":0.5,
               "STYLES":{"BackgroundAlpha":0.05},
               "CHILDREN":[{
                  "CLASS":TileList,
                  "ID":"creatureList",
                  "filterFunc":filterAuctionnedCreatures,
                  "widthInColumns":2,
                  "heightInRows":2,
                  "renderer":CreatureAuctionView
               },{
                  "CLASS":ScrollBar,
                  "name":"CreateAuctionWindow:CreatureListScrollBar",
                  "percentHeight":1,
                  "scrollable":"{creatureList}"
               }]
            },{
               "CLASS":Box,
               "direction":Box.HORIZONTAL,
               "percentWidth":0.5,
               "STYLES":{"BackgroundAlpha":0.05},
               "CHILDREN":[{
                  "CLASS":TileList,
                  "ID":"itemList",
                  "filterFunc":filterAuctionnedSeeds,
                  "widthInColumns":2,
                  "heightInRows":2,
                  "renderer":ItemAuctionView
               },{
                  "CLASS":ScrollBar,
                  "name":"CreateAuctionWindow:ItemListScrollBar",
                  "percentHeight":1,
                  "scrollable":"{itemList}"
               }]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Label,
            "text":Asset.getInstanceByName("STARTING_BID")
         },{
            "CLASS":TextInput,
            "ID":"bidAmount",
            "restrict":"0-9"
         },{
            "CLASS":Button,
            "ID":"createAuctionBtn",
            "label":Asset.getInstanceByName("CREATE_AUCTION"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onCreateAuctionClick"
            }]
         }];
         super();
         title = Asset.getInstanceByName("CREATE_AUCTION");
         width = UIGlobals.relativize(500);
         height = UIGlobals.relativize(400);
         rememberPositionId = "CreateAuctionWindow";
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.addEventListener("CreateAuction",this.onCreateAuction);
      }
      
      private static function sortBidsDescending(param1:*, param2:*) : int
      {
         var _loc3_:Bid = param1 as Bid;
         var _loc4_:Bid = param2 as Bid;
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
      
      private static function filterAuctionnedCreatures(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:CreatureInstance;
         return (_loc4_ = param1 as CreatureInstance).auction_id == 0 && _loc4_.team_id == 0;
      }
      
      private static function filterAuctionnedSeeds(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:ItemInstance;
         return (_loc4_ = param1 as ItemInstance).item.type == Item.TYPE_BREED && _loc4_.creature.id > 0 && _loc4_.auction_id == 0 && !_loc4_.creature.is_quest;
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
         this.itemList.dataProvider = this.player.items;
         this.itemList.addEventListener(Event.CHANGE,this.onItemSelectionChange);
         this.creatureList.dataProvider = this.player.creatures;
         this.creatureList.addEventListener(Event.CHANGE,this.onCreatureSelectionChange);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      public function onCreateAuctionClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_.starting_bid = Number(this.bidAmount.text);
         if(!_loc2_.starting_bid || isNaN(_loc2_.starting_bid) || _loc2_.starting_bid <= 0)
         {
            return;
         }
         if(this.itemList.selectedItem == null && this.creatureList.selectedItem == null)
         {
            return;
         }
         _loc2_.item_id = 0;
         if(this.itemList.selectedItem)
         {
            _loc2_.item_id = (this.itemList.selectedItem as ItemInstance).id;
         }
         _loc2_.creature_id = 0;
         if(this.creatureList.selectedItem)
         {
            _loc2_.creature_id = (this.creatureList.selectedItem as CreatureInstance).id;
         }
         client.service.CreateAuction(_loc2_);
         ++client.criticalComms;
      }
      
      private function onItemSelectionChange(param1:Event) : void
      {
         if(this.creatureList.selectedItem != null && this.itemList.selectedItem != null)
         {
            this.creatureList.selectedItem = null;
         }
      }
      
      private function onCreatureSelectionChange(param1:Event) : void
      {
         if(this.creatureList.selectedItem != null && this.itemList.selectedItem != null)
         {
            this.itemList.selectedItem = null;
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            this.createAuctionBtn.enabled = client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.method == "CreateAuction")
         {
            --client.criticalComms;
            if(param1.exception.cls == "StartingBidTooLow")
            {
               param1.handled = true;
               _loc2_ = Number(param1.exception.args[0]);
               this.gameView.dialogView.dialog = Dialog.getInstanceByName("auction_starting_bid_too_low");
               this.gameView.dialogView.globalParams = {"min_starting_bid":_loc2_.toString()};
               this.gameView.dialogView.step();
               this.bidAmount.text = _loc2_.toString();
            }
            else if(param1.exception.cls == "TooManyAuctions")
            {
               param1.handled = true;
               _loc3_ = Number(param1.exception.args[0]);
               this.gameView.dialogView.dialog = Dialog.getInstanceByName("auction_too_many_auctions");
               this.gameView.dialogView.globalParams = {"max_auctions":_loc3_.toString()};
               this.gameView.dialogView.step();
               this.doClose();
            }
         }
      }
      
      private function onCreateAuction(param1:ServiceEvent) : void
      {
         visible = false;
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.Listable;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.ui.creature.CreatureView;

class CreatureAuctionView extends Canvas implements Listable
{
    
   
   private var _selected:Boolean = false;
   
   private var _highlighted:Boolean = false;
   
   private var _creature:WeakReference;
   
   public var nameLbl:Label;
   
   public var creatureView:CreatureView;
   
   private var _layout:Array;
   
   public function CreatureAuctionView()
   {
      this._creature = new WeakReference(null,CreatureInstance);
      this._layout = [{
         "CLASS":Box,
         "percentWidth":1,
         "horizontalAlign":Box.ALIGN_CENTER,
         "filters":UIGlobals.fontOutline,
         "CHILDREN":[{
            "CLASS":Label,
            "ID":"nameLbl",
            "STYLES":{"FontSize":UIGlobals.relativize(10)}
         }]
      },{
         "CLASS":CreatureView,
         "ID":"creatureView",
         "width":"{width}",
         "height":"{height}"
      }];
      super();
      width = UIGlobals.relativize(96);
      height = UIGlobals.relativize(96);
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
         this._creature.reset(param1);
         if(childrenCreated)
         {
            this.update();
         }
      }
   }
   
   private function update() : void
   {
      if(this.creature)
      {
         if(this.creature.isEgg)
         {
            this.nameLbl.text = Asset.getInstanceByName("CREATURE_EGG");
         }
         else
         {
            this.nameLbl.text = this.creature.name;
         }
         this.creatureView.creature = this.creature;
      }
      else
      {
         this.nameLbl.text = "";
         this.creatureView.creature = null;
      }
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
   }
}

import com.edgebee.atlas.ui.Listable;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.WeakReference;
import com.edgebee.breedr.Client;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.ui.item.ItemView;

class ItemAuctionView extends Canvas implements Listable
{
    
   
   private var _selected:Boolean = false;
   
   private var _highlighted:Boolean = false;
   
   private var _item:WeakReference;
   
   public var itemView:ItemView;
   
   private var _layout:Array;
   
   public function ItemAuctionView()
   {
      this._item = new WeakReference(null,ItemInstance);
      this._layout = [{
         "CLASS":ItemView,
         "ID":"itemView",
         "percentWidth":1,
         "percentHeight":1,
         "canModifyNote":true
      }];
      super();
      width = UIGlobals.relativize(96);
      height = UIGlobals.relativize(96);
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
      return this.item;
   }
   
   public function set listElement(param1:Object) : void
   {
      this.item = param1 as ItemInstance;
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
   
   public function get item() : ItemInstance
   {
      return this._item.get() as ItemInstance;
   }
   
   public function set item(param1:ItemInstance) : void
   {
      if(this.item != param1)
      {
         this._item.reset(param1);
         if(childrenCreated)
         {
            this.update();
         }
      }
   }
   
   private function update() : void
   {
      if(this.item)
      {
         this.itemView.item = this.item;
      }
      else
      {
         this.itemView.item = null;
      }
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._layout);
   }
}
