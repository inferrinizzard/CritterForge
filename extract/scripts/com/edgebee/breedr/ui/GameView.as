package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BufferedSWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.ui.combat.CombatResultsWindow;
   import com.edgebee.breedr.ui.combat.CombatView;
   import com.edgebee.breedr.ui.creature.StatusWindow;
   import com.edgebee.breedr.ui.item.InventoryView;
   import com.edgebee.breedr.ui.skill.SkillEditorWindow;
   import com.edgebee.breedr.ui.world.NavigationBar;
   import com.edgebee.breedr.ui.world.NpcView;
   import com.edgebee.breedr.ui.world.areas.arena.ArenaView;
   import com.edgebee.breedr.ui.world.areas.auction.AuctionView;
   import com.edgebee.breedr.ui.world.areas.lab.LabView;
   import com.edgebee.breedr.ui.world.areas.quest.QuestView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import com.edgebee.breedr.ui.world.areas.safari.SafariView;
   import com.edgebee.breedr.ui.world.areas.shop.ShopView;
   import com.edgebee.breedr.ui.world.areas.syndicate.SyndicateView;
   import com.edgebee.breedr.ui.world.areas.travel.TravelView;
   import flash.events.Event;
   
   public class GameView extends Canvas
   {
      
      public static const BACKGROUND_LOADED:String = "BACKGROUND_LOADED";
      
      public static const LOGOUT_OR_QUIT:String = "LOGOUT_OR_QUIT";
      
      public static const COMBAT_END:String = "COMBAT_END";
      
      private static var _fadeIn:Animation;
       
      
      public var controlBar:com.edgebee.breedr.ui.ControlBar;
      
      public var loggingBox:com.edgebee.breedr.ui.SmoothLogger;
      
      public var mainViewCanvas:Canvas;
      
      public var bottomViewCanvas:Canvas;
      
      public var backgroundImage:BufferedSWFLoader;
      
      public var fadeOverlay:Canvas;
      
      public var navigationBar:NavigationBar;
      
      public var ranchView:RanchView;
      
      public var labView:LabView;
      
      public var shopView:ShopView;
      
      public var combatView:CombatView;
      
      public var arenaView:ArenaView;
      
      public var travelView:TravelView;
      
      public var auctionView:AuctionView;
      
      public var syndicateView:SyndicateView;
      
      public var questView:QuestView;
      
      public var safariView:SafariView;
      
      public var npcView:NpcView;
      
      public var cutsceneView:com.edgebee.breedr.ui.CutsceneView;
      
      public var dialogView:com.edgebee.breedr.ui.DialogView;
      
      public var inventoryView:InventoryView;
      
      public var statusWindow:StatusWindow;
      
      public var skillEditorWindow:SkillEditorWindow;
      
      public var combatResultsWindow:CombatResultsWindow;
      
      private var _playView:Component;
      
      private var _mainBox:Box;
      
      private var _mazeBox:Box;
      
      private var _fadeInCompleted:Boolean = false;
      
      public var fadeInInstance:AnimationInstance;
      
      public var fadeOutInstance:AnimationInstance;
      
      private var _layout:Array;
      
      public function GameView()
      {
         this._layout = [{
            "CLASS":Canvas,
            "ID":"mainViewCanvas",
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":BufferedSWFLoader,
               "ID":"backgroundImage",
               "width":UIGlobals.relativizeX(960),
               "height":UIGlobals.relativizeY(720),
               "STYLES":{
                  "ShadowBorderEnabled":true,
                  "ShadowBorderAlpha":[0,0.65],
                  "ShadowBorderRatios":[150,255],
                  "ShadowBorderGradientSizeFactor":{
                     "width":1.5,
                     "height":1.5
                  }
               },
               "EVENTS":[{
                  "TYPE":Event.COMPLETE,
                  "LISTENER":"onBackgroundLoaded"
               }]
            }]
         },{
            "CLASS":CombatView,
            "ID":"combatView",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":NpcView,
            "ID":"npcView",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":RanchView,
            "ID":"ranchView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(48),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":LabView,
            "ID":"labView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":ShopView,
            "ID":"shopView",
            "visible":false,
            "createChildrenOnVisible":true,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":ArenaView,
            "ID":"arenaView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":TravelView,
            "ID":"travelView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":AuctionView,
            "ID":"auctionView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":SyndicateView,
            "ID":"syndicateView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":QuestView,
            "ID":"questView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":SafariView,
            "ID":"safariView",
            "visible":false,
            "createChildrenOnVisible":true,
            "percentWidth":1,
            "y":UIGlobals.relativize(96),
            "height":UIGlobals.relativizeY(720 - 100)
         },{
            "CLASS":com.edgebee.breedr.ui.ControlBar,
            "ID":"controlBar",
            "width":UIGlobals.relativizeX(960)
         },{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "CHILDREN":[{
               "CLASS":InventoryView,
               "ID":"inventoryView",
               "visible":false
            }]
         },{
            "CLASS":com.edgebee.breedr.ui.DialogView,
            "ID":"dialogView",
            "visible":false,
            "x":UIGlobals.relativize(80),
            "width":UIGlobals.relativize(800),
            "y":UIGlobals.relativize(576),
            "height":UIGlobals.relativize(120)
         },{
            "CLASS":NavigationBar,
            "ID":"navigationBar",
            "x":UIGlobals.relativize(-864),
            "y":UIGlobals.relativize(720 - 120)
         },{
            "CLASS":com.edgebee.breedr.ui.CutsceneView,
            "ID":"cutsceneView",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":com.edgebee.breedr.ui.SmoothLogger,
            "ID":"loggingBox",
            "percentWidth":1,
            "y":UIGlobals.relativize(36),
            "height":UIGlobals.relativizeY(120),
            "mouseEnabled":false,
            "mouseChildren":false,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(19)}
         },{
            "CLASS":Canvas,
            "ID":"fadeOverlay",
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "BackgroundColor":0,
               "BackgroundAlpha":1
            }
         }];
         super();
         name = "gameView";
         visible = false;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get isIdle() : Boolean
      {
         return childrenCreated && !this.client.actionDispatcher.hasActionsWaiting();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Track = null;
         super.createChildren();
         addEventListener(Component.CHILDREN_CREATED,this.onChildrenCreated);
         this.statusWindow = new StatusWindow();
         UIGlobals.popUpManager.addPopUp(this.statusWindow,this);
         UIGlobals.popUpManager.centerPopUp(this.statusWindow);
         this.skillEditorWindow = new SkillEditorWindow();
         UIGlobals.popUpManager.addPopUp(this.skillEditorWindow,this);
         UIGlobals.popUpManager.centerPopUp(this.skillEditorWindow);
         this.combatResultsWindow = new CombatResultsWindow();
         UIGlobals.popUpManager.addPopUp(this.combatResultsWindow,this);
         UIGlobals.popUpManager.centerPopUp(this.combatResultsWindow);
         UIUtils.performLayout(this,this,this._layout);
         if(!_fadeIn)
         {
            _fadeIn = new Animation();
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(1.5,0));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _fadeIn.addTrack(_loc1_);
         }
         this.fadeInInstance = this.fadeOverlay.controller.addAnimation(_fadeIn);
         this.dialogView.npcView = this.npcView;
         this.client.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.backgroundImage.colorMatrix.saturation = -35;
      }
      
      public function softLogout() : void
      {
         this.fadeOverlay.alpha = 0;
         this.fadeOverlay.visible = true;
         this.fadeOutInstance = this.fadeOverlay.controller.addAnimation(_fadeIn);
         this.fadeOutInstance.addEventListener(AnimationEvent.STOP,this.onFadeOutStop);
         this.fadeOutInstance.gotoEndAndPlayReversed();
      }
      
      private function onFadeOutStop(param1:AnimationEvent) : void
      {
         ++this.client.criticalComms;
         this.client.service.Logout(this.client.createInput());
      }
      
      public function logout() : void
      {
         ++this.client.criticalComms;
         this.client.service.Logout(this.client.createInput());
      }
      
      public function hideAreaViews() : void
      {
         this.statusWindow.visible = false;
         this.statusWindow.stall = null;
         this.combatResultsWindow.visible = false;
         this.ranchView.visible = false;
         this.labView.visible = false;
         this.shopView.visible = false;
         this.combatView.visible = false;
         this.arenaView.visible = false;
         this.travelView.visible = false;
         this.auctionView.visible = false;
         this.syndicateView.visible = false;
         this.questView.visible = false;
         this.inventoryView.visible = false;
         this.safariView.visible = false;
      }
      
      public function onBackgroundLoaded(param1:Event) : void
      {
         dispatchEvent(new Event(BACKGROUND_LOADED));
      }
      
      private function onChildrenCreated(param1:Event) : void
      {
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "ranch_level")
         {
            if(Boolean(this.client.player.area) && this.client.player.area.type == Area.TYPE_RANCH)
            {
               this.backgroundImage.source = UIGlobals.getAssetPath(this.client.player.area.getImageForPlayer(this.client.player));
            }
         }
      }
   }
}
