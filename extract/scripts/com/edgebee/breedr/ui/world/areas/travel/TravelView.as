package com.edgebee.breedr.ui.world.areas.travel
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Destination;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.ui.ControlBar;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.skins.TransparentWindow;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TravelView extends Box
   {
      
      private static const views:Array = ["destinationView01","destinationView02","destinationView03","destinationView04","destinationView05","destinationView06","destinationView07","destinationView08"];
       
      
      private var _selectedView:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var optionsBox:Box;
      
      public var travelButton:Button;
      
      public var bg:TransparentWindow;
      
      private var creaturePicker:com.edgebee.breedr.ui.world.areas.travel.CreaturePickerWindow;
      
      private var _noExtractorWarning:Boolean;
      
      public var destinationsBox:Box;
      
      public var destinationView01:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView02:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView03:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView04:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView05:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView06:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView07:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      public var destinationView08:com.edgebee.breedr.ui.world.areas.travel.DestinationView;
      
      private var _layout:Array;
      
      public function TravelView()
      {
         this._layout = [{
            "CLASS":Box,
            "ID":"destinationsBox",
            "name":"TravelDestinationsBox",
            "direction":Box.VERTICAL,
            "width":UIGlobals.relativize(600),
            "height":UIGlobals.relativize(450),
            "spreadProportionality":false,
            "STYLES":{
               "Padding":UIGlobals.relativize(12),
               "Gap":UIGlobals.relativize(12)
            },
            "CHILDREN":[{
               "CLASS":TransparentWindow,
               "ID":"bg",
               "width":UIGlobals.relativize(600),
               "height":UIGlobals.relativize(450),
               "includeInLayout":false
            },{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_CENTER,
               "STYLES":{"Gap":UIGlobals.relativize(6)},
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView01",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView02",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView03",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView04",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               }]
            },{
               "CLASS":Box,
               "horizontalAlign":Box.ALIGN_CENTER,
               "STYLES":{"Gap":UIGlobals.relativize(6)},
               "CHILDREN":[{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView05",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView06",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView07",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               },{
                  "CLASS":com.edgebee.breedr.ui.world.areas.travel.DestinationView,
                  "ID":"destinationView08",
                  "width":UIGlobals.relativize(140),
                  "height":UIGlobals.relativize(140),
                  "travelView":this
               }]
            },{
               "CLASS":Spacer,
               "percentHeight":1
            },{
               "CLASS":Box,
               "ID":"optionsBox",
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_CENTER,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "STYLES":{
                  "BackgroundAlpha":0.5,
                  "CornerRadius":15,
                  "Padding":UIGlobals.relativize(12)
               },
               "CHILDREN":[{
                  "CLASS":Button,
                  "ID":"travelButton",
                  "name":"TravelStartButton",
                  "label":Asset.getInstanceByName("START_SAFARI"),
                  "EVENTS":[{
                     "TYPE":MouseEvent.CLICK,
                     "LISTENER":"onTravelClick"
                  }]
               }]
            }]
         }];
         super(Box.VERTICAL);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("SafariStart",this.onSafariStart);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get selectedView() : com.edgebee.breedr.ui.world.areas.travel.DestinationView
      {
         return this._selectedView;
      }
      
      public function set selectedView(param1:com.edgebee.breedr.ui.world.areas.travel.DestinationView) : void
      {
         if(this.selectedView != param1)
         {
            if(this.selectedView)
            {
               this.selectedView.selected = false;
            }
            this._selectedView = param1;
            if(this.selectedView)
            {
               this.selectedView.selected = true;
            }
            this.updateButton();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.travelButton.enabled = false;
         this.update();
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         this._noExtractorWarning = false;
         if(param1)
         {
            this.bg.startAnimation();
         }
         else
         {
            this.bg.stopAnimation();
         }
      }
      
      public function onTravelClick(param1:MouseEvent) : void
      {
         if(!this._noExtractorWarning && !this.player.hasExtractor)
         {
            this._noExtractorWarning = true;
            this.gameView.dialogView.dialog = Dialog.getInstanceByName("travel_no_extract");
            this.gameView.dialogView.addEventListener(Event.COMPLETE,this.onWarnDialogComplete);
            ++this.client.criticalComms;
            this.gameView.dialogView.step();
            return;
         }
         if(!this.creaturePicker)
         {
            this.creaturePicker = new com.edgebee.breedr.ui.world.areas.travel.CreaturePickerWindow();
            this.creaturePicker.addEventListener(com.edgebee.breedr.ui.world.areas.travel.CreaturePickerWindow.CREATURE_SELECTED,this.onCreatureSelected);
         }
         else
         {
            this.creaturePicker.creatureList.selectedItem = null;
         }
         UIGlobals.popUpManager.addPopUp(this.creaturePicker,this,true);
         UIGlobals.popUpManager.centerPopUp(this.creaturePicker);
      }
      
      private function onWarnDialogComplete(param1:Event) : void
      {
         this.gameView.dialogView.removeEventListener(Event.COMPLETE,this.onWarnDialogComplete);
         --this.client.criticalComms;
      }
      
      private function onConfirmSafariStart(param1:Event) : void
      {
         var _loc2_:AlertWindow = param1.target as AlertWindow;
         this.client.service.SafariStart(_loc2_.extraData);
         ++this.client.criticalComms;
      }
      
      private function onCreatureSelected(param1:ExtendedEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:AlertWindow = null;
         var _loc2_:Object = this.client.createInput();
         var _loc3_:CreatureInstance = param1.data as CreatureInstance;
         UIGlobals.popUpManager.removePopUp(this.creaturePicker);
         _loc2_.creature_id = _loc3_.id;
         _loc2_.destination_id = this.selectedView.destination.id;
         var _loc4_:int;
         if(((_loc4_ = this.selectedView.destination.creditsCostForCreature(_loc3_)) <= 0 || _loc4_ > this.player.credits) && this.selectedView.destination.tokens > 0 && this.client.user.tokens >= this.selectedView.destination.tokens)
         {
            _loc5_ = Asset.getInstanceByName("CONFIRM_TOKEN_PURCHASE").value;
            _loc5_ = Utils.formatString(_loc5_,{"tokens":this.selectedView.destination.tokens.toString()});
            (_loc6_ = AlertWindow.show(_loc5_,Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{"ALERT_WINDOW_OK":this.onConfirmSafariStart},true,true,false,false,true,true,ControlBar.TokenIcon32Png)).extraData = _loc2_;
         }
         else
         {
            this.client.service.SafariStart(_loc2_);
            ++this.client.criticalComms;
         }
      }
      
      private function onSafariStart(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function update() : void
      {
         var _loc1_:Destination = null;
         var _loc2_:int = 0;
         if(childrenCreated || childrenCreating)
         {
            if(!this.destinationsBox)
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < views.length)
            {
               if(_loc2_ < this.player.area.destinations.length)
               {
                  _loc1_ = this.player.area.destinations.getItemAt(_loc2_) as Destination;
                  (this[views[_loc2_]] as com.edgebee.breedr.ui.world.areas.travel.DestinationView).destination = _loc1_;
               }
               else
               {
                  (this[views[_loc2_]] as com.edgebee.breedr.ui.world.areas.travel.DestinationView).destination = null;
               }
               _loc2_++;
            }
         }
      }
      
      private function updateButton() : void
      {
         if(this.selectedView)
         {
            this.travelButton.enabled = this.selectedView.destination.accessibleForPlayer(this.player);
         }
         else
         {
            this.travelButton.enabled = false;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "area")
         {
            if(this.player.area.type == Area.TYPE_TRAVEL)
            {
               this.update();
            }
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms" && Boolean(this.optionsBox))
         {
            this.optionsBox.enabled = this.client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SafariStart")
         {
            --this.client.criticalComms;
         }
      }
   }
}
