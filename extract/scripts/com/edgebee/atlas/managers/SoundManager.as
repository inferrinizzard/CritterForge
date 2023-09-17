package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.media.MusicFader;
   import com.edgebee.atlas.media.MusicInfo;
   import com.edgebee.atlas.media.SoundInfo;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   public class SoundManager extends EventDispatcher
   {
      
      public static const DEFAULT_VOLUME:Number = 1;
      
      public static const SFX:String = "SFX";
      
      public static const MUSIC:String = "MUSIC";
      
      public static const MUSIC_MODE_REPLACE:String = "MUSIC_MODE_REPLACE";
      
      public static const MUSIC_MODE_PUSH:String = "MUSIC_MODE_PUSH";
      
      public static const MUSIC_MODE_QUEUE:String = "MUSIC_MODE_QUEUE";
       
      
      private var _position:Point;
      
      private var _cutOffDistance:Number = 0;
      
      private var _volumes:Object;
      
      private var _loading:ArrayCollection;
      
      private var _sounds:Object;
      
      private var _sfxChannels:ArrayCollection;
      
      private var _musicChannels:ArrayCollection;
      
      private var _client:Client;
      
      public function SoundManager(param1:Client)
      {
         super();
         this._client = param1;
         this._sounds = {};
         this._volumes = {
            "MASTER":DEFAULT_VOLUME,
            "SFX":param1.userCookie._sfx_volume,
            "MUSIC":param1.userCookie._music_volume
         };
         this._sfxChannels = new ArrayCollection();
         this._musicChannels = new ArrayCollection();
         this.initializeVolumes();
         UIGlobals.fiftyMsTimer.addEventListener(TimerEvent.TIMER,this.updatePositionalSounds);
      }
      
      public function initializeVolumes() : void
      {
         this._volumes = {
            "MASTER":DEFAULT_VOLUME,
            "SFX":this._client.userCookie._sfx_volume,
            "SFX_MULTIPLIER":1,
            "MUSIC":this._client.userCookie._music_volume,
            "MUSIC_MULTIPLIER":1
         };
         this.updateVolume();
      }
      
      public function get volume() : Number
      {
         return this._volumes.MASTER;
      }
      
      public function set volume(param1:Number) : void
      {
         param1 = Utils.clamp(param1);
         if(param1 != this._volumes.MASTER)
         {
            this._volumes.MASTER = param1;
            this.updateVolume();
         }
      }
      
      public function get sfxVolume() : Number
      {
         return this._volumes.SFX;
      }
      
      public function set sfxVolume(param1:Number) : void
      {
         param1 = Utils.clamp(param1);
         if(this._volumes.SFX != param1)
         {
            this._volumes.SFX = param1;
            this._client.genericCookie._sfx_volume = param1;
            this._client.userCookie._sfx_volume = param1;
            this._client.saveCookie();
            this.updateSfxVolume();
         }
      }
      
      public function get sfxVolumeMultiplier() : Number
      {
         return this._volumes.SFX_MULTIPLIER;
      }
      
      public function set sfxVolumeMultiplier(param1:Number) : void
      {
         param1 = Utils.clamp(param1);
         if(param1 != this._volumes.SFX_MULTIPLIER)
         {
            this._volumes.SFX_MULTIPLIER = param1;
            this.updateVolume();
         }
      }
      
      public function get musicVolume() : Number
      {
         return this._volumes.MUSIC;
      }
      
      public function set musicVolume(param1:Number) : void
      {
         param1 = Utils.clamp(param1);
         if(this._volumes.MUSIC != param1)
         {
            this._volumes.MUSIC = param1;
            this._client.genericCookie._music_volume = param1;
            this._client.userCookie._music_volume = param1;
            this._client.saveCookie();
            this.updateMusicVolume();
         }
      }
      
      public function get musicVolumeMultiplier() : Number
      {
         return this._volumes.MUSIC_MULTIPLIER;
      }
      
      public function set musicVolumeMultiplier(param1:Number) : void
      {
         param1 = Utils.clamp(param1);
         if(param1 != this._volumes.MUSIC_MULTIPLIER)
         {
            this._volumes.MUSIC_MULTIPLIER = param1;
            this.updateVolume();
         }
      }
      
      public function get adjustedSfxVolume() : Number
      {
         return this.volume * this.sfxVolumeMultiplier * this.sfxVolume;
      }
      
      public function get adjustedMusicVolume() : Number
      {
         return this.volume * this.musicVolumeMultiplier * this.musicVolume;
      }
      
      public function get music() : MusicInfo
      {
         return this._musicChannels.last as MusicInfo;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function set position(param1:Point) : void
      {
         if(this.position != param1)
         {
            this._position = param1;
         }
      }
      
      public function get cutOffDistance() : Number
      {
         return this._cutOffDistance;
      }
      
      public function set cutOffDistance(param1:Number) : void
      {
         if(this.cutOffDistance != param1)
         {
            this._cutOffDistance = param1;
         }
      }
      
      public function play(param1:*, param2:Number = 0, param3:int = 0, param4:SoundTransform = null, param5:Point = null) : SoundChannel
      {
         var sound:Sound;
         var channel:SoundChannel = null;
         var soundInfo:SoundInfo = null;
         var source:* = param1;
         var startTime:Number = param2;
         var loops:int = param3;
         var sndTransform:SoundTransform = param4;
         var point:Point = param5;
         if(this.adjustedSfxVolume == 0)
         {
            return null;
         }
         sound = this.getSound(source);
         if(!sndTransform)
         {
            sndTransform = new SoundTransform();
         }
         sndTransform.volume = this.adjustedSfxVolume;
         try
         {
            channel = sound.play(startTime,loops,sndTransform);
            if(channel)
            {
               channel.addEventListener(Event.SOUND_COMPLETE,this.onSfxComplete,false,0,true);
               soundInfo = new SoundInfo(source,channel,point);
               soundInfo.adjust(this);
               this._sfxChannels.addItem(soundInfo);
               this.updatePositionalSounds();
            }
            return channel;
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public function isPlaying(param1:SoundChannel) : Boolean
      {
         return Boolean(this._sfxChannels.findItemByProperty("channel",param1)) || Boolean(this._musicChannels.findItemByProperty("channel",param1));
      }
      
      public function playMusic(param1:*, param2:Number = 0, param3:int = 0, param4:Number = 1, param5:Boolean = false) : SoundChannel
      {
         var _loc7_:SoundChannel = null;
         var _loc8_:MusicInfo = null;
         var _loc9_:MusicFader = null;
         if(this.adjustedMusicVolume == 0)
         {
            return null;
         }
         if(Boolean(this.music) && this.music.source == param1)
         {
            return null;
         }
         this.stopMusic(param4);
         if(!param1)
         {
            return null;
         }
         var _loc6_:Sound;
         if(_loc7_ = (_loc6_ = this.getSound(param1)).play(param2,param3,new SoundTransform(this.adjustedMusicVolume)))
         {
            _loc7_.addEventListener(Event.SOUND_COMPLETE,this.onMusicComplete,false,0,true);
            (_loc8_ = new MusicInfo(param1,_loc7_,param2)).loops = param3;
            (_loc9_ = new MusicFader(_loc8_,this,MusicFader.IN)).speed = param5 || this.music != null ? param4 : 99999;
            _loc9_.addEventListener(MusicFader.FADE_COMPLETE,this.onFadeComplete,false,0,true);
            this._musicChannels.addItem(_loc8_);
         }
         return _loc7_;
      }
      
      public function stopMusic(param1:Number = 1) : void
      {
         var _loc2_:MusicFader = null;
         if(this.music)
         {
            if(this.music.fader)
            {
               this.music.fader.dispose();
            }
            _loc2_ = new MusicFader(this.music,this,MusicFader.OUT);
            _loc2_.speed = param1;
            _loc2_.addEventListener(MusicFader.FADE_COMPLETE,this.onFadeComplete,false,0,true);
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function getSound(param1:*) : Sound
      {
         var _loc2_:Sound = null;
         var _loc3_:Class = null;
         var _loc4_:String = null;
         if(param1 is String)
         {
            if(this._sounds.hasOwnProperty(param1))
            {
               _loc2_ = this._sounds[param1];
            }
            else
            {
               _loc2_ = new Sound(new URLRequest(param1),new SoundLoaderContext(250));
               _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
               this._sounds[param1] = _loc2_;
            }
         }
         else if(param1 is Class)
         {
            _loc3_ = param1 as Class;
            _loc4_ = String(_loc3_.toString());
            if(this._sounds.hasOwnProperty(_loc4_))
            {
               _loc2_ = this._sounds[_loc4_];
            }
            else
            {
               _loc2_ = new param1() as Sound;
               this._sounds[_loc4_] = _loc2_;
            }
         }
         return _loc2_;
      }
      
      private function updateVolume() : void
      {
         this.updateSfxVolume();
         this.updateMusicVolume();
      }
      
      private function updateSfxVolume() : void
      {
         var _loc1_:SoundInfo = null;
         for each(_loc1_ in this._sfxChannels)
         {
            if(_loc1_.position == null)
            {
               _loc1_.channel.soundTransform = new SoundTransform(this.adjustedSfxVolume);
            }
         }
      }
      
      private function updateMusicVolume() : void
      {
         var _loc1_:MusicInfo = null;
         for each(_loc1_ in this._musicChannels)
         {
            if(!_loc1_.fader)
            {
               _loc1_.channel.soundTransform = new SoundTransform(this.adjustedMusicVolume);
            }
         }
      }
      
      private function findMusicInfoByChannel(param1:SoundChannel) : MusicInfo
      {
         var _loc2_:MusicInfo = null;
         for each(_loc2_ in this._musicChannels)
         {
            if(_loc2_.channel == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function onSfxComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         _loc2_.stop();
         if(this._sfxChannels.contains(_loc2_))
         {
            this._sfxChannels.removeItem(_loc2_);
         }
      }
      
      private function disposeMusic(param1:MusicInfo, param2:Boolean = false) : void
      {
         if(param2 || param1.fader && param1.fader.direction == MusicFader.OUT)
         {
            if(param1.fader)
            {
               param1.fader.dispose();
            }
            param1.channel.stop();
            this._musicChannels.removeItem(param1);
         }
      }
      
      private function onMusicComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         var _loc3_:MusicInfo = this.findMusicInfoByChannel(_loc2_);
         this.disposeMusic(_loc3_,true);
      }
      
      private function onFadeComplete(param1:ExtendedEvent) : void
      {
         var _loc2_:MusicInfo = param1.data as MusicInfo;
         this.disposeMusic(_loc2_);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
      }
      
      private function updatePositionalSounds(param1:TimerEvent = null) : void
      {
         var _loc2_:SoundInfo = null;
         for each(_loc2_ in this._sfxChannels)
         {
            _loc2_.adjust(this);
         }
      }
   }
}
