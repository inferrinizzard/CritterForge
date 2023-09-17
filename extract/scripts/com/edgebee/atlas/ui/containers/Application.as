package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.net.JsonService;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.ProgressIndicator;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.DebugInfo;
   import com.edgebee.atlas.ui.gadgets.NetworkStatus;
   import com.edgebee.atlas.ui.gadgets.NetworkStatusWindow;
   import com.edgebee.atlas.util.Utils;
   import flash.display.DisplayObject;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   
   public class Application extends com.edgebee.atlas.ui.containers.Canvas
   {
      
      public static const ADVERTISEMENT_FINISHED:String = "ADVERTISEMENT_FINISHED";
      
      public static const CLIENT_OUT_OF_DATE:String = "CLIENT_OUT_OF_DATE";
      
      public static const EXIT_APPLICATION:String = "EXIT_APPLICATION";
      
      public static const CHECK_ASSET_PRESENT:String = "CHECK_ASSET_PRESENT";
      
      private static const IN_FIVE:Number = 1;
      
      private static const IN_TEN:Number = 2;
      
      private static const IN_TWENTY:Number = 4;
      
      private static const IN_THIRTY:Number = 8;
      
      private static const IN_X_MINUTES:Number = 16;
       
      
      public var client:Client;
      
      public var adShown:Boolean = false;
      
      public var preloadedAssets:Object;
      
      public var appName:String;
      
      protected var debugInfo:DebugInfo;
      
      protected var networkStatus:NetworkStatus;
      
      private var _childrenHolder:com.edgebee.atlas.ui.containers.Canvas;
      
      private var _layerHolder:com.edgebee.atlas.ui.containers.Canvas;
      
      private var _layerCount:uint = 0;
      
      private var _initialized:Boolean = false;
      
      private var _advertisementHolder:AdvertisementHolder;
      
      private var _compatAlertWindow:AlertWindow = null;
      
      private var _maintenanceAlertWindow:AlertWindow = null;
      
      private var _networkStatusWindow:NetworkStatusWindow;
      
      private var _progressIndicator:ProgressIndicator;
      
      private var _stageQuality:String;
      
      private var _progressHolder:com.edgebee.atlas.ui.containers.Box;
      
      private var _outOfDateToggled:Boolean = false;
      
      private var _warnings:Number = 0;
      
      public function Application(param1:String = null, param2:String = "best")
      {
         this.preloadedAssets = {};
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         super();
         this.appName = param1;
         this._stageQuality = param2;
         this._childrenHolder = new com.edgebee.atlas.ui.containers.Canvas();
         this._childrenHolder.name = "Application._childrenHolder";
         this._layerHolder = new com.edgebee.atlas.ui.containers.Canvas();
         this._layerHolder.name = "Application._layerHolder";
      }
      
      public function get fps() : Number
      {
         if(this.debugInfo)
         {
            return this.debugInfo.fps;
         }
         return 0;
      }
      
      public function get buildVersion() : String
      {
         return "version not specified";
      }
      
      public function get buildMode() : String
      {
         return "mode not specified";
      }
      
      public function addLayer(param1:DisplayObject) : DisplayObject
      {
         return this._layerHolder.addChild(param1);
      }
      
      override public function get numChildren() : int
      {
         return this._childrenHolder.numChildren;
      }
      
      public function get active() : Boolean
      {
         return stage != null;
      }
      
      public function startAdvertisement() : void
      {
         if(this.client && this.client.user.showAdvertisements && this.client.mode == Client.PRODUCTION)
         {
            this._childrenHolder.visible = false;
            this._layerHolder.visible = false;
            this._advertisementHolder.startAdvertisement();
         }
         else
         {
            this.skipAdvertisement();
         }
      }
      
      public function skipAdvertisement() : void
      {
         UIGlobals.root.dispatchEvent(new Event(Application.ADVERTISEMENT_FINISHED));
         this.adShown = true;
      }
      
      public function endAdvertisement() : void
      {
         this.adShown = true;
         this._childrenHolder.visible = true;
         this._layerHolder.visible = true;
         UIGlobals.root.dispatchEvent(new Event(Application.ADVERTISEMENT_FINISHED));
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this._childrenHolder.addChild(param1);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         return this._childrenHolder.addChildAt(param1,param2);
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         return this._childrenHolder.removeChild(param1);
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         return this._childrenHolder.removeChildAt(param1);
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return this._childrenHolder.getChildAt(param1);
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         return this._childrenHolder.getChildByName(param1);
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         return this._childrenHolder.getChildIndex(param1);
      }
      
      protected function positionDebugInfo() : void
      {
         if(this.debugInfo)
         {
            this.debugInfo.x = 20;
            this.debugInfo.y = height - 50;
         }
      }
      
      protected function positionNetworkStatus() : void
      {
         if(this.networkStatus)
         {
            this.networkStatus.x = 10;
            this.networkStatus.y = 40;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         super.addChild(this._childrenHolder);
         super.addChild(this._layerHolder);
         if(this.client)
         {
            if(this.client.mode == Client.DEVELOPER)
            {
               this.debugInfo = new DebugInfo(this);
               this.debugInfo.addEventListener(Event.CHANGE,this.onDebugInfoChanged);
               this.addChild(this.debugInfo);
               this.positionDebugInfo();
            }
            this.networkStatus = new NetworkStatus();
            this.networkStatus.service = this.client.service;
            this.networkStatus.width = 150;
            this.networkStatus.height = 75;
            this.networkStatus.setStyle("FontSize",6);
            this.addChild(this.networkStatus);
            this.networkStatus.alpha = 0.75;
            this.networkStatus.filters = [new GlowFilter(0,1,2,2,10)];
            this.positionNetworkStatus();
            this._networkStatusWindow = new NetworkStatusWindow(this.client);
            this._progressHolder = new com.edgebee.atlas.ui.containers.Box(com.edgebee.atlas.ui.containers.Box.VERTICAL,com.edgebee.atlas.ui.containers.Box.ALIGN_CENTER,com.edgebee.atlas.ui.containers.Box.ALIGN_MIDDLE);
            if(stage)
            {
               this._progressHolder.width = stage.stageWidth;
               this._progressHolder.height = stage.stageHeight;
            }
            else
            {
               this._progressHolder.height = this.defaultWidth;
               this._progressHolder.width = this.defaultHeight;
            }
            this.addChild(this._progressHolder);
            this._progressIndicator = new ProgressIndicator();
            this._progressIndicator.visible = true;
            this._progressIndicator.paused = false;
            this._progressIndicator.width = UIGlobals.relativizeX(32);
            this._progressIndicator.height = UIGlobals.relativizeY(32);
            this._progressHolder.addChild(this._progressIndicator);
            this._progressHolder.validateNow(true);
            this.client.service.addEventListener(JsonService.SHOW_NETWORK_STATUS_WINDOW,this.onShowNetworkStatus);
            this.client.service.addEventListener(JsonService.HIDE_NETWORK_STATUS_WINDOW,this.onHideNetworkStatus);
         }
         UIGlobals.fiftyMsTimer.addEventListener(TimerEvent.TIMER,this.onUpdateTimer);
      }
      
      public function get defaultWidth() : Number
      {
         return 960;
      }
      
      public function get defaultHeight() : Number
      {
         return 720;
      }
      
      public function startProgressIndicator() : void
      {
         if(this._progressIndicator)
         {
            this._progressIndicator.paused = false;
            this._progressIndicator.visible = true;
         }
      }
      
      public function stopProgressIndicator() : void
      {
         if(this._progressIndicator)
         {
            this._progressIndicator.paused = true;
            this._progressIndicator.visible = false;
         }
      }
      
      private function onDebugInfoChanged(param1:Event) : void
      {
         this.positionDebugInfo();
      }
      
      private function onShowNetworkStatus(param1:Event) : void
      {
         UIGlobals.popUpManager.addPopUp(this._networkStatusWindow,this,true);
         UIGlobals.popUpManager.centerPopUp(this._networkStatusWindow);
      }
      
      private function onHideNetworkStatus(param1:Event) : void
      {
         UIGlobals.popUpManager.removePopUp(this._networkStatusWindow);
      }
      
      private function onDoRestart(param1:Event) : void
      {
         if(this.client.swfPlayerType == Client.BROWSER_PLUGIN && ExternalInterface.available)
         {
            ExternalInterface.call("reloadPortal",this.client.name,this.client.minClientVersion);
         }
      }
      
      private function checkServerClientCompatibility() : void
      {
         if(Boolean(this.client) && this.client.minClientVersion > int(this.buildVersion))
         {
            if(this.client.isHosted && this.client.swfPlayerType == Client.BROWSER_PLUGIN && !this._outOfDateToggled)
            {
               this._outOfDateToggled = true;
               this._compatAlertWindow = AlertWindow.show(Asset.getInstanceByName("CLIENT_OUT_OF_DATE"),Asset.getInstanceByName("CLIENT_OUT_OF_DATE_TITLE"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onDoRestart},false,true);
            }
            if(this.client.swfPlayerType == Client.AIR_APPLICATION && !this._outOfDateToggled)
            {
               this._outOfDateToggled = true;
               dispatchEvent(new Event(CLIENT_OUT_OF_DATE));
            }
         }
      }
      
      private function checkMaintenance() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = false;
         var _loc1_:Date = new Date();
         if(this.client && this.client.maintenanceAt && this.client.maintenanceAt.time > _loc1_.time)
         {
            _loc2_ = (this.client.maintenanceAt.time - _loc1_.time) / 60000;
            _loc3_ = false;
            if(_loc2_ <= 5)
            {
               _loc3_ = !(this._warnings & IN_FIVE);
               this._warnings |= IN_FIVE;
            }
            else if(_loc2_ <= 10)
            {
               _loc3_ = !(this._warnings & IN_TEN);
               this._warnings |= IN_TEN;
            }
            else if(_loc2_ <= 20)
            {
               _loc3_ = !(this._warnings & IN_TWENTY);
               this._warnings |= IN_TWENTY;
            }
            else if(_loc2_ <= 30)
            {
               _loc3_ = !(this._warnings & IN_THIRTY);
               this._warnings |= IN_THIRTY;
            }
            else
            {
               _loc3_ = !(this._warnings & IN_X_MINUTES);
               this._warnings |= IN_X_MINUTES;
            }
            if(_loc3_)
            {
               this._maintenanceAlertWindow = AlertWindow.show(Utils.formatString(Asset.getInstanceByName("CLIENT_MAINTENANCE").value,{"minutes":_loc2_.toFixed(0)}),Asset.getInstanceByName("CLIENT_MAINTENANCE_TITLE"),UIGlobals.root,true,null,true,true);
            }
         }
         else
         {
            this._warnings = 0;
         }
      }
      
      private function onUpdateTimer(param1:TimerEvent) : void
      {
         if(this.networkStatus)
         {
            if(this.getChildIndex(this.networkStatus) != this.numChildren - 3)
            {
               this.removeChild(this.networkStatus);
               this.addChild(this.networkStatus);
            }
         }
         if(this._progressHolder)
         {
            if(this.getChildIndex(this._progressHolder) != this.numChildren - 2)
            {
               this.removeChild(this._progressHolder);
               this.addChild(this._progressHolder);
            }
         }
         if(Boolean(this.debugInfo) && this.getChildIndex(this.debugInfo) != this.numChildren - 1)
         {
            this.removeChild(this.debugInfo);
            this.addChild(this.debugInfo);
         }
         this.checkServerClientCompatibility();
         this.checkMaintenance();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(!this._initialized)
         {
            this._initialized = true;
            stage.quality = this._stageQuality;
            UIGlobals.Init(this);
            this._advertisementHolder = new AdvertisementHolder();
            this._advertisementHolder.visible = false;
            super.addChild(this._advertisementHolder);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            if(!this.client || this.client.swfPlayerType == Client.BROWSER_PLUGIN)
            {
               width = stage.stageWidth;
               height = stage.stageHeight;
            }
            this.createChildren();
            _childrenCreated = true;
            dispatchEvent(new Event(Component.CHILDREN_CREATED));
            if(!this.client || this.client.swfPlayerType == Client.BROWSER_PLUGIN)
            {
               width = stage.stageWidth;
               height = stage.stageHeight;
               this.positionDebugInfo();
            }
            this._advertisementHolder.init(width,height);
            processedDescriptors = true;
            stage.addEventListener(MouseEvent.CLICK,this.onStageClicked,false,0,true);
         }
      }
      
      private function onStageClicked(param1:MouseEvent) : void
      {
         if(Boolean(this.client) && this.client.mode == Client.BROWSER_PLUGIN)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.onStageClicked);
            stage.fullScreenSourceRect = null;
            stage.scaleMode = StageScaleMode.SHOW_ALL;
            stage.align = StageAlign.TOP;
            stage.displayState = StageDisplayState.FULL_SCREEN;
            stage.scaleMode = StageScaleMode.EXACT_FIT;
            stage.displayState = StageDisplayState.NORMAL;
         }
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.mochiads.MochiAd;
import flash.display.MovieClip;

dynamic class AdvertisementHolder extends MovieClip
{
    
   
   private var _width:Number;
   
   private var _height:Number;
   
   public function AdvertisementHolder()
   {
      super();
   }
   
   public function init(param1:Number, param2:Number) : void
   {
      this._width = param1;
      this._height = param2;
      graphics.beginFill(0,0);
      graphics.drawRect(0,0,param1,param2);
      graphics.endFill();
   }
   
   public function startAdvertisement() : void
   {
      var _loc1_:String = this._width.toString() + "x" + this._height.toString();
      visible = true;
      MochiAd.showInterLevelAd({
         "clip":this,
         "id":"d1701a6ba4876270",
         "res":_loc1_,
         "ad_finished":this.onAdFinish
      });
   }
   
   private function onAdFinish() : void
   {
      this.visible = false;
      UIGlobals.root.endAdvertisement();
   }
}
