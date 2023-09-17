package com.edgebee.breedr.ui.world.areas.ranch
{
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.skins.borders.GradientLineBorder;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Level;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.RanchLevel;
   import com.edgebee.breedr.data.world.Stall;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.ChangeBubble;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.creature.LevelView;
   import com.edgebee.breedr.ui.creature.PropertyView;
   import com.edgebee.breedr.ui.world.UpgradeWindow;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class StallView extends Canvas
   {
      
      public static const LockPng:Class = StallView_LockPng;
      
      public static const ArrowPng:Class = StallView_ArrowPng;
      
      private static const ICON_SIZE:Number = UIGlobals.relativize(20);
       
      
      public var moving:Boolean = false;
      
      private var _stall:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _levelBlinkAnim:AnimationInstance;
      
      private var _lastPopTime:Number = 0;
      
      private var _mouseDown:Boolean = false;
      
      private var _ranchView:com.edgebee.breedr.ui.world.areas.ranch.RanchView;
      
      public var creatureBox:Box;
      
      public var creatureView:CreatureView;
      
      private var _animatedBorder:GradientLineBorder;
      
      public var infoBox:Box;
      
      public var statsBox:Box;
      
      public var stallNameLbl:Label;
      
      public var nameBtn:Button;
      
      public var levelView:PropertyView;
      
      public var staminaLevelView:LevelView;
      
      public var happinessLevelView:LevelView;
      
      public var healthLevelView:LevelView;
      
      public var feederView:com.edgebee.breedr.ui.world.areas.ranch.FeederView;
      
      public var genderIcon:BitmapComponent;
      
      public var infoLbl:Label;
      
      public var lockBox:Box;
      
      public var upgradeBtn:Button;
      
      private var _layout:Array;
      
      public function StallView()
      {
         this._stall = new WeakReference(null,Stall);
         this._layout = [{
            "CLASS":Label,
            "ID":"stallNameLbl",
            "alpha":0.35,
            "filters":UIGlobals.fontSmallOutline,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(14)}
         },{
            "CLASS":CreatureView,
            "ID":"creatureView",
            "y":-ICON_SIZE,
            "width":"{width}",
            "height":"{height}"
         },{
            "CLASS":Box,
            "ID":"infoBox",
            "direction":Box.VERTICAL,
            "percentWidth":1,
            "percentHeight":1,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "STYLES":{"Gap":UIGlobals.relativize(-4)},
            "CHILDREN":[{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_RIGHT,
               "percentWidth":1,
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.FeederView,
                  "ID":"feederView",
                  "width":ICON_SIZE * 1.5,
                  "height":ICON_SIZE * 1.5,
                  "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
               }]
            },{
               "CLASS":Spacer,
               "percentHeight":1
            },{
               "CLASS":Box,
               "ID":"statsBox",
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "filters":UIGlobals.fontOutline,
               "horizontalAlign":Box.ALIGN_CENTER,
               "STYLES":{"Gap":UIGlobals.relativize(-3)},
               "CHILDREN":[{
                  "CLASS":Box,
                  "horizontalAlign":Box.ALIGN_LEFT,
                  "percentWidth":0.95,
                  "CHILDREN":[{
                     "CLASS":Button,
                     "ID":"nameBtn",
                     "EVENTS":[{
                        "TYPE":MouseEvent.CLICK,
                        "LISTENER":this.onMouseDoubleClick
                     }],
                     "STYLES":{
                        "Skin":LinkButtonSkin,
                        "FontSize":UIGlobals.relativizeFont(12),
                        "FontColor":16777215
                     }
                  }]
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_CENTER,
                  "STYLES":{"Gap":UIGlobals.relativize(5)},
                  "CHILDREN":[{
                     "CLASS":LevelView,
                     "ID":"staminaLevelView",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "style":LevelView.VALUE,
                     "property":"stamina",
                     "icon":com.edgebee.breedr.ui.world.areas.ranch.RanchView.StaminaIconPng,
                     "toolTip":Asset.getInstanceByName("STAMINA_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(10)}
                  },{
                     "CLASS":LevelView,
                     "ID":"happinessLevelView",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "style":LevelView.VALUE,
                     "property":"happiness",
                     "icon":com.edgebee.breedr.ui.world.areas.ranch.RanchView.HappinessIconPng,
                     "toolTip":Asset.getInstanceByName("HAPPINESS_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(10)}
                  },{
                     "CLASS":LevelView,
                     "ID":"healthLevelView",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "style":LevelView.VALUE,
                     "property":"health",
                     "icon":com.edgebee.breedr.ui.world.areas.ranch.RanchView.HealthIconPng,
                     "toolTip":Asset.getInstanceByName("HEALTH_TOOLTIP"),
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(10)}
                  },{
                     "CLASS":PropertyView,
                     "ID":"levelView",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "toolTip":Asset.getInstanceByName("LEVEL_TOOLTIP"),
                     "property":"level",
                     "icon":com.edgebee.breedr.ui.world.areas.ranch.RanchView.LevelIconPng,
                     "STYLES":{"FontSize":UIGlobals.relativizeFont(10)}
                  },{
                     "CLASS":BitmapComponent,
                     "ID":"genderIcon",
                     "width":ICON_SIZE,
                     "height":ICON_SIZE,
                     "toolTip":Asset.getInstanceByName("GENDER_TOOLTIP")
                  }]
               }]
            }]
         },{
            "CLASS":Label,
            "ID":"infoLbl",
            "alpha":0.75,
            "visible":false,
            "filters":UIGlobals.fontOutline,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(18),
               "FontWeight":"bold"
            }
         },{
            "CLASS":Box,
            "ID":"lockBox",
            "direction":Box.VERTICAL,
            "visible":false,
            "percentWidth":1,
            "percentHeight":1,
            "layoutInvisibleChildren":false,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{"Gap":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "source":LockPng,
               "filters":UIGlobals.fontOutline,
               "width":UIGlobals.relativize(64),
               "height":UIGlobals.relativize(64)
            },{
               "CLASS":Button,
               "ID":"upgradeBtn",
               "label":Asset.getInstanceByName("UPGRADE"),
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(11),
                  "Padding":UIGlobals.relativize(2)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onUpgradeClick"
               }]
            }]
         }];
         super();
         doubleClickEnabled = true;
         setStyle("BackgroundColor",[3355443,10066329]);
         setStyle("BackgroundDirection",Math.PI / 2);
         setStyle("BackgroundAlpha",0.65);
         setStyle("CornerRadius",5);
         setStyle("BorderThickness",2);
         setStyle("BorderAlpha",0.85);
         setStyle("BorderColor",[7829367,16777215]);
         setStyle("BorderDirection",3 * Math.PI / 2);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClick);
         addEventListener(DragEvent.DRAG_ENTER,this.onDragEnter);
         addEventListener(DragEvent.DRAG_EXIT,this.onDragExit);
         addEventListener(DragEvent.DRAG_DROP,this.onDragDrop);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get ranchView() : com.edgebee.breedr.ui.world.areas.ranch.RanchView
      {
         return this.gameView.ranchView;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get stall() : Stall
      {
         return this._stall.get() as Stall;
      }
      
      public function set stall(param1:Stall) : void
      {
         if(this.stall != param1)
         {
            if(this.stall)
            {
               this.stall.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onStallChange);
               this.stall.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               removeEventListener(MouseEvent.CLICK,this.onMouseClick);
               removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
               removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            }
            this._stall.reset(param1);
            if(childrenCreated)
            {
               this.update();
            }
            if(this.stall)
            {
               this.stall.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onStallChange);
               this.stall.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               addEventListener(MouseEvent.CLICK,this.onMouseClick);
               addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
               addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            }
         }
      }
      
      public function get creature() : CreatureInstance
      {
         if(this.stall)
         {
            return this.stall.creature;
         }
         return null;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.updateBorder();
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         this.updateBorder();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:BitmapComponent = null;
         super.createChildren();
         this._animatedBorder = new GradientLineBorder(this);
         this._animatedBorder.setStyle("BorderThickness",2);
         this._animatedBorder.setStyle("GradientLength",50);
         this._animatedBorder.setStyle("AnimationSpeed",0.5);
         addChild(this._animatedBorder);
         this._animatedBorder.visible = false;
         UIUtils.performLayout(this,this,this._layout);
         _loc1_ = new BitmapComponent();
         _loc1_.width = UIGlobals.relativize(20);
         _loc1_.height = UIGlobals.relativize(20);
         _loc1_.source = com.edgebee.breedr.ui.world.areas.ranch.RanchView.UpgradeIconPng;
         this.upgradeBtn.icon = _loc1_;
         this.levelView.controller.updateType = Controller.UPDATE_ON_50MS;
         this._levelBlinkAnim = this.levelView.controller.addAnimation(UIGlobals.blinkAnimation);
         this._levelBlinkAnim.synchronized = true;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function updateBorder() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.selected)
            {
               this._animatedBorder.visible = true;
               this._animatedBorder.setStyle("BorderColor",getStyle("ThemeColor2"));
            }
            else if(this.highlighted)
            {
               this._animatedBorder.visible = true;
               this._animatedBorder.setStyle("BorderColor",UIUtils.adjustBrightness2(getStyle("ThemeColor2"),35));
            }
            else
            {
               this._animatedBorder.visible = false;
            }
         }
      }
      
      private function updateUpgradeButton() : void
      {
         var _loc1_:RanchLevel = null;
         var _loc2_:Asset = null;
         if(this.upgradeBtn)
         {
            _loc1_ = RanchLevel.getInstanceByLevel(this.player.ranch_level.level + 1);
            this.upgradeBtn.enabled = this.client.criticalComms == 0 && Boolean(_loc1_) && (_loc1_.credits > 0 && this.player.credits >= _loc1_.credits || _loc1_.tokens > 0 && this.client.user.tokens >= _loc1_.tokens);
            if(_loc1_)
            {
               _loc2_ = Asset.getInstanceByName("UPGRADE_STALL_TIP");
               if(_loc1_.credits < 0)
               {
                  _loc2_ = Asset.getInstanceByName("UPGRADE_STALL_TIP_NO_CREDS");
               }
               this.upgradeBtn.toolTip = Utils.formatString(_loc2_.value,{
                  "credits":_loc1_.credits,
                  "tokens":_loc1_.tokens
               });
            }
            else
            {
               this.upgradeBtn.toolTip = "";
            }
         }
      }
      
      private function update() : void
      {
         UIGlobals.oneSecTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateHatchTime);
         UIGlobals.oneSecTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateWakeupTime);
         if(this.stall)
         {
            visible = true;
            this.stallNameLbl.text = Asset.getInstanceByName("STALL").value + " " + (this.stall.index + 1).toString();
            this.feederView.feeder = this.stall.feeder;
            this.creatureView.y = -ICON_SIZE;
            if(this.stall.locked)
            {
               this.creatureView.visible = false;
               this.infoBox.visible = false;
               this.lockBox.visible = false;
               this.stallNameLbl.visible = false;
               this.feederView.visible = false;
               this.infoLbl.visible = false;
               if(this.isFirstLockedStall)
               {
                  this.lockBox.visible = true;
                  this.upgradeBtn.visible = true;
                  this.updateUpgradeButton();
               }
               else
               {
                  visible = false;
               }
            }
            else
            {
               this.lockBox.visible = false;
               this.infoBox.visible = true;
               this.staminaLevelView.name = "StallStaminaLevel_" + this.stall.index;
               this.happinessLevelView.name = "StallHappinessLevel_" + this.stall.index;
               this.healthLevelView.name = "StallHealthLevel_" + this.stall.index;
               this.stallNameLbl.visible = true;
               this.feederView.visible = true;
               if(this.stall.creature.id > 0)
               {
                  this.statsBox.visible = !this.stall.creature.isEgg;
                  if(this.stall.creature.isEgg)
                  {
                     this.creatureView.y = 0;
                  }
                  this.creatureView.visible = true;
                  this.nameBtn.label = this.creature.name;
                  this.levelView.target = this.creature;
                  if(this.creature.modifiedSkillPoints > 0)
                  {
                     this._levelBlinkAnim.play();
                  }
                  else
                  {
                     this._levelBlinkAnim.gotoEndAndStop();
                  }
                  this.creatureView.creature = this.creature;
                  this.happinessLevelView.creature = this.creature;
                  this.healthLevelView.creature = this.creature;
                  this.staminaLevelView.creature = this.creature;
                  if(this.creature.auction_id > 0)
                  {
                     this.infoLbl.visible = true;
                     this.infoLbl.text = Asset.getInstanceByName("AUCTION").value.toLocaleUpperCase();
                     validateNow(true);
                     this.infoLbl.x = (width - this.infoLbl.width) / 2;
                     this.infoLbl.y = height / 2;
                  }
                  else if(this.creature.isEgg)
                  {
                     this.infoLbl.visible = true;
                     UIGlobals.oneSecTimer.addEventListener(TimerEvent.TIMER,this.onUpdateHatchTime);
                  }
                  else if(this.creature.stamina.index == 0)
                  {
                     this.infoLbl.visible = true;
                     UIGlobals.oneSecTimer.addEventListener(TimerEvent.TIMER,this.onUpdateWakeupTime);
                  }
                  else
                  {
                     this.infoLbl.visible = false;
                  }
                  this.genderIcon.source = this.creature.is_male ? com.edgebee.breedr.ui.world.areas.ranch.RanchView.MaleIconPng : com.edgebee.breedr.ui.world.areas.ranch.RanchView.FemaleIconPng;
                  this.onUpdateHatchTime(null);
                  this.onUpdateWakeupTime(null);
               }
               else
               {
                  this.creatureView.visible = false;
                  this.statsBox.visible = false;
                  this.infoLbl.visible = false;
               }
            }
         }
         else
         {
            visible = false;
         }
      }
      
      public function onStallChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tokens")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "credits")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:ChangeBubble = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.ranchView.visible)
         {
            switch(param1.property)
            {
               case "happiness":
                  if(this.moving || this.creature.id == 0)
                  {
                     break;
                  }
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Number) - (param1.oldValue as Number);
                  _loc2_.icon = com.edgebee.breedr.ui.world.areas.ranch.RanchView.HappinessIconPng;
                  break;
               case "stamina":
                  if(!param1.oldValue || !param1.newValue || this.moving || this.creature.id == 0)
                  {
                     break;
                  }
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Level).index - (param1.oldValue as Level).index;
                  _loc2_.icon = com.edgebee.breedr.ui.world.areas.ranch.RanchView.StaminaIconPng;
                  break;
               case "health":
                  if(this.moving || this.creature.id == 0)
                  {
                     break;
                  }
                  _loc2_ = new ChangeBubble();
                  _loc2_.delta = (param1.newValue as Number) - (param1.oldValue as Number);
                  _loc2_.icon = com.edgebee.breedr.ui.world.areas.ranch.RanchView.HealthIconPng;
                  break;
               case "is_male":
                  if(this.genderIcon)
                  {
                     this.genderIcon.source = this.creature.is_male ? com.edgebee.breedr.ui.world.areas.ranch.RanchView.MaleIconPng : com.edgebee.breedr.ui.world.areas.ranch.RanchView.FemaleIconPng;
                  }
            }
            if(_loc2_)
            {
               _loc3_ = new Point(this.creatureView.x + this.creatureView.width / 2,this.creatureView.y + this.creatureView.height);
               _loc3_ = localToGlobal(_loc3_);
               _loc3_ = this.ranchView.globalToLocal(_loc3_);
               _loc2_.center = _loc3_;
               if((_loc5_ = (_loc4_ = new Date().time) - this._lastPopTime) < 1500)
               {
                  _loc2_.delay = 1500 - _loc5_;
               }
               this._lastPopTime = _loc4_;
               this._lastPopTime += _loc2_.delay;
               this.ranchView.addChild(_loc2_);
            }
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:BitmapComponent = null;
         if(this._mouseDown && !this.stall.empty && this.creatureView.asBitmap && !this.client.criticalComms)
         {
            _loc2_ = new BitmapComponent();
            _loc2_.width = width;
            _loc2_.height = height;
            _loc2_.bitmap = new Bitmap(this.creatureView.asBitmap.bitmapData);
            if(this.creatureView.creature.isEgg)
            {
               _loc2_.colorMatrix.hue = this.creatureView.creature.hue;
            }
            UIGlobals.dragManager.doDrag(this,{"creature":this.stall.creature},_loc2_,param1,width / 2 - mouseX);
         }
      }
      
      private function onDragEnter(param1:DragEvent) : void
      {
         var _loc2_:CreatureInstance = null;
         var _loc3_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("creature"))
         {
            _loc2_ = param1.dragInfo.creature as CreatureInstance;
            if(!this.stall.locked && _loc2_.id != this.stall.creature.id)
            {
               this.creatureView.colorMatrix.brightness = 25;
               UIGlobals.dragManager.acceptDragDrop(this);
            }
         }
         else if(param1.dragInfo.hasOwnProperty("attachment_creature"))
         {
            _loc2_ = param1.dragInfo.attachment_creature as CreatureInstance;
            if(!this.stall.locked && this.stall.empty)
            {
               this.creatureView.colorMatrix.brightness = 25;
               UIGlobals.dragManager.acceptDragDrop(this);
            }
         }
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc3_ = param1.dragInfo.item as ItemInstance;
            if(_loc3_.canUseItem(this.stall))
            {
               UIGlobals.dragManager.acceptDragDrop(this);
               this.creatureView.colorMatrix.brightness = 25;
            }
         }
      }
      
      private function onDragExit(param1:DragEvent) : void
      {
         this.creatureView.colorMatrix.reset();
      }
      
      private function onDragDrop(param1:DragEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:CreatureInstance = null;
         var _loc4_:ItemInstance = null;
         if(this.client.criticalComms)
         {
            return;
         }
         if(param1.dragInfo.hasOwnProperty("creature"))
         {
            this.creatureView.colorMatrix.reset();
            _loc3_ = param1.dragInfo.creature as CreatureInstance;
            _loc2_ = this.client.createInput();
            _loc2_.creature_id = _loc3_.id;
            _loc2_.stall_id = this.stall.id;
            this.client.service.MoveToStall(_loc2_);
            ++this.client.criticalComms;
         }
         else if(param1.dragInfo.hasOwnProperty("attachment_creature"))
         {
            this.creatureView.colorMatrix.reset();
            param1.dragInfo.success = true;
            param1.dragInfo.stall_id = this.stall.id;
         }
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            this.creatureView.colorMatrix.reset();
            _loc4_ = param1.dragInfo.item as ItemInstance;
            this.doUseItem(_loc4_);
         }
      }
      
      public function doUseItem(param1:ItemInstance) : void
      {
         var _loc2_:Object = null;
         if(this.client.criticalComms)
         {
            return;
         }
         if(!param1.canUseItem(this.stall))
         {
            return;
         }
         if(param1.item.type == Item.TYPE_USE && param1.item.subtype >= Item.USE_INJECT_FIRE && param1.item.subtype <= Item.USE_INJECT_EARTH)
         {
            this.ranchView.injectionPopup.creature = this.creature;
            this.ranchView.injectionPopup.item = param1;
            UIGlobals.popUpManager.addPopUp(this.ranchView.injectionPopup,UIGlobals.root,true);
            UIGlobals.popUpManager.centerPopUp(this.ranchView.injectionPopup);
         }
         else
         {
            _loc2_ = this.client.createInput();
            _loc2_.creature_id = !!this.creature ? this.creature.id : 0;
            _loc2_.stall_id = this.stall.id;
            _loc2_.item_id = param1.id;
            this.client.service.UseItem(_loc2_);
            ++this.client.criticalComms;
         }
      }
      
      private function get isFirstLockedStall() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:Stall = null;
         if(this.stall.locked)
         {
            _loc1_ = uint(this.player.stalls.getItemIndex(this.stall));
            _loc2_ = this.player.stalls[_loc1_ - 1];
            if(!_loc2_.locked)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onUpdateHatchTime(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         if(Boolean(this.creature) && Boolean(this.creature.hatch_at))
         {
            _loc2_ = Utils.etaToTimer(this.creature.hatch_at);
            this.infoLbl.text = _loc2_;
            validateNow(true);
            this.infoLbl.x = (width - this.infoLbl.width) / 2;
            this.infoLbl.y = height / 2;
         }
      }
      
      private function onUpdateWakeupTime(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(Boolean(this.creature) && Boolean(this.creature.wakeup_at))
         {
            _loc2_ = Utils.etaToTimer(this.creature.wakeup_at);
            if(_loc2_ == "0:00:00")
            {
               UIGlobals.oneSecTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateWakeupTime);
               _loc3_ = this.client.createInput();
               _loc3_.creature_instance_id = this.creature.id;
               this.client.service.addEventListener("UpdateCreature",this.onUpdateCreature);
               this.client.service.UpdateCreature(_loc3_);
            }
            this.infoLbl.text = _loc2_;
            validateNow(true);
            this.infoLbl.x = (width - this.infoLbl.width) / 2;
            this.infoLbl.y = height / 2;
         }
      }
      
      private function onUpdateCreature(param1:ServiceEvent) : void
      {
         this.client.service.removeEventListener("UpdateCreature",this.onUpdateCreature);
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(this.creature)
         {
            this.ranchView.selectedView = this;
         }
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         if(Boolean(this.creature) && this.creature.id > 0)
         {
            this.gameView.statusWindow.locked = false;
            this.gameView.statusWindow.visible = true;
            this.gameView.statusWindow.stall = this.stall;
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(this.creature)
         {
            this.highlighted = true;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.highlighted = false;
      }
      
      private function onUpgradeWithCredits(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = false;
         this.client.service.UpgradeRanch(_loc2_);
         this.upgradeBtn.enabled = false;
      }
      
      private function onUpgradeWithTokens(param1:Event) : void
      {
         var _loc2_:Object = this.client.createInput();
         _loc2_.use_tokens = true;
         this.client.service.UpgradeRanch(_loc2_);
         this.upgradeBtn.enabled = false;
      }
      
      public function onUpgradeClick(param1:MouseEvent) : void
      {
         var _loc2_:RanchLevel = RanchLevel.getInstanceByLevel(this.player.ranch_level.level + 1);
         var _loc3_:UpgradeWindow = new UpgradeWindow();
         _loc3_.titleIcon = UIUtils.createBitmapIcon(com.edgebee.breedr.ui.world.areas.ranch.RanchView.UpgradeIconPng,UIGlobals.relativize(16),UIGlobals.relativize(16));
         _loc3_.credits = _loc2_.credits;
         _loc3_.tokens = _loc2_.tokens;
         _loc3_.addEventListener(UpgradeWindow.USE_CREDITS,this.onUpgradeWithCredits);
         _loc3_.addEventListener(UpgradeWindow.USE_TOKENS,this.onUpgradeWithTokens);
         UIGlobals.popUpManager.addPopUp(_loc3_,UIGlobals.root,true);
         UIGlobals.popUpManager.centerPopUp(_loc3_,null,false);
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            this.updateUpgradeButton();
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "UpgradeRanch" && this.upgradeBtn.visible && !this.upgradeBtn.enabled)
         {
            this.updateUpgradeButton();
         }
      }
   }
}
