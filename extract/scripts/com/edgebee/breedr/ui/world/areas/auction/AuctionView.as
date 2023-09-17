package com.edgebee.breedr.ui.world.areas.auction
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.ToggleButton;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.Creature;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Auction;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AuctionView extends Canvas
   {
      
      public static const BirdIconPng:Class = AuctionView_BirdIconPng;
      
      public static const FishIconPng:Class = AuctionView_FishIconPng;
      
      public static const LizardIconPng:Class = AuctionView_LizardIconPng;
      
      public static const MothIconPng:Class = AuctionView_MothIconPng;
      
      public static const WolfIconPng:Class = AuctionView_WolfIconPng;
      
      public static const CrustaceanIconPng:Class = AuctionView_CrustaceanIconPng;
      
      public static const OwlbearIconPng:Class = AuctionView_OwlbearIconPng;
      
      public static const RaptorIconPng:Class = AuctionView_RaptorIconPng;
      
      public static const SpiderIconPng:Class = AuctionView_SpiderIconPng;
      
      public static const ToadIconPng:Class = AuctionView_ToadIconPng;
      
      public static const CalamariIconPng:Class = AuctionView_CalamariIconPng;
      
      public static const CrocodileIconPng:Class = AuctionView_CrocodileIconPng;
      
      public static const HornetIconPng:Class = AuctionView_HornetIconPng;
      
      public static const MammothIconPng:Class = AuctionView_MammothIconPng;
      
      public static const WalrusIconPng:Class = AuctionView_WalrusIconPng;
      
      public static const DragonIconPng:Class = AuctionView_DragonIconPng;
      
      public static const GorillaIconPng:Class = AuctionView_GorillaIconPng;
      
      public static const HydraIconPng:Class = AuctionView_HydraIconPng;
      
      public static const MantisIconPng:Class = AuctionView_MantisIconPng;
      
      public static const TortoiseIconPng:Class = AuctionView_TortoiseIconPng;
      
      public static const BeholderIconPng:Class = AuctionView_BeholderIconPng;
      
      public static const CerberusIconPng:Class = AuctionView_CerberusIconPng;
      
      public static const LionIconPng:Class = AuctionView_LionIconPng;
      
      public static const SteedIconPng:Class = AuctionView_SteedIconPng;
      
      public static const WyrmIconPng:Class = AuctionView_WyrmIconPng;
      
      public static const EggIconPng:Class = AuctionView_EggIconPng;
      
      public static const FILTER_BIRD:int = 1;
      
      public static const FILTER_FISH:int = 2;
      
      public static const FILTER_LIZARD:int = 4;
      
      public static const FILTER_MOTH:int = 8;
      
      public static const FILTER_WOLF:int = 16;
      
      public static const FILTER_CRUSTACEAN:int = 32;
      
      public static const FILTER_OWLBEAR:int = 64;
      
      public static const FILTER_RAPTOR:int = 128;
      
      public static const FILTER_SPIDER:int = 256;
      
      public static const FILTER_TOAD:int = 512;
      
      public static const FILTER_CALAMARI:int = 1024;
      
      public static const FILTER_CROCODILE:int = 2048;
      
      public static const FILTER_HORNET:int = 4096;
      
      public static const FILTER_MAMMOTH:int = 8192;
      
      public static const FILTER_WALRUS:int = 16384;
      
      public static const FILTER_STEED:int = 32768;
      
      public static const FILTER_DRAGON:int = 65536;
      
      public static const FILTER_GORILLA:int = 131072;
      
      public static const FILTER_HYDRA:int = 262144;
      
      public static const FILTER_MANTIS:int = 524288;
      
      public static const FILTER_TORTOISE:int = 1048576;
      
      public static const FILTER_LION:int = 2097152;
      
      public static const FILTER_WYRM:int = 4194304;
      
      public static const FILTER_CERBERUS:int = 8388608;
      
      public static const FILTER_BEHOLDER:int = 16777216;
      
      public static const FILTER_EGG:int = 33554432;
      
      private static const _filterButtons:Array = ["birdFilterBtn","fishFilterBtn","lizardFilterBtn","mothFilterBtn","wolfFilterBtn","crustaceanFilterBtn","owlbearFilterBtn","raptorFilterBtn","spiderFilterBtn","toadFilterBtn","calamariFilterBtn","crocodileFilterBtn","hornetFilterBtn","mammothFilterBtn","walrusFilterBtn","steedFilterBtn","dragonFilterBtn","gorillaFilterBtn","hydraFilterBtn","mantisFilterBtn","tortoiseFilterBtn","lionFilterBtn","wyrmFilterBtn","cerberusFilterBtn","beholderFilterBtn","eggFilterBtn"];
      
      private static const _filterIcons:Array = [BirdIconPng,FishIconPng,LizardIconPng,MothIconPng,WolfIconPng,CrustaceanIconPng,OwlbearIconPng,RaptorIconPng,SpiderIconPng,ToadIconPng,CalamariIconPng,CrocodileIconPng,HornetIconPng,MammothIconPng,WalrusIconPng,SteedIconPng,DragonIconPng,GorillaIconPng,HydraIconPng,MantisIconPng,TortoiseIconPng,LionIconPng,WyrmIconPng,CerberusIconPng,BeholderIconPng,EggIconPng];
      
      private static const _filterTips:Array = ["CREATURE_BIRD_NAME","CREATURE_FISH_NAME","CREATURE_LIZARD_NAME","CREATURE_MOTH_NAME","CREATURE_WOLF_NAME","CREATURE_CRUSTACEAN_NAME","CREATURE_OWLBEAR_NAME","CREATURE_RAPTOR_NAME","CREATURE_SPIDER_NAME","CREATURE_toad_NAME","CREATURE_CALAMARI_NAME","CREATURE_CROCODILE_NAME","CREATURE_HORNET_NAME","CREATURE_MAMMOTH_NAME","CREATURE_walrus_NAME","CREATURE_STEED_NAME","CREATURE_DRAGON_NAME","CREATURE_GORILLA_NAME","CREATURE_HYDRA_NAME","CREATURE_MANTIS_NAME","CREATURE_tortoise_NAME","CREATURE_LION_NAME","CREATURE_WYRM_NAME","CREATURE_CERBERUS_NAME","CREATURE_BEHOLDER_NAME","CREATURE_EGG"];
      
      private static const SEARCH_RESULT_LENGTH:uint = 8;
      
      private static const LATEST:String = "LATEST";
      
      private static const OLDEST:String = "OLDEST";
      
      private static const OWNED:String = "OWNED";
      
      private static const BIDS:String = "BIDS";
      
      private static const SEARCH:String = "SEARCH";
       
      
      public var ownedAuctionsArr:DataArray;
      
      public var bidsAuctionsArr:DataArray;
      
      public var allSearchAuctionsArr:DataArray;
      
      public var searchAuctionsArr:DataArray;
      
      public var auctionBox:Box;
      
      public var auctionList:TileList;
      
      public var bg:TransparentWindow;
      
      public var panelsBox:Box;
      
      private var _panelsGroup:RadioButtonGroup;
      
      public var ownedBtn:RadioButton;
      
      public var bidsBtn:RadioButton;
      
      private var _searchOrderGroup:RadioButtonGroup;
      
      public var orderByLatestBtn:RadioButton;
      
      public var orderByOldestBtn:RadioButton;
      
      public var doSearchBtn:Button;
      
      public var searchPreviousBtn:Button;
      
      public var searchNextBtn:Button;
      
      private var _maxOffset:uint = 0;
      
      private var _currentOffset:uint = 0;
      
      private var _allSearchesDone:Boolean = false;
      
      public var filtersBox1:Box;
      
      public var filtersBox2:Box;
      
      public var birdFilterBtn:ToggleButton;
      
      public var fishFilterBtn:ToggleButton;
      
      public var lizardFilterBtn:ToggleButton;
      
      public var mothFilterBtn:ToggleButton;
      
      public var wolfFilterBtn:ToggleButton;
      
      public var crustaceanFilterBtn:ToggleButton;
      
      public var owlbearFilterBtn:ToggleButton;
      
      public var raptorFilterBtn:ToggleButton;
      
      public var spiderFilterBtn:ToggleButton;
      
      public var toadFilterBtn:ToggleButton;
      
      public var calamariFilterBtn:ToggleButton;
      
      public var crocodileFilterBtn:ToggleButton;
      
      public var hornetFilterBtn:ToggleButton;
      
      public var mammothFilterBtn:ToggleButton;
      
      public var walrusFilterBtn:ToggleButton;
      
      public var dragonFilterBtn:ToggleButton;
      
      public var gorillaFilterBtn:ToggleButton;
      
      public var hydraFilterBtn:ToggleButton;
      
      public var mantisFilterBtn:ToggleButton;
      
      public var tortoiseFilterBtn:ToggleButton;
      
      public var beholderFilterBtn:ToggleButton;
      
      public var cerberusFilterBtn:ToggleButton;
      
      public var lionFilterBtn:ToggleButton;
      
      public var steedFilterBtn:ToggleButton;
      
      public var wyrmFilterBtn:ToggleButton;
      
      public var eggFilterBtn:ToggleButton;
      
      public var createAuctionBtn:Button;
      
      private var _detailsWindow:com.edgebee.breedr.ui.world.areas.auction.AuctionDetailsWindow;
      
      private var _createWindow:com.edgebee.breedr.ui.world.areas.auction.CreateAuctionWindow;
      
      private var _initialFetch:Boolean = false;
      
      private var _layout:Array;
      
      public function AuctionView()
      {
         this.ownedAuctionsArr = new DataArray(Auction.classinfo);
         this.bidsAuctionsArr = new DataArray(Auction.classinfo);
         this.allSearchAuctionsArr = new DataArray(Auction.classinfo);
         this.searchAuctionsArr = new DataArray(Auction.classinfo);
         this._layout = [{
            "CLASS":Box,
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(500),
            "direction":Box.VERTICAL,
            "STYLES":{"Padding":UIGlobals.relativize(12)},
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(500),
               "includeInLayout":false
            },{
               "CLASS":Box,
               "ID":"auctionBox",
               "CHILDREN":[{
                  "CLASS":List,
                  "ID":"auctionList",
                  "percentHeight":1,
                  "percentWidth":1,
                  "filterFunc":filterAuctions,
                  "animated":false,
                  "renderer":AuctionItemView,
                  "STYLES":{"BackgroundAlpha":0.15}
               },{
                  "CLASS":ScrollBar,
                  "name":"AuctionView:AuctionItemScrollBar",
                  "percentHeight":1,
                  "scrollable":"{auctionList}"
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(3)
            },{
               "CLASS":Box,
               "percentWidth":1,
               "name":"AuctionSearchBox",
               "direction":Box.VERTICAL,
               "CHILDREN":[{
                  "CLASS":Box,
                  "ID":"filtersBox1",
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "STYLES":{"Gap":3}
               },{
                  "CLASS":Spacer,
                  "height":2
               },{
                  "CLASS":Box,
                  "ID":"filtersBox2",
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "STYLES":{"Gap":3}
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(5)
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "STYLES":{"Gap":UIGlobals.relativize(5)},
                  "CHILDREN":[{
                     "CLASS":Label,
                     "text":"Order by"
                  },{
                     "CLASS":Box,
                     "direction":Box.VERTICAL,
                     "autoSizeChildren":true,
                     "CHILDREN":[{
                        "CLASS":RadioButton,
                        "ID":"orderByLatestBtn",
                        "label":Asset.getInstanceByName("NEWEST"),
                        "userData":LATEST,
                        "STYLES":{
                           "FontColor":0,
                           "FontSize":UIGlobals.relativizeFont(13),
                           "Skin":BreedrButtonSkin
                        }
                     },{
                        "CLASS":RadioButton,
                        "ID":"orderByOldestBtn",
                        "label":Asset.getInstanceByName("OLDEST"),
                        "userData":OLDEST,
                        "STYLES":{
                           "FontColor":0,
                           "FontSize":UIGlobals.relativizeFont(13),
                           "Skin":BreedrButtonSkin
                        }
                     }]
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativizeX(10)
                  },{
                     "CLASS":Button,
                     "ID":"doSearchBtn",
                     "label":Asset.getInstanceByName("SEARCH"),
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":"onSearchClick"
                     }]
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativizeX(10)
                  },{
                     "CLASS":Button,
                     "ID":"searchPreviousBtn",
                     "label":Asset.getInstanceByName("BACK"),
                     "enabled":false,
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":"onSearchPreviousClick"
                     }]
                  },{
                     "CLASS":Button,
                     "ID":"searchNextBtn",
                     "label":Asset.getInstanceByName("NEXT"),
                     "enabled":false,
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":"onSearchNextClick"
                     }]
                  }]
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(5)
            },{
               "CLASS":Box,
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "STYLES":{
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12)
               },
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"createAuctionBtn",
                  "name":"AuctionCreateButton",
                  "label":Asset.getInstanceByName("CREATE_AUCTION"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onCreateAuctionClick"
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":0.5
               },{
                  "CLASS":Button,
                  "label":Asset.getInstanceByName("REFRESH"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onRefreshClick"
                  }]
               },{
                  "CLASS":Spacer,
                  "percentWidth":0.5
               },{
                  "CLASS":RadioButton,
                  "ID":"ownedBtn",
                  "name":"AuctionOwnedTab",
                  "label":Asset.getInstanceByName("MY_AUCTIONS"),
                  "userData":OWNED,
                  "STYLES":{
                     "FontColor":0,
                     "FontSize":UIGlobals.relativizeFont(13),
                     "Skin":BreedrButtonSkin
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"bidsBtn",
                  "name":"AuctionBidsTab",
                  "label":Asset.getInstanceByName("MY_BIDS"),
                  "userData":BIDS,
                  "STYLES":{
                     "FontColor":0,
                     "FontSize":UIGlobals.relativizeFont(13),
                     "Skin":BreedrButtonSkin
                  }
               }]
            }]
         }];
         super();
         this.client.service.addEventListener("GetAuctions",this.onGetAuctions);
         this.client.service.addEventListener("MakeBid",this.onMakeBid);
         this.client.service.addEventListener("SearchAuctions",this.onSearchAuctions);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      }
      
      private static function filterAuctions(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:Auction = param1 as Auction;
         if(new Date().time >= _loc4_.closing_date.time)
         {
            return false;
         }
         var _loc5_:Client = UIGlobals.root.client as Client;
         switch(_loc4_.codeName)
         {
            case "bird":
               return Boolean(_loc5_.auctionFilters & FILTER_BIRD);
            case "fish":
               return Boolean(_loc5_.auctionFilters & FILTER_FISH);
            case "lizard":
               return Boolean(_loc5_.auctionFilters & FILTER_LIZARD);
            case "moth":
               return Boolean(_loc5_.auctionFilters & FILTER_MOTH);
            case "wolf":
               return Boolean(_loc5_.auctionFilters & FILTER_WOLF);
            case "crustacean":
               return Boolean(_loc5_.auctionFilters & FILTER_CRUSTACEAN);
            case "owlbear":
               return Boolean(_loc5_.auctionFilters & FILTER_OWLBEAR);
            case "raptor":
               return Boolean(_loc5_.auctionFilters & FILTER_RAPTOR);
            case "spider":
               return Boolean(_loc5_.auctionFilters & FILTER_SPIDER);
            case "toad":
               return Boolean(_loc5_.auctionFilters & FILTER_TOAD);
            case "calamari":
               return Boolean(_loc5_.auctionFilters & FILTER_CALAMARI);
            case "crocodile":
               return Boolean(_loc5_.auctionFilters & FILTER_CROCODILE);
            case "hornet":
               return Boolean(_loc5_.auctionFilters & FILTER_HORNET);
            case "mammoth":
               return Boolean(_loc5_.auctionFilters & FILTER_MAMMOTH);
            case "walrus":
               return Boolean(_loc5_.auctionFilters & FILTER_WALRUS);
            case "dragon":
               return Boolean(_loc5_.auctionFilters & FILTER_DRAGON);
            case "hydra":
               return Boolean(_loc5_.auctionFilters & FILTER_HYDRA);
            case "mantis":
               return Boolean(_loc5_.auctionFilters & FILTER_MANTIS);
            case "gorilla":
               return Boolean(_loc5_.auctionFilters & FILTER_GORILLA);
            case "tortoise":
               return Boolean(_loc5_.auctionFilters & FILTER_TORTOISE);
            case "egg":
               return Boolean(_loc5_.auctionFilters & FILTER_EGG);
            case "wyrm":
               return Boolean(_loc5_.auctionFilters & FILTER_WYRM);
            case "cerberus":
               return Boolean(_loc5_.auctionFilters & FILTER_CERBERUS);
            case "beholder":
               return Boolean(_loc5_.auctionFilters & FILTER_BEHOLDER);
            case "steed":
               return Boolean(_loc5_.auctionFilters & FILTER_STEED);
            case "lion":
               return Boolean(_loc5_.auctionFilters & FILTER_LION);
            default:
               return false;
         }
      }
      
      private static function sortLastBidTime(param1:*, param2:*) : int
      {
         var _loc3_:Auction = param1 as Auction;
         var _loc4_:Auction = param2 as Auction;
         if(_loc3_.last_bid_time.time < _loc4_.last_bid_time.time)
         {
            return 1;
         }
         if(_loc3_.last_bid_time.time > _loc4_.last_bid_time.time)
         {
            return -1;
         }
         return 0;
      }
      
      private static function sortNewest(param1:*, param2:*) : int
      {
         var _loc3_:Auction = param1 as Auction;
         var _loc4_:Auction = param2 as Auction;
         if(_loc3_.creation_date.time < _loc4_.creation_date.time)
         {
            return 1;
         }
         if(_loc3_.creation_date.time > _loc4_.creation_date.time)
         {
            return -1;
         }
         return 0;
      }
      
      private static function sortOldest(param1:*, param2:*) : int
      {
         var _loc3_:Auction = param1 as Auction;
         var _loc4_:Auction = param2 as Auction;
         if(_loc3_.creation_date.time > _loc4_.creation_date.time)
         {
            return 1;
         }
         if(_loc3_.creation_date.time < _loc4_.creation_date.time)
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
      
      override protected function createChildren() : void
      {
         var _loc1_:ToggleButton = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         if(this.player.area.type == Area.TYPE_AUCTION)
         {
            this.client.service.GetAuctions(this.client.createInput());
         }
         this._panelsGroup = new RadioButtonGroup();
         this._panelsGroup.addButton(this.bidsBtn);
         this._panelsGroup.addButton(this.ownedBtn);
         this._panelsGroup.addEventListener(Event.CHANGE,this.onPanelChange);
         this._panelsGroup.selected = this.bidsBtn;
         this._searchOrderGroup = new RadioButtonGroup();
         this._searchOrderGroup.addButton(this.orderByLatestBtn);
         this._searchOrderGroup.addButton(this.orderByOldestBtn);
         this._searchOrderGroup.addEventListener(Event.CHANGE,this.onSearchOrderChange);
         this._searchOrderGroup.selected = this.orderByLatestBtn;
         this._detailsWindow = new com.edgebee.breedr.ui.world.areas.auction.AuctionDetailsWindow();
         this._detailsWindow.visible = false;
         UIGlobals.popUpManager.addPopUp(this._detailsWindow,this);
         UIGlobals.popUpManager.centerPopUp(this._detailsWindow);
         this._createWindow = new com.edgebee.breedr.ui.world.areas.auction.CreateAuctionWindow();
         this._createWindow.visible = false;
         UIGlobals.popUpManager.addPopUp(this._createWindow,this);
         UIGlobals.popUpManager.centerPopUp(this._createWindow);
         addEventListener(AuctionItemView.DETAILS_CLICKED,this.onDetailsClicked);
         addEventListener(AuctionItemView.QUICK_BID_CLICKED,this.onQuickBidClicked);
         this.gameView.dialogView.addEventListener("TUT_AUCTION_SHOW_OWNED",this.onDialogShowOwned);
         this.gameView.dialogView.addEventListener("TUT_AUCTION_SHOW_BIDS",this.onDialogShowBids);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         var _loc2_:int = 0;
         while(_loc2_ < _filterButtons.length)
         {
            _loc1_ = new ToggleButton();
            _loc1_.userData = Math.pow(2,_loc2_);
            _loc1_.toolTip = Asset.getInstanceByName(_filterTips[_loc2_]);
            _loc1_.icon = UIUtils.createBitmapIcon(_filterIcons[_loc2_],UIGlobals.relativize(16),UIGlobals.relativize(16));
            _loc1_.icon.filters = UIGlobals.fontSmallOutline;
            _loc1_.selected = Boolean(this.client.auctionFilters & Math.pow(2,_loc2_));
            _loc1_.addEventListener(MouseEvent.CLICK,this.onFilterChange);
            this[_filterButtons[_loc2_]] = _loc1_;
            if(_loc2_ < 13)
            {
               this.filtersBox1.addChild(_loc1_);
            }
            else
            {
               this.filtersBox2.addChild(_loc1_);
            }
            _loc2_++;
         }
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
            if(this._detailsWindow)
            {
               this._detailsWindow.doClose();
            }
            if(this._createWindow)
            {
               this._createWindow.doClose();
            }
            this.bg.stopAnimation();
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(!this._initialFetch && this.player.area.type == Area.TYPE_AUCTION)
            {
               this._initialFetch = true;
               this.client.service.GetAuctions(this.client.createInput());
            }
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.createAuctionBtn))
         {
            this.createAuctionBtn.enabled = this.client.criticalComms == 0;
         }
         if(param1.property == "auctionFilters")
         {
            if(this.auctionList.dataProvider)
            {
               this.resetSearch();
               switch(this._panelsGroup.selected)
               {
                  case this.ownedBtn:
                     this.ownedAuctionsArr.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,null,0));
                     break;
                  case this.bidsBtn:
                     this.bidsAuctionsArr.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,CollectionEvent.RESET,null,0));
               }
            }
         }
      }
      
      private function onFilterChange(param1:MouseEvent) : void
      {
         var _loc2_:ToggleButton = param1.target as ToggleButton;
         if(_loc2_.selected)
         {
            this.client.auctionFilters |= _loc2_.userData as Number;
         }
         else
         {
            this.client.auctionFilters &= ~(_loc2_.userData as Number);
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "MakeBid")
         {
            if(param1.exception.cls == "StaleAuctions")
            {
               AlertWindow.show(Asset.getInstanceByName("STALE_AUCTIONS_BODY"),Asset.getInstanceByName("STALE_AUCTIONS_TITLE"),this.gameView,true,null,true,true);
               this._detailsWindow.visible = false;
               this.onRefreshClick(null);
               param1.handled = true;
            }
            --this.client.criticalComms;
         }
      }
      
      private function onPanelChange(param1:ExtendedEvent) : void
      {
         this.resetSearch();
         switch(param1.data)
         {
            case OWNED:
               this.auctionList.dataProvider = this.ownedAuctionsArr;
               this.auctionList.sortFunc = sortNewest;
               break;
            case BIDS:
               this.auctionList.dataProvider = this.bidsAuctionsArr;
               this.auctionList.sortFunc = sortLastBidTime;
         }
      }
      
      private function onDialogShowOwned(param1:Event) : void
      {
         this._panelsGroup.selected = this.ownedBtn;
      }
      
      private function onDialogShowBids(param1:Event) : void
      {
         this._panelsGroup.selected = this.bidsBtn;
      }
      
      private function onDetailsClicked(param1:ExtendedEvent) : void
      {
         if(this._detailsWindow.x < 0 || this._detailsWindow.x > stage.stageWidth || this._detailsWindow.y < 0 || this._detailsWindow.y > stage.stageHeight)
         {
            UIGlobals.popUpManager.centerPopUp(this._detailsWindow);
         }
         this._detailsWindow.auction = param1.data as Auction;
         this._detailsWindow.visible = true;
      }
      
      private function onQuickBidClicked(param1:ExtendedEvent) : void
      {
         var _loc2_:Auction = param1.data as Auction;
         var _loc3_:Object = this.client.createInput();
         _loc3_.auction_id = _loc2_.id;
         _loc3_.amount = _loc2_.currentBidAmount + _loc2_.quickBidAmount;
         this.client.service.MakeBid(_loc3_);
         ++this.client.criticalComms;
      }
      
      public function onCreateAuctionClick(param1:MouseEvent) : void
      {
         UIGlobals.popUpManager.centerPopUp(this._createWindow);
         this._createWindow.visible = true;
      }
      
      public function onRefreshClick(param1:MouseEvent) : void
      {
         if(this._panelsGroup.selected)
         {
            this.client.service.GetAuctions(this.client.createInput());
         }
         else
         {
            this.onSearchClick(null);
         }
      }
      
      private function onGetAuctions(param1:ServiceEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.ownedAuctionsArr.update(param1.data.owned);
         this.bidsAuctionsArr.update(param1.data.bids);
      }
      
      private function onMakeBid(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onSearchOrderChange(param1:ExtendedEvent) : void
      {
         this.resetSearch();
      }
      
      private function doSearch() : void
      {
         var _loc1_:Object = this.client.createInput();
         _loc1_.offset = this._currentOffset * SEARCH_RESULT_LENGTH;
         if(this._searchOrderGroup.selectedItem == LATEST)
         {
            _loc1_.order = 1;
         }
         else
         {
            _loc1_.order = 2;
         }
         var _loc2_:Array = [];
         if(this.client.auctionFilters & FILTER_WOLF)
         {
            _loc2_.push(Creature.FAMILY_WOLF);
         }
         if(this.client.auctionFilters & FILTER_LIZARD)
         {
            _loc2_.push(Creature.FAMILY_LIZARD);
         }
         if(this.client.auctionFilters & FILTER_FISH)
         {
            _loc2_.push(Creature.FAMILY_FISH);
         }
         if(this.client.auctionFilters & FILTER_MOTH)
         {
            _loc2_.push(Creature.FAMILY_MOTH);
         }
         if(this.client.auctionFilters & FILTER_BIRD)
         {
            _loc2_.push(Creature.FAMILY_BIRD);
         }
         if(this.client.auctionFilters & FILTER_TOAD)
         {
            _loc2_.push(Creature.FAMILY_TOAD);
         }
         if(this.client.auctionFilters & FILTER_CRUSTACEAN)
         {
            _loc2_.push(Creature.FAMILY_CRUSTACEAN);
         }
         if(this.client.auctionFilters & FILTER_SPIDER)
         {
            _loc2_.push(Creature.FAMILY_SPIDER);
         }
         if(this.client.auctionFilters & FILTER_RAPTOR)
         {
            _loc2_.push(Creature.FAMILY_RAPTOR);
         }
         if(this.client.auctionFilters & FILTER_OWLBEAR)
         {
            _loc2_.push(Creature.FAMILY_OWLBEAR);
         }
         if(this.client.auctionFilters & FILTER_WALRUS)
         {
            _loc2_.push(Creature.FAMILY_WALRUS);
         }
         if(this.client.auctionFilters & FILTER_CALAMARI)
         {
            _loc2_.push(Creature.FAMILY_CALAMARI);
         }
         if(this.client.auctionFilters & FILTER_CROCODILE)
         {
            _loc2_.push(Creature.FAMILY_CROCODILE);
         }
         if(this.client.auctionFilters & FILTER_HORNET)
         {
            _loc2_.push(Creature.FAMILY_HORNET);
         }
         if(this.client.auctionFilters & FILTER_MAMMOTH)
         {
            _loc2_.push(Creature.FAMILY_MAMMOTH);
         }
         if(this.client.auctionFilters & FILTER_TORTOISE)
         {
            _loc2_.push(Creature.FAMILY_TORTOISE);
         }
         if(this.client.auctionFilters & FILTER_DRAGON)
         {
            _loc2_.push(Creature.FAMILY_DRAGON);
         }
         if(this.client.auctionFilters & FILTER_MANTIS)
         {
            _loc2_.push(Creature.FAMILY_MANTIS);
         }
         if(this.client.auctionFilters & FILTER_HYDRA)
         {
            _loc2_.push(Creature.FAMILY_HYDRA);
         }
         if(this.client.auctionFilters & FILTER_GORILLA)
         {
            _loc2_.push(Creature.FAMILY_GORILLA);
         }
         if(this.client.auctionFilters & FILTER_WYRM)
         {
            _loc2_.push(Creature.FAMILY_WYRM);
         }
         if(this.client.auctionFilters & FILTER_STEED)
         {
            _loc2_.push(Creature.FAMILY_STEED);
         }
         if(this.client.auctionFilters & FILTER_CERBERUS)
         {
            _loc2_.push(Creature.FAMILY_CERBERUS);
         }
         if(this.client.auctionFilters & FILTER_BEHOLDER)
         {
            _loc2_.push(Creature.FAMILY_BEHOLDER);
         }
         if(this.client.auctionFilters & FILTER_LION)
         {
            _loc2_.push(Creature.FAMILY_LION);
         }
         _loc1_.search_eggs = (this.client.auctionFilters & FILTER_EGG) == FILTER_EGG;
         _loc1_.families = _loc2_;
         this.client.service.SearchAuctions(_loc1_);
      }
      
      private function onSearchAuctions(param1:ServiceEvent) : void
      {
         var _loc2_:DataArray = null;
         if(this._currentOffset > this._maxOffset)
         {
            _loc2_ = new DataArray(Auction.classinfo);
            _loc2_.update(param1.data.auctions);
            if(_loc2_.length)
            {
               this.allSearchAuctionsArr.source = this.allSearchAuctionsArr.source.concat(_loc2_.source);
               this.searchAuctionsArr.source = this.allSearchAuctionsArr.source.slice(this._currentOffset * SEARCH_RESULT_LENGTH,(this._currentOffset + 1) * SEARCH_RESULT_LENGTH);
               this._maxOffset = this._currentOffset;
               this.searchNextBtn.enabled = _loc2_.length == SEARCH_RESULT_LENGTH;
               this._allSearchesDone = _loc2_.length != SEARCH_RESULT_LENGTH;
            }
            else
            {
               this._currentOffset = this._maxOffset;
               this.searchNextBtn.enabled = false;
               this._allSearchesDone = true;
            }
         }
         else
         {
            this.allSearchAuctionsArr.update(param1.data.auctions);
            this.searchAuctionsArr.source = this.allSearchAuctionsArr.source.slice(0,SEARCH_RESULT_LENGTH);
            this.searchNextBtn.enabled = this.allSearchAuctionsArr.length == SEARCH_RESULT_LENGTH;
            this._allSearchesDone = this.allSearchAuctionsArr.length != SEARCH_RESULT_LENGTH;
         }
      }
      
      private function resetSearch() : void
      {
         this.allSearchAuctionsArr.removeAll();
         this.searchAuctionsArr.removeAll();
         this.searchNextBtn.enabled = this.searchPreviousBtn.enabled = false;
         this._currentOffset = 0;
         this._maxOffset = 0;
         this._allSearchesDone = false;
      }
      
      public function onSearchClick(param1:MouseEvent) : void
      {
         this._panelsGroup.reset();
         this.resetSearch();
         this.auctionList.dataProvider = this.searchAuctionsArr;
         this.auctionList.sortFunc = null;
         this.doSearch();
      }
      
      public function onSearchPreviousClick(param1:MouseEvent) : void
      {
         if(this._currentOffset > 0)
         {
            --this._currentOffset;
            this.searchAuctionsArr.source = this.allSearchAuctionsArr.source.slice(this._currentOffset * SEARCH_RESULT_LENGTH,(this._currentOffset + 1) * SEARCH_RESULT_LENGTH);
            this.searchPreviousBtn.enabled = this._currentOffset > 0;
            this.searchNextBtn.enabled = true;
         }
      }
      
      public function onSearchNextClick(param1:MouseEvent) : void
      {
         this._currentOffset += 1;
         if(this._currentOffset > this._maxOffset)
         {
            this.doSearch();
         }
         else
         {
            this.searchAuctionsArr.source = this.allSearchAuctionsArr.source.slice(this._currentOffset * SEARCH_RESULT_LENGTH,(this._currentOffset + 1) * SEARCH_RESULT_LENGTH);
            if(this._currentOffset == this._maxOffset && this._allSearchesDone)
            {
               this.searchNextBtn.enabled = false;
            }
         }
         this.searchPreviousBtn.enabled = true;
      }
   }
}
