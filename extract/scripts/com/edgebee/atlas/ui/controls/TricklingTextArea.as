package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.text.TextLineMetrics;
   
   public class TricklingTextArea extends TextArea
   {
      
      public static const FINISHED:String = "FINISHED";
      
      public static const TRICKLED:String = "TRICKLED";
      
      public static const START_TRICKLING:String = "START_TRICKLING";
      
      private static var _sfx:SoundChannel;
       
      
      private var _sound;
      
      private var _textMask:Sprite;
      
      private var _maskAnim:AnimationInstance;
      
      private var _speed:uint;
      
      private var _progression:Number = 0;
      
      private var _autoStart:Boolean = true;
      
      private var _startAnimCharIndex:uint = 0;
      
      private var _endAnimCharIndex:uint = 0;
      
      public function TricklingTextArea()
      {
         super();
         cacheAsBitmap = true;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      public function get sound() : *
      {
         return this._sound;
      }
      
      public function set sound(param1:*) : void
      {
         this._sound = param1;
      }
      
      public function get progression() : Number
      {
         return this._progression;
      }
      
      public function set progression(param1:Number) : void
      {
         this._progression = param1;
         this.drawMask();
      }
      
      public function get autoStart() : Boolean
      {
         return this._autoStart;
      }
      
      public function set autoStart(param1:Boolean) : void
      {
         this._autoStart = param1;
         if(this.autoStart)
         {
            this.trickle();
         }
      }
      
      public function get lineCount() : uint
      {
         return _textField.getLineIndexOfChar(_textField.length - 1) + 1;
      }
      
      public function get trickling() : Boolean
      {
         return Boolean(this._maskAnim) && this._maskAnim.playing;
      }
      
      override public function set text(param1:*) : void
      {
         _text = null;
         super.text = param1;
      }
      
      public function trickle() : void
      {
         if(_textField.length > 0)
         {
            this.trickleUpToChar(_textField.length - 1);
         }
      }
      
      public function trickleUpToLine(param1:uint) : void
      {
         if(_textField.length > 0)
         {
            param1 = Math.min(this.lineCount - 1,param1);
            param1 = uint(_textField.getLineOffset(param1) + _textField.getLineLength(param1) - 1);
            this.trickleUpToChar(param1);
         }
      }
      
      public function trickleUpToChar(param1:uint) : void
      {
         if((childrenCreated || childrenCreating) && Boolean(actualText))
         {
            this.flush();
            this._endAnimCharIndex = param1;
            this._maskAnim = controller.animateTo({"progression":1},null,false);
            this._maskAnim.speed = 1 / this.animDuration;
            this._maskAnim.addEventListener(AnimationEvent.STOP,this.onMaskAnimStop);
            this._maskAnim.gotoStartAndPlay();
            dispatchEvent(new Event(START_TRICKLING));
            if(_sfx)
            {
               _sfx.stop();
               _sfx = null;
            }
            if(this.sound is String)
            {
               _sfx = UIGlobals.root.client.sndManager.play(UIGlobals.getAssetPath(this.sound),0,99999);
            }
            else if(this.sound is Class)
            {
               _sfx = UIGlobals.root.client.sndManager.play(this.sound,0,99999);
            }
            else
            {
               _sfx = null;
            }
         }
      }
      
      public function flush() : void
      {
         if(Boolean(this._maskAnim) && this._maskAnim.playing)
         {
            this._maskAnim.gotoEndAndStop();
         }
      }
      
      public function getLineHeight(param1:uint) : Number
      {
         return _textField.getLineMetrics(param1).height;
      }
      
      override public function get styleClassName() : String
      {
         return "TricklingTextArea";
      }
      
      override protected function createChildren() : void
      {
         _textField.cacheAsBitmap = true;
         this._textMask = new Sprite();
         this._textMask.cacheAsBitmap = true;
         addChild(this._textMask);
         _textField.mask = this._textMask;
         super.createChildren();
      }
      
      override public function resetTextField() : void
      {
         super.resetTextField();
         if(Boolean(this._maskAnim) && this._maskAnim.playing)
         {
            this._maskAnim.stop();
         }
         this._speed = getStyle("TricklingSpeed",40);
         if(childrenCreated || childrenCreating)
         {
            this.progression = 0;
         }
         if(this.autoStart)
         {
            this.trickle();
         }
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(!param1 && Boolean(_sfx))
         {
            _sfx.stop();
            _sfx = null;
         }
      }
      
      private function get animatedCharCount() : uint
      {
         return 1 + this._endAnimCharIndex - this._startAnimCharIndex;
      }
      
      private function get animDuration() : Number
      {
         return this.animatedCharCount / this._speed;
      }
      
      private function get visibleCharacterCount() : uint
      {
         return this._startAnimCharIndex + this.animatedCharCount * this.progression;
      }
      
      private function drawMask() : void
      {
         var _loc2_:TextLineMetrics = null;
         var _loc6_:uint = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         this._textMask.graphics.clear();
         var _loc1_:uint = Math.max(0,this.visibleCharacterCount - 1);
         var _loc3_:int = _textField.getLineIndexOfChar(_loc1_);
         var _loc4_:uint;
         var _loc5_:uint = _loc4_ = 2;
         if(_loc3_ >= 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               _loc2_ = _textField.getLineMetrics(_loc6_);
               _loc4_ += _loc2_.height;
               _loc6_++;
            }
            _loc2_ = _textField.getLineMetrics(_loc3_);
            _loc5_ += _loc4_ + _loc2_.height;
            this._textMask.graphics.beginFill(0,1);
            this._textMask.graphics.drawRect(0,0,_textField.width,_loc4_);
            this._textMask.graphics.endFill();
            if(this.visibleCharacterCount)
            {
               _loc7_ = _textField.getCharBoundaries(_loc1_);
               _loc8_ = 0;
               while(!_loc7_)
               {
                  _loc7_ = _textField.getCharBoundaries(_loc1_ - ++_loc8_);
               }
               _loc9_ = _loc7_.x + _loc7_.width;
               this._textMask.graphics.beginFill(0,1);
               this._textMask.graphics.drawRect(0,_loc4_,_loc9_,_loc2_.height + 2);
               this._textMask.graphics.endFill();
            }
         }
      }
      
      private function onMaskAnimStop(param1:AnimationEvent) : void
      {
         this._maskAnim.removeEventListener(AnimationEvent.STOP,this.onMaskAnimStop);
         this._maskAnim = null;
         if(_sfx)
         {
            _sfx.stop();
            _sfx = null;
         }
         if(this._endAnimCharIndex == _textField.length - 1)
         {
            this._startAnimCharIndex = 0;
         }
         else
         {
            this._startAnimCharIndex = this._endAnimCharIndex;
            this.progression = 0;
         }
         if(this._endAnimCharIndex == _textField.length - 1)
         {
            dispatchEvent(new Event(TRICKLED));
            dispatchEvent(new Event(FINISHED));
         }
         else
         {
            dispatchEvent(new Event(TRICKLED));
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         if(_sfx)
         {
            _sfx.stop();
            _sfx = null;
         }
      }
   }
}
