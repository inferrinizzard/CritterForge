package com.edgebee.atlas.media
{
   import flash.media.SoundChannel;
   
   public class MusicInfo
   {
       
      
      public var source:String;
      
      public var channel:SoundChannel;
      
      public var time:Number;
      
      public var fader:com.edgebee.atlas.media.MusicFader;
      
      public var loops:int = 0;
      
      public function MusicInfo(param1:String, param2:SoundChannel, param3:Number = 0)
      {
         super();
         this.source = param1;
         this.channel = param2;
         this.time = param3;
      }
   }
}
