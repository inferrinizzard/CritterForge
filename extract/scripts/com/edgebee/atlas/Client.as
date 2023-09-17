package com.edgebee.atlas
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.*;
   import com.edgebee.atlas.managers.ChatManager;
   import com.edgebee.atlas.managers.GameEventDispatcher;
   import com.edgebee.atlas.managers.SoundManager;
   import com.edgebee.atlas.managers.processors.ParallelProcessor;
   import com.edgebee.atlas.managers.processors.ScheduledProcessor;
   import com.edgebee.atlas.managers.processors.SequentialProcessor;
   import com.edgebee.atlas.net.JsonService;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Application;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.ExceptionWindow;
   import com.edgebee.atlas.util.Clock;
   import com.edgebee.atlas.util.ClockTimer;
   import com.edgebee.atlas.util.DelayedCallback;
   import com.edgebee.atlas.util.IClockTimerFactory;
   import com.edgebee.atlas.util.Utils;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   import flash.utils.ByteArray;
   
   public class Client extends EventDispatcher implements IClockTimerFactory
   {
      
      public static const DEVELOPER:String = "DEVELOPER";
      
      public static const PRODUCTION:String = "PRODUCTION";
      
      public static const BROWSER_PLUGIN:String = "BROWSER_PLUGIN";
      
      public static const AIR_APPLICATION:String = "AIR_APPLICATION";
      
      public static const FULLSCREEN_HW_SCALING:String = "FULLSCREEN_HW_SCALING";
      
      public static const FULLSCREEN_FP_SCALING:String = "FULLSCREEN_FP_SCALING";
       
      
      public var username:String;
      
      public var instance:uint;
      
      public var basePlayer:Player;
      
      public var scheduledProcessor:ScheduledProcessor;
      
      public var sequentialProcessor:SequentialProcessor;
      
      public var parallelProcessor:ParallelProcessor;
      
      public var processorTimer:ClockTimer;
      
      protected var gameEventDispatcher:GameEventDispatcher;
      
      private var _password:String;
      
      private var _MD5password:String;
      
      private var _hosted:Boolean;
      
      private var _id:String;
      
      private var _name:String;
      
      private var _embeddedStaticData:Class;
      
      private var _url:String;
      
      private var _contentUrl:String;
      
      private var _service:JsonService;
      
      private var _cookie;
      
      private var _session:uint;
      
      private var _user:User;
      
      private var _critical:int = 0;
      
      private var _soundManager:SoundManager;
      
      private var _chatManager:ChatManager;
      
      private var _serverVersion:int;
      
      private var _minClientVersion:int;
      
      private var _maintenanceAt:Date;
      
      private var _checkSent:Boolean = false;
      
      private var _mainClock:Clock;
      
      private var _systemClock:Clock;
      
      private var _kongregateApi;
      
      private var _mode:String;
      
      private var _swfPlayerType:String;
      
      private var _dc:DelayedCallback;
      
      private var _pauseRefCount:uint = 0;
      
      public function Client(param1:String, param2:Class)
      {
         super();
         this._hosted = false;
         this._id = createUniqueClientUID();
         this.username = null;
         this.password = null;
         this.instance = 0;
         this._mainClock = new Clock();
         this._mainClock.start();
         this._mainClock.timeScale = 1;
         this._systemClock = new Clock();
         this._systemClock.start();
         this._name = param1;
         this._embeddedStaticData = param2;
      }
      
      private static function createUniqueClientUID() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:String = _loc1_.time.toString() + _loc1_.timezoneOffset.toString();
         _loc2_ += Capabilities.serverString.toString();
         _loc2_ += Math.random().toString();
         return MD5.hash(_loc2_);
      }
      
      public function initialize() : void
      {
         var paramObj:Object = null;
         var apiPath:String = null;
         var root:Application = UIGlobals.root;
         if(Capabilities.playerType == "Desktop")
         {
            this._swfPlayerType = AIR_APPLICATION;
         }
         else
         {
            this._swfPlayerType = BROWSER_PLUGIN;
         }
         if(UIGlobals.root.buildMode == "developer")
         {
            this._mode = DEVELOPER;
            this._url = "http://127.0.0.1:8000";
         }
         else
         {
            this._mode = PRODUCTION;
            this._url = "http://www.edgebee.com";
            this._contentUrl = "http://cdn.edgebee.com/static";
         }
         this._service = new JsonService(this,this.gameUrl);
         try
         {
            this._cookie = SharedObject.getLocal(this.name,"/");
         }
         catch(error:Error)
         {
            _cookie = {
               "data":{},
               "flush":function():void
               {
               }
            };
         }
         this._user = new User();
         this._user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this.gameEventDispatcher = new GameEventDispatcher();
         this.initCookie();
         UIGlobals.l10nManager.initialize(this);
         this.service.addEventListener("GetStaticDump",this.onStaticDumpReceived);
         this.getStaticDump();
         this._soundManager = new SoundManager(this);
         this._chatManager = new ChatManager(this);
         this._chatManager.autoReconnect = true;
         if(this.mode == PRODUCTION)
         {
            this._chatManager.host = "chat.edgebee.com";
            this._chatManager.port = 80;
         }
         else
         {
            this._chatManager.host = "127.0.0.1";
            this._chatManager.port = 3001;
         }
         Security.allowDomain("edgebee.com");
         Security.allowDomain("www.edgebee.com");
         Security.allowDomain("cdn.edgebee.com");
         Security.loadPolicyFile("xmlsocket://" + this._chatManager.host + ":" + this._chatManager.port.toString());
         Security.loadPolicyFile("http://cdn.edgebee.com/static/crossdomain.xml");
         Security.loadPolicyFile("http://facebook.com/crossdomain.xml");
         Security.loadPolicyFile("http://ak.fbcdn.net/crossdomain.xml");
         Security.loadPolicyFile("http://api.facebook.com/crossdomain.xml");
         Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
         Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
         Security.loadPolicyFile("http://static.ak.fbcdn.net/crossdomain.xml");
         if(this.isKongregate)
         {
            paramObj = LoaderInfo(UIGlobals.root.loaderInfo).parameters;
            apiPath = String(String(paramObj.kongregate_api_path) || "http://www.kongregate.com/flash/API_AS3_Local.swf");
            if(UIGlobals.root.preloadedAssets.hasOwnProperty(apiPath))
            {
               this._kongregateApi = UIGlobals.root.preloadedAssets[apiPath].content;
               UIGlobals.root.addChild(this._kongregateApi);
            }
            if(!this._kongregateApi || this._kongregateApi.services == null)
            {
               AlertWindow.show("Error loading Kongregate API! Try reloading the game.","Loading Error",UIGlobals.root,true,null,false,false);
               return;
            }
            this._kongregateApi.services.connect();
            this._kongregateApi.services.addEventListener("login",this.onKongregateLogin);
         }
         this.service.addEventListener(ServiceEvent.LOGIN,this.onLogin);
         this.service.addEventListener(ServiceEvent.GUEST_LOGIN,this.onLogin);
         this.service.addEventListener(ServiceEvent.REGISTER,this.onLogin);
         this.service.addEventListener("KongregateLogin",this.onLogin);
         this.service.addEventListener("FacebookLogin",this.onLogin);
         this.service.addEventListener("OpenSocialLogin",this.onLogin);
         this.service.addEventListener(ServiceEvent.LOGOUT,this.onLogout);
         this.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.service.addEventListener(ExceptionEvent.UNHANDLED_EXCEPTION,this.onUnhandledException);
         this.service.addEventListener(JsonService.HANDLE_PIGGY_BACK,this.onPiggyBack);
         this.service.addEventListener(ServerUnderMaintenanceEvent.SERVER_UNDER_MAINTENANCE,this.onServerUnderMaintenance);
         this.scheduledProcessor = new ScheduledProcessor();
         this.sequentialProcessor = new SequentialProcessor();
         this.parallelProcessor = new ParallelProcessor();
         this.processorTimer = this.createClockTimer(25);
         this.processorTimer.addEventListener(TimerEvent.TIMER,this.onProcessorTimer);
         this.processorTimer.start();
         this.service.addEventListener(JsonService.SHOW_NETWORK_STATUS_WINDOW,this.onShowNetworkStatus);
         this.service.addEventListener(JsonService.HIDE_NETWORK_STATUS_WINDOW,this.onHideNetworkStatus);
         UIGlobals.initDebug();
      }
      
      public function get password() : String
      {
         return this._password;
      }
      
      public function set password(param1:String) : void
      {
         if(param1)
         {
            this._password = param1;
            this._MD5password = MD5.hash(param1);
         }
      }
      
      public function get MD5password() : String
      {
         return this._MD5password;
      }
      
      public function set MD5password(param1:String) : void
      {
         this._MD5password = param1;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get isForeign() : Boolean
      {
         return !this.isHosted && !this.isKongregate && !this.isFacebook && !this.isOpenSocial;
      }
      
      public function get hasEmbeddedData() : Boolean
      {
         var _loc1_:ByteArray = null;
         if(this._embeddedStaticData != null)
         {
            _loc1_ = new this._embeddedStaticData();
            return _loc1_.length > 8;
         }
         return false;
      }
      
      public function get isKongregate() : Boolean
      {
         return Utils.isKongregate(UIGlobals.root.loaderInfo);
      }
      
      public function get isFacebook() : Boolean
      {
         return Utils.isFacebook(UIGlobals.root.loaderInfo);
      }
      
      public function get isOpenSocial() : Boolean
      {
         return Utils.isOpenSocial(UIGlobals.root.loaderInfo);
      }
      
      public function get openSocialProvider() : String
      {
         return Utils.getOpenSocialProvider(UIGlobals.root.loaderInfo);
      }
      
      public function get isDeveloper() : Boolean
      {
         return this.mode == DEVELOPER;
      }
      
      public function get isHosted() : Boolean
      {
         var _loc1_:Application = UIGlobals.root;
         if(this.mode != DEVELOPER && _loc1_.loaderInfo.loaderURL.slice(0,23) != "http://cdn.edgebee.com/")
         {
            return false;
         }
         if(this.isKongregate || this.isFacebook || this.isOpenSocial)
         {
            return false;
         }
         if(this.swfPlayerType == Client.BROWSER_PLUGIN && ExternalInterface.available)
         {
            return ExternalInterface.call("isHosted") == "true";
         }
         return false;
      }
      
      public function get user() : User
      {
         return this._user;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function get swfPlayerType() : String
      {
         return this._swfPlayerType;
      }
      
      public function get gameUrl() : String
      {
         return this._url + "/" + this._name;
      }
      
      public function get contentUrl() : String
      {
         if(this._contentUrl)
         {
            return this._contentUrl;
         }
         return this._url + "/static";
      }
      
      public function set contentUrl(param1:String) : void
      {
         this._contentUrl = param1;
      }
      
      public function get service() : JsonService
      {
         return this._service;
      }
      
      public function get session() : uint
      {
         return this._session;
      }
      
      public function clearSession() : void
      {
         this._session = 0;
      }
      
      public function saveCookie() : void
      {
         try
         {
            this._cookie.flush();
         }
         catch(error:Error)
         {
         }
      }
      
      public function get sndManager() : SoundManager
      {
         return this._soundManager;
      }
      
      public function get chatManager() : ChatManager
      {
         return this._chatManager;
      }
      
      public function get serverVersion() : int
      {
         return this._serverVersion;
      }
      
      public function get minClientVersion() : int
      {
         return this._minClientVersion;
      }
      
      public function get maintenanceAt() : Date
      {
         return this._maintenanceAt;
      }
      
      public function get userCookie() : Object
      {
         if(Boolean(this.user) && Boolean(this.user.name))
         {
            if(!this._cookie.data.hasOwnProperty(this.user.name))
            {
               this._cookie.data[this.user.name] = new Object();
            }
            return this._cookie.data[this.user.name];
         }
         return this.genericCookie;
      }
      
      public function get genericCookie() : Object
      {
         return this._cookie.data;
      }
      
      public function get signedIn() : Boolean
      {
         return this._session != 0;
      }
      
      public function get locale() : String
      {
         if(!this.userCookie.hasOwnProperty("_last_locale"))
         {
            this.userCookie._last_locale = "en_us";
            this.saveCookie();
         }
         return this.userCookie._last_locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this.userCookie._last_locale != param1)
         {
            this.userCookie._last_locale = param1;
            this.genericCookie._last_locale = param1;
            this.saveCookie();
            this.doLocaleChange();
         }
      }
      
      public function get criticalComms() : int
      {
         return this._critical;
      }
      
      public function set criticalComms(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._critical != param1)
         {
            if(param1 < 0)
            {
               throw new Error("Critical comms ref count is under 0 this should not happen!");
            }
            _loc2_ = this._critical;
            this._critical = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"criticalComms",_loc2_,param1));
         }
      }
      
      public function get kongregateApi() : *
      {
         return this._kongregateApi;
      }
      
      public function get showChatJoinLeave() : Boolean
      {
         return this.userCookie.showChatJoinLeave;
      }
      
      public function set showChatJoinLeave(param1:Boolean) : void
      {
         if(this.userCookie.showChatJoinLeave != param1)
         {
            this.userCookie.showChatJoinLeave = param1;
            this.saveCookie();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"showChatJoinLeave",!param1,param1));
         }
      }
      
      public function get paused() : Boolean
      {
         return this.pauseRefCount > 0;
      }
      
      public function get mainClock() : Clock
      {
         return this._mainClock;
      }
      
      public function get systemClock() : Clock
      {
         return this._systemClock;
      }
      
      public function get currentTime() : Number
      {
         return this._mainClock.gameTime;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function reset() : void
      {
         this._id = createUniqueClientUID();
         this._session = 0;
         this.instance = 0;
         this._user.reset();
         dispatchEvent(new ServiceEvent(ServiceEvent.RESET));
         System.gc();
      }
      
      public function unpause() : void
      {
         --this.pauseRefCount;
         if(this.pauseRefCount == 0)
         {
            this._mainClock.start();
         }
      }
      
      public function pause() : void
      {
         if(this.pauseRefCount == 0)
         {
            this._mainClock.stop();
         }
         ++this.pauseRefCount;
      }
      
      public function createInput(param1:Boolean = true, param2:Boolean = false) : Object
      {
         var _loc3_:Object = new Object();
         if(param1)
         {
            _loc3_.session = this.session;
         }
         if(param2 && !this._checkSent && (this.session & 768) == 768)
         {
            _loc3_.bsession_key = this.session & 16711935;
            this._checkSent = true;
         }
         if(this.locale != "en_us")
         {
            _loc3_.__locale = this.locale;
         }
         return _loc3_;
      }
      
      public function toPortal() : void
      {
         var _loc1_:URLRequest = null;
         if(Boolean(this.genericCookie.last_login) && Boolean(this.genericCookie.last_password))
         {
            _loc1_ = new URLRequest("http://www.edgebee.com/signin");
            if(this.mode == DEVELOPER)
            {
               _loc1_.url = "http://127.0.0.1:8000/signin";
            }
            _loc1_.method = URLRequestMethod.POST;
            _loc1_.data = new URLVariables();
            _loc1_.data.username = this.genericCookie.last_login;
            _loc1_.data.password = this.genericCookie.last_password;
            _loc1_.data.remember = "off";
            navigateToURL(_loc1_);
         }
         else if(this.genericCookie.anonymous_id)
         {
            _loc1_ = new URLRequest("http://www.edgebee.com/signin");
            if(this.mode == DEVELOPER)
            {
               _loc1_.url = "http://127.0.0.1:8000/signin";
            }
            _loc1_.method = URLRequestMethod.POST;
            _loc1_.data = new URLVariables();
            _loc1_.data.username = this.genericCookie.anonymous_id;
            _loc1_.data.password = this.genericCookie.anonymous_id;
            _loc1_.data.remember = "off";
            navigateToURL(_loc1_);
         }
         else
         {
            _loc1_ = new URLRequest("http://www.edgebee.com/");
            if(this.mode == DEVELOPER)
            {
               _loc1_.url = "http://127.0.0.1:8000/";
            }
            navigateToURL(_loc1_);
         }
      }
      
      protected function onLogin(param1:ServiceEvent) : void
      {
         var _loc2_:String = this.locale;
         if(param1.data.hasOwnProperty("user"))
         {
            this._user.update(param1.data.user);
            if(!this._cookie.data.hasOwnProperty(this._user.name))
            {
               this._cookie.data[this._user.name] = new Object();
            }
            if(this._user.anonymous)
            {
               this.genericCookie.anonymous_id = this._user.name;
               this.saveCookie();
            }
            this.initCookie();
            this.sndManager.initializeVolumes();
         }
         if(param1.data.hasOwnProperty("session"))
         {
            this._session = param1.data.session;
         }
         if(_loc2_ != this.locale)
         {
            this.genericCookie._last_locale = this.locale;
            this.doLocaleChange();
         }
         this.username = this.user.name;
         if(param1.data.hasOwnProperty("user") && Boolean(param1.data.user.hasOwnProperty("password")))
         {
            this.password = this.user.password;
            this.MD5password = MD5.hash(this.user.password);
         }
      }
      
      protected function onLogout(param1:ServiceEvent) : void
      {
         this._session = 0;
         this._hosted = false;
         this.instance = 0;
         this._user.reset();
         if(this.basePlayer != null)
         {
            this.basePlayer.reset();
         }
      }
      
      public function GetAssetPath(param1:String, param2:Boolean = false, param3:String = null) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         if(param2)
         {
            if(!param3)
            {
               _loc4_ = this._url + "/static/" + this.name;
            }
            else
            {
               _loc4_ = this._url + "/static/" + param3;
            }
         }
         else
         {
            _loc4_ = this.contentUrl;
            if(param3)
            {
               _loc4_ += "/" + param3;
            }
         }
         if(this.swfPlayerType == AIR_APPLICATION)
         {
            _loc5_ = this.contentUrl + param1;
            UIGlobals.root.dispatchEvent(new ExtendedEvent(Application.CHECK_ASSET_PRESENT,param1));
            return this.contentUrl + param1;
         }
         if(param1.length > 0 && param1.charAt(0) == "/")
         {
            return _loc4_ + param1;
         }
         if(_loc4_.length > 0)
         {
            return _loc4_ + "/" + param1;
         }
         return param1;
      }
      
      protected function onException(param1:ExceptionEvent) : void
      {
         if(param1.exception.cls == "DuplicateAction")
         {
            param1.handled = true;
            this.doClientOutOfSynch();
         }
         if(!param1.handled && param1.exception.cls == "SessionExpired")
         {
            param1.handled = true;
            AlertWindow.show(Asset.getInstanceByName("SESSION_EXPIRED_EXPLAINED"),Asset.getInstanceByName("SESSION_EXPIRED"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onSessionExpiredOk},true,true);
         }
      }
      
      public function doClientOutOfSynch() : void
      {
         var _loc1_:Window = null;
         _loc1_ = AlertWindow.show(Asset.getInstanceByName("CLIENT_OUT_OF_SYNCH"),Asset.getInstanceByName("CLIENT_OUT_OF_SYNCH_TITLE"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onClientOutOfSynchOk},false,true);
      }
      
      protected function onUnhandledException(param1:ExceptionEvent) : void
      {
         UIGlobals.root.enabled = true;
         var _loc2_:ExceptionWindow = new ExceptionWindow();
         _loc2_.exception = param1.exception;
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root.stage,true);
         UIGlobals.popUpManager.centerPopUp(_loc2_);
      }
      
      protected function onServerUnderMaintenance(param1:ServerUnderMaintenanceEvent) : void
      {
         var _loc2_:AlertWindow = AlertWindow.show(Asset.getInstanceByName("SERVER_UNDER_MAINTENANCE"),Asset.getInstanceByName("SERVER_UNDER_MAINTENANCE_TITLE"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onServerUnderMaintenanceOk},false,true);
      }
      
      protected function onPiggyBack(param1:ExtendedEvent) : void
      {
         if(param1.data.hasOwnProperty("sv_version"))
         {
            this._serverVersion = param1.data.sv_version;
         }
         if(param1.data.hasOwnProperty("cl_version"))
         {
            this._minClientVersion = param1.data.cl_version;
         }
         if(param1.data.hasOwnProperty("maintenance"))
         {
            this._maintenanceAt = Utils.dateFromString(param1.data.maintenance);
         }
         else
         {
            this._maintenanceAt = null;
         }
         if(param1.data.hasOwnProperty("events"))
         {
            this.handleGameEvents(param1.data.events);
         }
      }
      
      public function handleGameEvents(param1:Array) : void
      {
         this.gameEventDispatcher.dispatch(param1);
      }
      
      protected function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            if(this.isHosted)
            {
               ExternalInterface.call("synchTokens",param1.newValue);
            }
         }
      }
      
      protected function onAssetsReplaced(param1:ServiceEvent) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Asset = null;
         this.service.removeEventListener("GetStaticDump",this.onAssetsReplaced);
         var _loc3_:Array = param1.data["assets"];
         for each(_loc2_ in _loc3_)
         {
            _loc4_ = new Asset(_loc2_);
         }
         UIGlobals.l10nManager.dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function onStaticDumpReceived(param1:ServiceEvent, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         var _loc5_:Asset = null;
         this.service.removeEventListener("GetStaticDump",this.onStaticDumpReceived);
         if(param1.data.hasOwnProperty("sv_version"))
         {
            this._serverVersion = int(param1.data.sv_version);
         }
         if(param1.data.hasOwnProperty("cl_version"))
         {
            this._minClientVersion = int(param1.data.cl_version);
         }
         var _loc4_:Array = param1.data["assets"];
         for each(_loc3_ in _loc4_)
         {
            _loc5_ = new Asset(_loc3_);
         }
         if(param2)
         {
            dispatchEvent(new Event(Event.INIT));
         }
      }
      
      protected function onKongregateLogin(param1:Event) : void
      {
         AlertWindow.show(Asset.getInstanceByName("KONGREGATE_LOGIN_DURING_PLAY"),Asset.getInstanceByName("KONGREGATE_LOGIN_DURING_PLAY_TITLE"),null,true,null,false,true,false,false,false,true);
         this.service.Logout(this.createInput());
      }
      
      protected function initCookie() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(this.genericCookie.hasOwnProperty("anonymous_id") && this.genericCookie["anonymous_id"] == null)
         {
            delete this.genericCookie["anonymous_id"];
         }
         if(!this.userCookie.hasOwnProperty("_ui"))
         {
            this.userCookie._ui = new Object();
         }
         if(!this.userCookie._ui.hasOwnProperty("windows"))
         {
            this.userCookie._ui.windows = new Object();
         }
         if(!this.userCookie.hasOwnProperty("_music_volume"))
         {
            this.userCookie._music_volume = SoundManager.DEFAULT_VOLUME * 0.5;
         }
         if(!this.userCookie.hasOwnProperty("_sfx_volume"))
         {
            this.userCookie._sfx_volume = SoundManager.DEFAULT_VOLUME * 0.5;
         }
         if(!this.userCookie.hasOwnProperty("latestNewsId"))
         {
            this.userCookie.latestNewsId = 0;
         }
         if(!this.userCookie.hasOwnProperty("_last_locale"))
         {
            this.userCookie._last_locale = "en_us";
         }
         if(this.userCookie._last_locale != this.user.locale)
         {
            if(Boolean(this.user) && Boolean(this.user.name))
            {
               this.userCookie._last_locale = this.user.locale;
            }
         }
         if(this.isHosted)
         {
            _loc1_ = ExternalInterface.call("getLocale");
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               _loc2_ = com.adobe.serialization.json.JSON.decode(_loc1_);
               if(_loc2_.hasOwnProperty("locale"))
               {
                  this.userCookie._last_locale = _loc2_.locale;
               }
            }
         }
         if(!this.userCookie.hasOwnProperty("fullScreenMode"))
         {
            this.userCookie.fullScreenMode = Client.FULLSCREEN_HW_SCALING;
         }
         this.saveCookie();
      }
      
      public function createClockTimer(param1:Number, param2:int = 0) : ClockTimer
      {
         return new ClockTimer(this._mainClock,param1,param2);
      }
      
      private function onServerUnderMaintenanceOk(param1:Event) : void
      {
         if(this.swfPlayerType == Client.AIR_APPLICATION)
         {
            UIGlobals.root.dispatchEvent(new Event(Application.EXIT_APPLICATION));
         }
         else if(this.isHosted)
         {
            ExternalInterface.call("doQuitGame");
         }
      }
      
      private function onClientOutOfSynchOk(param1:Event) : void
      {
         if(this.swfPlayerType == Client.AIR_APPLICATION)
         {
            UIGlobals.root.dispatchEvent(new Event(Application.EXIT_APPLICATION));
         }
         else if(this.isHosted)
         {
            ExternalInterface.call("reloadPortal",this.name,this.minClientVersion);
         }
      }
      
      private function loadEmbeddedStaticDump() : void
      {
         var _loc1_:ByteArray = new this._embeddedStaticData();
         var _loc2_:String = _loc1_.toString();
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(_loc2_,true);
         this.service.dispatchEvent(new ServiceEvent("GetStaticDump",_loc3_.result));
         this._dc = null;
      }
      
      private function getStaticDump() : void
      {
         var _loc1_:ByteArray = new this._embeddedStaticData();
         if(_loc1_.length > 8)
         {
            this._dc = new DelayedCallback(500,this.loadEmbeddedStaticDump);
            this._dc.touch();
         }
         else if(this.mode == DEVELOPER)
         {
            this.service.callSpecificUrl("static/" + this.name + "/StaticDump_" + this.locale + ".txt","GetStaticDump",URLRequestMethod.GET,null);
         }
         else if(Capabilities.playerType == "ActiveX")
         {
            this.service.callSpecificUrl(this._contentUrl + "/" + this.name + "/StaticDump_" + this.locale + "_" + UIGlobals.root.buildVersion + ".txt","GetStaticDump",URLRequestMethod.GET,null);
         }
         else
         {
            this.service.callSpecificUrl(this._contentUrl + "/" + this.name + "/StaticDump_" + this.locale + "_" + UIGlobals.root.buildVersion + "_gz.txt","GetStaticDump",URLRequestMethod.GET,null);
         }
      }
      
      private function doLocaleChange() : void
      {
         var _loc1_:Asset = null;
         for each(_loc1_ in StaticData.getStore("Asset")["id"])
         {
            _loc1_.toReplace = true;
         }
         this.service.addEventListener("GetStaticDump",this.onAssetsReplaced);
         this.getStaticDump();
      }
      
      public function onProcessorTimer(param1:TimerEvent) : void
      {
         this.sequentialProcessor.execute();
         this.parallelProcessor.execute();
      }
      
      private function get pauseRefCount() : uint
      {
         return this._pauseRefCount;
      }
      
      private function set pauseRefCount(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.pauseRefCount != param1)
         {
            _loc2_ = this._pauseRefCount;
            this._pauseRefCount = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"paused",_loc2_ == 0,this._pauseRefCount == 0));
         }
      }
      
      private function onShowNetworkStatus(param1:Event) : void
      {
         this.pause();
      }
      
      private function onHideNetworkStatus(param1:Event) : void
      {
         this.unpause();
      }
      
      private function onSessionExpiredOk(param1:Event) : void
      {
         this.service.Logout(this.createInput());
      }
   }
}
