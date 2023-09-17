package com.edgebee.atlas.ui.gadgets.messaging
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.messaging.Attachment;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import flash.events.Event;
   
   public class BaseAttachmentDisplay extends Box
   {
       
      
      private var _attachment:Attachment;
      
      public function BaseAttachmentDisplay()
      {
         super();
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get attachment() : Attachment
      {
         return this._attachment;
      }
      
      public function set attachment(param1:Attachment) : void
      {
         this._attachment = param1;
         this.update();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      protected function reset() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this._attachment)
            {
               removeAllChildren();
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }
      
      protected function update() : void
      {
      }
      
      protected function executeAttachment(param1:int) : void
      {
         dispatchEvent(new Event(AttachmentDisplay.START_EXECUTE_ATTACHMENT));
         this.client.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("ExecuteAttachment",this.onExecuteAttachment);
         this._attachment.execute();
         this.update();
         var _loc2_:Object = this.client.createInput();
         _loc2_.attachment_id = this.attachment.id;
         _loc2_.data = param1;
         this.client.service.ExecuteAttachment(_loc2_);
      }
      
      protected function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "ExecuteAttachment")
         {
            this.client.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
            this.client.service.removeEventListener("ExecuteAttachment",this.onExecuteAttachment);
            this._attachment.unexecute();
            this.update();
            dispatchEvent(new Event(AttachmentDisplay.STOP_EXECUTE_ATTACHMENT));
         }
      }
      
      private function onExecuteAttachment(param1:ServiceEvent) : void
      {
         this.client.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.removeEventListener("ExecuteAttachment",this.onExecuteAttachment);
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.handleGameEvents(param1.data.events);
         }
         dispatchEvent(new Event(AttachmentDisplay.STOP_EXECUTE_ATTACHMENT));
      }
   }
}
