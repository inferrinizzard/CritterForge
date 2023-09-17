package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.message.Attachment;
   import com.edgebee.breedr.ui.ControlBar;
   import flash.events.MouseEvent;
   
   public class CreditDisplay extends BaseAttachmentDisplay
   {
       
      
      private var _button:Button;
      
      public function CreditDisplay()
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
            _loc1_.source = ControlBar.CreditsIconPng;
            this._button = new Button();
            this._button.icon = _loc1_;
            this._button.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            addChild(this._button);
            this.update();
         }
      }
      
      override protected function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Attachment = null;
         enabled = Boolean(attachment) && !attachment.isExecuted;
         if(this._button)
         {
            _loc1_ = 0;
            _loc2_ = attachment as Attachment;
            if(_loc2_)
            {
               _loc1_ = int(_loc2_.credits);
            }
            this._button.label = Utils.abreviateNumber(_loc1_,0);
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         executeAttachment(0);
      }
   }
}
