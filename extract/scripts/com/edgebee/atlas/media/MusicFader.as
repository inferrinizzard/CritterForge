package com.edgebee.atlas.media
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.animation.IAnimatable;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.managers.SoundManager;
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   
   public class MusicFader extends EventDispatcher implements IAnimatable
   {
      
      public static const FADE_COMPLETE:String = "FADE_COMPLETE";
      
      public static const IN:String = "IN";
      
      public static const OUT:String = "OUT";
      
      private static var _fadeIn:Animation;
      
      private static var _fadeOut:Animation;
       
      
      private var _direction:String;
      
      private var _volume:Number;
      
      private var _musicInfo:com.edgebee.atlas.media.MusicInfo;
      
      private var _sndManager:SoundManager;
      
      private var _controller:Controller;
      
      private var _instance:AnimationInstance;
      
      private var _disposed:Boolean = false;
      
      public function MusicFader(param1:com.edgebee.atlas.media.MusicInfo, param2:SoundManager, param3:String = "OUT")
      {
         var _loc4_:Track = null;
         super();
         this._direction = param3;
         this._musicInfo = param1;
         this._sndManager = param2;
         this._controller = new Controller(this);
         if(!_fadeIn)
         {
            _fadeIn = new Animation();
            (_loc4_ = new Track("volume")).addKeyframe(new Keyframe(0,0));
            _loc4_.addKeyframe(new Keyframe(1,1));
            _fadeIn.addTrack(_loc4_);
            _fadeOut = new Animation();
            (_loc4_ = new Track("volume")).addKeyframe(new Keyframe(0,1));
            _loc4_.addKeyframe(new Keyframe(1,0));
            _fadeOut.addTrack(_loc4_);
         }
         switch(this._direction)
         {
            case IN:
               this._volume = 0;
               this._instance = this.controller.addAnimation(_fadeIn);
               break;
            case OUT:
               this._volume = 1;
               this._instance = this.controller.addAnimation(_fadeOut);
         }
         this._instance.addEventListener(AnimationEvent.STOP,this.onFadeStop);
         this._instance.play();
         param1.fader = this;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(param1:Number) : void
      {
         this._volume = param1;
         this.musicInfo.channel.soundTransform = new SoundTransform(this._sndManager.adjustedMusicVolume * this._volume);
      }
      
      public function get speed() : Number
      {
         return this._instance.speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this._instance.speed = param1;
      }
      
      public function get musicInfo() : com.edgebee.atlas.media.MusicInfo
      {
         return this._musicInfo;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function get controller() : Controller
      {
         return this._controller;
      }
      
      public function getProperty(param1:String) : *
      {
         return this[param1];
      }
      
      public function setProperty(param1:String, param2:*) : void
      {
         this[param1] = param2;
      }
      
      public function dispose() : void
      {
         if(!this._disposed)
         {
            this._disposed = true;
            this.musicInfo.fader = null;
            this._musicInfo = null;
            this._instance.removeEventListener(AnimationEvent.STOP,this.onFadeStop);
            this._instance.stop();
         }
      }
      
      private function onFadeStop(param1:AnimationEvent) : void
      {
         dispatchEvent(new ExtendedEvent(FADE_COMPLETE,this.musicInfo));
         this.dispose();
      }
   }
}
