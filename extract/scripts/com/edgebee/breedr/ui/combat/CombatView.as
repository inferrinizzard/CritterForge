package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.events.combat.CombatEndEvent;
   import com.edgebee.breedr.events.combat.CreditEvent;
   import com.edgebee.breedr.events.combat.ExperienceEvent;
   import com.edgebee.breedr.ui.SmoothLogger;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import idv.cjcat.stardust.twoD.renderers.DisplayObjectRenderer;
   
   public class CombatView extends Canvas
   {
      
      public static const NORMAL_MODE:uint = 0;
      
      public static const REPLAY_MODE:uint = 1;
      
      public static const ELEMENT_CLICKED:String = "ELEMENT_CLICKED";
       
      
      private var _mode:int = -1;
      
      public var _creature1:CreatureInstance;
      
      public var _creature2:CreatureInstance;
      
      public var leftActor:com.edgebee.breedr.ui.combat.ActorView;
      
      public var rightActor:com.edgebee.breedr.ui.combat.ActorView;
      
      public var stopBtn:Button;
      
      public var roundBar:ProgressBar;
      
      public var combatLogger:SmoothLogger;
      
      public var announcer:com.edgebee.breedr.ui.combat.Announcer;
      
      public var particleLayer:Sprite;
      
      public var particleRenderer:DisplayObjectRenderer;
      
      private var _bitmapBuffer:BitmapData;
      
      private var _bitmapBackground:Bitmap;
      
      private var _layout:Array;
      
      public function CombatView()
      {
         this._layout = [{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "layoutInvisibleChildren":false,
            "CHILDREN":[{
               "CLASS":com.edgebee.breedr.ui.combat.ActorView,
               "ID":"leftActor",
               "orientation":com.edgebee.breedr.ui.combat.ActorView.RIGHT,
               "percentWidth":0.5,
               "percentHeight":1
            },{
               "CLASS":com.edgebee.breedr.ui.combat.ActorView,
               "ID":"rightActor",
               "orientation":com.edgebee.breedr.ui.combat.ActorView.LEFT,
               "percentWidth":0.5,
               "percentHeight":1
            }]
         },{
            "CLASS":SmoothLogger,
            "ID":"combatLogger",
            "percentWidth":1,
            "y":UIGlobals.relativize(180),
            "alignment":Box.ALIGN_CENTER,
            "idleTime":1000,
            "height":UIGlobals.relativizeY(130),
            "mouseEnabled":false,
            "mouseChildren":false,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(24)}
         },{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("COMBAT_PROGRESS"),
               "filters":UIGlobals.fontOutline,
               "STYLES":{
                  "FontWeight":"bold",
                  "FontSize":UIGlobals.relativize(16)
               }
            },{
               "CLASS":ProgressBar,
               "ID":"roundBar",
               "width":UIGlobals.relativize(200),
               "height":UIGlobals.relativize(10),
               "STYLES":{
                  "ShowLabel":true,
                  "FontColor":16777215,
                  "Animated":false,
                  "FontSize":UIGlobals.relativizeFont(10),
                  "BarOffset":-2,
                  "LabelType":"fraction"
               }
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(10)
            },{
               "CLASS":Button,
               "ID":"stopBtn",
               "label":Asset.getInstanceByName("SKIP"),
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":this.onStopClick
               }]
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(5)
            }]
         },{
            "CLASS":com.edgebee.breedr.ui.combat.Announcer,
            "ID":"announcer",
            "percentWidth":1,
            "percentHeight":1
         }];
         super();
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get mode() : int
      {
         return this._mode;
      }
      
      public function set mode(param1:int) : void
      {
         if(this._mode != param1)
         {
            this._mode = param1;
         }
      }
      
      public function get creature1() : CreatureInstance
      {
         return this._creature1;
      }
      
      public function set creature1(param1:CreatureInstance) : void
      {
         this._creature1 = param1;
         this.rightActor.creature = param1;
      }
      
      public function get creature2() : CreatureInstance
      {
         return this._creature2;
      }
      
      public function set creature2(param1:CreatureInstance) : void
      {
         this._creature2 = param1;
         this.leftActor.creature = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.particleLayer = new Sprite();
         this.particleLayer.graphics.clear();
         this.particleLayer.graphics.beginFill(0,0);
         this.particleLayer.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         this.particleLayer.graphics.endFill();
         this.particleLayer.visible = true;
         this.particleLayer.mouseEnabled = false;
         this.particleRenderer = new DisplayObjectRenderer(this.particleLayer);
         UIUtils.performLayout(this,this,this._layout);
         this.leftActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_HP_CLICKED,this.onActorHpClicked);
         this.leftActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_PP_CLICKED,this.onActorPpClicked);
         this.leftActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_CONDITION_CLICKED,this.onActorConditionClicked);
         this.rightActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_HP_CLICKED,this.onActorHpClicked);
         this.rightActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_PP_CLICKED,this.onActorPpClicked);
         this.rightActor.addEventListener(com.edgebee.breedr.ui.combat.ActorView.ACTOR_CONDITION_CLICKED,this.onActorConditionClicked);
         addChild(this.particleLayer);
      }
      
      public function reset() : void
      {
         this.creature1 = null;
         this.creature2 = null;
         this.leftActor.reset();
         this.rightActor.reset();
         this.stopBtn.enabled = true;
      }
      
      public function getCreatureById(param1:uint) : CreatureInstance
      {
         if(Boolean(this.leftActor.creature) && this.leftActor.creature.id == param1)
         {
            return this.leftActor.creature;
         }
         if(Boolean(this.rightActor.creature) && this.rightActor.creature.id == param1)
         {
            return this.rightActor.creature;
         }
         return null;
      }
      
      public function getViewById(param1:uint) : com.edgebee.breedr.ui.combat.ActorView
      {
         if(Boolean(this.leftActor.creature) && this.leftActor.creature.id == param1)
         {
            return this.leftActor;
         }
         if(Boolean(this.rightActor.creature) && this.rightActor.creature.id == param1)
         {
            return this.rightActor;
         }
         return null;
      }
      
      private function onActorHpClicked(param1:ExtendedEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ELEMENT_CLICKED,{
            "type":param1.type,
            "creature":param1.data.creature
         }));
      }
      
      private function onActorPpClicked(param1:ExtendedEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ELEMENT_CLICKED,{
            "type":param1.type,
            "creature":param1.data.creature
         }));
      }
      
      private function onActorConditionClicked(param1:ExtendedEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ELEMENT_CLICKED,{
            "type":param1.type,
            "creature":param1.data.creature,
            "condition":param1.data.condition
         }));
      }
      
      private function onStopClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         this.stopBtn.enabled = false;
         this.client.eventProcessor.paused = true;
         var _loc3_:Boolean = false;
         var _loc4_:Array = [];
         for each(_loc2_ in this.client.actionDispatcher.getActions())
         {
            _loc3_ = _loc2_ is CombatEndEvent || this.mode != REPLAY_MODE && (_loc2_ is CreditEvent || _loc2_ is ExperienceEvent);
            if(_loc3_)
            {
               break;
            }
            _loc4_.push(_loc2_);
         }
         _loc4_.pop();
         if(_loc3_)
         {
            for each(_loc2_ in _loc4_)
            {
               this.client.actionDispatcher.getActions().removeItem(_loc2_);
            }
         }
         this.client.eventProcessor.paused = false;
      }
   }
}
