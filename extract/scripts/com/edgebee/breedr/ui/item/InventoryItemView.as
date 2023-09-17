package com.edgebee.breedr.ui.item
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class InventoryItemView extends Canvas implements Listable
   {
      
      public static const START_BREED:String = "START_BREED";
      
      public static const ITEM_DOUBLE_CLICKED:String = "ITEM_DOUBLE_CLICKED";
      
      public static const SIZE:Number = UIGlobals.relativize(48);
       
      
      private var _item:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _mouseDown:Boolean = false;
      
      public var itemView:com.edgebee.breedr.ui.item.ItemView;
      
      public var infoLbl:Label;
      
      private var _layout:Array;
      
      public function InventoryItemView()
      {
         this._item = new WeakReference(null,ItemInstance);
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.item.ItemView,
            "ID":"itemView",
            "width":SIZE,
            "height":SIZE,
            "filters":UIGlobals.fontOutline
         },{
            "CLASS":Label,
            "ID":"infoLbl",
            "alpha":0.75,
            "visible":false,
            "mouseEnabled":false,
            "mouseChildren":false,
            "filters":UIGlobals.fontOutline,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         }];
         super();
         width = SIZE;
         height = SIZE;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClick);
         doubleClickEnabled = true;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get listElement() : Object
      {
         return this.item;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.item = param1 as ItemInstance;
      }
      
      public function get item() : ItemInstance
      {
         return this._item.get() as ItemInstance;
      }
      
      public function set item(param1:ItemInstance) : void
      {
         if(this.item != param1)
         {
            if(this.item)
            {
               this.item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemInstanceChange);
            }
            this._item.reset(param1);
            if(childrenCreated)
            {
               this.update();
            }
            if(this.item)
            {
               this.item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemInstanceChange);
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         visible = false;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function update() : void
      {
         if(this.item)
         {
            visible = true;
            this.itemView.item = this.item;
            if(this.item.auction_id > 0)
            {
               this.infoLbl.visible = true;
               this.infoLbl.text = Asset.getInstanceByName("AUCTION").value.toLocaleUpperCase();
            }
            else if(this.item.creature.is_quest)
            {
               this.infoLbl.visible = true;
               this.infoLbl.text = Asset.getInstanceByName("QUEST_ITEM_LABEL").value.toLocaleUpperCase();
            }
            else
            {
               this.infoLbl.visible = false;
            }
            validateNow(true);
            this.infoLbl.x = (width - this.infoLbl.width) / 2;
            this.infoLbl.y = (height - this.infoLbl.height) / 2;
         }
         else
         {
            visible = false;
            this.itemView.item = null;
         }
      }
      
      private function onItemInstanceChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         if(enabled && this.client.criticalComms == 0 && Boolean(this.item))
         {
            dispatchEvent(new ExtendedEvent(ITEM_DOUBLE_CLICKED,this.item,true));
         }
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
         if(this._mouseDown && this.item && this.itemView.image.loaded && enabled && this.client.criticalComms == 0)
         {
            _loc2_ = new BitmapComponent();
            _loc2_.width = this.itemView.width;
            _loc2_.height = this.itemView.height;
            _loc2_.colorMatrix.hue = this.itemView.image.colorMatrix.hue;
            _loc2_.bitmap = new Bitmap((this.itemView.image.content as Bitmap).bitmapData);
            _loc2_.colorMatrix.hue = this.item.item.hue;
            UIGlobals.dragManager.doDrag(this,{"item":this.item},_loc2_,param1,this.itemView.width / 2 - mouseX);
         }
      }
   }
}
