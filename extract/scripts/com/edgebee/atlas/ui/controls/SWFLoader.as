package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Timer;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class SWFLoader extends Component
   {
      
      public static const LOAD_ERROR:String = "LOAD_ERROR";
       
      
      private var _contentWidth:Number = 0;
      
      private var _contentHeight:Number = 0;
      
      private var _source:String;
      
      private var _request:URLRequest;
      
      private var _loader:Loader;
      
      private var _loaded:Boolean = false;
      
      private var _loading:Boolean = false;
      
      private var _autoLoad:Boolean = true;
      
      private var _maintainAspectRatio:Boolean = false;
      
      private var _scaleContent:Boolean = true;
      
      private var _centered:Boolean = false;
      
      private var _loaderContext:LoaderContext;
      
      private var _cachedLoaders:Object;
      
      private var _timer:Timer;
      
      private var _retries:int = 0;
      
      private var _smoothing:Boolean = true;
      
      private var _pixelSnapping:String = "auto";
      
      private var _isSquare:Boolean = false;
      
      public function SWFLoader(param1:Loader = null)
      {
         this._loaderContext = new LoaderContext(true);
         this._cachedLoaders = {};
         this._timer = new Timer(30000);
         super();
         var _loc2_:Boolean = false;
         if(!param1)
         {
            this._loader = new Loader();
         }
         else
         {
            this._loader = param1;
            _loc2_ = true;
         }
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.onOpenHandler,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
         addChild(this._loader);
         this._timer.addEventListener(TimerEvent.TIMER,this.onLoadTimeout);
         if(_loc2_)
         {
            this._source = param1.contentLoaderInfo.url;
            this.onLoaderComplete(new Event(Event.COMPLETE));
         }
      }
      
      public function get source() : *
      {
         if(this._source != null)
         {
            return this._source;
         }
         if(this._request != null)
         {
            return this._request;
         }
         return null;
      }
      
      public function set source(param1:*) : void
      {
         if(this._source != param1)
         {
            if(param1 is String)
            {
               this._source = param1;
               this._request = null;
            }
            else if(param1 is URLRequest)
            {
               this._source = null;
               this._request = param1;
            }
            else
            {
               if(param1)
               {
                  throw Error("SWFLoader:: Unsupportred source type.");
               }
               this._source = null;
               this._request = null;
               if(this._loader)
               {
                  this._loader.unload();
               }
            }
            if(this.autoLoad && Boolean(this._loader))
            {
               this.load2();
            }
         }
      }
      
      public function get autoLoad() : Boolean
      {
         return this._autoLoad;
      }
      
      public function set autoLoad(param1:Boolean) : void
      {
         this._autoLoad = param1;
         if(this._autoLoad && this.source && !this._loaded && !this._loading)
         {
            this.load2();
         }
      }
      
      public function get scaleContent() : Boolean
      {
         return this._scaleContent;
      }
      
      public function set scaleContent(param1:Boolean) : void
      {
         this._scaleContent = param1;
         if(this._loaded)
         {
            invalidateDisplayList();
         }
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         this._maintainAspectRatio = param1;
         if(this._loaded && this.scaleContent)
         {
            invalidateDisplayList();
         }
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get loading() : Boolean
      {
         return this._loading;
      }
      
      public function get content() : DisplayObject
      {
         return this._loader.content;
      }
      
      public function get centered() : Boolean
      {
         return this._centered;
      }
      
      public function set centered(param1:Boolean) : void
      {
         this._centered = param1;
         if(this._loaded)
         {
            invalidateDisplayList();
         }
      }
      
      public function set loaderContext(param1:LoaderContext) : void
      {
         this._loaderContext = param1;
      }
      
      public function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      public function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         if(this._smoothing != param1)
         {
            this._smoothing = param1;
            if(this._loader.content is Bitmap)
            {
               (this._loader.content as Bitmap).smoothing = this.smoothing;
            }
         }
      }
      
      public function get pixelSnapping() : String
      {
         return this._pixelSnapping;
      }
      
      public function set pixelSnapping(param1:String) : void
      {
         if(this._pixelSnapping != param1)
         {
            this._pixelSnapping = param1;
            if(this._loader.content is Bitmap)
            {
               (this._loader.content as Bitmap).pixelSnapping = param1;
            }
         }
      }
      
      public function get isSquare() : Boolean
      {
         return this._isSquare;
      }
      
      public function set isSquare(param1:Boolean) : void
      {
         if(this._isSquare != param1)
         {
            this._isSquare = param1;
            invalidateSize();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(percentWidth == 0)
         {
            measuredWidth = this._contentWidth;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._contentHeight;
         }
         if(this.isSquare)
         {
            if(width != height && height > 0)
            {
               width = height;
            }
            else if(width != height && width > 0)
            {
               height = width;
            }
         }
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         if(this.isSquare)
         {
            if(width != height && height > 0)
            {
               width = height;
            }
            else if(width != height && width > 0)
            {
               height = width;
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(!this._loaded)
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         this.doScaleContent();
      }
      
      public function load2(param1:String = null) : void
      {
         var urlReq:URLRequest = null;
         var url:String = param1;
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
            if(e.errorID != 2029)
            {
               throw e;
            }
         }
         this._loading = true;
         this._loaded = false;
         if(UIGlobals.root.client.swfPlayerType == Client.AIR_APPLICATION)
         {
            this._timer.delay = 3000;
         }
         else
         {
            this._timer.delay = 30000;
         }
         if(!this.source || this.source is String)
         {
            if(url)
            {
               this._source = url;
            }
            if(this.source)
            {
               urlReq = new URLRequest(this.source);
               this._loader.load(urlReq,new LoaderContext(true));
               this._timer.start();
            }
            else
            {
               this._loader.unload();
            }
         }
         else if(this.source is URLRequest)
         {
            if(url)
            {
               this._request.url = url;
            }
            if(this._request.url)
            {
               this._loader.load(this._request,new LoaderContext(true));
               this._timer.start();
            }
            else
            {
               this._loader.unload();
            }
         }
      }
      
      private function doScaleContent() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = this._loader;
         if(this.scaleContent)
         {
            if(this.maintainAspectRatio)
            {
               _loc2_ = width / this._contentWidth;
               _loc3_ = height / this._contentHeight;
               _loc4_ = Math.min(_loc2_,_loc3_);
               _loc1_.width = this._contentWidth * _loc4_;
               _loc1_.height = this._contentHeight * _loc4_;
            }
            else
            {
               _loc1_.width = width;
               _loc1_.height = height;
            }
         }
         else
         {
            _loc1_.width = this._contentWidth;
            _loc1_.height = this._contentHeight;
         }
         if(this.centered)
         {
            _loc1_.x = width / 2 - _loc1_.width / 2;
            _loc1_.y = height / 2 - _loc1_.height / 2;
         }
         else
         {
            _loc1_.x = 0;
            _loc1_.y = 0;
         }
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         var _loc2_:Bitmap = null;
         this._contentWidth = this._loader.contentLoaderInfo.width;
         this._contentHeight = this._loader.contentLoaderInfo.height;
         if(this._loader.content is Bitmap)
         {
            _loc2_ = this._loader.content as Bitmap;
            _loc2_.pixelSnapping = this.pixelSnapping;
            _loc2_.smoothing = this.smoothing;
         }
         this._loading = false;
         this._loaded = true;
         this._timer.stop();
         invalidateSize();
         validateNow(true);
         this.doScaleContent();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(param1);
      }
      
      private function onLoadTimeout(param1:TimerEvent) : void
      {
         this._timer.stop();
         this.load2();
      }
      
      private function onOpenHandler(param1:Event) : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      private function onProgressHandler(param1:ProgressEvent) : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         if(UIGlobals.root.client.mode == Client.PRODUCTION)
         {
            if(UIGlobals.root.client.swfPlayerType == Client.BROWSER_PLUGIN)
            {
               if(this.source is String)
               {
                  throw Error("SWFLoader::Bad source, \'" + this.source + "\' could not be found.");
               }
               if(this.source is URLRequest)
               {
                  throw Error("SWFLoader::Bad source, \'" + (this.source as URLRequest).url + "\' could not be found.");
               }
            }
            else if(UIGlobals.root.client.swfPlayerType == Client.AIR_APPLICATION)
            {
               ++this._retries;
               if(this._retries > 10)
               {
                  if(this.source is String)
                  {
                     throw Error("SWFLoader::Bad source, \'" + this.source + "\' could not be found.");
                  }
                  if(this.source is URLRequest)
                  {
                     throw Error("SWFLoader::Bad source, \'" + (this.source as URLRequest).url + "\' could not be found.");
                  }
               }
            }
         }
         else if(!(this.source is String))
         {
            if(this.source is URLRequest)
            {
            }
         }
         dispatchEvent(new ExtendedEvent(LOAD_ERROR));
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         var event:SecurityErrorEvent = param1;
         try
         {
            this.onLoaderComplete(null);
         }
         catch(e:Error)
         {
         }
      }
   }
}
