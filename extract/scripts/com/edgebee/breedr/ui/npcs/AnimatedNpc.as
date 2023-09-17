package com.edgebee.breedr.ui.npcs
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   
   public class AnimatedNpc extends Canvas
   {
      
      private static const MIN_BLINK_INTERVAL:Number = 2500;
      
      private static const BLINK_INTERVAL_RANDOM:Number = 2500;
       
      
      private var _talking:Boolean = false;
      
      public var _frames:Object;
      
      private var _blinkEyesAnimation:Animation;
      
      private var _blinkEyesInstance:AnimationInstance;
      
      private var _blinkTimer:Timer;
      
      private var _talkAnimation:Animation;
      
      private var _talkInstance:AnimationInstance;
      
      public var baseBmp:BitmapComponent;
      
      public var eyes1Bmp:BitmapComponent;
      
      public var eyes2Bmp:BitmapComponent;
      
      public var eyes3Bmp:BitmapComponent;
      
      public var mouth1Bmp:BitmapComponent;
      
      public var mouth2Bmp:BitmapComponent;
      
      public var mouth3Bmp:BitmapComponent;
      
      private var _layout:Array;
      
      public function AnimatedNpc()
      {
         var _loc1_:Track = null;
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"baseBmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"eyes1Bmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"eyes2Bmp",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"eyes3Bmp",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"mouth1Bmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"mouth2Bmp",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"mouth3Bmp",
            "visible":false,
            "percentWidth":1,
            "percentHeight":1
         }];
         super();
         if(!this._blinkEyesAnimation)
         {
            this._blinkEyesAnimation = new Animation();
            _loc1_ = new Track("dummy");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addCallback(new Callback(0,"eyes1",true));
            _loc1_.addCallback(new Callback(0.25,"eyes2",true));
            _loc1_.addCallback(new Callback(0.5,"eyes3",true));
            _loc1_.addCallback(new Callback(0.75,"eyes2",true));
            _loc1_.addCallback(new Callback(1,"eyes1"));
            _loc1_.addKeyframe(new Keyframe(1,0));
            this._blinkEyesAnimation.addTrack(_loc1_);
         }
         this._blinkEyesInstance = controller.addAnimation(this._blinkEyesAnimation);
         this._blinkEyesInstance.speed = 3;
         this._blinkEyesInstance.addEventListener(AnimationEvent.CALLBACK,this.onAnimationCallback);
         if(!this._talkAnimation)
         {
            this._talkAnimation = new Animation();
            _loc1_ = new Track("dummy");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addCallback(new Callback(0,"mouth1",true));
            _loc1_.addCallback(new Callback(0.1,"mouth2",true));
            _loc1_.addCallback(new Callback(0.2,"mouth3",true));
            _loc1_.addCallback(new Callback(0.3,"mouth1",true));
            _loc1_.addCallback(new Callback(0.4,"mouth3",true));
            _loc1_.addCallback(new Callback(0.5,"mouth2",true));
            _loc1_.addCallback(new Callback(0.6,"mouth3",true));
            _loc1_.addCallback(new Callback(0.7,"mouth1",true));
            _loc1_.addCallback(new Callback(0.8,"mouth2",true));
            _loc1_.addCallback(new Callback(0.9,"mouth3",true));
            _loc1_.addCallback(new Callback(1,"mouth2",true));
            _loc1_.addKeyframe(new Keyframe(1,0));
            this._talkAnimation.addTrack(_loc1_);
            this._talkAnimation.loop = true;
         }
         this._talkInstance = controller.addAnimation(this._talkAnimation);
         this._talkInstance.addEventListener(AnimationEvent.CALLBACK,this.onAnimationCallback);
      }
      
      public function get talking() : Boolean
      {
         return this._talking;
      }
      
      public function set talking(param1:Boolean) : void
      {
         if(this._talking != param1)
         {
            this._talking = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"talking",!this.talking,this.talking));
            this.update();
         }
      }
      
      public function get frames() : Object
      {
         return this._frames;
      }
      
      public function set frames(param1:Object) : void
      {
         if(this._frames != param1)
         {
            this._frames = param1;
            if(this.frames)
            {
               this.baseBmp.source = this.frames["base"].bmp;
               this.baseBmp.bitmapRect = new Rectangle(this.frames["base"].x / 512,this.frames["base"].y / 768,this.baseBmp.bitmap.bitmapData.width / 512,this.baseBmp.bitmap.bitmapData.height / 768);
               if(this.frames.hasOwnProperty("eyes1"))
               {
                  this.eyes1Bmp.source = this.frames["eyes1"].bmp;
                  this.eyes1Bmp.bitmapRect = new Rectangle(this.frames["eyes1"].x / 512,this.frames["eyes1"].y / 768,this.eyes1Bmp.bitmap.bitmapData.width / 512,this.eyes1Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.eyes1Bmp.source = null;
               }
               if(this.frames.hasOwnProperty("eyes2"))
               {
                  this.eyes2Bmp.source = this.frames["eyes2"].bmp;
                  this.eyes2Bmp.bitmapRect = new Rectangle(this.frames["eyes2"].x / 512,this.frames["eyes2"].y / 768,this.eyes2Bmp.bitmap.bitmapData.width / 512,this.eyes2Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.eyes2Bmp.source = null;
               }
               if(this.frames.hasOwnProperty("eyes3"))
               {
                  this.eyes3Bmp.source = this.frames["eyes3"].bmp;
                  this.eyes3Bmp.bitmapRect = new Rectangle(this.frames["eyes3"].x / 512,this.frames["eyes3"].y / 768,this.eyes3Bmp.bitmap.bitmapData.width / 512,this.eyes3Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.eyes3Bmp.source = null;
               }
               if(this.frames.hasOwnProperty("mouth1"))
               {
                  this.mouth1Bmp.source = this.frames["mouth1"].bmp;
                  this.mouth1Bmp.bitmapRect = new Rectangle(this.frames["mouth1"].x / 512,this.frames["mouth1"].y / 768,this.mouth1Bmp.bitmap.bitmapData.width / 512,this.mouth1Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.mouth1Bmp.source = null;
               }
               if(this.frames.hasOwnProperty("mouth2"))
               {
                  this.mouth2Bmp.source = this.frames["mouth2"].bmp;
                  this.mouth2Bmp.bitmapRect = new Rectangle(this.frames["mouth2"].x / 512,this.frames["mouth2"].y / 768,this.mouth2Bmp.bitmap.bitmapData.width / 512,this.mouth2Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.mouth2Bmp.source = null;
               }
               if(this.frames.hasOwnProperty("mouth3"))
               {
                  this.mouth3Bmp.source = this.frames["mouth3"].bmp;
                  this.mouth3Bmp.bitmapRect = new Rectangle(this.frames["mouth3"].x / 512,this.frames["mouth3"].y / 768,this.mouth3Bmp.bitmap.bitmapData.width / 512,this.mouth3Bmp.bitmap.bitmapData.height / 768);
               }
               else
               {
                  this.mouth3Bmp.source = null;
               }
            }
            else
            {
               this.baseBmp.source = null;
               this.eyes1Bmp.source = null;
               this.eyes2Bmp.source = null;
               this.eyes3Bmp.source = null;
               this.mouth1Bmp.source = null;
               this.mouth2Bmp.source = null;
               this.mouth3Bmp.source = null;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._blinkTimer = new Timer(MIN_BLINK_INTERVAL + Math.random() * BLINK_INTERVAL_RANDOM,1);
         this._blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onBlinkTimer);
         this._blinkTimer.start();
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this._blinkTimer.start();
         }
         else
         {
            this._blinkTimer.stop();
            this.talking = false;
         }
      }
      
      public function get dummy() : int
      {
         return 0;
      }
      
      public function set dummy(param1:int) : void
      {
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.talking)
            {
               this._talkInstance.gotoStartAndPlay();
            }
            else
            {
               this._talkInstance.gotoStartAndStop();
               this.mouth1Bmp.visible = true;
               this.mouth2Bmp.visible = false;
               this.mouth3Bmp.visible = false;
            }
         }
      }
      
      private function onAnimationCallback(param1:AnimationEvent) : void
      {
         if(childrenCreated || childrenCreating)
         {
            switch(param1.data)
            {
               case "eyes1":
                  if(!this.eyes1Bmp.bitmap)
                  {
                     break;
                  }
                  this.eyes1Bmp.visible = true;
                  this.eyes2Bmp.visible = false;
                  this.eyes3Bmp.visible = false;
                  break;
               case "eyes2":
                  if(!this.eyes2Bmp.bitmap)
                  {
                     break;
                  }
                  this.eyes2Bmp.visible = true;
                  this.eyes1Bmp.visible = false;
                  this.eyes3Bmp.visible = false;
                  break;
               case "eyes3":
                  if(!this.eyes3Bmp.bitmap)
                  {
                     break;
                  }
                  this.eyes3Bmp.visible = true;
                  this.eyes2Bmp.visible = false;
                  this.eyes1Bmp.visible = false;
                  break;
               case "mouth1":
                  if(!this.mouth1Bmp.bitmap)
                  {
                     break;
                  }
                  this.mouth1Bmp.visible = true;
                  this.mouth2Bmp.visible = false;
                  this.mouth3Bmp.visible = false;
                  break;
               case "mouth2":
                  if(!this.mouth2Bmp.bitmap)
                  {
                     break;
                  }
                  this.mouth2Bmp.visible = true;
                  this.mouth1Bmp.visible = false;
                  this.mouth3Bmp.visible = false;
                  break;
               case "mouth3":
                  if(!this.mouth3Bmp.bitmap)
                  {
                     break;
                  }
                  this.mouth3Bmp.visible = true;
                  this.mouth2Bmp.visible = false;
                  this.mouth1Bmp.visible = false;
                  break;
            }
         }
      }
      
      private function onBlinkTimer(param1:TimerEvent) : void
      {
         this._blinkTimer.reset();
         this._blinkTimer.delay = MIN_BLINK_INTERVAL + Math.random() * BLINK_INTERVAL_RANDOM;
         this._blinkTimer.repeatCount = 1;
         this._blinkTimer.start();
         if(!this._blinkEyesInstance.playing)
         {
            this._blinkEyesInstance.gotoStartAndPlay();
         }
      }
   }
}
