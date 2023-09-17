package com.edgebee.breedr.ui.world.areas.auction
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Bid;
   import com.edgebee.breedr.ui.ControlBar;
   import flash.text.TextFormatAlign;
   
   public class BidView extends Box implements Listable
   {
       
      
      private var _bid:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      public var timeLbl:Label;
      
      public var playerLbl:PlayerLabel;
      
      public var currentBidBox:Box;
      
      public var currentBidLbl:Label;
      
      private var _layout:Array;
      
      public function BidView()
      {
         this._bid = new WeakReference(null,Bid);
         this._layout = [{
            "CLASS":PlayerLabel,
            "ID":"playerLbl",
            "percentWidth":0.35,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Box,
            "ID":"currentBidBox",
            "verticalAlign":Box.ALIGN_MIDDLE,
            "horizontalAlign":Box.ALIGN_CENTER,
            "percentWidth":0.35,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"currentBidLbl",
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            },{
               "CLASS":Spacer,
               "width":3
            },{
               "CLASS":BitmapComponent,
               "width":UIGlobals.relativize(16),
               "height":UIGlobals.relativize(16),
               "source":ControlBar.CreditsIconPng
            }]
         },{
            "CLASS":Label,
            "ID":"timeLbl",
            "percentWidth":0.3,
            "alignment":TextFormatAlign.RIGHT,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         percentWidth = 1;
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
         return this.bid;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.bid = param1 as Bid;
      }
      
      public function get bid() : Bid
      {
         return this._bid.get() as Bid;
      }
      
      public function set bid(param1:Bid) : void
      {
         if(this.bid != param1)
         {
            if(this.bid)
            {
               this.bid.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBidChange);
            }
            this._bid.reset(param1);
            if(this.bid)
            {
               this.bid.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onBidChange);
            }
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
      
      private function onBidChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(this.bid)
         {
            visible = true;
            this.playerLbl.player = this.bid.player;
            this.currentBidLbl.text = this.bid.amount.toString();
            this.timeLbl.text = Utils.dateToElapsed(this.bid.date);
         }
         else
         {
            visible = false;
         }
      }
   }
}
