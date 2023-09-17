package com.edgebee.atlas.animation
{
   import flash.events.EventDispatcher;
   
   public class Animation extends EventDispatcher
   {
       
      
      public var duration:Number = 0;
      
      public var tracks:Object;
      
      public var numTracks:uint = 0;
      
      public var type:String;
      
      public var speed:Number = 1;
      
      public var loop:Boolean = false;
      
      public function Animation()
      {
         super();
      }
      
      public function addTrack(param1:Track) : void
      {
         if(!this.tracks)
         {
            this.tracks = {};
            this.type = param1.type;
         }
         this.tracks[param1.property] = param1;
         ++this.numTracks;
         this.calculateDuration();
      }
      
      private function calculateDuration() : void
      {
         var _loc2_:Track = null;
         var _loc1_:Number = 0;
         for each(_loc2_ in this.tracks)
         {
            if(_loc2_.endTime > _loc1_)
            {
               _loc1_ = _loc2_.endTime;
            }
         }
         this.duration = _loc1_;
      }
   }
}
