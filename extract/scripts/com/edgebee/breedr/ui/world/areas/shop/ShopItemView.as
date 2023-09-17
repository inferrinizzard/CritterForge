package com.edgebee.breedr.ui.world.areas.shop
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.item.ItemView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class ShopItemView extends Box implements Listable
   {
      
      public static const ITEM_DOUBLE_CLICKED:String = "ITEM_DOUBLE_CLICKED";
       
      
      private var _item:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _mouseDown:Boolean = false;
      
      public var creditsBox:Box;
      
      public var nameLbl:Label;
      
      public var creditsLbl:Label;
      
      public var tokensBox:Box;
      
      public var tokensLbl:Label;
      
      public var itemView:ItemView;
      
      private var _layout:Array;
      
      public function ShopItemView()
      {
         this._item = new WeakReference(null,Item);
         this._layout = [{
            "CLASS":Box,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "percentWidth":1,
            "percentHeight":1,
            "layoutInvisibleChildren":false,
            "STYLES":{
               "BackgroundAlpha":0.15,
               "BorderThickness":1,
               "BorderAlpha":0.05,
               "CornerRadius":5
            },
            "CHILDREN":[{
               "CLASS":ItemView,
               "ID":"itemView",
               "width":UIGlobals.relativize(58),
               "height":UIGlobals.relativize(58),
               "canModifyNote":false
            },{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "CHILDREN":[{
                  "CLASS":Label,
                  "useHtml":true,
                  "percentHeight":1,
                  "ID":"nameLbl",
                  "filters":UIGlobals.fontOutline,
                  "STYLES":{"FontSize":UIGlobals.relativize(12)}
               },{
                  "CLASS":Box,
                  "percentWidth":1,
                  "layoutInvisibleChildren":false,
                  "horizontalAlign":Box.ALIGN_RIGHT,
                  "CHILDREN":[{
                     "CLASS":Box,
                     "ID":"creditsBox",
                     "horizontalAlign":Box.ALIGN_RIGHT,
                     "verticalAlign":Box.ALIGN_MIDDLE,
                     "percentWidth":0.5,
                     "filters":UIGlobals.fontOutline,
                     "CHILDREN":[{
                        "CLASS":Label,
                        "ID":"creditsLbl",
                        "STYLES":{
                           "FontSize":UIGlobals.relativizeFont(24),
                           "FontColor":16777215
                        }
                     },{
                        "CLASS":Spacer,
                        "width":UIGlobals.relativize(4)
                     },{
                        "CLASS":BitmapComponent,
                        "width":UIGlobals.relativize(22),
                        "height":UIGlobals.relativize(22),
                        "source":ControlBar.CreditsIconPng
                     }]
                  },{
                     "CLASS":Box,
                     "ID":"tokensBox",
                     "horizontalAlign":Box.ALIGN_RIGHT,
                     "verticalAlign":Box.ALIGN_MIDDLE,
                     "percentWidth":0.5,
                     "filters":UIGlobals.fontOutline,
                     "CHILDREN":[{
                        "CLASS":Label,
                        "ID":"tokensLbl",
                        "STYLES":{
                           "FontSize":UIGlobals.relativizeFont(24),
                           "FontColor":16777215
                        }
                     },{
                        "CLASS":Spacer,
                        "width":UIGlobals.relativize(4)
                     },{
                        "CLASS":BitmapComponent,
                        "width":UIGlobals.relativize(22),
                        "height":UIGlobals.relativize(22),
                        "source":ControlBar.TokenIcon32Png
                     }]
                  }]
               }]
            }]
         }];
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClick);
         doubleClickEnabled = true;
         setStyle("Padding",3);
         width = UIGlobals.relativize(240);
         height = UIGlobals.relativize(58) + 2 * getStyle("Padding");
         filters = [new DropShadowFilter(3,45,0,0.75,3,3)];
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
         this.item = param1 as Item;
      }
      
      public function get item() : Item
      {
         return this._item.get() as Item;
      }
      
      public function set item(param1:Item) : void
      {
         if(this.item != param1)
         {
            this._item.reset(param1);
            if(childrenCreated)
            {
               this.update();
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
            this.itemView.static_item = this.item;
            this.itemView.tooltipEnabled = false;
            if(this.item.uid == MD5.hash("Item:feed_1"))
            {
               name = "FirstFeedItemView";
            }
            else
            {
               name = "shop_item_instance";
            }
            if(this.item.tokens == 0)
            {
               this.creditsLbl.text = this.item.credits.toString();
               this.creditsBox.visible = true;
               this.tokensBox.visible = false;
            }
            else
            {
               this.tokensLbl.text = this.item.tokens.toString();
               this.tokensBox.visible = true;
               this.creditsBox.visible = false;
            }
            this.nameLbl.text = Utils.htmlWrap(Utils.capitalizeFirst(this.item.name.value),null,16777215);
            toolTip = this.item.description;
         }
         else
         {
            visible = false;
            this.itemView.static_item = null;
            this.tokensBox.visible = false;
            this.creditsBox.visible = false;
            this.nameLbl.text = "";
            toolTip = "";
         }
      }
      
      private function onItemInstanceChange(param1:PropertyChangeEvent) : void
      {
         this.update();
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
         if(this._mouseDown && enabled && this.item && this.itemView.image.loaded && !this.client.criticalComms)
         {
            _loc2_ = new BitmapComponent();
            _loc2_.width = this.itemView.width;
            _loc2_.height = this.itemView.height;
            _loc2_.bitmap = new Bitmap((this.itemView.image.content as Bitmap).bitmapData);
            _loc2_.colorMatrix.hue = this.item.hue;
            UIGlobals.dragManager.doDrag(this,{"shop_item":this.item},_loc2_,param1,this.itemView.width / 2 - mouseX);
         }
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         if(enabled && this.client.criticalComms == 0 && Boolean(this.item))
         {
            dispatchEvent(new ExtendedEvent(ITEM_DOUBLE_CLICKED,this.item,true));
         }
      }
   }
}
