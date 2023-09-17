package com.edgebee.breedr.ui.world.areas.auction
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.DelayedCallback;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Auction;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.data.world.NonPlayerCharacter;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AuctionItemView extends Box implements Listable
   {
      
      public static const QUICK_BID_CLICKED:String = "QUICK_BID";
      
      public static const DETAILS_CLICKED:String = "DETAILS_CLICKED";
       
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _auction:WeakReference;
      
      private var _mouseDown:Boolean = false;
      
      public var nameLbl:Label;
      
      public var timeLeftLbl:Label;
      
      public var currentBidBox:Box;
      
      public var currentBidLbl:Label;
      
      public var quickBidBtn:Button;
      
      public var detailsBtn:Button;
      
      private var pendingQuickBidSingleClick:Boolean = false;
      
      private var doubleClickWarnCallback:DelayedCallback;
      
      private var _layout:Array;
      
      public function AuctionItemView()
      {
         this._auction = new WeakReference(null,Auction);
         this._layout = [{
            "CLASS":Label,
            "ID":"nameLbl",
            "percentWidth":0.5,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Label,
            "ID":"timeLeftLbl",
            "percentWidth":0.2,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Box,
            "ID":"currentBidBox",
            "verticalAlign":Box.ALIGN_MIDDLE,
            "percentWidth":0.3,
            "horizontalAlign":Box.ALIGN_CENTER,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"currentBidLbl",
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":Spacer,
               "width":3
            },{
               "CLASS":BitmapComponent,
               "width":UIGlobals.relativize(16),
               "height":UIGlobals.relativize(16),
               "source":ControlBar.CreditsIconPng
            }]
         },{
            "CLASS":Button,
            "ID":"quickBidBtn",
            "label":Asset.getInstanceByName("QUICK_BID"),
            "doubleClickEnabled":true,
            "STYLES":{
               "Skin":LinkButtonSkin,
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onQuickBidClick"
            },{
               "TYPE":MouseEvent.DOUBLE_CLICK,
               "LISTENER":"onQuickBidDbClick"
            }]
         },{
            "CLASS":Button,
            "ID":"detailsBtn",
            "label":Asset.getInstanceByName("DETAILS"),
            "STYLES":{
               "Skin":LinkButtonSkin,
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            },
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onDetailsClick"
            }]
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         useMouseScreen = true;
         percentWidth = 1;
         filters = UIGlobals.fontSmallOutline;
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
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
         return this.auction;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.auction = param1 as Auction;
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
      
      private function onAuctionChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            this.update();
         }
      }
      
      private function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         if(Boolean(this.auction) && Boolean(this.nameLbl))
         {
            visible = true;
            this.nameLbl.text = this.auction.shortName;
            _loc1_ = int(this.auction.closing_date.time - new Date().time) / 1000;
            _loc2_ = false;
            if(_loc1_ < 0)
            {
               _loc2_ = true;
            }
            this.timeLeftLbl.text = Utils.secondsToDelta(_loc1_);
            this.currentBidLbl.text = this.auction.currentBidAmount.toString();
            this.quickBidBtn.enabled = !_loc2_ && this.client.criticalComms == 0 && (!this.auction.lastBid || this.auction.lastBid.player.id != this.auction.player.id) && this.auction.currentBidAmount + this.auction.quickBidAmount <= this.player.credits;
            this.quickBidBtn.toolTip = Utils.formatString(Asset.getInstanceByName("QUICK_BID_TIP").value,{
               "net":(this.auction.currentBidAmount + this.auction.quickBidAmount).toString(),
               "amount":this.auction.quickBidAmount.toString()
            });
         }
         else
         {
            visible = false;
         }
      }
      
      private function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function onQuickBidClick(param1:MouseEvent) : void
      {
         this.pendingQuickBidSingleClick = true;
         this.doubleClickWarnCallback = new DelayedCallback(300,this.doubleClickWarn);
         this.doubleClickWarnCallback.touch();
      }
      
      private function doubleClickWarn() : void
      {
         if(this.pendingQuickBidSingleClick)
         {
            this.gameView.dialogView.dialog = Dialog.getInstanceByName("auction_quick_bid_dbclick");
            this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
            this.gameView.dialogView.step();
         }
      }
      
      private function onDialogComplete(param1:Event) : void
      {
         this.gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
         this.gameView.npcView.setNpcAndExpression(this.player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      }
      
      public function onQuickBidDbClick(param1:MouseEvent) : void
      {
         this.pendingQuickBidSingleClick = false;
         dispatchEvent(new ExtendedEvent(QUICK_BID_CLICKED,this.auction,true));
      }
      
      public function onDetailsClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(DETAILS_CLICKED,this.auction,true));
      }
   }
}
