package com.edgebee.atlas.ui.utils
{
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      
      private static const CONCURRENT_LOAD_MAX:Number = 20;
      
      private static const MAX_RETRIES:uint = 5;
       
      
      public var url:String;
      
      public var applicationClassName:String;
      
      protected var body:Sprite;
      
      protected var clickToContinue:Boolean = false;
      
      private var _assetsToPreload:Object;
      
      private var _assetsLoaded:Number = 0;
      
      private var _assetsTotal:Number = 0;
      
      private var _loaders:Object;
      
      private var _errors:Object;
      
      private var _loading:Array;
      
      public function Preloader(param1:String)
      {
         this._loaders = {};
         this._errors = {};
         this._loading = [];
         super();
         this.applicationClassName = param1;
         stop();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.body = new Sprite();
         this.body.graphics.beginFill(0,0);
         this.body.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         this.body.graphics.endFill();
         addChild(this.body);
         this._assetsToPreload = {};
         if("production" == "developer")
         {
            this.url = "http://127.0.0.1:8000";
         }
         else
         {
            this.url = "http://cdn.edgebee.com";
         }
      }
      
      public function get isKongregate() : Boolean
      {
         var _loc1_:Array = loaderInfo.loaderURL.match(/.*kongregate\.com.*/);
         return Boolean(_loc1_) && _loc1_.length > 0;
      }
      
      public function addAssetToPreload(param1:String) : void
      {
         this._assetsToPreload[param1] = null;
         ++this._assetsTotal;
      }
      
      public function getPreloadedAsset(param1:String) : SWFLoader
      {
         return this._assetsToPreload[param1];
      }
      
      protected function setup() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(this.isKongregate)
         {
            _loc1_ = LoaderInfo(loaderInfo).parameters;
            _loc2_ = String(String(_loc1_.kongregate_api_path) || "http://www.kongregate.com/flash/API_AS3_Local.swf");
            this.addAssetToPreload(_loc2_);
            Security.allowDomain(_loc2_);
            this.clickToContinue = true;
         }
         this.preloadNextAssets();
      }
      
      private function preloadNextAssets() : void
      {
         var _loc1_:String = null;
         var _loc2_:Loader = null;
         var _loc3_:Array = null;
         for(_loc1_ in this._assetsToPreload)
         {
            if(this._loading.length >= CONCURRENT_LOAD_MAX)
            {
               return;
            }
            if(!(this._assetsToPreload[_loc1_] is Loader))
            {
               _loc2_ = new Loader();
               _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAssetLoaded);
               _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onAssetLoadIoErrorHandler);
               _loc2_.load(new URLRequest(_loc1_),new LoaderContext(true));
               _loc3_ = _loc1_.match(/.*kongregate.*/);
               if(Boolean(_loc3_) && _loc3_.length > 0)
               {
                  addChild(_loc2_);
               }
               this._assetsToPreload[_loc1_] = _loc2_;
               this._loading.push(_loc1_);
            }
         }
      }
      
      protected function terminate() : void
      {
      }
      
      protected function update(param1:Number) : void
      {
         this.body.graphics.clear();
         this.body.graphics.beginFill(16777215,1);
         this.body.graphics.drawRect(0,stage.stageHeight / 2 - 10,stage.stageWidth * param1,20);
         this.body.graphics.endFill();
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         this.body.removeEventListener(MouseEvent.CLICK,this.onClick);
         nextFrame();
         this.init();
      }
      
      private function findLoaderUrl(param1:Loader) : String
      {
         var _loc2_:Loader = null;
         var _loc3_:String = null;
         for(_loc3_ in this._assetsToPreload)
         {
            _loc2_ = this._assetsToPreload[_loc3_];
            if(_loc2_ == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function retryAssetLoad(param1:String) : void
      {
         var _loc2_:Number = NaN;
         if(!this._errors.hasOwnProperty(param1))
         {
            this._errors[param1] = 0;
         }
         if(this._errors[param1]++ < MAX_RETRIES)
         {
            this._assetsToPreload[param1] = null;
            _loc2_ = this._loading.indexOf(param1);
            this._loading.splice(_loc2_,1)[0];
            this.preloadNextAssets();
            return;
         }
         throw new Error("Error::could not preload asset " + param1);
      }
      
      private function init() : void
      {
         var _loc2_:Object = null;
         removeChild(this.body);
         var _loc1_:Class = Class(getDefinitionByName(this.applicationClassName));
         if(_loc1_)
         {
            _loc2_ = new _loc1_(this._assetsToPreload);
            addChild(_loc2_ as DisplayObject);
            this._assetsToPreload = null;
         }
         this.terminate();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(framesLoaded == totalFrames && this._assetsLoaded == this._assetsTotal)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this.clickToContinue)
            {
               this.body.addEventListener(MouseEvent.CLICK,this.onClick);
               this.update(1);
            }
            else
            {
               nextFrame();
               this.init();
            }
         }
         else
         {
            _loc2_ = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            if(this._assetsTotal > 0)
            {
               _loc2_ /= 2;
               _loc2_ += this._assetsLoaded / (2 * this._assetsTotal);
            }
            this.update(_loc2_);
         }
      }
      
      private function onAssetLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,this.onAssetLoaded);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onAssetLoadIoErrorHandler);
         ++this._assetsLoaded;
         var _loc3_:Number = this._loading.indexOf(_loc2_.url);
         this._loading.splice(_loc3_,1)[0];
         this.preloadNextAssets();
      }
      
      private function onAssetLoadIoErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,this.onAssetLoaded);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onAssetLoadIoErrorHandler);
         this.retryAssetLoad(this.findLoaderUrl(_loc2_.loader));
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.setup();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.terminate();
      }
   }
}
