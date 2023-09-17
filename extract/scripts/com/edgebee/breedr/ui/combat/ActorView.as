package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.AAGradientLabel;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.combat.Condition;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Element;
   import com.edgebee.breedr.data.effect.Effect;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.EffectPieceInstance;
   import com.edgebee.breedr.data.skill.SkillInstance;
   import com.edgebee.breedr.effects.BreathEmitter;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class ActorView extends Canvas
   {
      
      public static const FireBreathWav:Class = ActorView_FireBreathWav;
      
      public static const IceBreathWav:Class = ActorView_IceBreathWav;
      
      public static const ThunderBreathWav:Class = ActorView_ThunderBreathWav;
      
      public static const EarthBreathWav:Class = ActorView_EarthBreathWav;
      
      public static const XpWav:Class = ActorView_XpWav;
      
      public static const SpawnWav:Class = ActorView_SpawnWav;
      
      public static var HPIconPng:Class = ActorView_HPIconPng;
      
      public static var PPIconPng:Class = ActorView_PPIconPng;
      
      public static var LuckyPng:Class = ActorView_LuckyPng;
      
      public static const LEFT:String = "LEFT";
      
      public static const RIGHT:String = "RIGHT";
      
      public static const ACTOR_HP_CLICKED:String = "ACTOR_HP_CLICKED";
      
      public static const ACTOR_PP_CLICKED:String = "ACTOR_PP_CLICKED";
      
      public static const ACTOR_CONDITION_CLICKED:String = "ACTOR_CONDITION_CLICKED";
      
      private static var _showAction:Animation;
      
      private static var _showDamage:Animation;
      
      private static var _showDamageRed:Animation;
      
      private static var _showRestoration:Animation;
      
      private static var _showRestorationGreen:Animation;
      
      private static var _showDeath:Animation;
      
      private static var _showSpawn:Animation;
       
      
      private var _creature:WeakReference;
      
      private var _orientation:String = "LEFT";
      
      private var _currentSkill:WeakReference;
      
      public var creatureView:CreatureView;
      
      public var podiumBmp:BitmapComponent;
      
      public var nameLbl:AAGradientLabel;
      
      public var levelLbl:GradientLabel;
      
      public var hpBar:com.edgebee.breedr.ui.combat.ValueMeter;
      
      public var ppBar:com.edgebee.breedr.ui.combat.ValueMeter;
      
      public var xpBox:Box;
      
      public var xpBar:ProgressBar;
      
      public var infoBox:Box;
      
      public var infoBox2:Box;
      
      public var conditionsBox:Box;
      
      public var effectDisplay:com.edgebee.breedr.ui.combat.EffectDisplay;
      
      public var effectValueDisplay:com.edgebee.breedr.ui.combat.EffectValueDisplay;
      
      public var effectIconDisplay:com.edgebee.breedr.ui.combat.EffectIconDisplay;
      
      public var customIconDisplay:com.edgebee.breedr.ui.combat.CustomIconDisplay;
      
      public var idleDisplay:com.edgebee.breedr.ui.combat.IdleDisplay;
      
      private var _showActionInstance:AnimationInstance;
      
      private var _showDamageInstance:AnimationInstance;
      
      private var _showDamageRedInstance:AnimationInstance;
      
      private var _showRestorationInstance:AnimationInstance;
      
      private var _showRestorationGreenInstance:AnimationInstance;
      
      private var _showDeathInstance:AnimationInstance;
      
      private var _showSpawnInstance:AnimationInstance;
      
      private var _showXpBoxInstance:AnimationInstance;
      
      private var _breathEmitter:BreathEmitter;
      
      private var _layout:Array;
      
      public function ActorView()
      {
         var _loc1_:Track = null;
         this._creature = new WeakReference(null,CreatureInstance);
         this._currentSkill = new WeakReference(null,SkillInstance);
         this._layout = [{
            "CLASS":Box,
            "ID":"infoBox",
            "y":UIGlobals.relativize(50),
            "horizontalAlign":Box.ALIGN_RIGHT,
            "percentWidth":1,
            "CHILDREN":[{
               "CLASS":Box,
               "ID":"infoBox2",
               "direction":Box.VERTICAL,
               "horizontalAlign":Box.ALIGN_RIGHT,
               "layoutInvisibleChildren":false,
               "STYLES":{
                  "Gap":0,
                  "Padding":UIGlobals.relativize(10),
                  "BackgroundColor":[0,0],
                  "BackgroundAlpha":[0.5,0],
                  "BackgroundDirection":0
               },
               "CHILDREN":[{
                  "CLASS":Box,
                  "verticalAlign":Box.ALIGN_MIDDLE,
                  "CHILDREN":[{
                     "CLASS":AAGradientLabel,
                     "ID":"nameLbl",
                     "colors":[7829367,16777215,11184810,0],
                     "alphas":[1,1,1,1],
                     "ratios":[0,100,200,255],
                     "filters":[new GlowFilter(16777215,0.5,2,2,5,1,true),new GlowFilter(0,1,4,4,5)],
                     "STYLES":{
                        "FontWeight":"bold",
                        "FontSize":UIGlobals.relativizeFont(26)
                     }
                  },{
                     "CLASS":Spacer,
                     "width":UIGlobals.relativize(20)
                  },{
                     "CLASS":BitmapComponent,
                     "width":UIGlobals.relativize(24),
                     "filters":UIGlobals.fontOutline,
                     "isSquare":true,
                     "source":RanchView.LevelIconPng
                  },{
                     "CLASS":Label,
                     "text":Asset.getInstanceByName("LEVEL"),
                     "filters":UIGlobals.fontOutline,
                     "STYLES":{
                        "FontColor":13421772,
                        "FontSize":UIGlobals.relativizeFont(18)
                     }
                  },{
                     "CLASS":GradientLabel,
                     "ID":"levelLbl",
                     "colors":[5592405,16777215],
                     "filters":[new GlowFilter(16777215,0.5,2,2,5,1,true),new GlowFilter(0,1,4,4,5)],
                     "STYLES":{
                        "FontSize":UIGlobals.relativizeFont(26),
                        "FontWeight":"bold"
                     }
                  }]
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(5)
               },{
                  "CLASS":com.edgebee.breedr.ui.combat.ValueMeter,
                  "ID":"hpBar",
                  "property":"hp",
                  "maxProperty":"max_hp",
                  "width":UIGlobals.relativize(650 / 2),
                  "height":UIGlobals.relativize(40),
                  "icon":HPIconPng,
                  "color":new Color(UIGlobals.getStyle("HPColor"))
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(5)
               },{
                  "CLASS":com.edgebee.breedr.ui.combat.ValueMeter,
                  "ID":"ppBar",
                  "property":"pp",
                  "maxProperty":"max_pp",
                  "width":UIGlobals.relativize(650 / 2),
                  "height":UIGlobals.relativize(40),
                  "icon":PPIconPng,
                  "color":new Color(UIGlobals.getStyle("PPColor"))
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(5)
               },{
                  "CLASS":Box,
                  "ID":"conditionsBox",
                  "visible":false,
                  "STYLES":{"Gap":UIGlobals.relativize(3)}
               },{
                  "CLASS":Spacer,
                  "height":UIGlobals.relativize(3)
               }]
            }]
         },{
            "CLASS":CreatureView,
            "ID":"creatureView",
            "y":UIGlobals.relativize(180),
            "width":UIGlobals.relativize(480),
            "height":UIGlobals.relativize(480),
            "relativeProportions":true
         },{
            "CLASS":Box,
            "ID":"xpBox",
            "alpha":0,
            "direction":Box.VERTICAL,
            "y":UIGlobals.relativize(280),
            "x":UIGlobals.relativize(80),
            "width":UIGlobals.relativize(320),
            "STYLES":{
               "CornerRadius":10,
               "BackgroundAlpha":0.35,
               "Padding":10
            },
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("NEXT_LEVEL_PROGRESS"),
               "STYLES":{
                  "FontWeight":"bold",
                  "FontSize":UIGlobals.relativize(18)
               },
               "filters":UIGlobals.fontOutline
            },{
               "CLASS":Spacer,
               "height":UIGlobals.relativize(10)
            },{
               "CLASS":ProgressBar,
               "ID":"xpBar",
               "percentWidth":1,
               "height":UIGlobals.relativize(22),
               "STYLES":{
                  "ForegroundColor":UIGlobals.getStyle("XPColor"),
                  "ShowLabel":true,
                  "FontColor":UIUtils.adjustBrightness2(UIGlobals.getStyle("XPColor"),85),
                  "Animated":true,
                  "AnimationSpeed":1,
                  "AnimationInterpolation":Interpolation.linear,
                  "Sound":XpWav,
                  "FontSize":UIGlobals.relativizeFont(17),
                  "BarOffset":-2,
                  "LabelType":"percentage",
                  "FontWeight":"bold"
               }
            }]
         },{
            "CLASS":com.edgebee.breedr.ui.combat.EffectDisplay,
            "ID":"effectDisplay",
            "x":UIGlobals.relativize(252),
            "y":UIGlobals.relativize(552),
            "width":UIGlobals.relativize(216),
            "height":UIGlobals.relativize(216)
         },{
            "CLASS":com.edgebee.breedr.ui.combat.EffectValueDisplay,
            "ID":"effectValueDisplay",
            "x":UIGlobals.relativize(90),
            "y":UIGlobals.relativize(300),
            "width":UIGlobals.relativize(300),
            "height":UIGlobals.relativize(300)
         },{
            "CLASS":com.edgebee.breedr.ui.combat.EffectIconDisplay,
            "ID":"effectIconDisplay",
            "x":UIGlobals.relativize(90),
            "y":UIGlobals.relativize(300),
            "width":UIGlobals.relativize(300),
            "height":UIGlobals.relativize(300)
         },{
            "CLASS":com.edgebee.breedr.ui.combat.CustomIconDisplay,
            "ID":"customIconDisplay"
         },{
            "CLASS":com.edgebee.breedr.ui.combat.IdleDisplay,
            "ID":"idleDisplay",
            "x":UIGlobals.relativize(90),
            "y":UIGlobals.relativize(300),
            "width":UIGlobals.relativize(300),
            "height":UIGlobals.relativize(300)
         }];
         super();
         if(!_showAction)
         {
            _showAction = new Animation();
            _loc1_ = new Track("colorTransformProxy.offset");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.3,200));
            _loc1_.addKeyframe(new Keyframe(0.4,50));
            _loc1_.addKeyframe(new Keyframe(0.5,255));
            _loc1_.addKeyframe(new Keyframe(0.8,0));
            _showAction.addTrack(_loc1_);
         }
         if(!_showDeath)
         {
            _showDeath = new Animation();
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.65,0));
            _showDeath.addTrack(_loc1_);
            _loc1_ = new Track("colorMatrix.brightness");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.65,-100));
            _showDeath.addTrack(_loc1_);
            _loc1_ = new Track("blurProxy.blurY");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.65,20));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _showDeath.addTrack(_loc1_);
         }
         if(!_showSpawn)
         {
            _showSpawn = new Animation();
            _loc1_ = new Track("x",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,UIGlobals.relativize(480) / 2));
            _loc1_.addKeyframe(new Keyframe(0.5,0));
            _loc1_.addKeyframe(new Keyframe(0.55,-UIGlobals.relativize(480) / 20));
            _loc1_.addKeyframe(new Keyframe(0.6,0));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("scaleX");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,1));
            _loc1_.addKeyframe(new Keyframe(0.55,1.1));
            _loc1_.addKeyframe(new Keyframe(0.6,1));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("y");
            _loc1_.addKeyframe(new Keyframe(0,-UIGlobals.relativize(480) * 2));
            _loc1_.addKeyframe(new Keyframe(0.5,UIGlobals.relativize(180)));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("scaleY");
            _loc1_.addKeyframe(new Keyframe(0,1.5));
            _loc1_.addKeyframe(new Keyframe(0.45,1));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("colorTransformProxy.offset");
            _loc1_.addKeyframe(new Keyframe(0,255));
            _loc1_.addKeyframe(new Keyframe(0.25,255));
            _loc1_.addKeyframe(new Keyframe(0.45,0));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("glowProxy.alpha");
            _loc1_.addKeyframe(new Keyframe(0,0.65));
            _loc1_.addKeyframe(new Keyframe(0.55,0));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("alpha");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.45,1));
            _showSpawn.addTrack(_loc1_);
            _loc1_ = new Track("blurProxy.blurY");
            _loc1_.addKeyframe(new Keyframe(0,25));
            _loc1_.addKeyframe(new Keyframe(0.25,25));
            _loc1_.addKeyframe(new Keyframe(0.45,0));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _showSpawn.addTrack(_loc1_);
         }
         if(!_showDamage)
         {
            _showDamage = new Animation();
            _loc1_ = new Track("x",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.075,-3));
            _loc1_.addKeyframe(new Keyframe(0.15,3));
            _loc1_.addKeyframe(new Keyframe(0.225,-3));
            _loc1_.addKeyframe(new Keyframe(0.3,3));
            _loc1_.addKeyframe(new Keyframe(0.375,-3));
            _loc1_.addKeyframe(new Keyframe(0.45,3));
            _loc1_.addKeyframe(new Keyframe(0.55,0));
            _showDamage.addTrack(_loc1_);
            _loc1_ = new Track("y",Track.DELTA);
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.075,3));
            _loc1_.addKeyframe(new Keyframe(0.15,3));
            _loc1_.addKeyframe(new Keyframe(0.225,-3));
            _loc1_.addKeyframe(new Keyframe(0.3,-3));
            _loc1_.addKeyframe(new Keyframe(0.375,-3));
            _loc1_.addKeyframe(new Keyframe(0.45,3));
            _loc1_.addKeyframe(new Keyframe(0.55,0));
            _showDamage.addTrack(_loc1_);
            _showDamageRed = new Animation();
            _loc1_ = new Track("colorTransformProxy.redOffset");
            _loc1_.addKeyframe(new Keyframe(0,250));
            _loc1_.addKeyframe(new Keyframe(0.1,50));
            _loc1_.addKeyframe(new Keyframe(0.2,250));
            _loc1_.addKeyframe(new Keyframe(0.3,50));
            _loc1_.addKeyframe(new Keyframe(0.4,250));
            _loc1_.addKeyframe(new Keyframe(0.5,50));
            _loc1_.addKeyframe(new Keyframe(0.6,250));
            _loc1_.addKeyframe(new Keyframe(0.75,0));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _showDamageRed.addTrack(_loc1_);
         }
         if(!_showRestoration)
         {
            _showRestoration = new Animation();
            _loc1_ = new Track("glowProxy.blur");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.3,20));
            _loc1_.addKeyframe(new Keyframe(0.55,0));
            _showRestoration.addTrack(_loc1_);
            _showRestorationGreen = new Animation();
            _loc1_ = new Track("colorTransformProxy.greenOffset");
            _loc1_.addKeyframe(new Keyframe(0,250));
            _loc1_.addKeyframe(new Keyframe(0.75,0));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _showRestorationGreen.addTrack(_loc1_);
            _loc1_ = new Track("colorTransformProxy.blueOffset");
            _loc1_.addKeyframe(new Keyframe(0,250));
            _loc1_.addKeyframe(new Keyframe(0.75,0));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicIn);
            _showRestorationGreen.addTrack(_loc1_);
         }
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
      
      public function get combatView() : CombatView
      {
         return this.gameView.combatView;
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(!this.creature || !this.creature.equals(param1))
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               this.creature.conditions.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onConditionsChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               this.creature.conditions.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onConditionsChange);
            }
            this.onConditionsChange();
            this.update();
         }
      }
      
      public function get orientation() : String
      {
         return this._orientation;
      }
      
      public function set orientation(param1:String) : void
      {
         if(this._orientation != param1)
         {
            this._orientation = param1;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.creatureView.glowProxy.color = 7829367;
         this.creatureView.glowProxy.blurX = 5;
         this.creatureView.glowProxy.blurY = 25;
         this.creatureView.glowProxy.alpha = 0.65;
         this.creatureView.addEventListener(Event.COMPLETE,this.onCreatureLoaded);
         if(this.orientation == RIGHT)
         {
            this.hpBar.name = "ActorViewLeftHPBar";
            this.hpBar.orientation = com.edgebee.breedr.ui.combat.ValueMeter.RIGHT;
            this.ppBar.name = "ActorViewLeftPPBar";
            this.ppBar.orientation = com.edgebee.breedr.ui.combat.ValueMeter.RIGHT;
            this.creatureView.flipped = true;
            this.infoBox.horizontalAlign = Box.ALIGN_LEFT;
            this.infoBox2.horizontalAlign = Box.ALIGN_LEFT;
            this.xpBox.visible = false;
         }
         else
         {
            this.hpBar.name = "ActorViewRightHPBar";
            this.ppBar.name = "ActorViewRightPPBar";
            this.infoBox2.setStyle("BackgroundDirection",Math.PI);
            this.xpBox.visible = false;
            this._showXpBoxInstance = this.xpBox.controller.addAnimation(UIGlobals.alphaFadeIn);
            this._showXpBoxInstance.speed = 2;
         }
         this._showActionInstance = this.creatureView.fgCvs.controller.addAnimation(_showAction);
         this._showActionInstance.addEventListener(AnimationEvent.START,this.onShowActionStart);
         this._showActionInstance.addEventListener(AnimationEvent.STOP,this.onShowActionStop);
         this._showDamageInstance = this.creatureView.fgCvs.controller.addAnimation(_showDamage);
         this._showDamageInstance.addEventListener(AnimationEvent.STOP,this.onShowDamageStop);
         this._showDamageRedInstance = this.creatureView.fgCvs.controller.addAnimation(_showDamageRed);
         this._showRestorationInstance = this.creatureView.fgCvs.controller.addAnimation(_showRestoration);
         this._showRestorationInstance.addEventListener(AnimationEvent.STOP,this.onShowRestorationStop);
         this._showRestorationGreenInstance = this.creatureView.fgCvs.controller.addAnimation(_showRestorationGreen);
         this._showDeathInstance = this.creatureView.controller.addAnimation(_showDeath);
         this._showDeathInstance.addEventListener(AnimationEvent.STOP,this.onShowDeathStop);
         this._showSpawnInstance = this.creatureView.controller.addAnimation(_showSpawn);
         this._showSpawnInstance.addEventListener(AnimationEvent.STOP,this.onShowSpawnStop);
         this._breathEmitter = new BreathEmitter();
         this._breathEmitter.active = false;
         this.combatView.particleRenderer.addEmitter(this._breathEmitter);
         if(this.orientation == LEFT)
         {
            this._breathEmitter.velocity.x = -(this._breathEmitter.velocity.x + this._breathEmitter.velocity.width);
         }
         this.update();
      }
      
      public function reset() : void
      {
         this.creatureView.colorTransformProxy.reset();
         this.creatureView.glowProxy.reset();
         this.creatureView.blurProxy.reset();
         this.creatureView.colorMatrix.reset();
      }
      
      public function get currentSkill() : SkillInstance
      {
         return this._currentSkill.get() as SkillInstance;
      }
      
      public function showAction(param1:SkillInstance = null) : void
      {
         this._currentSkill.reset(param1);
         this._showActionInstance.speed = 1 * this.client.combatSpeedMultiplier;
         this._showActionInstance.gotoStartAndPlay();
      }
      
      public function showSkillIcons(param1:SkillInstance, param2:Boolean = true) : void
      {
         var _loc3_:EffectPieceInstance = param1.secondary;
         var _loc4_:String = param1.name;
         if(param1.originalIndex == 0)
         {
            _loc4_ = null;
         }
         this.effectIconDisplay.setEffects(_loc4_,param1.primary.effect_piece,!!_loc3_ ? _loc3_.effect_piece : null,!param2);
         this.effectIconDisplay.show();
      }
      
      public function showIdle(param1:String) : void
      {
         this.idleDisplay.idle = param1;
         this.idleDisplay.show();
      }
      
      public function showDamage() : void
      {
         this._showDamageInstance.speed = 1 * this.client.combatSpeedMultiplier;
         this._showDamageInstance.gotoStartAndPlay();
         this._showDamageRedInstance.speed = 1 * this.client.combatSpeedMultiplier;
         this._showDamageRedInstance.gotoStartAndPlay();
      }
      
      public function showRestoration() : void
      {
         this.creatureView.glowProxy.alpha = 1;
         this.creatureView.glowProxy.blur = 0;
         this.creatureView.glowProxy.color = 65535;
         this.creatureView.glowProxy.strength = 3;
         this.creatureView.glowProxy.quality = 2;
         this._showRestorationInstance.speed = 1 * this.client.combatSpeedMultiplier;
         this._showRestorationInstance.gotoStartAndPlay();
         this._showRestorationGreenInstance.speed = 1 * this.client.combatSpeedMultiplier;
         this._showRestorationGreenInstance.gotoStartAndPlay();
      }
      
      public function showDeath() : void
      {
         colorTransformProxy.reset();
         blurProxy.reset();
         this._showDeathInstance.gotoStartAndPlay();
      }
      
      public function showSpawn() : void
      {
         this._showSpawnInstance.gotoStartAndPlay();
         UIGlobals.playSound(SpawnWav);
      }
      
      public function showMiss() : void
      {
         this.effectValueDisplay.color = 15663103;
         this.effectValueDisplay.label = Asset.getInstanceByName("MISS2").value;
         this.effectValueDisplay.show();
      }
      
      public function showLucky() : void
      {
         this.customIconDisplay.icon = LuckyPng;
         this.customIconDisplay.show();
      }
      
      public function showNoEffect() : void
      {
         this.effectValueDisplay.color = 14548991;
         this.effectValueDisplay.label = Asset.getInstanceByName("RESISTED").value;
         this.effectValueDisplay.show();
      }
      
      public function showLevelUp() : void
      {
         this.effectValueDisplay.color = UIGlobals.getStyle("XPColor");
         this.effectValueDisplay.label = Asset.getInstanceByName("LEVELUP").value;
         this.effectValueDisplay.useCombatSpeedMultiplier = false;
         this.effectValueDisplay.show();
         this.effectValueDisplay.useCombatSpeedMultiplier = true;
      }
      
      public function showXpBox() : void
      {
         this.xpBox.visible = true;
         this._showXpBoxInstance.speed = 3;
         this._showXpBoxInstance.gotoStartAndPlay();
      }
      
      public function hideXpBox() : void
      {
         this._showXpBoxInstance.speed = 2;
         this._showXpBoxInstance.gotoEndAndPlayReversed();
         this._showXpBoxInstance.addEventListener(AnimationEvent.STOP,this.onHideXpAnimationEnd);
      }
      
      private function onHideXpAnimationEnd(param1:AnimationEvent) : void
      {
         this._showXpBoxInstance.removeEventListener(AnimationEvent.STOP,this.onHideXpAnimationEnd);
         this.xpBox.visible = false;
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.creature)
            {
               this.nameLbl.text = this.creature.name;
               this.levelLbl.text = this.creature.level.toString();
               this.creatureView.creature = this.creature;
               this.hpBar.target = this.creature;
               this.ppBar.target = this.creature;
            }
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "level")
         {
            if(childrenCreated || childrenCreating)
            {
               this.levelLbl.text = this.creature.level.toString();
            }
         }
      }
      
      private function onCreatureLoaded(param1:Event) : void
      {
         var _loc2_:Point = globalToLocal(this.creatureView.bodyCenter);
         this.effectDisplay.x = _loc2_.x;
         this.effectDisplay.y = _loc2_.y;
         this.effectValueDisplay.x = _loc2_.x - this.effectValueDisplay.width / 2;
         this.effectValueDisplay.y = _loc2_.y - this.effectValueDisplay.height / 2 - this.creatureView.height / 5;
         this.effectIconDisplay.x = _loc2_.x - this.effectIconDisplay.width / 2;
         this.effectIconDisplay.y = _loc2_.y - this.effectIconDisplay.height / 2 - this.creatureView.height / 5;
         this.idleDisplay.x = _loc2_.x - this.idleDisplay.width / 2;
         this.idleDisplay.y = _loc2_.y - this.idleDisplay.height / 2 - this.creatureView.height / 4;
         this.customIconDisplay.x = _loc2_.x;
         this.customIconDisplay.y = _loc2_.y;
      }
      
      private function onConditionsChange(param1:CollectionEvent = null) : void
      {
         var _loc2_:Condition = null;
         var _loc3_:ConditionView = null;
         var _loc4_:int = 0;
         if(!param1 || param1.kind == CollectionEvent.RESET)
         {
            this.conditionsBox.removeAllChildren();
            if(this.creature)
            {
               for each(_loc2_ in this.creature.conditions)
               {
                  _loc3_ = new ConditionView();
                  _loc3_.width = UIGlobals.relativizeX(48);
                  _loc3_.height = UIGlobals.relativizeY(48);
                  _loc3_.condition = _loc2_;
                  this.conditionsBox.addChild(_loc3_);
               }
            }
         }
         else if(Boolean(param1) && Boolean(param1.subject))
         {
            if(param1.kind == CollectionEvent.ADD && param1.subject is Condition)
            {
               _loc2_ = param1.subject as Condition;
               _loc3_ = new ConditionView();
               _loc3_.width = UIGlobals.relativizeX(32);
               _loc3_.height = UIGlobals.relativizeY(32);
               _loc3_.condition = _loc2_;
               this.conditionsBox.addChild(_loc3_);
            }
            else if(param1.kind == CollectionEvent.REMOVE && param1.subject is Condition)
            {
               _loc2_ = param1.subject as Condition;
               _loc4_ = 0;
               while(_loc4_ < this.conditionsBox.numChildren)
               {
                  _loc3_ = this.conditionsBox.getChildAt(_loc4_) as ConditionView;
                  if(Boolean(_loc3_) && _loc3_.condition == _loc2_)
                  {
                     this.conditionsBox.removeChildAt(_loc4_);
                     break;
                  }
                  _loc4_++;
               }
            }
         }
         this.conditionsBox.visible = this.conditionsBox.numChildren > 0;
      }
      
      private function onShowActionStart(param1:AnimationEvent) : void
      {
         var _loc2_:Point = null;
         if(Boolean(this.currentSkill) && this.currentSkill.primaryType == Effect.TYPE_DAMAGE)
         {
            _loc2_ = new Point(this.creatureView.x + this.creatureView.width / 2,this.creatureView.y + 3 * this.creatureView.height / 4);
            _loc2_ = localToGlobal(_loc2_);
            this._breathEmitter.element = this.currentSkill.primaryElementType;
            this._breathEmitter.position.x = _loc2_.x - 5;
            this._breathEmitter.position.y = _loc2_.y - 5;
            switch(this.currentSkill.primaryElementType.type)
            {
               case Element.TYPE_FIRE:
                  UIGlobals.playSound(FireBreathWav);
                  break;
               case Element.TYPE_ICE:
                  UIGlobals.playSound(IceBreathWav);
                  break;
               case Element.TYPE_THUNDER:
                  UIGlobals.playSound(ThunderBreathWav);
                  break;
               case Element.TYPE_EARTH:
                  UIGlobals.playSound(EarthBreathWav);
            }
            this.combatView.particleLayer.filters = [new BlurFilter(16,16,1)];
            this._breathEmitter.active = true;
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onShowActionStop(param1:AnimationEvent) : void
      {
         if(Boolean(this.currentSkill) && this.currentSkill.primaryType == Effect.TYPE_DAMAGE)
         {
            this._breathEmitter.active = false;
            this._currentSkill.reset(null);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(visible)
         {
            this._breathEmitter.step();
            if(this._breathEmitter.numParticles == 0)
            {
               this.combatView.particleLayer.filters = [];
               removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
         }
      }
      
      private function onShowDamageStop(param1:AnimationEvent) : void
      {
      }
      
      private function onShowRestorationStop(param1:AnimationEvent) : void
      {
         this.creatureView.glowProxy.reset();
      }
      
      private function onShowDeathStop(param1:AnimationEvent) : void
      {
      }
      
      private function onShowSpawnStop(param1:AnimationEvent) : void
      {
         this.creatureView.colorTransformProxy.reset();
         this.creatureView.glowProxy.reset();
         this.creatureView.blurProxy.reset();
         this.creatureView.x = 0;
         this.creatureView.y = UIGlobals.relativize(180);
         this.creatureView.scaleX = 1;
         this.creatureView.scaleY = 1;
         this.onCreatureLoaded(null);
      }
      
      private function onHpClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ACTOR_HP_CLICKED,{"creature":this.creature}));
      }
      
      private function onPpClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ACTOR_PP_CLICKED,{"creature":this.creature}));
      }
      
      private function onConditionClick(param1:ExtendedEvent) : void
      {
         dispatchEvent(new ExtendedEvent(ACTOR_CONDITION_CLICKED,{
            "creature":this.creature,
            "condition":param1.data.condition
         }));
      }
      
      private function onConditionMouseOver(param1:ExtendedEvent) : void
      {
      }
      
      private function onConditionMouseOut(param1:ExtendedEvent) : void
      {
      }
   }
}
