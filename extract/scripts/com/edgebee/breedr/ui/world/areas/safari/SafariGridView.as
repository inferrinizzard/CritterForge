package com.edgebee.breedr.ui.world.areas.safari
{
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   
   public class SafariGridView extends Canvas
   {
      
      public static const cards:Array = ["card01","card02","card03","card04","card05","card06","card07","card08","card09","card10","card11","card12","card13","card14","card15","card16","card17","card18","card19","card20","card21","card22","card23","card24","card25"];
       
      
      public var card01:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card02:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card03:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card04:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card05:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card06:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card07:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card08:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card09:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card10:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card11:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card12:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card13:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card14:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card15:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card16:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card17:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card18:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card19:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card20:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card21:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card22:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card23:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card24:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      public var card25:com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
      
      private var _layout:Array;
      
      public function SafariGridView()
      {
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card01",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "index":0
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card02",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "index":1
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card03",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "index":2
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card04",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "index":3
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card05",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "index":4
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card06",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "index":5
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card07",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "index":6
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card08",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "index":7
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card09",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "index":8
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card10",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "index":9
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card11",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "index":10
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card12",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "index":11
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card13",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "index":12
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card14",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "index":13
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card15",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "index":14
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card16",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "index":15
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card17",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "index":16
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card18",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "index":17
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card19",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "index":18
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card20",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "index":19
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card21",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 0,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "index":20
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card22",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 1,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "index":21
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card23",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 2,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "index":22
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card24",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 3,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "index":23
         },{
            "CLASS":com.edgebee.breedr.ui.world.areas.safari.SafariCardView,
            "ID":"card25",
            "x":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "y":com.edgebee.breedr.ui.world.areas.safari.SafariCardView.SIZE * 4,
            "index":24
         }];
         super();
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         filters = UIGlobals.fontOutline;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
      }
   }
}
