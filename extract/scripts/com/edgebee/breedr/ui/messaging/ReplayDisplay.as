package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import com.edgebee.atlas.ui.gadgets.messaging.MessageDisplay;
   import flash.events.MouseEvent;
   
   public class ReplayDisplay extends BaseAttachmentDisplay
   {
       
      
      private var _button:Button;
      
      public function ReplayDisplay()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.reset();
      }
      
      override protected function reset() : void
      {
         var _loc1_:BitmapComponent = null;
         super.reset();
         if(childrenCreated || childrenCreating)
         {
            _loc1_ = new BitmapComponent();
            _loc1_.width = _loc1_.height = 16;
            _loc1_.source = MessageDisplay.ReplayPng;
            this._button = new Button();
            this._button.icon = _loc1_;
            this._button.label = Asset.getInstanceByName("PLAY");
            this._button.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            addChild(this._button);
            this.update();
         }
      }
      
      override protected function update() : void
      {
         enabled = attachment != null;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         executeAttachment(0);
      }
   }
}
