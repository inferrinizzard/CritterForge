package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.skins.borders.ShadowBorder;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.managers.handlers.combat.DamageHandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.*;
   import flash.utils.ByteArray;
   
   public class LogoSplash extends Canvas
   {
      
      public static var EdgebeePng:Class = LogoSplash_EdgebeePng;
      
      public static var EdgeArcadePng:Class = LogoSplash_EdgeArcadePng;
      
      public static var EdgeArcadeButtonPng:Class = LogoSplash_EdgeArcadeButtonPng;
      
      public static var IntroMc:Class = LogoSplash_IntroMc;
       
      
      public var splashBgAnimation:Animation;
      
      public var splashBgInstance:AnimationInstance;
      
      public var edgebeeSplashAnimation:Animation;
      
      public var edgebeeSplashInstance:AnimationInstance;
      
      public var edgeArcadeSplashAnimation:Animation;
      
      public var edgeArcadeSplashInstance:AnimationInstance;
      
      public var creditsAnimation:Animation;
      
      public var creditsInstance:AnimationInstance;
      
      public var edgebeeSplashBox:Box;
      
      public var edgebeeBmp:BitmapComponent;
      
      public var edgeArcadeSplashBox:Box;
      
      public var edgeArcadeBmp:BitmapComponent;
      
      public var splashMovie:MovieClipComponent;
      
      public var breedrSplashCvs:Canvas;
      
      public var creditsLbl:Label;
      
      public var bgLoader:SWFLoader;
      
      private var _introLoader:Loader;
      
      private var _playOnChildrenCreated:Boolean = false;
      
      private var _skipOnChildrenCreated:Boolean = false;
      
      private var _layout:Array;
      
      public function LogoSplash()
      {
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"edgebeeBmp",
            "centered":true,
            "width":256,
            "height":256,
            "source":EdgebeePng,
            "filters":[new GlowFilter(16777215,1,3,3,10,2)]
         },{
            "CLASS":BitmapComponent,
            "ID":"edgeArcadeBmp",
            "centered":true,
            "width":UIGlobals.relativizeX(587),
            "height":UIGlobals.relativizeY(128),
            "source":EdgeArcadePng
         },{
            "CLASS":Canvas,
            "ID":"breedrSplashCvs",
            "alpha":0,
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":Box,
               "percentWidth":1,
               "percentHeight":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "CHILDREN":[{
                  "CLASS":SWFLoader,
                  "ID":"bgLoader",
                  "width":UIGlobals.relativizeX(960),
                  "height":UIGlobals.relativizeY(720),
                  "source":UIGlobals.getAssetPath("breedr/bg/city.jpg")
               }]
            },{
               "CLASS":MovieClipComponent,
               "ID":"splashMovie",
               "controlled":false,
               "width":UIGlobals.relativize(960),
               "height":UIGlobals.relativize(720)
            }]
         },{
            "CLASS":Box,
            "percentWidth":0.9,
            "percentHeight":0.8,
            "direction":Box.HORIZONTAL,
            "horizontalAlign":Box.ALIGN_LEFT,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "CHILDREN":[{
               "CLASS":Spacer,
               "width":50
            },{
               "CLASS":Label,
               "alpha":0.2,
               "text":Asset.getInstanceByName("CLICK_TO_SKIP").value.toLocaleUpperCase(),
               "filters":[new GlowFilter(0,1,4,4,3)],
               "STYLES":{
                  "FontSize":9,
                  "FontColor":16777215
               }
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":0.9,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"creditsLbl",
               "useHtml":true,
               "filters":[new GlowFilter(0,0.5,4,4,3),new DropShadowFilter()]
            }]
         }];
         super();
         mouseChildren = false;
         this._introLoader = new Loader();
         this._introLoader.loadBytes(new IntroMc() as ByteArray);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function play() : void
      {
         this._playOnChildrenCreated = true;
         if(childrenCreated)
         {
            this.splashBgInstance.play();
            this.edgebeeSplashInstance.play();
            this.edgeArcadeSplashInstance.play();
            this.creditsInstance.play();
         }
      }
      
      public function skip() : void
      {
         this._skipOnChildrenCreated = true;
         if(childrenCreated)
         {
            this.splashBgInstance.gotoEndAndStop();
            this.edgebeeSplashInstance.gotoEndAndStop();
            this.edgeArcadeSplashInstance.gotoEndAndStop();
            this.creditsInstance.gotoEndAndStop();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:Track = null;
         var _loc3_:Number = NaN;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         super.createChildren();
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         alpha = 0;
         UIUtils.performLayout(this,this,this._layout);
         var _loc1_:ShadowBorder = new ShadowBorder(this.bgLoader);
         _loc1_.setStyle("ShadowBorderEnabled",true);
         this.bgLoader.addChild(_loc1_);
         this.bgLoader.colorMatrix.saturation = -100;
         this.edgebeeBmp.x = width / 2;
         this.edgebeeBmp.y = height / 2;
         this.edgeArcadeBmp.x = width / 2;
         this.edgeArcadeBmp.y = height / 2;
         if(!this.splashBgAnimation)
         {
            this.splashBgAnimation = new Animation();
            _loc2_ = new Track("alpha");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addCallback(new Callback(5,"intro",true));
            _loc2_.addCallback(new Callback(5,"music"));
            _loc2_.addKeyframe(new Keyframe(45,1));
            _loc2_.addKeyframe(new Keyframe(47.5,0));
            this.splashBgAnimation.addTrack(_loc2_);
            this.edgebeeSplashAnimation = new Animation();
            _loc2_ = new Track("alpha");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(0.5,1));
            _loc2_.addKeyframe(new Keyframe(1.75,1));
            _loc2_.addKeyframe(new Keyframe(2,0));
            this.edgebeeSplashAnimation.addTrack(_loc2_);
            _loc2_ = new Track("scaleX");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(2,1.1));
            this.edgebeeSplashAnimation.addTrack(_loc2_);
            _loc2_ = new Track("scaleY");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(2,1.1));
            this.edgebeeSplashAnimation.addTrack(_loc2_);
            this.edgeArcadeSplashAnimation = new Animation();
            _loc2_ = new Track("alpha");
            _loc2_.addKeyframe(new Keyframe(0,0));
            _loc2_.addKeyframe(new Keyframe(2,0));
            _loc2_.addKeyframe(new Keyframe(2.5,1));
            _loc2_.addKeyframe(new Keyframe(3.5,1));
            _loc2_.addKeyframe(new Keyframe(4,0));
            this.edgeArcadeSplashAnimation.addTrack(_loc2_);
            _loc2_ = new Track("scaleX");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(2,1));
            _loc2_.addKeyframe(new Keyframe(4,1.1));
            this.edgeArcadeSplashAnimation.addTrack(_loc2_);
            _loc2_ = new Track("scaleY");
            _loc2_.addKeyframe(new Keyframe(0,1));
            _loc2_.addKeyframe(new Keyframe(2,1));
            _loc2_.addKeyframe(new Keyframe(4,1.1));
            this.edgeArcadeSplashAnimation.addTrack(_loc2_);
            this.creditsAnimation = new Animation();
            _loc2_ = new Track("alpha");
            _loc3_ = 7;
            _loc4_ = ["BREEDR_CREDITS_DESIGN","BREEDR_CREDITS_PROGRAMING","BREEDR_CREDITS_ARTWORK","BREEDR_CREDITS_MUSIC","BREEDR_CREDITS_OTHER","BREEDR_CREDITS_SPECIAL"];
            _loc2_.addKeyframe(new Keyframe(0,0));
            for each(_loc5_ in _loc4_)
            {
               _loc2_.addCallback(new Callback(_loc3_,_loc5_,true));
               _loc2_.addKeyframe(new Keyframe(_loc3_,0));
               _loc2_.addKeyframe(new Keyframe(_loc3_ + 1,0.75));
               _loc2_.addKeyframe(new Keyframe(_loc3_ + 4,0.75));
               _loc2_.addKeyframe(new Keyframe(_loc3_ + 5,0));
               _loc3_ += 6;
            }
            this.creditsAnimation.addTrack(_loc2_);
         }
         this.splashBgInstance = controller.addAnimation(this.splashBgAnimation);
         this.splashBgInstance.addEventListener(AnimationEvent.STOP,this.onSplashComplete);
         this.splashBgInstance.addEventListener(AnimationEvent.CALLBACK,this.onCallback);
         this.edgebeeSplashInstance = this.edgebeeBmp.controller.addAnimation(this.edgebeeSplashAnimation);
         this.edgeArcadeSplashInstance = this.edgeArcadeBmp.controller.addAnimation(this.edgeArcadeSplashAnimation);
         this.creditsInstance = this.creditsLbl.controller.addAnimation(this.creditsAnimation);
         this.creditsInstance.addEventListener(AnimationEvent.CALLBACK,this.onCreditsCallback);
         if(this._playOnChildrenCreated || this._skipOnChildrenCreated)
         {
            this.play();
         }
         if(this._skipOnChildrenCreated)
         {
            this.skip();
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         this.skip();
      }
      
      private function onSplashComplete(param1:AnimationEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onCallback(param1:AnimationEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         if(param1.data == "intro")
         {
            this.breedrSplashCvs.alpha = 1;
            _loc2_ = this._introLoader.content as MovieClip;
            _loc3_ = stage.stageWidth / 800;
            _loc2_.scaleX = 2 * _loc3_;
            _loc2_.scaleY = 2 * _loc3_;
            _loc2_.intro.gotoAndPlay(0);
            _loc2_.addEventListener("COLLISION",this.onIntroCollision,false,0,false);
            this.splashMovie.movieclip = _loc2_;
         }
         if(param1.data == "music")
         {
            UIGlobals.root.client.sndManager.playMusic(UIGlobals.getAssetPath("breedr/sounds/music/intro.mp3"));
         }
      }
      
      private function onCreditsCallback(param1:AnimationEvent) : void
      {
         this.creditsLbl.text = Utils.htmlWrap(Asset.getInstanceByName(param1.data as String).value,null,16777215,20,false,false,"center");
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var _loc2_:MovieClip = this._introLoader.content as MovieClip;
         _loc2_.intro.stop;
         this.splashMovie.movieclip = null;
         this._introLoader.unload();
      }
      
      private function onIntroCollision(param1:Event) : void
      {
         UIGlobals.playSound(DamageHandler.CrushWav);
      }
   }
}
