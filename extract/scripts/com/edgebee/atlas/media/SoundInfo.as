package com.edgebee.atlas.media
{
   import com.edgebee.atlas.managers.SoundManager;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundInfo
   {
       
      
      public var source;
      
      public var channel:SoundChannel;
      
      public var loops:int = 0;
      
      public var position:Point;
      
      public function SoundInfo(param1:*, param2:SoundChannel, param3:Point = null)
      {
         super();
         this.source = param1;
         this.channel = param2;
      }
      
      public function adjust(param1:SoundManager) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:SoundTransform = null;
         if(Boolean(this.position) && Boolean(param1.position) && Boolean(param1.cutOffDistance))
         {
            _loc2_ = param1.adjustedSfxVolume;
            _loc3_ = param1.cutOffDistance;
            _loc4_ = param1.position;
            _loc5_ = Math.pow(_loc4_.x - this.position.x,2) + Math.pow(_loc4_.y - this.position.y,2);
            _loc7_ = (_loc6_ = Math.pow(_loc3_,2)) > 0 ? _loc5_ / _loc6_ : 0;
            (_loc8_ = new SoundTransform()).volume = (1 - Math.min(_loc7_,1)) * _loc2_;
            this.channel.soundTransform = _loc8_;
         }
      }
   }
}
