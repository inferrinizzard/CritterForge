package com.edgebee.breedr.ui.world.areas.travel
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.skins.borders.GradientLineBorder;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Destination;
   import flash.events.MouseEvent;
   
   public class DestinationView extends Canvas
   {
       
      
      private var _destination:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _travelView:com.edgebee.breedr.ui.world.areas.travel.TravelView;
      
      public var image:SWFLoader;
      
      public var nameLbl:GradientLabel;
      
      private var _animatedBorder:GradientLineBorder;
      
      private var _layout:Array;
      
      public function DestinationView()
      {
         this._destination = new WeakReference(null,Destination);
         this._layout = [{
            "CLASS":SWFLoader,
            "ID":"image",
            "percentWidth":1,
            "percentHeight":1,
            "maintainAspectRatio":true
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "percentWidth":1,
            "percentHeight":1,
            "filters":UIGlobals.fontOutline,
            "STYLES":{"Gap":UIGlobals.relativize(-5)},
            "CHILDREN":[{
               "CLASS":GradientLabel,
               "ID":"nameLbl",
               "percentWidth":1,
               "colors":[10066329,16777215],
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(16),
                  "FontWeight":"bold"
               }
            }]
         }];
         super();
         setStyle("BackgroundAlpha",0.5);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get destination() : Destination
      {
         return this._destination.get() as Destination;
      }
      
      public function set destination(param1:Destination) : void
      {
         if(this.destination != param1)
         {
            if(this.destination)
            {
               removeEventListener(MouseEvent.CLICK,this.onMouseClick);
               removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
               removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            }
            this._destination.reset(param1);
            if(childrenCreated)
            {
               this.update();
            }
            if(this.destination)
            {
               addEventListener(MouseEvent.CLICK,this.onMouseClick);
               addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
               addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
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
         this.updateBorder();
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         this.updateBorder();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this._animatedBorder = new GradientLineBorder(this);
         this._animatedBorder.setStyle("BorderThickness",2);
         this._animatedBorder.setStyle("GradientLength",50);
         this._animatedBorder.setStyle("AnimationSpeed",0.5);
         addChild(this._animatedBorder);
         this._animatedBorder.visible = false;
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function updateBorder() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.selected)
            {
               this._animatedBorder.visible = true;
               this._animatedBorder.setStyle("BorderColor",getStyle("ThemeColor2"));
            }
            else if(this.highlighted)
            {
               this._animatedBorder.visible = true;
               this._animatedBorder.setStyle("BorderColor",UIUtils.adjustBrightness2(getStyle("ThemeColor2"),35));
            }
            else
            {
               this._animatedBorder.visible = false;
            }
         }
      }
      
      private function update() : void
      {
         var _loc1_:Boolean = false;
         if(this.destination)
         {
            _loc1_ = this.destination.accessibleForPlayer(this.player);
            this.image.visible = true;
            this.nameLbl.visible = true;
            this.image.source = _loc1_ ? UIGlobals.getAssetPath(this.destination.destination.image_url) : UIGlobals.getAssetPath("breedr/splash_mono.png");
            this.nameLbl.text = _loc1_ ? this.destination.destination.name : "???";
            toolTip = _loc1_ ? this.destination.destination.name.value + "<br>" + this.destination.destination.description.value : null;
         }
         else
         {
            this.image.visible = false;
            this.nameLbl.visible = false;
            toolTip = null;
         }
      }
      
      public function get travelView() : com.edgebee.breedr.ui.world.areas.travel.TravelView
      {
         return this._travelView;
      }
      
      public function set travelView(param1:com.edgebee.breedr.ui.world.areas.travel.TravelView) : void
      {
         this._travelView = param1;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.destination.accessibleForPlayer(this.player);
         if(_loc2_)
         {
            this.travelView.selectedView = this;
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.destination.accessibleForPlayer(this.player);
         if(_loc2_)
         {
            this.highlighted = true;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.destination.accessibleForPlayer(this.player);
         if(_loc2_)
         {
            this.highlighted = false;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "event_flags")
         {
            this.update();
         }
      }
   }
}
