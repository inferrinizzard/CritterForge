package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.message.Attachment;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class CreatureAttachmentDisplay extends BaseAttachmentDisplay
   {
      
      public static const SIZE:Number = UIGlobals.relativize(64);
       
      
      private var _mouseDown:Boolean = false;
      
      private var _creatureView:CreatureView;
      
      public function CreatureAttachmentDisplay()
      {
         super();
         height = width = SIZE;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(DragEvent.DRAG_COMPLETE,this.onDragComplete);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClick);
         doubleClickEnabled = true;
      }
      
      public function get creature() : CreatureInstance
      {
         var _loc1_:Attachment = null;
         if(attachment)
         {
            _loc1_ = attachment as Attachment;
            return _loc1_.creature;
         }
         return null;
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
            this._creatureView = new CreatureView();
            this._creatureView.height = this._creatureView.width = SIZE;
            addChild(this._creatureView);
            this.update();
         }
      }
      
      override protected function update() : void
      {
         enabled = Boolean(attachment) && !attachment.isExecuted;
         if(this._creatureView)
         {
            this._creatureView.creature = this.creature;
            if(!enabled)
            {
               this._creatureView.colorMatrix.saturation = -100;
               this._creatureView.colorMatrix.brightness = -5;
               this._creatureView.colorMatrix.contrast = -50;
            }
            else
            {
               this._creatureView.colorMatrix.reset();
            }
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         executeAttachment(0);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:BitmapComponent = null;
         if(this._mouseDown && enabled && this.creature && this._creatureView.asBitmap && !client.criticalComms)
         {
            _loc2_ = new BitmapComponent();
            _loc2_.width = width;
            _loc2_.height = height;
            _loc2_.bitmap = new Bitmap(this._creatureView.asBitmap.bitmapData);
            UIGlobals.dragManager.doDrag(this,{
               "attachment_creature":this.creature,
               "success":false
            },_loc2_,param1,this._creatureView.width / 2 - mouseX);
         }
      }
      
      private function onDragComplete(param1:DragEvent) : void
      {
         if(param1.dragInfo.hasOwnProperty("success") && Boolean(param1.dragInfo.success))
         {
            executeAttachment(param1.dragInfo.stall_id);
         }
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         if(enabled && client.criticalComms == 0 && Boolean(this.creature))
         {
            executeAttachment(0);
         }
      }
   }
}
