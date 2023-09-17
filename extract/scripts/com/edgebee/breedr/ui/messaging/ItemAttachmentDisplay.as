package com.edgebee.breedr.ui.messaging
{
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.gadgets.messaging.BaseAttachmentDisplay;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.message.Attachment;
   import com.edgebee.breedr.ui.item.ItemView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ItemAttachmentDisplay extends BaseAttachmentDisplay
   {
      
      public static const SIZE:Number = UIGlobals.relativize(48);
       
      
      private var _mouseDown:Boolean = false;
      
      private var _itemView:ItemView;
      
      public function ItemAttachmentDisplay()
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
      
      public function get item() : Item
      {
         var _loc1_:Attachment = null;
         if(attachment)
         {
            _loc1_ = attachment as Attachment;
            return _loc1_.item;
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
            this._itemView = new ItemView();
            this._itemView.canModifyNote = false;
            this._itemView.height = this._itemView.width = SIZE;
            addChild(this._itemView);
            this.update();
         }
      }
      
      override protected function update() : void
      {
         enabled = Boolean(attachment) && !attachment.isExecuted;
         if(this._itemView)
         {
            this._itemView.static_item = this.item;
            if(!enabled)
            {
               this._itemView.colorMatrix.saturation = -100;
               this._itemView.colorMatrix.brightness = -5;
               this._itemView.colorMatrix.contrast = -50;
            }
            else
            {
               this._itemView.colorMatrix.reset();
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
         if(this._mouseDown && enabled && this.item && this._itemView.image.loaded && !client.criticalComms)
         {
            _loc2_ = new BitmapComponent();
            _loc2_.width = this._itemView.width;
            _loc2_.height = this._itemView.height;
            _loc2_.bitmap = new Bitmap((this._itemView.image.content as Bitmap).bitmapData);
            UIGlobals.dragManager.doDrag(this,{
               "attachment_item":this.item,
               "success":false
            },_loc2_,param1,this._itemView.width / 2 - mouseX);
         }
      }
      
      private function onDragComplete(param1:DragEvent) : void
      {
         if(param1.dragInfo.hasOwnProperty("success") && Boolean(param1.dragInfo.success))
         {
            executeAttachment(0);
         }
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         if(enabled && client.criticalComms == 0 && Boolean(this.item))
         {
            executeAttachment(0);
         }
      }
   }
}
