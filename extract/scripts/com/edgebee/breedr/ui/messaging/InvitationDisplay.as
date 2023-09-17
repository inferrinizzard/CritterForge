package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import flash.events.MouseEvent;
   
   public class InvitationDisplay extends BaseAttachmentDisplay
   {
       
      
      private var _acceptBtn:Button;
      
      private var _refuseBtn:Button;
      
      public function InvitationDisplay()
      {
         super();
         setStyle("Gap",5);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.reset();
      }
      
      override protected function reset() : void
      {
         super.reset();
         if(childrenCreated || childrenCreating)
         {
            this._acceptBtn = new Button();
            this._acceptBtn.label = Asset.getInstanceByName("ACCEPT");
            this._acceptBtn.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
            addChild(this._acceptBtn);
            this._refuseBtn = new Button();
            this._refuseBtn.label = Asset.getInstanceByName("REFUSE");
            this._refuseBtn.addEventListener(MouseEvent.CLICK,this.onRefuseClick);
            addChild(this._refuseBtn);
            this.update();
         }
      }
      
      override protected function update() : void
      {
         enabled = Boolean(attachment) && !attachment.isExecuted;
      }
      
      override protected function onException(param1:ExceptionEvent) : void
      {
         super.onException(param1);
         if(param1.method == "ExecuteAttachment")
         {
            if(param1.exception.cls == "SyndicateFull")
            {
               param1.handled = true;
               AlertWindow.show(Asset.getInstanceByName("SYNDICATE_FULL"),Asset.getInstanceByName("SYNDICATE_FULL_TITLE"),UIGlobals.root,true,null,true,true);
            }
         }
      }
      
      private function onAcceptClick(param1:MouseEvent) : void
      {
         executeAttachment(1);
      }
      
      private function onRefuseClick(param1:MouseEvent) : void
      {
         executeAttachment(0);
      }
   }
}
