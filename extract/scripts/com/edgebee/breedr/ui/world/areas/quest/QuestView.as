package com.edgebee.breedr.ui.world.areas.quest
{
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
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.item.ItemView;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   
   public class QuestView extends Box
   {
       
      
      public var creatureBox:Canvas;
      
      public var creatureView:CreatureView;
      
      public var rewardLbl:Label;
      
      public var optionsBox:Box;
      
      public var abandonBtn:Button;
      
      public var nameLbl:Label;
      
      public var bg:TransparentWindow;
      
      public var rewardItem:ItemView;
      
      public var locationImg:SWFLoader;
      
      public var locationLbl:Label;
      
      private var _layout:Array;
      
      public function QuestView()
      {
         this._layout = [{
            "CLASS":Box,
            "name":"QuestBox",
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(450),
            "direction":Box.VERTICAL,
            "layoutInvisibleChildren":false,
            "toolTip":Asset.getInstanceByName("QUEST_COMPLETE_TIP"),
            "STYLES":{"Padding":UIGlobals.relativize(12)},
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(450),
               "includeInLayout":false
            },{
               "CLASS":Canvas,
               "ID":"creatureBox",
               "percentWidth":1,
               "percentHeight":1,
               "CHILDREN":[{
                  "CLASS":CreatureView,
                  "ID":"creatureView",
                  "name":"QuestCreatureView",
                  "width":UIGlobals.relativize(352),
                  "height":UIGlobals.relativize(352)
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "horizontalAlign":Box.ALIGN_RIGHT,
                  "CHILDREN":[{
                     "CLASS":Box,
                     "name":"QuestRewardBox",
                     "direction":Box.VERTICAL,
                     "verticalAlign":Box.ALIGN_MIDDLE,
                     "percentWidth":0.35,
                     "filters":UIGlobals.fontOutline,
                     "STYLES":{"Gap":UIGlobals.relativize(-2)},
                     "CHILDREN":[{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("NAME"),
                        "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                     },{
                        "CLASS":Label,
                        "ID":"nameLbl",
                        "STYLES":{
                           "FontColor":16776960,
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(18)
                        }
                     },{
                        "CLASS":Spacer,
                        "height":UIGlobals.relativize(20)
                     },{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("REWARD"),
                        "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                     },{
                        "CLASS":Box,
                        "verticalAlign":Box.ALIGN_MIDDLE,
                        "CHILDREN":[{
                           "CLASS":Label,
                           "ID":"rewardLbl",
                           "STYLES":{
                              "FontColor":65280,
                              "FontWeight":"bold",
                              "FontSize":UIGlobals.relativizeFont(18)
                           }
                        },{
                           "CLASS":Spacer,
                           "width":UIGlobals.relativize(5)
                        },{
                           "CLASS":BitmapComponent,
                           "width":UIGlobals.relativize(24),
                           "isSquare":true,
                           "source":ControlBar.CreditsIconPng
                        }]
                     },{
                        "CLASS":Box,
                        "CHILDREN":[{
                           "CLASS":ItemView,
                           "ID":"rewardItem",
                           "canModifyNote":false,
                           "width":UIGlobals.relativize(64),
                           "height":UIGlobals.relativize(64)
                        }]
                     },{
                        "CLASS":Spacer,
                        "height":UIGlobals.relativize(20)
                     },{
                        "CLASS":Label,
                        "text":Asset.getInstanceByName("QUEST_LOCATION"),
                        "STYLES":{"FontSize":UIGlobals.relativizeFont(16)}
                     },{
                        "CLASS":SWFLoader,
                        "ID":"locationImg",
                        "width":UIGlobals.relativize(128),
                        "height":UIGlobals.relativize(96)
                     },{
                        "CLASS":Spacer,
                        "height":UIGlobals.relativize(5)
                     },{
                        "CLASS":Label,
                        "ID":"locationLbl",
                        "STYLES":{
                           "FontColor":16777215,
                           "FontWeight":"bold",
                           "FontSize":UIGlobals.relativizeFont(16)
                        }
                     }]
                  }]
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(15)
            },{
               "CLASS":Box,
               "ID":"optionsBox",
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "STYLES":{
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12)
               },
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"abandonBtn",
                  "name":"QuestAbandonButton",
                  "label":Asset.getInstanceByName("ABANDON_QUEST"),
                  "toolTip":Asset.getInstanceByName("ABANDON_QUEST_TIP"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":this.onAbandonClick
                  }]
               }]
            }]
         }];
         super(Box.VERTICAL,Box.ALIGN_LEFT,Box.ALIGN_TOP);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("QuestAbandon",this.onQuestAbandon);
         this.client.service.addEventListener("QuestComplete",this.onQuestComplete);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.player.quest.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onQuestChange);
         addEventListener(DragEvent.DRAG_ENTER,this.onDragEnter);
         addEventListener(DragEvent.DRAG_EXIT,this.onDragExit);
         addEventListener(DragEvent.DRAG_DROP,this.onDragDrop);
         UIGlobals.fiveSecTimer.addEventListener(TimerEvent.TIMER,this.onFiveSecondTimer);
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.bg.startAnimation();
         }
         else
         {
            this.bg.stopAnimation();
         }
      }
      
      private function onAbandonClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.client.createInput();
         this.client.service.QuestAbandon(_loc2_);
         ++this.client.criticalComms;
      }
      
      private function onQuestAbandon(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onQuestComplete(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function update() : void
      {
         if((childrenCreated || childrenCreating) && this.creatureView != null)
         {
            this.creatureView.creature = this.player.quest.snapshot;
            this.nameLbl.text = this.player.quest.snapshot.name;
            this.rewardLbl.text = this.player.quest.reward.toString();
            this.abandonBtn.enabled = this.player.quest.canAbandon;
            this.rewardItem.visible = this.player.quest.item_id > 0;
            if(this.player.quest.item_id > 0)
            {
               this.rewardItem.static_item = this.player.quest.item;
            }
            else
            {
               this.rewardItem.static_item = null;
            }
            this.locationImg.source = UIGlobals.getAssetPath(this.player.quest.area.image_url);
            this.locationLbl.text = this.player.quest.area.name;
         }
      }
      
      private function onFiveSecondTimer(param1:TimerEvent) : void
      {
         if(visible && this.abandonBtn && this.player && Boolean(this.player.quest))
         {
            this.abandonBtn.enabled = this.player.quest.canAbandon;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(this.player.area.type == Area.TYPE_QUEST)
            {
               this.update();
            }
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.optionsBox))
         {
            this.optionsBox.enabled = this.client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "QuestAbandon")
         {
            --this.client.criticalComms;
         }
         else if(param1.method == "QuestComplete")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onQuestChange(param1:PropertyChangeEvent) : void
      {
         if(this.player.quest.copying == false)
         {
            this.update();
         }
      }
      
      private function onDragEnter(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            if(_loc2_.item.type == Item.TYPE_BREED && _loc2_.creature.name == this.player.quest.snapshot.name)
            {
               this.gameView.questView.glowProxy.alpha = 1;
               this.gameView.questView.glowProxy.color = UIGlobals.getStyle("ThemeColor2");
               UIGlobals.dragManager.acceptDragDrop(this);
            }
         }
      }
      
      private function onDragExit(param1:DragEvent) : void
      {
         this.gameView.questView.glowProxy.reset();
      }
      
      private function onDragDrop(param1:DragEvent) : void
      {
         var _loc2_:ItemInstance = null;
         var _loc3_:Object = null;
         if(param1.dragInfo.hasOwnProperty("item"))
         {
            _loc2_ = param1.dragInfo.item as ItemInstance;
            this.gameView.questView.glowProxy.reset();
            _loc3_ = this.client.createInput();
            _loc3_ = this.client.createInput();
            _loc3_.item_id = _loc2_.id;
            this.client.service.QuestComplete(_loc3_);
            ++this.client.criticalComms;
         }
      }
   }
}
