package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.Component;
   import flash.display.MovieClip;
   import flash.display.Scene;
   import flash.events.Event;
   
   public class MovieClipComponent extends Component
   {
       
      
      public var framerate:Number = 60;
      
      public var loop:Boolean = false;
      
      public var loopFrame = 0;
      
      private var _controlled:Boolean = true;
      
      private var _movieclip:MovieClip;
      
      private var _centered:Boolean = false;
      
      private var _startTime:Number = 0;
      
      private var _startFrame:int = 0;
      
      private var _scene:Scene;
      
      private var _highest:int = 0;
      
      public function MovieClipComponent()
      {
         super();
      }
      
      private static function advanceMovieClip(param1:MovieClip, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         param1.nextFrame();
         var _loc4_:uint = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            if(_loc3_ is MovieClip)
            {
               advanceMovieClip(_loc3_ as MovieClip);
            }
            _loc4_++;
         }
      }
      
      public function get movieclip() : MovieClip
      {
         return this._movieclip;
      }
      
      public function set movieclip(param1:MovieClip) : void
      {
         if(this.movieclip != param1)
         {
            if(this.movieclip)
            {
               removeChild(this.movieclip);
               removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            this._movieclip = param1;
            if(this.movieclip)
            {
               if(this.controlled)
               {
                  this.movieclip.gotoAndStop(0);
               }
               addChild(this.movieclip);
            }
            invalidateDisplayList();
         }
      }
      
      public function get centered() : Boolean
      {
         return this._centered;
      }
      
      public function set centered(param1:Boolean) : void
      {
         this._centered = param1;
         invalidateDisplayList();
      }
      
      public function get controlled() : Boolean
      {
         return this._controlled;
      }
      
      public function set controlled(param1:Boolean) : void
      {
         this._controlled = param1;
      }
      
      public function play() : void
      {
         if(this.movieclip)
         {
            if(this.controlled)
            {
               this._startTime = new Date().time;
               this.movieclip.gotoAndStop(0);
               this._startFrame = this.movieclip.currentFrame;
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            else
            {
               this.movieclip.gotoAndPlay(0);
            }
         }
      }
      
      public function stop() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this.movieclip)
         {
            this.movieclip.stop();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.positionMovieClip();
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
      }
      
      public function dispose() : void
      {
         this.stop();
         this.movieclip = null;
      }
      
      private function positionMovieClip() : void
      {
         if(this.movieclip)
         {
            if(this.centered)
            {
               this.movieclip.x = -this.movieclip.width / 2;
               this.movieclip.y = -this.movieclip.height / 2;
            }
            else
            {
               this.movieclip.x = 0;
               this.movieclip.y = 0;
            }
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = this.framerate;
         var _loc3_:Number = new Date().time - this._startTime;
         var _loc4_:int = int(_loc3_ / 1000 * _loc2_);
         while(_loc4_ > this.movieclip.currentFrame)
         {
            advanceMovieClip(this.movieclip,true);
            if(this.movieclip.currentFrame == this.movieclip.totalFrames)
            {
               if(!this.loop)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
                  this.stop();
                  return;
               }
               this.movieclip.gotoAndStop(this.loopFrame);
               _loc4_ = (_loc4_ %= this.movieclip.totalFrames) + this.loopFrame;
            }
         }
      }
   }
}
