package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.User;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.skins.PersistentTooltipSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class PlayerLabel extends Box
   {
      
      public static var LevelGoldPng:Class = PlayerLabel_LevelGoldPng;
      
      public static var LevelSilverPng:Class = PlayerLabel_LevelSilverPng;
      
      public static var LevelBronzePng:Class = PlayerLabel_LevelBronzePng;
      
      private static const MAX_ERRORS:int = 25;
       
      
      private var _iconSize:int = 16;
      
      private var _extraLinks:Dictionary;
      
      public var avatarImg:com.edgebee.atlas.ui.controls.SWFLoader;
      
      public var levelImg:com.edgebee.atlas.ui.controls.BitmapComponent;
      
      public var nameCvs:Canvas;
      
      public var nameLbl:com.edgebee.atlas.ui.controls.GradientLabel;
      
      private var _player:WeakReference;
      
      public var tooltipAvatarImg:com.edgebee.atlas.ui.controls.SWFLoader;
      
      public var tooltipNameLbl:com.edgebee.atlas.ui.controls.GradientLabel;
      
      public var addFriendBtn:com.edgebee.atlas.ui.controls.Button;
      
      private var _toolTipBox:Box;
      
      public var extraLinksBox:Box;
      
      private var _avatarErrors:int = 0;
      
      private var _layout:Array;
      
      private var _toolTipUI:Array;
      
      public function PlayerLabel()
      {
         this._player = new WeakReference(null,Player);
         this._layout = [{
            "CLASS":com.edgebee.atlas.ui.controls.SWFLoader,
            "ID":"avatarImg",
            "width":"{iconSize}",
            "height":"{iconSize}"
         },{
            "CLASS":Spacer,
            "width":2
         },{
            "CLASS":com.edgebee.atlas.ui.controls.BitmapComponent,
            "ID":"levelImg",
            "visible":false,
            "width":"{iconSize}",
            "height":"{iconSize}"
         },{
            "CLASS":Spacer,
            "width":1
         },{
            "CLASS":Canvas,
            "ID":"nameCvs",
            "height":"{iconSize}",
            "CHILDREN":[{
               "CLASS":com.edgebee.atlas.ui.controls.GradientLabel,
               "ID":"nameLbl",
               "STYLES":{"CapitalizeFirst":false}
            }]
         }];
         this._toolTipUI = [{
            "CLASS":Box,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":com.edgebee.atlas.ui.controls.SWFLoader,
               "ID":"tooltipAvatarImg",
               "width":32,
               "height":32,
               "maintainAspectRatio":true
            },{
               "CLASS":com.edgebee.atlas.ui.controls.GradientLabel,
               "ID":"tooltipNameLbl"
            }]
         },{
            "CLASS":com.edgebee.atlas.ui.controls.Button,
            "ID":"addFriendBtn",
            "label":Asset.getInstanceByName("ADD_AS_FRIEND"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onAddAsFriendClick"
            }],
            "STYLES":{"Skin":LinkButtonSkin}
         },{
            "CLASS":Box,
            "ID":"extraLinksBox",
            "visible":false,
            "direction":Box.VERTICAL,
            "CHILDREN":[]
         }];
         super();
         layoutInvisibleChildren = false;
         spreadProportionality = false;
         horizontalAlign = Box.ALIGN_LEFT;
         verticalAlign = Box.ALIGN_MIDDLE;
         setStyle("TooltipSkin",PersistentTooltipSkin);
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get player() : Player
      {
         return this._player.get() as Player;
      }
      
      public function set player(param1:Player) : void
      {
         this._player.reset(param1);
         this.update();
      }
      
      public function get iconSize() : int
      {
         return this._iconSize;
      }
      
      public function set iconSize(param1:int) : void
      {
         this._iconSize = param1;
         this.update();
      }
      
      public function get extraLinks() : Dictionary
      {
         return this._extraLinks;
      }
      
      public function set extraLinks(param1:Dictionary) : void
      {
         this._extraLinks = param1;
         this.updateLinks();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.avatarImg.addEventListener(com.edgebee.atlas.ui.controls.SWFLoader.LOAD_ERROR,this.onAvatarLoadError);
         this.nameLbl.setStyle("FontSize",getStyle("FontSize"));
         this.nameLbl.setStyle("FontColor",getStyle("FontColor"));
         this.nameLbl.setStyle("FontWeight",getStyle("FontWeight"));
         this._toolTipBox = new Box(Box.VERTICAL);
         this._toolTipBox.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,this._toolTipBox,this._toolTipUI);
         this.tooltipNameLbl.setStyle("FontSize",getStyle("FontSize"));
         this.tooltipNameLbl.setStyle("FontColor",getStyle("FontColor"));
         this.tooltipNameLbl.setStyle("FontWeight",getStyle("FontWeight"));
         this.update();
      }
      
      private function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.player && this.player.name && this.player.name.length > 0)
            {
               if(this.player.name == this.client.basePlayer.name && this.client.user.anonymous)
               {
                  this.avatarImg.source = null;
                  this.tooltipAvatarImg.source = null;
                  this.tooltipNameLbl.text = "";
                  this.addFriendBtn.visible = false;
                  this.extraLinksBox.visible = false;
                  this.nameLbl.text = Asset.getInstanceByName("GUEST");
                  this.nameLbl.setStyle("FontWeight","normal");
                  if(this.player.name == this.client.basePlayer.name)
                  {
                     this.nameLbl.colors = [13434828,11193514];
                  }
                  else
                  {
                     this.nameLbl.colors = [16777215,13421772];
                  }
               }
               else
               {
                  this.avatarImg.source = this.player.avatarUrlSmall;
                  this.tooltipAvatarImg.source = this.avatarImg.source;
                  this.nameLbl.text = this.player.name;
                  this.tooltipNameLbl.text = this.player.name;
                  toolTip = this._toolTipBox;
                  this.addFriendBtn.visible = this.player.name != this.client.basePlayer.name && this.client.user.friends.indexOf(this.player.name) == -1;
                  this.extraLinksBox.visible = this.player.name != this.client.basePlayer.name;
                  this.nameLbl.colors = [16777215,13421772];
                  if(this.player.name == this.client.basePlayer.name)
                  {
                     this.nameLbl.colors = [13434828,11193514];
                  }
                  else if(this.client.user.friends.indexOf(this.player.name) >= 0)
                  {
                     this.nameLbl.colors = [16777096,14535782];
                  }
                  else
                  {
                     this.nameLbl.colors = [16777215,13421772];
                  }
                  this.nameLbl.setStyle("FontWeight",this.player.name == this.client.basePlayer.name ? "bold" : "normal");
               }
               if(this.player.user_level == User.FANATIC)
               {
                  this.levelImg.source = LevelGoldPng;
                  this.levelImg.visible = true;
               }
               else if(this.player.user_level == User.SUPPORTER)
               {
                  this.levelImg.source = LevelSilverPng;
                  this.levelImg.visible = true;
               }
               else if(this.player.user_level == User.CONTRIBUTOR)
               {
                  this.levelImg.source = LevelBronzePng;
                  this.levelImg.visible = true;
               }
               else
               {
                  this.levelImg.source = null;
                  this.levelImg.visible = false;
               }
               validateNow(true);
               this.avatarImg.width = this._iconSize;
               this.avatarImg.height = this._iconSize;
               this.levelImg.width = this._iconSize;
               this.levelImg.height = this._iconSize;
               this.nameCvs.height = this._iconSize;
               if(this.nameLbl.height > this.nameCvs.height)
               {
                  this.nameLbl.y = -(this.nameLbl.height - this.nameCvs.height) / 2;
               }
               else
               {
                  this.nameLbl.y = 0;
               }
               this.nameCvs.width = this.nameLbl.width;
            }
            else
            {
               this.avatarImg.source = null;
               this.tooltipAvatarImg.source = null;
               this.nameLbl.text = "";
               this.nameLbl.setStyle("FontWeight","normal");
               this.nameLbl.colors = [16777215,13421772];
               this.tooltipNameLbl.text = "";
               this.addFriendBtn.visible = false;
               this.extraLinksBox.visible = false;
               this.levelImg.source = null;
               this.levelImg.visible = false;
            }
         }
         this.updateLinks();
      }
      
      private function updateLinks() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:com.edgebee.atlas.ui.controls.Button = null;
         if(this.extraLinksBox)
         {
            this.extraLinksBox.removeAllChildren();
            for(_loc1_ in this.extraLinks)
            {
               _loc2_ = new com.edgebee.atlas.ui.controls.Button();
               _loc2_.setStyle("Skin",LinkButtonSkin);
               _loc2_.label = _loc1_;
               _loc2_.addEventListener(MouseEvent.CLICK,this.extraLinks[_loc1_]);
               this.extraLinksBox.addChild(_loc2_);
            }
         }
      }
      
      public function onAddAsFriendClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.player_name = this.player.name;
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.AddFriend(_loc2_);
         if(this.client.user.friends.indexOf(this.player.name) == -1)
         {
            this.client.user.friends.push(this.player.name);
            this.update();
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "AddFriend")
         {
            if(param1.exception.cls == "AlreadyFriendsWith")
            {
               param1.handled = true;
            }
            this.client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
         }
      }
      
      private function onStyleChange(param1:StyleChangedEvent) : void
      {
         if(param1.style == "FontColor")
         {
            if(this.nameLbl)
            {
               this.nameLbl.setStyle(param1.style,param1.newValue);
            }
         }
         if(param1.style == "FontSize")
         {
            if(this.nameLbl)
            {
               this.nameLbl.setStyle(param1.style,param1.newValue);
            }
         }
      }
      
      private function onAvatarLoadError(param1:ExtendedEvent) : void
      {
      }
   }
}
