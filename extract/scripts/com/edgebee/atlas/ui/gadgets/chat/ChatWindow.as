package com.edgebee.atlas.ui.gadgets.chat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.chat.Channel;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ChatEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.LoggingBox;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.skins.ButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class ChatWindow extends Window
   {
      
      public static const LAYOUT_MODE_NORMAL:String = "LAYOUT_MODE_NORMAL";
      
      public static const LAYOUT_MODE_VERTICAL:String = "LAYOUT_MODE_VERTICAL";
      
      public static const LAYOUT_MODE_HORIZONTAL:String = "LAYOUT_MODE_HORIZONTAL";
      
      public static var ChatIconPng:Class = ChatWindow_ChatIconPng;
      
      public static const CHAT_TEXT_NORMAL_WIDTH:Number = UIGlobals.relativize(600);
      
      public static const CHAT_TEXT_NORMAL_HEIGHT:Number = UIGlobals.relativize(450);
      
      public static const CHAT_TEXT_VERTICAL_WIDTH:Number = UIGlobals.relativize(200);
      
      public static const CHAT_TEXT_VERTICAL_HEIGHT:Number = UIGlobals.relativize(340);
      
      private static var _fadeAnim:Animation;
       
      
      private var _fadeAnimInstance:AnimationInstance;
      
      private var _layoutFromCookie:Boolean = false;
      
      private var _layoutMode:String = "LAYOUT_MODE_NORMAL";
      
      private var _channels:DataArray;
      
      private var _lastChannel:String;
      
      public var chatLog:LoggingBox;
      
      public var chatTxt:TextInput;
      
      public var plyrList:List;
      
      public var plyrListBox:Box;
      
      public var sendBtn:Button;
      
      public var channelBox:Box;
      
      private var _channelGroup:RadioButtonGroup;
      
      public var channelButtons:Array;
      
      public var channel1:RadioButton;
      
      public var channel2:RadioButton;
      
      public var channel3:RadioButton;
      
      public var channel4:RadioButton;
      
      public var channel5:RadioButton;
      
      public var channel6:RadioButton;
      
      public var channel7:RadioButton;
      
      public var channel8:RadioButton;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function ChatWindow()
      {
         this._channels = new DataArray(Channel.classinfo);
         this._statusBarLayout = [{
            "CLASS":TextInput,
            "ID":"chatTxt",
            "percentWidth":1,
            "multiline":false,
            "maxChars":128
         },{
            "CLASS":Button,
            "ID":"sendBtn",
            "label":Asset.getInstanceByName("SUBMIT"),
            "enabled":true,
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onSendClick"
            }]
         }];
         this._contentLayout = [{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "layoutInvisibleChildren":false,
            "spreadProportionality":false,
            "STYLES":{"Gap":2},
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"channelBox",
               "direction":Box.HORIZONTAL,
               "percentWidth":1,
               "layoutInvisibleChildren":false,
               "STYLES":{"Gap":3},
               "CHILDREN":[{
                  "CLASS":RadioButton,
                  "ID":"channel1",
                  "label":"Channel 1",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel2",
                  "label":"Channel 2",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel3",
                  "label":"Channel 3",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel4",
                  "label":"Channel 4",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel5",
                  "label":"Channel 5",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel6",
                  "label":"Channel 6",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel7",
                  "label":"Channel 7",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"channel8",
                  "label":"Channel 8",
                  "visible":false,
                  "STYLES":{
                     "Skin":UIGlobals.getStyle("Button.Skin",ButtonSkin),
                     "FontSize":UIGlobals.relativizeFont(12),
                     "PaddingTop":UIGlobals.relativize(3),
                     "PaddingBottom":UIGlobals.relativize(3),
                     "PaddingRight":UIGlobals.relativize(5),
                     "PaddingLeft":UIGlobals.relativize(5),
                     "ShowBorder":false
                  }
               }]
            },{
               "CLASS":Box,
               "direction":Box.HORIZONTAL,
               "STYLES":{"Gap":2},
               "layoutInvisibleChildren":false,
               "spreadProportionality":false,
               "CHILDREN":[{
                  "CLASS":LoggingBox,
                  "ID":"chatLog",
                  "maxCharacters":8192,
                  "width":CHAT_TEXT_NORMAL_WIDTH,
                  "height":CHAT_TEXT_NORMAL_HEIGHT,
                  "STYLES":{
                     "BackgroundAlpha":0.5,
                     "BackgroundColor":0,
                     "FontSize":UIGlobals.relativize(16)
                  }
               },{
                  "CLASS":Box,
                  "ID":"plyrListBox",
                  "width":UIGlobals.relativizeX(170),
                  "horizontalAlign":Box.ALIGN_RIGHT,
                  "verticalAlign":Box.ALIGN_BOTTOM,
                  "layoutInvisibleChildren":false,
                  "CHILDREN":[{
                     "CLASS":List,
                     "animated":false,
                     "ID":"plyrList",
                     "percentHeight":1,
                     "percentWidth":1,
                     "renderer":ChatPlayer,
                     "showBorder":false,
                     "selectable":false,
                     "highlightable":false,
                     "animated":false,
                     "STYLES":{
                        "BackgroundAlpha":0.5,
                        "BackgroundColor":0
                     }
                  },{
                     "CLASS":ScrollBar,
                     "percentHeight":1,
                     "scrollable":"{plyrList}"
                  }]
               }]
            }]
         }];
         super();
         rememberPositionId = "ChatWindow";
         super.visible = false;
         UIGlobals.root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(Component.CHILDREN_CREATED,this.onChildrenCreated);
         client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         client.chatManager.addEventListener(ChatEvent.AUTHORIZATION_REQUIRED,this.onAuthRequired);
         client.chatManager.addEventListener(ChatEvent.AUTHORIZED,this.onAuthorized);
         client.chatManager.addEventListener(ChatEvent.CONNECTING,this.onConnecting);
         client.chatManager.addEventListener(ChatEvent.CONNECT,this.onConnect);
         client.chatManager.addEventListener(ChatEvent.DISCONNECT,this.onDisconnect);
         client.chatManager.addEventListener(ChatEvent.ABORT,this.onAbort);
         client.chatManager.addEventListener(ChatEvent.RECONNECT,this.onReconnect);
         client.chatManager.addEventListener(ChatEvent.ERROR,this.onError);
         client.chatManager.addEventListener(ChatEvent.CHANNEL_MEMBERS,this.onChannelMembers);
         client.chatManager.addEventListener(ChatEvent.JOIN_CHANNEL,this.onJoinChannel);
         client.chatManager.addEventListener(ChatEvent.LEAVE_CHANNEL,this.onLeaveChannel);
         client.chatManager.addEventListener(ChatEvent.NOTICE,this.onNotice);
         client.chatManager.addEventListener(ChatEvent.MESSAGE,this.onMessage);
         client.chatManager.addEventListener(ChatEvent.WHISPER,this.onWhisper);
      }
      
      public static function decorateGlobal(param1:String) : String
      {
         return Utils.htmlWrap(param1,null,16777130,0,true);
      }
      
      public static function decorateLog(param1:String, param2:Boolean = false) : String
      {
         return Utils.htmlWrap(param1,null,13421772,0,param2);
      }
      
      public static function decorateError(param1:String) : String
      {
         return Utils.htmlWrap(param1,null,16733525,0,true);
      }
      
      public static function decorateName(param1:String, param2:Boolean = false) : String
      {
         if(param2)
         {
            return Utils.htmlWrap(param1,null,16755455,0,true,true);
         }
         if(client.user.name == param1)
         {
            return Utils.htmlWrap(param1,null,11206570,0,true);
         }
         if(client.user.friends.indexOf(param1) >= 0)
         {
            return Utils.htmlWrap(param1,null,16777130,0,true);
         }
         return Utils.htmlWrap(param1,null,13421823,0,true);
      }
      
      public static function decorateJoin(param1:String) : String
      {
         return Utils.htmlWrap(param1,null,11184895,0,false,true);
      }
      
      public static function decorateLeave(param1:String) : String
      {
         return Utils.htmlWrap(param1,null,16755370,0,false,true);
      }
      
      public function get channels() : DataArray
      {
         return this._channels;
      }
      
      override public function get styleClassName() : String
      {
         return "ChatWindow";
      }
      
      public function get activeChannel() : Channel
      {
         if(this._channelGroup.selected)
         {
            return this._channelGroup.selected.userData as Channel;
         }
         return null;
      }
      
      public function get layoutMode() : String
      {
         return this._layoutMode;
      }
      
      public function set layoutMode(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._layoutMode != param1)
         {
            _loc2_ = this._layoutMode;
            this._layoutMode = param1;
            if(this.layoutMode == LAYOUT_MODE_VERTICAL)
            {
               this.plyrListBox.visible = false;
               this.chatLog.width = CHAT_TEXT_VERTICAL_WIDTH;
               this.chatLog.height = CHAT_TEXT_VERTICAL_HEIGHT;
               alpha = 0.8;
               if(_loc2_ == LAYOUT_MODE_NORMAL && !this._layoutFromCookie)
               {
                  UIGlobals.popUpManager.movePopUp(this,UIGlobals.relativizeX(170) + (CHAT_TEXT_NORMAL_WIDTH - CHAT_TEXT_VERTICAL_WIDTH),0);
                  saveWinPosition();
               }
               addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            }
            else if(this.layoutMode == LAYOUT_MODE_HORIZONTAL)
            {
               this.plyrListBox.visible = false;
               this.chatLog.width = UIGlobals.relativizeX(330);
               this.chatLog.height = UIGlobals.relativizeY(200);
               alpha = 0.8;
            }
            else
            {
               this.plyrListBox.visible = true;
               this.chatLog.width = CHAT_TEXT_NORMAL_WIDTH;
               this.chatLog.height = CHAT_TEXT_NORMAL_HEIGHT;
               alpha = 1;
               if(_loc2_ == LAYOUT_MODE_VERTICAL && !this._layoutFromCookie)
               {
                  UIGlobals.popUpManager.movePopUp(this,-(UIGlobals.relativizeX(170) + (CHAT_TEXT_NORMAL_WIDTH - CHAT_TEXT_VERTICAL_WIDTH)),0);
                  saveWinPosition();
               }
               removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
               this.fadeIn();
            }
            this.saveWinLayoutMode();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"layoutMode",_loc2_,this.layoutMode));
         }
      }
      
      public function dispose() : void
      {
         UIGlobals.root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         client.chatManager.removeEventListener(ChatEvent.AUTHORIZATION_REQUIRED,this.onAuthRequired);
         client.chatManager.removeEventListener(ChatEvent.AUTHORIZED,this.onAuthorized);
         client.chatManager.removeEventListener(ChatEvent.CONNECT,this.onConnect);
         client.chatManager.removeEventListener(ChatEvent.DISCONNECT,this.onDisconnect);
         client.chatManager.removeEventListener(ChatEvent.RECONNECT,this.onReconnect);
         client.chatManager.removeEventListener(ChatEvent.ERROR,this.onError);
         client.chatManager.removeEventListener(ChatEvent.CHANNEL_MEMBERS,this.onChannelMembers);
         client.chatManager.removeEventListener(ChatEvent.JOIN_CHANNEL,this.onJoinChannel);
         client.chatManager.removeEventListener(ChatEvent.LEAVE_CHANNEL,this.onLeaveChannel);
         client.chatManager.removeEventListener(ChatEvent.MESSAGE,this.onMessage);
         client.chatManager.removeEventListener(ChatEvent.WHISPER,this.onWhisper);
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            client.basePlayer.new_whisper = false;
            if(x + width > UIGlobals.root.stage.stageWidth || y + height > UIGlobals.root.stage.stageHeight)
            {
               UIGlobals.popUpManager.centerPopUp(this);
            }
            if(client.user.registered && !client.chatManager.connected)
            {
               client.chatManager.connect();
            }
         }
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Track = null;
         super.createChildren();
         content.direction = Box.HORIZONTAL;
         content.layoutInvisibleChildren = false;
         title = Asset.getInstanceByName("CHAT");
         titleIcon = UIUtils.createBitmapIcon(ChatIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         this.plyrList.addEventListener(ChatPlayer.PLAYER_DBCLICK,this.onPlayerDblClick);
         statusBar.horizontalAlign = Box.ALIGN_RIGHT;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",5);
         statusBar.percentWidth = 1;
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this._channelGroup = new RadioButtonGroup();
         this._channelGroup.addButton(this.channel1);
         this._channelGroup.addButton(this.channel2);
         this._channelGroup.addButton(this.channel3);
         this._channelGroup.addButton(this.channel4);
         this._channelGroup.addButton(this.channel5);
         this._channelGroup.addButton(this.channel6);
         this._channelGroup.addButton(this.channel7);
         this._channelGroup.addButton(this.channel8);
         this._channelGroup.selected = this.channel1;
         this._channelGroup.addEventListener(Event.CHANGE,this.onChannelChange);
         this.channelButtons = [this.channel1,this.channel2,this.channel3,this.channel4,this.channel5,this.channel6,this.channel7,this.channel8];
         if(!_fadeAnim)
         {
            _fadeAnim = new Animation();
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(1,0.7));
            _fadeAnim.addTrack(_loc1_);
         }
         this._fadeAnimInstance = controller.addAnimation(_fadeAnim);
         if(client.userCookie._ui.windows.hasOwnProperty(rememberPositionId))
         {
            this._layoutFromCookie = true;
            this.layoutMode = client.userCookie._ui.windows[rememberPositionId].layoutMode;
         }
      }
      
      public function getChannel(param1:String) : Channel
      {
         var _loc2_:Channel = null;
         for each(_loc2_ in this.channels)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function isIgnored(param1:String) : Boolean
      {
         return this.ignoreList.indexOf(param1) >= 0;
      }
      
      private function saveWinLayoutMode() : void
      {
         if(childrenCreated && rememberPosition)
         {
            if(!client.userCookie._ui.windows.hasOwnProperty(rememberPositionId))
            {
               client.userCookie._ui.windows[rememberPositionId] = new Object();
               client.userCookie._ui.windows[rememberPositionId].x = x;
               client.userCookie._ui.windows[rememberPositionId].y = y;
            }
            client.userCookie._ui.windows[rememberPositionId].layoutMode = this.layoutMode;
            client.saveCookie();
         }
         this._layoutFromCookie = false;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.fadeIn();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.fadeOut();
      }
      
      private function fadeOut(param1:Boolean = false) : void
      {
         if(alpha <= 0.7)
         {
            return;
         }
         var _loc2_:Rectangle = new Rectangle(0,0,width,height);
         if(_loc2_.contains(mouseX,mouseY))
         {
            return;
         }
         if(this._fadeAnimInstance.playing)
         {
            this._fadeAnimInstance.speed = 1;
         }
         else
         {
            this._fadeAnimInstance.gotoStartAndPlay();
         }
      }
      
      private function fadeIn() : void
      {
         if(alpha == 1)
         {
            return;
         }
         if(this._fadeAnimInstance.playing)
         {
            this._fadeAnimInstance.speed = -2;
         }
         else
         {
            this._fadeAnimInstance.gotoEndAndPlayReversed();
            this._fadeAnimInstance.speed = -2;
         }
      }
      
      public function onSendClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         if(Boolean(this.chatTxt.text) && this.chatTxt.text.length > 0)
         {
            if(!client.chatManager.connected)
            {
               this.chatLog.print("*Not connected* " + this.chatTxt.text);
               this.chatLog.flush();
            }
            else if(this.chatTxt.text.search(/^\/whisper/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/whisper\s+"(?P<name>.*[^"])"\s+(?P<message>.*)/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("name") || !_loc2_.hasOwnProperty("message"))
               {
                  this.chatLog.print("/whisper \"name\" message...");
                  this.chatLog.flush();
               }
               else
               {
                  this.chatLog.print("Whisper sent to " + _loc2_.name + ": " + _loc2_.message);
                  this.chatLog.flush();
                  client.chatManager.sendWhisper(_loc2_.name,_loc2_.message);
               }
            }
            else if(this.chatTxt.text.search(/^\/join/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/join\s+(?P<channel>[_a-zA-Z0-9]+)/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("channel"))
               {
                  this.chatLog.print("/join channel");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.joinChannel(_loc2_.channel);
               }
            }
            else if(this.chatTxt.text.search(/^\/create/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/create\s+(?P<channel>[_a-zA-Z0-9]+)/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("channel"))
               {
                  this.chatLog.print("/create channel");
                  this.chatLog.flush();
               }
               else
               {
                  this.createChannel(_loc2_.channel);
               }
            }
            else if(this.chatTxt.text.search(/^\/sustain/) >= 0)
            {
               if(this.activeChannel.creator_id > 0)
               {
                  this.sustainChannel(this.activeChannel.name);
               }
            }
            else if(this.chatTxt.text.search(/^\/status/) >= 0)
            {
               client.chatManager.getStatus(this.activeChannel.name);
            }
            else if(this.chatTxt.text.search(/^\/help/) >= 0 || Boolean(this.chatTxt.text.search(/^\/?/)))
            {
               client.chatManager.getHelp();
            }
            else if(this.chatTxt.text.search(/^\/add_moderator/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/add_moderator\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/add_moderator \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.addModerator(this.activeChannel.name,_loc2_.user);
               }
            }
            else if(this.chatTxt.text.search(/^\/remove_moderator/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/remove_moderator\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/remove_moderator \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.removeModerator(this.activeChannel.name,_loc2_.user);
               }
            }
            else if(this.chatTxt.text.search(/^\/add_ban/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/add_ban\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/add_ban \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.addBan(this.activeChannel.name,_loc2_.user);
               }
            }
            else if(this.chatTxt.text.search(/^\/remove_ban/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/remove_ban\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/remove_ban \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.removeBan(this.activeChannel.name,_loc2_.user);
               }
            }
            else if(this.chatTxt.text.search(/^\/kick/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/kick\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/kick \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.kick(this.activeChannel.name,_loc2_.user);
               }
            }
            else if(this.chatTxt.text.search(/^\/mute/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/mute\s+"(?P<user>.*[^"])"\s+(?P<minutes>\d+)/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/mute \"name\" minutes");
                  this.chatLog.flush();
               }
               else
               {
                  client.chatManager.mute(_loc2_.user,uint(_loc2_.minutes));
               }
            }
            else if(this.chatTxt.text.search(/^\/ignore/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/ignore\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/ignore \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  this.addIgnore(_loc2_.user);
                  this.chatLog.print(Utils.formatString(Asset.getInstanceByName("CHAT_IGNORE").value,{"name":_loc2_.user}));
                  this.chatLog.flush();
               }
               this.printIgnoreList();
            }
            else if(this.chatTxt.text.search(/^\/unignore/) >= 0)
            {
               _loc2_ = this.chatTxt.text.match(/^\/unignore\s+"(?P<user>.*[^"])"/);
               if(!_loc2_ || !_loc2_.hasOwnProperty("user"))
               {
                  this.chatLog.print("/unignore \"name\"");
                  this.chatLog.flush();
               }
               else
               {
                  this.removeIgnore(_loc2_.user);
                  this.chatLog.print(Utils.formatString(Asset.getInstanceByName("CHAT_UNIGNORE").value,{"name":_loc2_.user}));
                  this.chatLog.flush();
               }
               this.printIgnoreList();
            }
            else if(this.chatTxt.text.search(/^\/leave/) >= 0)
            {
               client.chatManager.leaveChannel(this.activeChannel.name);
            }
            else
            {
               client.chatManager.sendMessage(this.activeChannel.name,this.chatTxt.text);
            }
            this.chatTxt.text = "";
         }
      }
      
      private function addIgnore(param1:String) : void
      {
         if(!this.isIgnored(param1))
         {
            this.ignoreList.push(param1);
            client.saveCookie();
         }
      }
      
      private function removeIgnore(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.isIgnored(param1))
         {
            _loc2_ = this.ignoreList.indexOf(param1);
            this.ignoreList.splice(_loc2_,1);
            client.userCookie.chatIgnoreList = this.ignoreList;
            client.saveCookie();
         }
      }
      
      private function get ignoreList() : Array
      {
         if(!client.userCookie.hasOwnProperty("chatIgnoreList") || !(client.userCookie.chatIgnoreList is Array))
         {
            client.userCookie.chatIgnoreList = new Array();
            client.saveCookie();
         }
         return client.userCookie.chatIgnoreList;
      }
      
      private function printIgnoreList() : void
      {
         if(this.ignoreList.length)
         {
            this.chatLog.print(Asset.getInstanceByName("CHAT_IGNORE_LIST").value);
            this.chatLog.flush();
            this.chatLog.print(this.ignoreList.join(", "));
            this.chatLog.flush();
         }
      }
      
      private function onChildrenCreated(param1:Event) : void
      {
         if(client.user.registered)
         {
            client.chatManager.connect();
         }
      }
      
      private function onChannelChange(param1:ExtendedEvent) : void
      {
         this.chatLog.channel = this.activeChannel.name;
         this.plyrList.dataProvider = new ArrayCollection();
         this.plyrList.dataProvider = this.activeChannel.members;
         var _loc2_:RadioButton = this.channelButtons[this.channels.getItemIndex(this.activeChannel)];
         _loc2_.glowProxy.reset();
         _loc2_.colorTransformProxy.reset();
      }
      
      private function printToChannel(param1:String, param2:String = null) : void
      {
         var _loc3_:Channel = null;
         var _loc4_:RadioButton = null;
         if(!param2 && Boolean(this.activeChannel))
         {
            param2 = this.activeChannel.name;
         }
         if(param2)
         {
            this.chatLog.print(param1,null,false,false,param2);
            this.chatLog.flush(param2);
            _loc3_ = this.getChannel(param2);
            if(Boolean(_loc3_) && _loc3_ != this.activeChannel)
            {
               (_loc4_ = this.channelButtons[this.channels.getItemIndex(_loc3_)]).glowProxy.blur = 4;
               _loc4_.glowProxy.color = UIGlobals.getStyle("FontColor");
               _loc4_.glowProxy.alpha = 0.75;
               _loc4_.colorTransformProxy.offset = 20;
            }
         }
         else
         {
            this.chatLog.print(param1,null,false,false);
            this.chatLog.flush();
         }
      }
      
      private function createChannel(param1:String) : void
      {
         this._lastChannel = param1;
         AlertWindow.show("Creating a private channel for the next 7 days, it will cost you 25 tokens.\n\nPlease click YES to confirm the purchase.","Please confirm",null,true,{"ALERT_WINDOW_YES":this.doCreateChannel},false,false,true,true);
      }
      
      private function sustainChannel(param1:String) : void
      {
         this._lastChannel = param1;
         AlertWindow.show("Sustaining a channel will cost you 5 tokens and will add 7 more days to the channel\'s expiry date.\n\nPlease click YES to confirm the purchase.","Please confirm",null,true,{"ALERT_WINDOW_YES":this.doSustainChannel},false,false,true,true);
      }
      
      private function doCreateChannel(param1:Event) : void
      {
         client.chatManager.createChannel(this._lastChannel);
      }
      
      private function doSustainChannel(param1:Event) : void
      {
         client.chatManager.sustainChannel(this._lastChannel);
      }
      
      private function onConnecting(param1:ChatEvent) : void
      {
         this.printToChannel(decorateLog(Asset.getInstanceByName("CHAT_INFO_CONNECTING").value,true));
      }
      
      private function onConnect(param1:ChatEvent) : void
      {
         this.channels.reset();
         this.printToChannel(decorateLog(Asset.getInstanceByName("CHAT_INFO_CONNECTED").value));
      }
      
      private function onDisconnect(param1:ChatEvent) : void
      {
         this.printToChannel(decorateError(Asset.getInstanceByName("CHAT_INFO_DISCONNECTED").value));
      }
      
      private function onAbort(param1:ChatEvent) : void
      {
         this.printToChannel(decorateError(Asset.getInstanceByName("CHAT_INFO_ABORT").value));
      }
      
      private function onReconnect(param1:ChatEvent) : void
      {
         this.chatLog.flush();
         this.printToChannel(decorateLog(Asset.getInstanceByName("CHAT_INFO_RECONNECTING").value));
      }
      
      private function onAuthRequired(param1:ChatEvent) : void
      {
         this.printToChannel(decorateLog(Asset.getInstanceByName("CHAT_INFO_LOGIN").value,true));
         if(client.basePlayer.foreign_type == "kongregate")
         {
            client.chatManager.sendAuth(client.kongregateApi.services.getUserId().toString(),client.kongregateApi.services.getGameAuthToken(),"kongregate");
         }
         else
         {
            client.chatManager.sendAuth(client.username,client.MD5password);
         }
      }
      
      private function onAuthorized(param1:ChatEvent) : void
      {
         var _loc2_:String = null;
         this.printToChannel(decorateLog(Asset.getInstanceByName("CHAT_INFO_AUTHORIZED").value));
         client.chatManager.joinChannel(client.name);
         if(client.userCookie.hasOwnProperty("channels"))
         {
            for each(_loc2_ in client.userCookie.channels)
            {
               client.chatManager.joinChannel(_loc2_);
            }
         }
      }
      
      private function onError(param1:ChatEvent) : void
      {
         this.printToChannel(decorateError(Utils.formatString(Asset.getInstanceByName("CHAT_INFO_ERROR").value,{"error":param1.data.toString()})));
      }
      
      private function onChannelMembers(param1:ChatEvent) : void
      {
         var _loc2_:Channel = new Channel(param1.data);
         this.channels.addItem(_loc2_);
         this.updateChannels(_loc2_);
         this.saveChannels();
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            if(client.user.registered && !client.chatManager.connected && !client.isDeveloper)
            {
               client.chatManager.connect();
            }
         }
      }
      
      private function saveChannels() : void
      {
         var _loc1_:Channel = null;
         client.userCookie.channels = [];
         for each(_loc1_ in this.channels)
         {
            if(_loc1_.nicename_id == 0)
            {
               client.userCookie.channels.push(_loc1_.name);
            }
         }
         client.saveCookie();
      }
      
      private function updateChannels(param1:Channel) : void
      {
         var _loc2_:RadioButton = null;
         var _loc3_:uint = 0;
         var _loc4_:Channel = null;
         for each(_loc2_ in this.channelButtons)
         {
            _loc3_ = uint(this.channelButtons.indexOf(_loc2_));
            if(this.channels.length > _loc3_)
            {
               _loc4_ = this.channels.getItemAt(_loc3_) as Channel;
               _loc2_.visible = true;
               _loc2_.userData = _loc4_;
               _loc2_.label = _loc4_.displayName;
               if(_loc4_ == param1)
               {
                  this._channelGroup.selected = _loc2_;
               }
            }
            else
            {
               _loc2_.visible = false;
               _loc2_.userData = null;
            }
         }
      }
      
      private function onJoinChannel(param1:ChatEvent) : void
      {
         var _loc2_:Channel = this.getChannel(param1.data.channel);
         var _loc3_:Player = new Player({
            "id":param1.data.user.id,
            "name":param1.data.user.name,
            "avatar_version":param1.data.user.avatar_version,
            "foreign_type":param1.data.user.foreign_type,
            "foreign_id":param1.data.user.foreign_id,
            "user_level":param1.data.user.c_level
         });
         _loc2_.addMember(_loc3_);
         if(this.isIgnored(_loc3_.name))
         {
            return;
         }
         var _loc4_:String = Utils.formatString(decorateJoin(Asset.getInstanceByName("CHAT_JOIN").value),{"player":_loc3_.name});
         if(!visible && client.user.friends.indexOf(_loc3_.name) >= 0)
         {
            client.basePlayer.new_whisper = true;
         }
         if(client.showChatJoinLeave || client.user.friends.indexOf(_loc3_.name) >= 0)
         {
            this.printToChannel(_loc4_,_loc2_.name);
         }
      }
      
      private function onLeaveChannel(param1:ChatEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Channel = this.getChannel(param1.data.channel);
         var _loc3_:Player = _loc2_.getChatMemberById(param1.data.id);
         if(_loc3_.id == client.user.id)
         {
            this.channels.removeItem(_loc2_);
            this.updateChannels(this.channels.getItemAt(0) as Channel);
            this.saveChannels();
         }
         else if(_loc3_)
         {
            _loc2_.members.removeItem(_loc3_);
            if(this.isIgnored(_loc3_.name))
            {
               return;
            }
            _loc4_ = Utils.formatString(decorateLeave(Asset.getInstanceByName("CHAT_LEAVE").value),{"player":_loc3_.name});
            if(!visible && client.user.friends.indexOf(_loc3_.name) >= 0)
            {
               client.basePlayer.new_whisper = true;
            }
            if(client.showChatJoinLeave || client.user.friends.indexOf(_loc3_.name) >= 0)
            {
               this.printToChannel(_loc4_,_loc2_.name);
            }
         }
      }
      
      private function onNotice(param1:ChatEvent) : void
      {
         var _loc2_:Asset = Asset.getInstanceById(param1.data.notice_id);
         var _loc3_:Object = param1.data.params;
         this.printToChannel(Utils.htmlWrap(Utils.formatString(_loc2_.value,_loc3_),null,16772778,0,true));
      }
      
      private function onMessage(param1:ChatEvent) : void
      {
         var _loc3_:Player = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Channel = this.getChannel(param1.data.channel);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getChatMemberById(param1.data.id);
            if(Boolean(_loc3_) || param1.data.hasOwnProperty("name"))
            {
               _loc4_ = !!_loc3_ ? _loc3_.name : String(param1.data.name);
               if(this.isIgnored(_loc4_))
               {
                  return;
               }
               _loc5_ = Utils.formatString(Asset.getInstanceByName("CHAT_MESSAGE").value,{
                  "player":decorateName(_loc4_),
                  "body":param1.data.message
               });
               this.printToChannel(_loc5_,_loc2_.name);
            }
         }
      }
      
      private function onWhisper(param1:ChatEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Player = new Player({
            "id":param1.data.user.id,
            "name":param1.data.user.name,
            "avatar_version":param1.data.user.avatar_version,
            "user_level":param1.data.user.c_level
         });
         if(_loc2_)
         {
            if(this.isIgnored(_loc2_.name))
            {
               return;
            }
            _loc3_ = Utils.formatString(Asset.getInstanceByName("CHAT_WHISPER").value,{
               "player":decorateName(_loc2_.name,true),
               "body":param1.data.message
            });
            if(!visible)
            {
               client.basePlayer.new_whisper = true;
            }
            this.printToChannel(_loc3_);
         }
      }
      
      public function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.target != this.chatTxt.textField)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onSendClick(null);
         }
      }
      
      private function onPlayerDblClick(param1:ExtendedEvent) : void
      {
         if(param1.data)
         {
            this.chatTxt.text = "/whisper \"" + (param1.data as Player).name + "\" ";
            stage.focus = this.chatTxt.textField;
            this.chatTxt.textField.setSelection(this.chatTxt.text.length,this.chatTxt.text.length);
         }
      }
   }
}
