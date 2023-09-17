package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.Component;
   import flash.events.MouseEvent;
   
   public class PersistentTooltipSkin extends DefaultTooltipSkin
   {
       
      
      private var _mouseHovering:Boolean = false;
      
      public function PersistentTooltipSkin(param1:Component)
      {
         super(param1);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      override protected function onFadeComplete(param1:AnimationEvent) : void
      {
         if(!this._mouseHovering)
         {
            super.onFadeComplete(param1);
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(_fadeOutAnimInstance.playing)
         {
            this._mouseHovering = true;
            _fadeOutAnimInstance.pause();
            _fadeOutAnimInstance.speed = -2;
            _fadeOutAnimInstance.play();
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this._mouseHovering = false;
         if(_fadeOutAnimInstance.playing)
         {
            _fadeOutAnimInstance.pause();
            _fadeOutAnimInstance.speed = 2;
            _fadeOutAnimInstance.play();
         }
         else
         {
            hide();
         }
      }
   }
}
