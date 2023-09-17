package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.events.ItemUseEvent;
   import com.edgebee.breedr.managers.handlers.TrashItemHandler;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.item.InventoryItemView;
   import flash.display.Bitmap;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class UseItemEffect extends Canvas
   {
       
      
      private var _useEvent:ItemUseEvent;
      
      private var _center:Point;
      
      private var _anim:Animation;
      
      private var _animInstance:AnimationInstance;
      
      private var _onStage:Boolean = false;
      
      private var _timer:Timer;
      
      public var itemBmp:BitmapComponent;
      
      private var _layout:Array;
      
      public function UseItemEffect()
      {
         this._timer = new Timer(0,1);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"itemBmp",
            "isSquare":true,
            "width":UIGlobals.relativize(64)
         }];
         super();
         width = UIGlobals.relativize(64);
         height = UIGlobals.relativize(64);
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
         alpha = 0;
         glowProxy.color = 16777215;
         glowProxy.alpha = 1;
         glowProxy.strength = 3;
         glowProxy.blur = 4;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
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
      
      public function get useEvent() : ItemUseEvent
      {
         return this._useEvent;
      }
      
      public function set useEvent(param1:ItemUseEvent) : void
      {
         if(this.useEvent != param1)
         {
            this._useEvent = param1;
            this.update();
         }
      }
      
      public function get center() : Point
      {
         return this._center;
      }
      
      public function set center(param1:Point) : void
      {
         if(this._center != param1)
         {
            this._center = param1;
         }
      }
      
      public function get delay() : Number
      {
         return this._timer.delay;
      }
      
      public function set delay(param1:Number) : void
      {
         if(this._timer.delay != param1)
         {
            this._timer.delay = param1;
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(this.center) && width > 0)
         {
            x = this.center.x - width / 2;
            y = this.center.y - height / 2;
            this.center = null;
            this.start();
         }
      }
      
      private function start() : void
      {
         var _loc1_:Track = null;
         var _loc2_:Track = null;
         var _loc3_:Track = null;
         var _loc4_:Track = null;
         var _loc5_:Track = null;
         var _loc6_:Track = null;
         var _loc7_:Track = null;
         if((childrenCreated || childrenCreating) && this._onStage && this.center == null && !this._timer.running)
         {
            visible = true;
            this._anim = new Animation();
            _loc2_ = new Track("x",Track.DELTA);
            _loc2_.addKeyframe(new Keyframe(0,-width * 0.15));
            _loc2_.addKeyframe(new Keyframe(0.25,0));
            _loc2_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            this._anim.addTrack(_loc2_);
            (_loc5_ = new Track("scaleX")).addKeyframe(new Keyframe(0,1.3));
            _loc5_.addKeyframe(new Keyframe(0.25,1));
            _loc5_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            this._anim.addTrack(_loc5_);
            _loc3_ = new Track("y",Track.DELTA);
            _loc3_.addKeyframe(new Keyframe(0,-height * 0.15));
            _loc3_.addKeyframe(new Keyframe(0.25,0));
            _loc3_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            this._anim.addTrack(_loc3_);
            (_loc6_ = new Track("scaleY")).addKeyframe(new Keyframe(0,1.3));
            _loc6_.addKeyframe(new Keyframe(0.2,1));
            _loc6_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            this._anim.addTrack(_loc6_);
            (_loc4_ = new Track("alpha")).addKeyframe(new Keyframe(0,0));
            _loc4_.addKeyframe(new Keyframe(0.05,1));
            _loc4_.addKeyframe(new Keyframe(0.5,1));
            this._anim.addTrack(_loc4_);
            (_loc7_ = new Track("colorMatrix.brightness")).addKeyframe(new Keyframe(0,35));
            _loc7_.addKeyframe(new Keyframe(0.25,0));
            this._anim.addTrack(_loc7_);
            if(this.useEvent.breaks || this.useEvent.destroy)
            {
               _loc2_.addKeyframe(new Keyframe(0.6,0));
               _loc2_.addCallback(new Callback(0.6,"break"));
               _loc2_.addKeyframe(new Keyframe(1.25,width / 2));
               _loc2_.addTransitionByKeyframeTime(0.6,Interpolation.cubicOut);
               _loc5_.addKeyframe(new Keyframe(0.6,1));
               _loc5_.addKeyframe(new Keyframe(1.25,0));
               _loc5_.addTransitionByKeyframeTime(0.6,Interpolation.cubicOut);
               _loc3_.addKeyframe(new Keyframe(0.6,0));
               _loc3_.addCallback(new Callback(0.6,"break"));
               _loc3_.addKeyframe(new Keyframe(1.25,-height / 2));
               _loc3_.addTransitionByKeyframeTime(0.6,Interpolation.cubicOut);
               _loc6_.addKeyframe(new Keyframe(0.6,1));
               _loc6_.addKeyframe(new Keyframe(1.25,2));
               _loc6_.addTransitionByKeyframeTime(0.6,Interpolation.cubicOut);
               _loc4_.addKeyframe(new Keyframe(1.05,1));
               _loc4_.addKeyframe(new Keyframe(1.25,0));
               _loc7_.addKeyframe(new Keyframe(0.75,0));
               _loc7_.addKeyframe(new Keyframe(1.25,100));
            }
            else
            {
               _loc4_.addKeyframe(new Keyframe(0.75,0));
            }
            this._anim.speed = 0.75;
            this._animInstance = controller.addAnimation(this._anim);
            this._animInstance.addEventListener(AnimationEvent.STOP,this.onAnimationStop);
            this._animInstance.addEventListener(AnimationEvent.CALLBACK,this.onAnimationCallback);
            this._animInstance.gotoStartAndPlay();
         }
      }
      
      private function update() : void
      {
         var _loc1_:InventoryItemView = null;
         var _loc2_:Listable = null;
         var _loc3_:Bitmap = null;
         if(childrenCreated || childrenCreating)
         {
            for each(_loc2_ in this.gameView.inventoryView.inventoryList.listables)
            {
               _loc1_ = _loc2_ as InventoryItemView;
               if(_loc1_ && _loc1_.item && _loc1_.item.id == this.useEvent.id)
               {
                  break;
               }
            }
            if(Boolean(_loc1_) && _loc1_.itemView.image.loaded)
            {
               _loc3_ = new Bitmap((_loc1_.itemView.image.content as Bitmap).bitmapData,PixelSnapping.AUTO,true);
               this.itemBmp.bitmap = _loc3_;
            }
            this.start();
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         this.start();
      }
      
      private function onAnimationStop(param1:AnimationEvent) : void
      {
         this._animInstance.removeEventListener(AnimationEvent.STOP,this.onAnimationStop);
         if(Boolean(parent) && parent.getChildIndex(this) >= 0)
         {
            parent.removeChild(this);
         }
      }
      
      private function onAnimationCallback(param1:AnimationEvent) : void
      {
         if(param1.data == "break" && this.useEvent.breaks)
         {
            UIGlobals.playSound(TrashItemHandler.ThrashWav);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._onStage = true;
         if(this._timer.delay > 0)
         {
            this._timer.start();
         }
         this.start();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this._onStage = false;
         if(this._animInstance.playing)
         {
            this._animInstance.stop();
         }
      }
   }
}
