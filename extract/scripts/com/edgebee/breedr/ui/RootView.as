package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.gadgets.LoginWindow;
   import com.edgebee.breedr.Client;
   
   public class RootView extends Canvas
   {
       
      
      public var loginWindow:LoginWindow;
      
      public var gameView:com.edgebee.breedr.ui.GameView;
      
      public var client:Client;
      
      public var mainBox:Box;
      
      public var turnsLeft:uint = 0;
      
      private var machine:RootViewMachine;
      
      public function RootView(param1:Client)
      {
         super();
         name = "rootView";
         this.client = param1;
      }
      
      public function toLoggingOutView() : void
      {
         if(this.gameView)
         {
            this.mainBox.removeChild(this.gameView);
            this.gameView = null;
         }
      }
      
      public function toLoginWindow() : void
      {
         if(this.gameView)
         {
            this.mainBox.removeChild(this.gameView);
         }
         this.loginWindow = new LoginWindow();
         UIGlobals.popUpManager.addPopUp(this.loginWindow,UIGlobals.root,false);
      }
      
      public function toGameView() : void
      {
         if(this.loginWindow)
         {
            UIGlobals.popUpManager.removePopUp(this.loginWindow);
            this.loginWindow = null;
            this.mainBox.addChild(this.gameView);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.mainBox = new Box(Box.VERTICAL,Box.ALIGN_CENTER,Box.ALIGN_MIDDLE);
         this.mainBox.layoutInvisibleChildren = false;
         this.mainBox.percentHeight = 1;
         this.mainBox.percentWidth = 1;
         addChild(this.mainBox);
         this.gameView = new com.edgebee.breedr.ui.GameView();
         this.gameView.width = width;
         this.gameView.height = height;
         this.gameView.visible = false;
         this.mainBox.addChild(this.gameView);
         this.machine = new RootViewMachine(this);
      }
   }
}

import com.edgebee.atlas.util.fsm.AutomaticMachine;
import com.edgebee.breedr.ui.RootView;

class RootViewMachine extends AutomaticMachine
{
    
   
   public var rootView:RootView;
   
   public function RootViewMachine(param1:RootView, param2:Boolean = false)
   {
      super();
      this.rootView = param1;
      if(param2)
      {
         if(0)
         {
            start(new Login(this));
         }
         else
         {
            start(new Goodbye(this));
         }
      }
      else
      {
         start(new WaitUntilActive(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.State;
import com.edgebee.breedr.Client;

class RootViewMachineState extends State
{
    
   
   public function RootViewMachineState(param1:RootViewMachine)
   {
      super(param1);
   }
   
   public function get lmachine() : RootViewMachine
   {
      return machine as RootViewMachine;
   }
   
   public function get client() : Client
   {
      return UIGlobals.root.client as Client;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;

class WaitUntilActive extends RootViewMachineState
{
    
   
   public function WaitUntilActive(param1:RootViewMachine)
   {
      super(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      if(UIGlobals.root.active)
      {
         return new Result(Result.TRANSITION,new Splash(lmachine));
      }
      return Result.CONTINUE;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.ui.LogoSplash;
import flash.events.Event;

class Splash extends RootViewMachineState
{
    
   
   private var _splash:LogoSplash;
   
   private var _splashComplete:Boolean = false;
   
   public function Splash(param1:RootViewMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      this._splash = new LogoSplash();
      this._splash.width = lmachine.rootView.width;
      this._splash.height = lmachine.rootView.height;
      this._splash.addEventListener(Event.COMPLETE,this.onSplashComplete);
      lmachine.rootView.mainBox.addChild(this._splash);
      this._splash.play();
      (UIGlobals.root as breedr_flash).drawBackground = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._splashComplete)
      {
         (UIGlobals.root as breedr_flash).startProgressIndicator();
         return new Result(Result.TRANSITION,new Login(lmachine));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      lmachine.rootView.mainBox.removeChild(this._splash);
      (UIGlobals.root as breedr_flash).invalidateDisplayList();
   }
   
   private function onSplashComplete(param1:Event) : void
   {
      this._splashComplete = true;
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.containers.Canvas;
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Button;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.gadgets.LoginWindow;
import com.edgebee.atlas.ui.skins.LinkButtonSkin;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.ui.BreedrPreloader;
import com.edgebee.breedr.ui.LogoSplash;
import flash.events.Event;
import flash.events.MouseEvent;

class Login extends RootViewMachineState
{
    
   
   private var _loggedIn:Boolean = false;
   
   public var eaLink:Canvas;
   
   private var _layout:Array;
   
   public function Login(param1:RootViewMachine)
   {
      this._layout = [{
         "CLASS":Canvas,
         "ID":"eaLink",
         "percentWidth":1,
         "percentHeight":1,
         "CHILDREN":[{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_TOP,
            "STYLES":{"Padding":20},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "source":BreedrPreloader.BreedrSplashPng,
               "width":UIGlobals.relativize(768),
               "height":UIGlobals.relativize(384)
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "STYLES":{"Padding":10},
            "CHILDREN":[{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "horizontalAlign":Box.ALIGN_CENTER,
               "layoutInvisibleChildren":false,
               "STYLES":{
                  "Padding":5,
                  "BackgroundColor":5592405,
                  "BackgroundAlpha":0.3,
                  "CornerRadius":10
               },
               "CHILDREN":[{
                  "CLASS":Box,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "visible":UIGlobals.root.client.isForeign,
                  "CHILDREN":[{
                     "CLASS":BitmapComponent,
                     "width":24,
                     "height":24,
                     "source":LogoSplash.EdgeArcadeButtonPng
                  },{
                     "CLASS":Button,
                     "STYLES":{
                        "Skin":LinkButtonSkin,
                        "FontSize":14,
                        "FontColor":16777215,
                        "CapitalizeFirst":false
                     },
                     "label":"http://www.edgebee.com",
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":"onLinkClick"
                     }]
                  }]
               },{
                  "CLASS":Box,
                  "STYLES":{"Gap":10},
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "CHILDREN":[{
                     "CLASS":Label,
                     "text":"Server version: " + client.serverVersion.toString(),
                     "STYLES":{
                        "FontColor":5592405,
                        "FontSize":9
                     }
                  },{
                     "CLASS":Label,
                     "text":"Client version: " + UIGlobals.root.buildVersion,
                     "STYLES":{
                        "FontColor":5592405,
                        "FontSize":9
                     }
                  },{
                     "CLASS":Label,
                     "text":"Minimum client: " + client.minClientVersion.toString(),
                     "STYLES":{
                        "FontColor":5592405,
                        "FontSize":9
                     }
                  }]
               }]
            }]
         }]
      }];
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      lmachine.rootView.toLoginWindow();
      lmachine.rootView.loginWindow.addEventListener(LoginWindow.LOGIN_COMPLETE,this.onLoginComplete);
      UIUtils.performLayout(this,lmachine.rootView,this._layout);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedIn)
      {
         return new Result(Result.TRANSITION,new Idle(lmachine));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      lmachine.rootView.removeChild(this.eaLink);
      lmachine.rootView.loginWindow.removeEventListener(LoginWindow.LOGIN_COMPLETE,this.onLoginComplete);
      lmachine.rootView.toGameView();
   }
   
   private function onLoginComplete(param1:Event) : void
   {
      this._loggedIn = true;
   }
   
   public function onLinkClick(param1:MouseEvent) : void
   {
      client.toPortal();
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import flash.events.Event;
import flash.external.ExternalInterface;

class Idle extends RootViewMachineState
{
    
   
   private var _loggedOut:Boolean = false;
   
   private var _reset:Boolean = false;
   
   public function Idle(param1:RootViewMachine)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      client.addEventListener("Logout",this.onLogout);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._loggedOut)
      {
         if(UIGlobals.root.client.isHosted)
         {
            return Result.STOP;
         }
         return new Result(Result.TRANSITION,new Goodbye(lmachine));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      if(UIGlobals.root.client.isHosted)
      {
         ExternalInterface.call("doQuitGame");
      }
   }
   
   private function onLogout(param1:Event) : void
   {
      client.service.removeEventListener("Logout",this.onLogout);
      lmachine.rootView.gameView.controlBar.closeAllWindows();
      lmachine.rootView.toLoggingOutView();
      this._loggedOut = true;
   }
}

import com.edgebee.atlas.Client;
import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Button;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.skins.LinkButtonSkin;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.ui.LogoSplash;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.system.System;
import flash.text.TextFormatAlign;

class Goodbye extends RootViewMachineState
{
    
   
   private var _layout:Array;
   
   public function Goodbye(param1:RootViewMachine)
   {
      this._layout = [{
         "CLASS":Box,
         "percentWidth":1,
         "percentHeight":1,
         "direction":Box.VERTICAL,
         "horizontalAlign":Box.ALIGN_CENTER,
         "verticalAlign":Box.ALIGN_MIDDLE,
         "CHILDREN":[{
            "CLASS":Label,
            "text":Utils.htmlWrap(Asset.getInstanceByName("BREEDR_GOODBYE").value,UIGlobals.getStyle("FontFamily"),16777215,36,false,false,TextFormatAlign.CENTER),
            "useHtml":true,
            "filters":[new GlowFilter(UIUtils.adjustBrightness2(13421772,90),1,3,3,4,1,true),new GlowFilter(UIUtils.adjustBrightness2(13421772,-75),1,4,4,5)],
            "STYLES":{"FontSize":36}
         },{
            "CLASS":Spacer,
            "height":50
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "width":350,
            "horizontalAlign":Box.ALIGN_CENTER,
            "layoutInvisibleChildren":false,
            "STYLES":{
               "Padding":5,
               "BackgroundColor":5592405,
               "BackgroundAlpha":0.3,
               "CornerRadius":10
            },
            "CHILDREN":[{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "visible":!UIGlobals.root.client.isHosted,
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "width":32,
                  "height":32,
                  "source":LogoSplash.EdgeArcadeButtonPng
               },{
                  "CLASS":Button,
                  "STYLES":{
                     "Skin":LinkButtonSkin,
                     "FontColor":16777215,
                     "FontSize":16,
                     "CapitalizeFirst":false
                  },
                  "label":"http://www.edgebee.com",
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onLinkClick
                  }]
               }]
            },{
               "CLASS":Spacer,
               "height":30,
               "visible":client.user.anonymous && !client.isKongregate
            },{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "visible":client.user.anonymous && !client.isKongregate,
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "STYLES":{"Gap":5},
               "CHILDREN":[{
                  "CLASS":Label,
                  "text":Asset.getInstanceByName("ANONYMOUS_ID"),
                  "STYLES":{"FontSize":12}
               },{
                  "CLASS":Label,
                  "mouseChildren":false,
                  "buttonMode":true,
                  "useHandCursor":true,
                  "text":client.user.name.toUpperCase(),
                  "toolTip":Asset.getInstanceByName("CLICK_TO_CLIPBOARD"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onAnonymousLblClick"
                  }],
                  "STYLES":{
                     "FontFamily":"courier new",
                     "FontSize":12,
                     "FontColor":16777096,
                     "FontWeight":"bold"
                  }
               }]
            }]
         }]
      }];
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      UIUtils.performLayout(this,lmachine.rootView,this._layout);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
   
   private function onLinkClick(param1:MouseEvent) : void
   {
      var _loc2_:URLRequest = new URLRequest("http://www.edgebee.com/signin");
      if(lmachine.rootView.client.mode == Client.DEVELOPER)
      {
         _loc2_.url = "http://127.0.0.1:8000/signin";
      }
      _loc2_.method = URLRequestMethod.POST;
      _loc2_.data = new URLVariables();
      _loc2_.data.username = lmachine.rootView.client.username;
      _loc2_.data.password = lmachine.rootView.client.password;
      _loc2_.data.remember = "on";
      navigateToURL(_loc2_);
   }
   
   public function onAnonymousLblClick(param1:MouseEvent) : void
   {
      System.setClipboard(client.username);
   }
}
