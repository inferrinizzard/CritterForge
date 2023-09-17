package com.edgebee.atlas.ui.gadgets
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.controls.ToggleButton;
   import com.edgebee.atlas.ui.skins.CheckBoxSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.codec.Utf8;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   
   public class LoginWindow extends Window
   {
      
      public static const LOGIN_COMPLETE:String = "LOGIN_COMPLETE";
      
      public static const STATE_WAITING:String = "STATE_WAITING";
      
      public static const STATE_INITIAL:String = "STATE_INITIAL";
      
      public static const STATE_CHOOSE:String = "STATE_CHOOSE";
      
      public static const STATE_SIGN_IN:String = "STATE_SIGN_IN";
      
      public static const STATE_REGISTER:String = "STATE_REGISTER";
      
      public static const REASON_BOTING:int = 1;
      
      public static const REASON_CHAT_ABUSE:int = 2;
      
      public static const REASON_FORUM_ABUSE:int = 3;
      
      public static const REASON_PLAYER_FRAUD:int = 4;
      
      public static const REASON_MULTIPLE_ACCOUNTS:int = 5;
       
      
      public var setCritical:Boolean;
      
      public var usernameInput:TextInput;
      
      public var passwordInput:TextInput;
      
      public var rememberPasswordBtn:ToggleButton;
      
      public var submitButton:Button;
      
      public var signUpButton:Button;
      
      public var guestButton:Button;
      
      private var _loginWindowMachine:LoginWindowMachine;
      
      private var _layout:Array;
      
      private var _statusLayout:Array;
      
      public function LoginWindow(param1:Boolean = true)
      {
         this._layout = [{
            "CLASS":Box,
            "percentWidth":1,
            "horizontalAlign":Box.ALIGN_LEFT,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("USERNAME"),
               "percentWidth":0.3,
               "alignment":TextFormatAlign.RIGHT,
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "FontColor":16777215,
                  "FontWeight":"bold",
                  "FontSize":UIGlobals.relativizeFont(18)
               }
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(5)
            },{
               "CLASS":TextInput,
               "ID":"usernameInput",
               "percentWidth":0.7,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(18)},
               "text":(!!UIGlobals.root.client.genericCookie.last_login ? UIGlobals.root.client.genericCookie.last_login : ""),
               "EVENTS":[{
                  "TYPE":Event.CHANGE,
                  "LISTENER":this.update
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "horizontalAlign":Box.ALIGN_LEFT,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("PASSWORD"),
               "percentWidth":0.3,
               "alignment":TextFormatAlign.RIGHT,
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "FontColor":16777215,
                  "FontWeight":"bold",
                  "FontSize":UIGlobals.relativizeFont(18)
               }
            },{
               "CLASS":Spacer,
               "width":UIGlobals.relativize(5)
            },{
               "CLASS":TextInput,
               "ID":"passwordInput",
               "percentWidth":0.7,
               "displayAsPassword":true,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(18)},
               "text":(!!UIGlobals.root.client.genericCookie.last_password ? UIGlobals.root.client.genericCookie.last_password : ""),
               "EVENTS":[{
                  "TYPE":Event.CHANGE,
                  "LISTENER":this.update
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "horizontalAlign":Box.ALIGN_LEFT,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Spacer,
               "percentWidth":0.3
            },{
               "CLASS":ToggleButton,
               "ID":"rememberPasswordBtn",
               "label":Asset.getInstanceByName("REMEMBER_PW"),
               "percentWidth":0.6,
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "Skin":CheckBoxSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(18)
               },
               "selected":(!!UIGlobals.root.client.genericCookie.last_rememberPwd ? true : false)
            }]
         },{
            "CLASS":Spacer,
            "height":UIGlobals.relativize(5)
         }];
         this._statusLayout = [{
            "CLASS":Button,
            "ID":"guestButton",
            "label":Asset.getInstanceByName("GUEST"),
            "STYLES":{"FontSize":UIGlobals.relativizeFont(16)},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onGuestClick
            }]
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Button,
            "ID":"signUpButton",
            "label":Asset.getInstanceByName("SIGN_UP"),
            "STYLES":{"FontSize":UIGlobals.relativizeFont(16)},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onSignUpClick
            }]
         },{
            "CLASS":Button,
            "ID":"submitButton",
            "label":Asset.getInstanceByName("SIGN_IN"),
            "STYLES":{"FontSize":UIGlobals.relativizeFont(18)},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onSubmitClick
            }]
         }];
         super();
         width = UIGlobals.relativizeX(450);
         showCloseButton = false;
         visible = false;
         this.setCritical = param1;
      }
      
      public function dispatchLoginComplete() : void
      {
         UIGlobals.root.skipAdvertisement();
         dispatchEvent(new Event(LOGIN_COMPLETE));
         UIGlobals.root.stopProgressIndicator();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.layoutInvisibleChildren = false;
         content.horizontalAlign = Box.ALIGN_CENTER;
         content.setStyle("Gap",UIGlobals.relativize(5));
         UIUtils.performLayout(this,content,this._layout);
         statusBar.horizontalAlign = Box.ALIGN_RIGHT;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",UIGlobals.relativize(10));
         UIUtils.performLayout(this,statusBar,this._statusLayout);
         UIGlobals.popUpManager.addPopUp(this,UIGlobals.root);
         UIGlobals.popUpManager.centerPopUp(this);
         this._loginWindowMachine = new LoginWindowMachine(this);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,0,true);
         if(client.genericCookie.hasOwnProperty("anonymous_id"))
         {
            this.guestButton.label = Asset.getInstanceByName("CONTINUE_GUEST");
         }
         this.update();
      }
      
      private function update(param1:Event = null) : void
      {
         this.submitButton.enabled = Boolean(this.usernameInput.text) && Boolean(this.passwordInput.text);
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(visible && param1.keyCode == Keyboard.ENTER)
         {
            if(this.submitButton.enabled)
            {
               this.onSubmitClick(null);
            }
         }
      }
      
      private function onSignUpClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(client.mode == Client.PRODUCTION)
         {
            _loc2_ = new URLRequest("http://www.edgebee.com/register");
         }
         else
         {
            _loc2_ = new URLRequest("http://127.0.0.1:8000/register");
         }
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.data = new URLVariables();
         _loc2_.data.anonymous_id = client.genericCookie.hasOwnProperty("anonymous_id") ? client.genericCookie.anonymous_id : "";
         navigateToURL(_loc2_);
      }
      
      public function onGuestClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = client.createInput(false);
         if(UIGlobals.root.client.genericCookie.anonymous_id)
         {
            _loc2_.username = UIGlobals.root.client.genericCookie.anonymous_id;
            _loc2_.password = UIGlobals.root.client.genericCookie.anonymous_id;
         }
         client.username = _loc2_.username;
         client.password = _loc2_.password;
         client.service.GuestLogin(_loc2_);
         if(this.setCritical)
         {
            ++client.criticalComms;
         }
         dispatchEvent(new Event("GUEST_CLICKED"));
      }
      
      private function onSubmitClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.usernameInput.text)
         {
            client.genericCookie.last_login = this.usernameInput.text;
            client.genericCookie.last_rememberPwd = this.rememberPasswordBtn.selected;
            if(this.rememberPasswordBtn.selected)
            {
               client.genericCookie.last_password = this.passwordInput.text;
            }
            else
            {
               client.genericCookie.last_password = "";
            }
            client.genericCookie.anonymous_id = null;
            client.saveCookie();
         }
         _loc2_ = client.createInput(false);
         client.username = this.usernameInput.text;
         client.password = this.passwordInput.text;
         _loc2_.username = this.usernameInput.text;
         _loc2_.password = MD5.hash(Utf8.encode(this.passwordInput.text));
         client.service.Login(_loc2_);
         if(this.setCritical)
         {
            ++client.criticalComms;
         }
         dispatchEvent(new Event("LOGIN_CLICKED"));
      }
   }
}

import com.edgebee.atlas.ui.gadgets.LoginWindow;
import com.edgebee.atlas.util.fsm.AutomaticMachine;

class LoginWindowMachine extends AutomaticMachine
{
    
   
   public var loginView:LoginWindow;
   
   public function LoginWindowMachine(param1:LoginWindow)
   {
      super();
      this.loginView = param1;
      start(new WaitingForApplicationActive(this));
   }
}

import com.edgebee.atlas.Client;
import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.State;

class LoginWindowMachineState extends State
{
    
   
   public function LoginWindowMachineState(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   public function get lmachine() : LoginWindowMachine
   {
      return machine as LoginWindowMachine;
   }
   
   public function get client() : Client
   {
      return UIGlobals.root.client;
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      this.lmachine.loginView.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLoginWindowChange);
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      this.lmachine.loginView.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onLoginWindowChange);
   }
   
   protected function onLoginWindowChange(param1:PropertyChangeEvent) : void
   {
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;

class WaitingForApplicationActive extends LoginWindowMachineState
{
    
   
   public function WaitingForApplicationActive(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(UIGlobals.root.active)
      {
         if(client.isHosted)
         {
            return new Result(Result.TRANSITION,new EdgebeeLogin(lmachine));
         }
         if(client.isKongregate)
         {
            if(client.kongregateApi.services.isGuest())
            {
               return new Result(Result.TRANSITION,new GuestLogin(lmachine));
            }
            return new Result(Result.TRANSITION,new KongregateLogin(lmachine));
         }
         if(client.isFacebook)
         {
            return new Result(Result.TRANSITION,new FacebookLogin(lmachine));
         }
         if(client.isOpenSocial)
         {
            return new Result(Result.TRANSITION,new OpenSocialLogin(lmachine));
         }
         return new Result(Result.TRANSITION,new Prompt(lmachine));
      }
      return Result.CONTINUE;
   }
}

import com.adobe.serialization.json.JSON;
import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.gadgets.AlertWindow;
import com.edgebee.atlas.ui.gadgets.LoginWindow;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import flash.external.ExternalInterface;

class EdgebeeLogin extends LoginWindowMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   public function EdgebeeLogin(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Object = null;
      var _loc4_:Object = null;
      super.transitionInto(param1);
      lmachine.loginView.visible = false;
      var _loc2_:String = ExternalInterface.call("getUsernameAndPassword");
      if(Boolean(_loc2_) && _loc2_.length > 0)
      {
         _loc3_ = com.adobe.serialization.json.JSON.decode(_loc2_);
         if(_loc3_.hasOwnProperty("username") && _loc3_.hasOwnProperty("password"))
         {
            (_loc4_ = client.createInput(false)).username = _loc3_.username;
            _loc4_.password = _loc3_.password;
            client.username = _loc3_.username;
            client.MD5password = _loc3_.password;
            client.service.Login(_loc4_);
            client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
            if(lmachine.loginView.setCritical)
            {
               ++client.criticalComms;
            }
            client.service.addEventListener(ServiceEvent.LOGIN,this.onLogin);
         }
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         UIGlobals.root.startProgressIndicator();
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener(ServiceEvent.LOGIN,this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      var _loc2_:uint = 0;
      var _loc3_:uint = 0;
      var _loc4_:String = null;
      var _loc5_:String = null;
      if(param1.method == "Login" && param1.exception.cls == "UserSuspended")
      {
         if(lmachine.loginView.setCritical)
         {
            --client.criticalComms;
         }
         param1.handled = true;
         _loc2_ = uint(param1.exception.args[1]);
         _loc3_ = uint(param1.exception.args[2]);
         _loc4_ = Asset.getInstanceByName("ACCOUNT_SUSPENDED").value;
         if(_loc3_ == LoginWindow.REASON_BOTING)
         {
            _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_BOTIN").value;
         }
         else if(_loc3_ == LoginWindow.REASON_CHAT_ABUSE)
         {
            _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_CHAT_ABUSE").value;
         }
         else if(_loc3_ == LoginWindow.REASON_FORUM_ABUSE)
         {
            _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_FORUM_ABUSE").value;
         }
         else if(_loc3_ == LoginWindow.REASON_PLAYER_FRAUD)
         {
            _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_PLAYER_FRAUD").value;
         }
         else if(_loc3_ == LoginWindow.REASON_MULTIPLE_ACCOUNTS)
         {
            _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_MULTIPLE_ACCOUNTS").value;
         }
         _loc4_ = Utils.formatString(_loc4_,{
            "days":_loc2_.toString(),
            "reason":_loc5_
         });
         AlertWindow.show(_loc4_,Asset.getInstanceByName("ACCOUNT_SUSPENDED_TITLE").value);
      }
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}

import com.adobe.crypto.MD5;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;

class KongregateLogin extends LoginWindowMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   public function KongregateLogin(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      lmachine.loginView.visible = false;
      client.service.addEventListener("KongregateLogin",this.onLogin);
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      var _loc2_:Object = client.createInput(false);
      if(client.genericCookie.hasOwnProperty("anonymous_id"))
      {
         _loc2_.anonymous_id = client.genericCookie.anonymous_id;
      }
      _loc2_.user_id = client.kongregateApi.services.getUserId();
      _loc2_.game_auth_token = client.kongregateApi.services.getGameAuthToken();
      client.password = MD5.hash(client.kongregateApi.services.getUsername() + "_" + _loc2_.user_id).slice(0,8);
      client.MD5password = MD5.hash(client.password);
      client.service.KongregateLogin(_loc2_);
      if(lmachine.loginView.setCritical)
      {
         ++client.criticalComms;
      }
      UIGlobals.root.startProgressIndicator();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener("KongregateLogin",this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      if(param1.method == "KongregateLogin")
      {
         throw new Error("Error while logging in");
      }
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.gadgets.InputWindow;
import com.edgebee.atlas.util.fsm.Result;
import flash.events.Event;

class FacebookLogin extends LoginWindowMachineState
{
   
   public static var AliasIconPng:Class = FacebookLogin_AliasIconPng;
    
   
   private var _loggedIn:Boolean = false;
   
   public function FacebookLogin(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      lmachine.loginView.visible = false;
      client.service.addEventListener("FacebookLogin",this.onLogin);
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      var _loc2_:Object = client.createInput(false);
      var _loc3_:Object = UIGlobals.root.loaderInfo.parameters;
      _loc2_.signed_request = _loc3_["signed_request"];
      client.service.FacebookLogin(_loc2_);
      if(lmachine.loginView.setCritical)
      {
         ++client.criticalComms;
      }
      UIGlobals.root.startProgressIndicator();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener("FacebookLogin",this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      var _loc2_:InputWindow = null;
      if(param1.method == "FacebookLogin")
      {
         if(param1.exception.cls == "FacebookNeedAlias")
         {
            param1.handled = true;
            _loc2_ = InputWindow.create(Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS"),Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_TITLE"),false,true,AliasIconPng);
            _loc2_.minChars = 3;
            _loc2_.maxChars = 20;
            _loc2_.trim = true;
            _loc2_.textInputWidth = UIGlobals.relativize(200);
            _loc2_.defaultText = param1.exception.args[0];
            _loc2_.addEventListener(InputWindow.RESULT_OK,this.onAliasInput);
            _loc2_.setStyle("FontSize",UIGlobals.relativizeFont(20));
            UIGlobals.root.stopProgressIndicator();
            UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root,true);
            UIGlobals.popUpManager.centerPopUp(_loc2_);
         }
         else if(param1.exception.cls == "FacebookAliasInUse")
         {
            param1.handled = true;
            _loc2_ = InputWindow.create(Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_IN_USE"),Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_TITLE"),false,true,AliasIconPng);
            _loc2_.minChars = 3;
            _loc2_.maxChars = 20;
            _loc2_.trim = true;
            _loc2_.textInputWidth = UIGlobals.relativize(200);
            _loc2_.defaultText = param1.exception.args[0];
            _loc2_.addEventListener(InputWindow.RESULT_OK,this.onAliasInput);
            _loc2_.setStyle("FontSize",UIGlobals.relativizeFont(20));
            UIGlobals.root.stopProgressIndicator();
            UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root,true);
            UIGlobals.popUpManager.centerPopUp(_loc2_);
         }
      }
   }
   
   private function onAliasInput(param1:Event) : void
   {
      var _loc2_:InputWindow = param1.currentTarget as InputWindow;
      var _loc3_:Object = client.createInput(false);
      _loc3_.signed_request = UIGlobals.root.loaderInfo.parameters["signed_request"];
      _loc3_.alias = _loc2_.textInput.text;
      client.service.FacebookLogin(_loc3_);
      UIGlobals.root.startProgressIndicator();
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.gadgets.InputWindow;
import com.edgebee.atlas.util.fsm.Result;
import flash.events.Event;

class OpenSocialLogin extends LoginWindowMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   public function OpenSocialLogin(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      lmachine.loginView.visible = false;
      client.service.addEventListener("OpenSocialLogin",this.onLogin);
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      var _loc2_:Object = client.createInput(false);
      var _loc3_:Object = UIGlobals.root.loaderInfo.parameters;
      _loc2_.provider = _loc3_["provider"];
      _loc2_.security_token = _loc3_["security_token"];
      _loc2_.user_id = _loc3_["user_id"];
      client.service.OpenSocialLogin(_loc2_);
      if(lmachine.loginView.setCritical)
      {
         ++client.criticalComms;
      }
      UIGlobals.root.startProgressIndicator();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener("OpenSocialLogin",this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      var _loc2_:InputWindow = null;
      if(param1.method == "OpenSocialLogin")
      {
         if(param1.exception.cls == "OpenSocialNeedAlias")
         {
            param1.handled = true;
            _loc2_ = InputWindow.create(Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS"),Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_TITLE"),false,true,FacebookLogin.AliasIconPng);
            _loc2_.minChars = 3;
            _loc2_.maxChars = 20;
            _loc2_.trim = true;
            _loc2_.textInputWidth = UIGlobals.relativize(200);
            _loc2_.defaultText = param1.exception.args[0];
            _loc2_.addEventListener(InputWindow.RESULT_OK,this.onAliasInput);
            _loc2_.setStyle("FontSize",UIGlobals.relativizeFont(20));
            UIGlobals.root.stopProgressIndicator();
            UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root,true);
            UIGlobals.popUpManager.centerPopUp(_loc2_);
         }
         else if(param1.exception.cls == "OpenSocialAliasInUse")
         {
            param1.handled = true;
            _loc2_ = InputWindow.create(Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_IN_USE"),Asset.getInstanceByName("FACEBOOK_CREATE_ALIAS_TITLE"),false,true,FacebookLogin.AliasIconPng);
            _loc2_.minChars = 3;
            _loc2_.maxChars = 20;
            _loc2_.trim = true;
            _loc2_.textInputWidth = UIGlobals.relativize(200);
            _loc2_.defaultText = param1.exception.args[0];
            _loc2_.addEventListener(InputWindow.RESULT_OK,this.onAliasInput);
            _loc2_.setStyle("FontSize",UIGlobals.relativizeFont(20));
            UIGlobals.root.stopProgressIndicator();
            UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root,true);
            UIGlobals.popUpManager.centerPopUp(_loc2_);
         }
      }
   }
   
   private function onAliasInput(param1:Event) : void
   {
      var _loc2_:InputWindow = param1.currentTarget as InputWindow;
      var _loc3_:Object = client.createInput(false);
      var _loc4_:Object = UIGlobals.root.loaderInfo.parameters;
      _loc3_.provider = _loc4_["provider"];
      _loc3_.security_token = _loc4_["security_token"];
      _loc3_.user_id = _loc4_["user_id"];
      _loc3_.alias = _loc2_.textInput.text;
      client.service.OpenSocialLogin(_loc3_);
      UIGlobals.root.startProgressIndicator();
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}

import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.util.fsm.Result;

class GuestLogin extends LoginWindowMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   public function GuestLogin(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      lmachine.loginView.visible = false;
      client.service.addEventListener(ServiceEvent.GUEST_LOGIN,this.onLogin);
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
      lmachine.loginView.onGuestClick(null);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener(ServiceEvent.GUEST_LOGIN,this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      if(param1.method == ServiceEvent.GUEST_LOGIN)
      {
         throw new Error("Error while logging in");
      }
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import flash.events.Event;

class Prompt extends LoginWindowMachineState
{
    
   
   private var _toLogin:Boolean;
   
   public function Prompt(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      UIGlobals.root.stopProgressIndicator();
      lmachine.loginView.visible = true;
      lmachine.loginView.addEventListener("GUEST_CLICKED",this.onLoginClicked);
      lmachine.loginView.addEventListener("LOGIN_CLICKED",this.onLoginClicked);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._toLogin)
      {
         return new Result(Result.TRANSITION,new Login(lmachine));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      lmachine.loginView.visible = false;
      lmachine.loginView.removeEventListener("GUEST_CLICKED",this.onLoginClicked);
      lmachine.loginView.removeEventListener("LOGIN_CLICKED",this.onLoginClicked);
   }
   
   private function onLoginClicked(param1:Event) : void
   {
      this._toLogin = true;
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.events.ExceptionEvent;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.gadgets.AlertWindow;
import com.edgebee.atlas.ui.gadgets.LoginWindow;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;

class Login extends LoginWindowMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   private var _toPrompt:Boolean = false;
   
   public function Login(param1:LoginWindowMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      UIGlobals.root.startProgressIndicator();
      client.service.addEventListener(ServiceEvent.LOGIN,this.onLogin);
      client.service.addEventListener(ServiceEvent.GUEST_LOGIN,this.onLogin);
      client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         lmachine.loginView.dispatchLoginComplete();
         return Result.STOP;
      }
      if(this._toPrompt)
      {
         return new Result(Result.TRANSITION,new Prompt(lmachine));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      client.service.removeEventListener(ServiceEvent.LOGIN,this.onLogin);
      client.service.removeEventListener(ServiceEvent.GUEST_LOGIN,this.onLogin);
      client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
      UIGlobals.root.stopProgressIndicator();
   }
   
   private function onException(param1:ExceptionEvent) : void
   {
      var _loc2_:uint = 0;
      var _loc3_:uint = 0;
      var _loc4_:String = null;
      var _loc5_:String = null;
      if(param1.method == "GuestLogin" || param1.method == "Login")
      {
         if(lmachine.loginView.setCritical)
         {
            --client.criticalComms;
         }
         if(param1.exception.cls == "UserSuspended")
         {
            param1.handled = true;
            _loc2_ = uint(param1.exception.args[1]);
            _loc3_ = uint(param1.exception.args[2]);
            _loc4_ = Asset.getInstanceByName("ACCOUNT_SUSPENDED").value;
            if(_loc3_ == LoginWindow.REASON_BOTING)
            {
               _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_BOTING").value;
            }
            else if(_loc3_ == LoginWindow.REASON_CHAT_ABUSE)
            {
               _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_CHAT_ABUSE").value;
            }
            else if(_loc3_ == LoginWindow.REASON_FORUM_ABUSE)
            {
               _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_FORUM_ABUSE").value;
            }
            else if(_loc3_ == LoginWindow.REASON_PLAYER_FRAUD)
            {
               _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_PLAYER_FRAUD").value;
            }
            else if(_loc3_ == LoginWindow.REASON_MULTIPLE_ACCOUNTS)
            {
               _loc5_ = Asset.getInstanceByName("SUSPEND_REASON_MULTIPLE_ACCOUNTS").value;
            }
            _loc4_ = Utils.formatString(_loc4_,{
               "days":_loc2_.toString(),
               "reason":_loc5_
            });
            AlertWindow.show(_loc4_,Asset.getInstanceByName("ACCOUNT_SUSPENDED_TITLE").value);
         }
         this._toPrompt = true;
      }
   }
   
   private function onLogin(param1:ServiceEvent) : void
   {
      this._loggedIn = true;
   }
}
