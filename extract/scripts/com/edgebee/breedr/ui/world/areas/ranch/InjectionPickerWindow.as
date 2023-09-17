package com.edgebee.breedr.ui.world.areas.ranch
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Element;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Bid;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.skins.BreedrButtonSkin;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InjectionPickerWindow extends Window
   {
      
      private static const _accessories:Array = ["horns","mouth","wings","dorsal","tail","claws"];
      
      private static const _buttons:Array = ["hornsBtn","mouthBtn","wingsBtn","dorsalBtn","tailBtn","clawsBtn"];
      
      private static const HORNS:String = "HORNS";
      
      private static const MOUTH:String = "MOUTH";
      
      private static const WINGS:String = "WINGS";
      
      private static const DORSAL:String = "DORSAL";
      
      private static const TAIL:String = "TAIL";
      
      private static const CLAWS:String = "CLAWS";
       
      
      private var _creature:WeakReference;
      
      private var _item:WeakReference;
      
      public var creatureView:CreatureView;
      
      public var applyBtn:Button;
      
      private var accessoryGroup:RadioButtonGroup;
      
      public var hornsBtn:RadioButton;
      
      public var mouthBtn:RadioButton;
      
      public var wingsBtn:RadioButton;
      
      public var dorsalBtn:RadioButton;
      
      public var tailBtn:RadioButton;
      
      public var clawsBtn:RadioButton;
      
      public var cancelBtn:Button;
      
      private var _lastSet:String = null;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function InjectionPickerWindow()
      {
         this._creature = new WeakReference(null,CreatureInstance);
         this._item = new WeakReference(null,ItemInstance);
         this._contentLayout = [{
            "CLASS":Box,
            "direction":Box.HORIZONTAL,
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "Gap":0,
               "Padding":2
            },
            "CHILDREN":[{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "verticalAlign":Box.ALIGN_MIDDLE,
               "horizontalAlign":Box.ALIGN_CENTER,
               "layoutInvisibleChildren":false,
               "CHILDREN":[{
                  "CLASS":CreatureView,
                  "ID":"creatureView",
                  "width":UIGlobals.relativize(400),
                  "height":UIGlobals.relativize(400)
               }]
            },{
               "CLASS":Box,
               "direction":Box.VERTICAL,
               "percentWidth":1,
               "percentHeight":1,
               "layoutInvisibleChildren":false,
               "CHILDREN":[{
                  "CLASS":RadioButton,
                  "ID":"hornsBtn",
                  "label":Asset.getInstanceByName("HORNS"),
                  "userData":HORNS,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"mouthBtn",
                  "label":Asset.getInstanceByName("JAW"),
                  "userData":MOUTH,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"wingsBtn",
                  "label":Asset.getInstanceByName("WINGS"),
                  "userData":WINGS,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"dorsalBtn",
                  "label":Asset.getInstanceByName("DORSAL"),
                  "userData":DORSAL,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"tailBtn",
                  "label":Asset.getInstanceByName("TAIL"),
                  "userData":TAIL,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               },{
                  "CLASS":RadioButton,
                  "ID":"clawsBtn",
                  "label":Asset.getInstanceByName("CLAWS"),
                  "userData":CLAWS,
                  "percentWidth":1,
                  "STYLES":{
                     "FontColor":0,
                     "Skin":BreedrButtonSkin,
                     "Padding":UIGlobals.relativize(4)
                  }
               }]
            }]
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"applyBtn",
            "label":Asset.getInstanceByName("APPLY"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onApplyClick
            }]
         },{
            "CLASS":Button,
            "ID":"cancelBtn",
            "label":Asset.getInstanceByName("CANCEL"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onCancelClick
            }]
         }];
         super();
         width = UIGlobals.relativize(700);
         height = UIGlobals.relativize(500);
         rememberPositionId = "InjectionPickerWindow";
         showCloseButton = false;
         client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.addEventListener("InjectElement",this.onInjectElement);
      }
      
      private static function sortBidsDescending(param1:*, param2:*) : int
      {
         var _loc3_:Bid = param1 as Bid;
         var _loc4_:Bid = param2 as Bid;
         if(_loc3_.date.time < _loc4_.date.time)
         {
            return 1;
         }
         if(_loc3_.date.time > _loc4_.date.time)
         {
            return -1;
         }
         return 0;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(this.creature != param1)
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this.update();
         }
      }
      
      public function get item() : ItemInstance
      {
         return this._item.get() as ItemInstance;
      }
      
      public function set item(param1:ItemInstance) : void
      {
         if(this.item != param1)
         {
            this._item.reset(param1);
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.accessoryGroup = new RadioButtonGroup();
         for each(_loc1_ in _buttons)
         {
            this.accessoryGroup.addButton(this[_loc1_]);
         }
         this.accessoryGroup.addEventListener(Event.CHANGE,this.onGroupChange);
         this.update();
      }
      
      override public function doClose() : void
      {
         super.doClose();
         this.creature = null;
         this.accessoryGroup.reset();
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         this.update(param1.property);
      }
      
      public function onApplyClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_.creature_id = this.creature.id;
         _loc2_.item_id = this.item.id;
         _loc2_.accessory_name = this._lastSet.toLowerCase();
         client.service.InjectElement(_loc2_);
         ++client.criticalComms;
      }
      
      public function onCancelClick(param1:MouseEvent) : void
      {
         if(this._lastSet)
         {
            this.creature[this._lastSet.toLowerCase() + "_element_id"] = 0;
            this._lastSet = null;
         }
         this.doClose();
      }
      
      private function onInjectElement(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            this.applyBtn.enabled = client.criticalComms == 0;
            this.cancelBtn.enabled = client.criticalComms == 0;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "InjectElement")
         {
            --client.criticalComms;
         }
      }
      
      private function update(param1:String = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:Element = null;
         var _loc5_:RadioButton = null;
         var _loc6_:int = 0;
         if(childrenCreated || childrenCreating)
         {
            if(Boolean(this.creature) && Boolean(this.item))
            {
               visible = true;
               title = this.item.item.name;
               this.creatureView.creature = this.creature.creature.id > 0 ? this.creature : null;
               this.creatureView.visible = this.creatureView.creature != null;
               _loc6_ = 0;
               while(_loc6_ < _accessories.length)
               {
                  _loc2_ = String(_accessories[_loc6_]);
                  _loc3_ = uint(this.creature[_loc2_ + "_id"]);
                  _loc4_ = this.creature[_loc2_ + "_element"];
                  (_loc5_ = this[_buttons[_loc6_]]).visible = _loc3_ > 0;
                  _loc5_.enabled = _loc4_ == null;
                  _loc6_++;
               }
            }
            else
            {
               visible = false;
               title = "";
               this.creatureView.creature = null;
            }
         }
      }
      
      private function get itemElement() : Element
      {
         switch(this.item.item.subtype)
         {
            case Item.USE_INJECT_FIRE:
               return Element.getInstanceByType(Element.TYPE_FIRE);
            case Item.USE_INJECT_ICE:
               return Element.getInstanceByType(Element.TYPE_ICE);
            case Item.USE_INJECT_THUNDER:
               return Element.getInstanceByType(Element.TYPE_THUNDER);
            case Item.USE_INJECT_EARTH:
               return Element.getInstanceByType(Element.TYPE_EARTH);
            default:
               return null;
         }
      }
      
      private function onGroupChange(param1:ExtendedEvent) : void
      {
         if(this.creature)
         {
            if(this._lastSet)
            {
               this.creature[this._lastSet.toLowerCase() + "_element_id"] = 0;
            }
            this._lastSet = param1.data as String;
            this.creature[this._lastSet.toLowerCase() + "_element_id"] = this.itemElement.id;
            this.applyBtn.enabled = true;
         }
         else
         {
            this._lastSet = null;
            this.applyBtn.enabled = false;
         }
      }
   }
}
