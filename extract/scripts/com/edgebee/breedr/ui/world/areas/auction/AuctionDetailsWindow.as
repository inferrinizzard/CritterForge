package com.edgebee.breedr.ui.world.areas.auction
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Auction;
   import com.edgebee.breedr.data.world.Bid;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.item.ItemView;
   import flash.events.MouseEvent;
   
   public class AuctionDetailsWindow extends Window
   {
       
      
      private var _auction:WeakReference;
      
      public var infoBox:Box;
      
      public var creatureView:CreatureView;
      
      public var itemView:ItemView;
      
      public var timeLeftLbl:Label;
      
      public var bidList:List;
      
      public var bidAmount:TextInput;
      
      public var startingBidLbl:Label;
      
      public var creatorLbl:PlayerLabel;
      
      public var bidBtn:Button;
      
      public var creatureInfoLbl:Label;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function AuctionDetailsWindow()
      {
         this._auction = new WeakReference(null,Auction);
         this._contentLayout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "direction":Box.VERTICAL,
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
               "verticalAlign":Box.ALIGN_MIDDLE,
               "horizontalAlign":Box.ALIGN_CENTER,
               "layoutInvisibleChildren":false,
               "CHILDREN":[{
                  "CLASS":CreatureView,
                  "ID":"creatureView",
                  "visible":false,
                  "width":UIGlobals.relativize(196),
                  "height":UIGlobals.relativize(196)
               },{
                  "CLASS":ItemView,
                  "ID":"itemView",
                  "visible":false,
                  "canModifyNote":false,
                  "filters":UIGlobals.fontOutline,
                  "width":UIGlobals.relativize(196),
                  "height":UIGlobals.relativize(196)
               }]
            },{
               "CLASS":Label,
               "ID":"creatureInfoLbl",
               "filters":UIGlobals.fontOutline,
               "text":Asset.getInstanceByName("AUCTION_DCLICK_CREATURE_FOR_MORE"),
               "visible":false,
               "STYLES":{
                  "FontStyle":"italic",
                  "FontSize":UIGlobals.relativizeFont(12),
                  "FontColor":16776960
               }
            },{
               "CLASS":Box,
               "filters":UIGlobals.fontOutline,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "percentWidth":0.4,
                  "text":Asset.getInstanceByName("CREATOR"),
                  "STYLES":{"FontColor":16777215}
               },{
                  "CLASS":PlayerLabel,
                  "percentWidth":0.6,
                  "ID":"creatorLbl",
                  "STYLES":{
                     "FontColor":16777215,
                     "FontWeight":"bold"
                  }
               }]
            },{
               "CLASS":Box,
               "filters":UIGlobals.fontOutline,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "percentWidth":0.4,
                  "text":Asset.getInstanceByName("STARTING_BID"),
                  "STYLES":{"FontColor":16777215}
               },{
                  "CLASS":Label,
                  "percentWidth":0.6,
                  "ID":"startingBidLbl",
                  "STYLES":{
                     "FontColor":16777215,
                     "FontWeight":"bold"
                  }
               }]
            },{
               "CLASS":Box,
               "filters":UIGlobals.fontOutline,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":Label,
                  "percentWidth":0.4,
                  "text":Asset.getInstanceByName("TIME_LEFT"),
                  "STYLES":{"FontColor":16777215}
               },{
                  "CLASS":Label,
                  "percentWidth":0.6,
                  "ID":"timeLeftLbl",
                  "STYLES":{
                     "FontColor":16777215,
                     "FontWeight":"bold"
                  }
               }]
            },{
               "CLASS":Box,
               "filters":UIGlobals.fontOutline,
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "STYLES":{"BackgroundAlpha":0.05},
               "CHILDREN":[{
                  "CLASS":List,
                  "ID":"bidList",
                  "selectable":false,
                  "highlightable":false,
                  "sortFunc":sortBidsDescending,
                  "animated":false,
                  "percentWidth":1,
                  "percentHeight":1,
                  "renderer":BidView
               },{
                  "CLASS":ScrollBar,
                  "name":"AuctionDetailsWindow:BidScrollBar",
                  "percentHeight":1,
                  "scrollable":"{bidList}"
               }]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Label,
            "text":Asset.getInstanceByName("BID_AMOUNT")
         },{
            "CLASS":TextInput,
            "ID":"bidAmount",
            "restrict":"0-9"
         },{
            "CLASS":Button,
            "ID":"bidBtn",
            "label":Asset.getInstanceByName("SUBMIT"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onSubmitBidClick
            }]
         }];
         super();
         width = UIGlobals.relativize(400);
         height = UIGlobals.relativize(560);
         rememberPositionId = "AuctionDetailsWindow";
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
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
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get auction() : Auction
      {
         return this._auction.get() as Auction;
      }
      
      public function set auction(param1:Auction) : void
      {
         if(this.auction != param1)
         {
            if(this.auction)
            {
               this.auction.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onAuctionChange);
            }
            this._auction.reset(param1);
            if(this.auction)
            {
               this.auction.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onAuctionChange);
            }
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
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.creatureView.doubleClickEnabled = true;
         this.creatureView.addEventListener(MouseEvent.DOUBLE_CLICK,this.onCreatureDoubleClick);
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.bidBtn))
         {
            this.bidBtn.enabled = client.criticalComms == 0;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onAuctionChange(param1:PropertyChangeEvent) : void
      {
         this.update(param1.property);
      }
      
      private function onSubmitBidClick(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = Number(this.bidAmount.text);
         if(_loc2_ > this.auction.currentBidAmount && this.player.credits >= _loc2_)
         {
            _loc3_ = client.createInput();
            _loc3_.auction_id = this.auction.id;
            _loc3_.amount = _loc2_;
            client.service.MakeBid(_loc3_);
            ++client.criticalComms;
         }
      }
      
      private function onCreatureDoubleClick(param1:MouseEvent) : void
      {
         this.gameView.statusWindow.stall = null;
         this.gameView.statusWindow.creature = this.auction.creature;
         this.gameView.statusWindow.locked = true;
         this.gameView.statusWindow.visible = true;
      }
      
      private function update(param1:String = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         if(this.auction)
         {
            title = this.auction.shortName;
            this.creatureView.creature = this.auction.creature.id > 0 ? this.auction.creature : null;
            this.creatureView.visible = this.creatureView.creature != null;
            this.creatureInfoLbl.visible = this.creatureView.creature != null;
            this.itemView.item = this.auction.item.id > 0 ? this.auction.item : null;
            this.itemView.visible = this.itemView.item != null;
            this.bidList.dataProvider = this.auction.bids;
            this.creatorLbl.player = this.auction.player;
            this.startingBidLbl.text = this.auction.starting_bid.toString();
            statusBar.enabled = Boolean(this.auction.lastBid) && this.player.credits > this.auction.lastBid.amount || this.player.credits > this.auction.starting_bid;
            _loc2_ = int(this.auction.closing_date.time - new Date().time) / 1000;
            _loc3_ = false;
            if(_loc2_ < 0)
            {
               this.timeLeftLbl.text = Asset.getInstanceByName("EXPIRED");
               _loc3_ = true;
            }
            else if(_loc2_ >= 3600 * 24 * 2)
            {
               this.timeLeftLbl.text = uint(_loc2_ / (3600 * 24)).toString() + " " + Asset.getInstanceByName("DAYS").value;
            }
            else if(_loc2_ >= 3600 * 2)
            {
               this.timeLeftLbl.text = uint(_loc2_ / 3600).toString() + " " + Asset.getInstanceByName("HOURS").value;
            }
            else if(_loc2_ >= 60 * 2)
            {
               this.timeLeftLbl.text = uint(_loc2_ / 60).toString() + " " + Asset.getInstanceByName("MINUTES").value;
            }
            else
            {
               this.timeLeftLbl.text = uint(_loc2_).toString() + " " + Asset.getInstanceByName("SECONDS").value;
            }
         }
      }
   }
}
