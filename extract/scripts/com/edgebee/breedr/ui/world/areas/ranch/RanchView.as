package com.edgebee.breedr.ui.world.areas.ranch
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.RanchLevel;
   import com.edgebee.breedr.data.world.Stall;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   
   public class RanchView extends Canvas
   {
      
      public static const MaleIconPng:Class = RanchView_MaleIconPng;
      
      public static const FemaleIconPng:Class = RanchView_FemaleIconPng;
      
      public static const HealthIconPng:Class = RanchView_HealthIconPng;
      
      public static const HappinessIconPng:Class = RanchView_HappinessIconPng;
      
      public static const StaminaIconPng:Class = RanchView_StaminaIconPng;
      
      public static const LevelIconPng:Class = RanchView_LevelIconPng;
      
      public static const RankIconPng:Class = RanchView_RankIconPng;
      
      public static const UpgradeIconPng:Class = RanchView_UpgradeIconPng;
      
      public static const NUM_STALLS_PER_PAGE:uint = 12;
      
      public static const views:Array = ["stallView01","stallView02","stallView03","stallView04","stallView05","stallView06","stallView07","stallView08","stallView09","stallView10","stallView11","stallView12"];
       
      
      private var _injectionPopup:com.edgebee.breedr.ui.world.areas.ranch.InjectionPickerWindow;
      
      private var _page:uint = 0;
      
      public var pagesBox:Box;
      
      public var page1Btn:RadioButton;
      
      public var page2Btn:RadioButton;
      
      private var _pagesGroup:RadioButtonGroup;
      
      public var stallsBox:Box;
      
      public var stallView01:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView02:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView03:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView04:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView05:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView06:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView07:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView08:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView09:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView10:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView11:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      public var stallView12:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      private var _selectedView:com.edgebee.breedr.ui.world.areas.ranch.StallView;
      
      private var _pageButtonDragTimer:Timer;
      
      private var _targetPageBtn:RadioButton;
      
      private const STALL_VIEW_WIDTH:Number = UIGlobals.relativize(148);
      
      private const STALL_VIEW_HEIGHT:Number = UIGlobals.relativize(148);
      
      private var _layout:Array;
      
      public function RanchView()
      {
         this._pageButtonDragTimer = new Timer(500,1);
         this._layout = [{
            "CLASS":Box,
            "ID":"pagesBox",
            "x":UIGlobals.relativize(10),
            "width":this.STALL_VIEW_WIDTH * 4 + UIGlobals.relativize(6) * 3,
            "height":UIGlobals.relativize(48),
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{"Gap":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":RadioButton,
               "ID":"page1Btn",
               "label":Utils.formatString(Asset.getInstanceByName("RANCH_PAGE").value,{"page":1}),
               "userData":0,
               "STYLES":{
                  "FontColor":0,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "Skin":BreedrButtonSkin
               }
            },{
               "CLASS":RadioButton,
               "ID":"page2Btn",
               "name":"RanchPage2Btn",
               "label":Utils.formatString(Asset.getInstanceByName("RANCH_PAGE").value,{"page":2}),
               "userData":1,
               "STYLES":{
                  "FontColor":0,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "Skin":BreedrButtonSkin
               }
            }]
         },{
            "CLASS":Box,
            "ID":"stallsBox",
            "x":UIGlobals.relativize(10),
            "y":UIGlobals.relativize(48),
            "direction":Box.VERTICAL,
            "STYLES":{"Gap":UIGlobals.relativize(6)},
            "CHILDREN":[{
               "CLASS":Box,
               "STYLES":{"Gap":UIGlobals.relativize(6)},
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView01",
                  "name":"Stall_0",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView02",
                  "name":"Stall_1",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView03",
                  "name":"Stall_2",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView04",
                  "name":"Stall_3",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               }]
            },{
               "CLASS":Box,
               "STYLES":{"Gap":UIGlobals.relativize(6)},
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView05",
                  "name":"Stall_4",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView06",
                  "name":"Stall_5",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView07",
                  "name":"Stall_6",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView08",
                  "name":"Stall_7",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               }]
            },{
               "CLASS":Box,
               "STYLES":{"Gap":UIGlobals.relativize(6)},
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView09",
                  "name":"Stall_8",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView10",
                  "name":"Stall_9",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView11",
                  "name":"Stall_10",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.ranch.StallView,
                  "ID":"stallView12",
                  "name":"Stall_11",
                  "width":this.STALL_VIEW_WIDTH,
                  "height":this.STALL_VIEW_HEIGHT
               }]
            }]
         }];
         super();
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("UseItem",this.onUseItem);
         this.client.service.addEventListener("MoveToStall",this.onMoveToStall);
         this.client.service.addEventListener("UpgradeRanch",this.onUpgradeRanch);
         this.client.service.addEventListener("HatchEggs",this.onHatchEggs);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         UIGlobals.fiveSecTimer.addEventListener(TimerEvent.TIMER,this.checkHatchedEggs);
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
      
      public function get injectionPopup() : com.edgebee.breedr.ui.world.areas.ranch.InjectionPickerWindow
      {
         if(!this._injectionPopup)
         {
            this._injectionPopup = new com.edgebee.breedr.ui.world.areas.ranch.InjectionPickerWindow();
         }
         return this._injectionPopup;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._pagesGroup = new RadioButtonGroup();
         this._pagesGroup.addButton(this.page1Btn);
         this._pagesGroup.addButton(this.page2Btn);
         this._pagesGroup.addEventListener(Event.CHANGE,this.onPageChange);
         this._pagesGroup.selected = this.page1Btn;
         this.page1Btn.addEventListener(DragEvent.DRAG_ENTER,this.onPageButtonDragEnter);
         this.page2Btn.addEventListener(DragEvent.DRAG_ENTER,this.onPageButtonDragEnter);
         this.page1Btn.addEventListener(DragEvent.DRAG_DROP,this.onPageButtonDragDrop);
         this.page2Btn.addEventListener(DragEvent.DRAG_DROP,this.onPageButtonDragDrop);
         this.page1Btn.addEventListener(DragEvent.DRAG_EXIT,this.onPageButtonDragExit);
         this.page2Btn.addEventListener(DragEvent.DRAG_EXIT,this.onPageButtonDragExit);
         this._pageButtonDragTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPageButtonDragTimerComplete);
         this.gameView.dialogView.addEventListener("DIALOG_TUTORIAL_LEVELUP_SHOW_SKILLS",this.onDialogShowSkills);
         this.gameView.cutsceneView.dialogView.addEventListener("DIALOG_TUTORIAL_FEED2_SHOW_STATUS",this.onDialogShowStatus);
         this.update();
      }
      
      public function findStallView(param1:Stall) : com.edgebee.breedr.ui.world.areas.ranch.StallView
      {
         var _loc2_:String = null;
         for each(_loc2_ in views)
         {
            if((this[_loc2_] as com.edgebee.breedr.ui.world.areas.ranch.StallView).stall == param1)
            {
               return this[_loc2_];
            }
         }
         return null;
      }
      
      public function get page() : uint
      {
         return this._page;
      }
      
      public function set page(param1:uint) : void
      {
         if(this.page != param1)
         {
            this._page = param1;
            this.update();
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "fridge_level")
         {
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
         }
      }
      
      private function onPageChange(param1:ExtendedEvent) : void
      {
         this.page = param1.data as uint;
      }
      
      private function checkHatchedEggs(param1:TimerEvent) : void
      {
         var _loc2_:Stall = null;
         if(visible && !this.client.criticalComms && this.gameView && !this.gameView.cutsceneView.visible && this.client.tutorialManager.state == 0 && !UIGlobals.popUpManager.isInModalState)
         {
            for each(_loc2_ in this.player.stalls)
            {
               if(_loc2_.creature.id && _loc2_.creature.isEgg && _loc2_.creature.hatch_at.time < new Date().time)
               {
                  ++this.client.criticalComms;
                  this.client.service.HatchEggs(this.client.createInput());
                  break;
               }
            }
         }
      }
      
      private function onHatchEggs(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            --this.client.criticalComms;
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "MoveToStall")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "UseItem")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
      }
      
      private function onSeedsChange(param1:CollectionEvent) : void
      {
      }
      
      private function update() : void
      {
         var _loc1_:Stall = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         if(childrenCreated || childrenCreating)
         {
            _loc2_ = 0;
            _loc3_ = uint(this.player.stalls.findItemsByProperty("locked",false).length);
            this.page2Btn.enabled = _loc3_ >= NUM_STALLS_PER_PAGE;
            _loc4_ = 0;
            while(_loc4_ < views.length)
            {
               _loc2_ = uint(_loc4_ + NUM_STALLS_PER_PAGE * this.page);
               _loc1_ = this.player.stalls.getItemAt(_loc2_) as Stall;
               (this[views[_loc4_]] as com.edgebee.breedr.ui.world.areas.ranch.StallView).stall = _loc1_;
               _loc4_++;
            }
         }
      }
      
      private function onDialogShowStatus(param1:Event) : void
      {
         this.gameView.ranchView.selectedView = this.stallView01;
         this.gameView.statusWindow.creature = this.stallView01.creature;
         this.gameView.statusWindow.visible = true;
         this.gameView.statusWindow.tabGroup.selected = this.gameView.statusWindow.toStatsBtn;
      }
      
      private function onDialogShowSkills(param1:Event) : void
      {
         this.gameView.statusWindow.visible = true;
         this.gameView.statusWindow.tabGroup.selected = this.gameView.statusWindow.toSkillsBtn;
      }
      
      public function get selectedView() : com.edgebee.breedr.ui.world.areas.ranch.StallView
      {
         return this._selectedView;
      }
      
      public function set selectedView(param1:com.edgebee.breedr.ui.world.areas.ranch.StallView) : void
      {
         if(this.selectedView != param1)
         {
            if(this.selectedView)
            {
               this.selectedView.selected = false;
            }
            this._selectedView = param1;
            if(this.selectedView)
            {
               this.selectedView.selected = true;
            }
         }
      }
      
      private function onFridgeChange(param1:PropertyChangeEvent) : void
      {
      }
      
      public function onRetireClick(param1:MouseEvent) : void
      {
      }
      
      private function onUseItem(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onMoveToStall(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onUpgradeRanch(param1:ServiceEvent) : void
      {
         var _loc2_:RanchLevel = null;
         if(param1.data.hasOwnProperty("events"))
         {
            _loc2_ = RanchLevel.getInstanceByLevel(this.player.ranch_level.level + 1);
            this.page2Btn.enabled = _loc2_ == null || _loc2_.capacity >= NUM_STALLS_PER_PAGE;
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onPageButtonDragEnter(param1:DragEvent) : void
      {
         this._targetPageBtn = param1.currentTarget as RadioButton;
         if(this._targetPageBtn.enabled && (param1.dragInfo.hasOwnProperty("creature") || param1.dragInfo.hasOwnProperty("attachment_creature") || param1.dragInfo.hasOwnProperty("item")))
         {
            this._pageButtonDragTimer.reset();
            this._pageButtonDragTimer.start();
            this._targetPageBtn.glowProxy.color = UIGlobals.getStyle("ThemeColor2");
            this._targetPageBtn.glowProxy.blur = 5;
            this._targetPageBtn.glowProxy.strength = 3;
            this._targetPageBtn.glowProxy.alpha = 1;
            UIGlobals.dragManager.acceptDragDrop(this._targetPageBtn);
         }
      }
      
      private function onPageButtonDragDrop(param1:DragEvent) : void
      {
         this._pageButtonDragTimer.stop();
         this._targetPageBtn.glowProxy.reset();
      }
      
      private function onPageButtonDragExit(param1:DragEvent) : void
      {
         this._pageButtonDragTimer.stop();
         this._targetPageBtn.glowProxy.reset();
      }
      
      private function onPageButtonDragTimerComplete(param1:TimerEvent) : void
      {
         this._pagesGroup.selected = this._targetPageBtn;
         this._targetPageBtn.glowProxy.reset();
      }
   }
}
