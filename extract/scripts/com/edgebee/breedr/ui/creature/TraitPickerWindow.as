package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.skill.TraitInstance;
   import com.edgebee.breedr.events.combat.LevelUpEvent;
   import com.edgebee.breedr.ui.skill.TraitView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TraitPickerWindow extends Window
   {
      
      private static const views:Array = ["traitView01","traitView02","traitView03"];
       
      
      private var _levelUpEvent:LevelUpEvent;
      
      private var _selectedView:TraitView;
      
      public var okBtn:Button;
      
      public var refuseBtn:Button;
      
      public var traitView01:TraitView;
      
      public var traitView02:TraitView;
      
      public var traitView03:TraitView;
      
      private var _contentLayout:Array;
      
      private var _statusBarLayout:Array;
      
      public function TraitPickerWindow()
      {
         this._contentLayout = [{
            "CLASS":TraitView,
            "ID":"traitView01",
            "visible":false,
            "width":UIGlobals.relativize(128),
            "height":UIGlobals.relativize(128)
         },{
            "CLASS":TraitView,
            "ID":"traitView02",
            "visible":false,
            "width":UIGlobals.relativize(128),
            "height":UIGlobals.relativize(128)
         },{
            "CLASS":TraitView,
            "ID":"traitView03",
            "visible":false,
            "width":UIGlobals.relativize(128),
            "height":UIGlobals.relativize(128)
         }];
         this._statusBarLayout = [{
            "CLASS":Button,
            "ID":"okBtn",
            "label":Asset.getInstanceByName("ACCEPT"),
            "enabled":false,
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onOkClick
            }]
         },{
            "CLASS":Button,
            "ID":"refuseBtn",
            "label":Asset.getInstanceByName("REFUSE"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":this.onRefuseClick
            }]
         }];
         super();
         width = UIGlobals.relativize(450);
         height = UIGlobals.relativize(256);
         title = Asset.getInstanceByName("TRAIT_PICKER");
         rememberPositionId = "TraitPickerWindow";
         showCloseButton = false;
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      public function get levelUpEvent() : LevelUpEvent
      {
         return this._levelUpEvent;
      }
      
      public function set levelUpEvent(param1:LevelUpEvent) : void
      {
         if(this.levelUpEvent != param1)
         {
            this._levelUpEvent = param1;
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.direction = Box.HORIZONTAL;
         content.horizontalAlign = Box.ALIGN_CENTER;
         content.setStyle("Gap",UIGlobals.relativize(15));
         content.setStyle("Padding",UIGlobals.relativize(10));
         content.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,content,this._contentLayout);
         this.traitView01.addEventListener(MouseEvent.CLICK,this.onTraitViewClick);
         this.traitView02.addEventListener(MouseEvent.CLICK,this.onTraitViewClick);
         this.traitView03.addEventListener(MouseEvent.CLICK,this.onTraitViewClick);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.verticalAlign = Box.ALIGN_MIDDLE;
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.update();
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this._selectedView)
         {
            client.service.addEventListener("UnlockTrait",this.onUnlockTrait);
            client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
            _loc2_ = client.createInput();
            _loc2_.creature_instance_id = this.levelUpEvent.creature_instance_id;
            _loc2_.trait_id = this._selectedView.trait.id;
            client.service.UnlockTrait(_loc2_);
            ++client.criticalComms;
            this.okBtn.enabled = false;
         }
      }
      
      private function onRefuseConfirm(param1:Event) : void
      {
         client.service.addEventListener("UnlockTrait",this.onUnlockTrait);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         var _loc2_:Object = client.createInput();
         _loc2_.creature_instance_id = this.levelUpEvent.creature_instance_id;
         _loc2_.trait_id = 0;
         client.service.UnlockTrait(_loc2_);
      }
      
      private function onRefuseCancel(param1:Event) : void
      {
         this.refuseBtn.enabled = true;
      }
      
      private function onRefuseClick(param1:MouseEvent) : void
      {
         AlertWindow.show(Asset.getInstanceByName("BREEDR_REFUSE_TRAIT_CONFIRMATION"),Asset.getInstanceByName("CONFIRMATION"),UIGlobals.root,true,{
            "ALERT_WINDOW_YES":this.onRefuseConfirm,
            "ALERT_WINDOW_NO":this.onRefuseCancel
         },false,false,true,true,false,false,AlertWindow.WarningIconPng);
         this.refuseBtn.enabled = false;
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            statusBar.enabled = client.criticalComms == 0;
         }
      }
      
      private function onUnlockTrait(param1:ServiceEvent) : void
      {
         client.service.removeEventListener("UnlockTrait",this.onUnlockTrait);
         client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
         this.refuseBtn.enabled = true;
         doClose();
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "UnlockTrait")
         {
            client.service.removeEventListener("UnlockTrait",this.onUnlockTrait);
            client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
            this.okBtn.enabled = true;
            this.refuseBtn.enabled = true;
            --client.criticalComms;
         }
      }
      
      private function onTraitViewClick(param1:MouseEvent) : void
      {
         var _loc2_:TraitView = param1.target as TraitView;
         if(this._selectedView != _loc2_)
         {
            if(this._selectedView)
            {
               this._selectedView.colorMatrix.reset();
               this._selectedView.glowProxy.reset();
            }
            this._selectedView = _loc2_;
            this._selectedView.colorMatrix.brightness = 15;
            this._selectedView.glowProxy.alpha = 1;
            this._selectedView.glowProxy.color = 16777215;
            this.okBtn.enabled = true;
         }
      }
      
      private function update() : void
      {
         var _loc1_:TraitView = null;
         var _loc2_:TraitInstance = null;
         var _loc3_:int = 0;
         if(childrenCreated || childrenCreating)
         {
            if(this.levelUpEvent)
            {
               _loc3_ = 0;
               while(_loc3_ < LevelUpEvent.MAX_TRAIT_CHOICES)
               {
                  _loc1_ = this[views[_loc3_]];
                  if(_loc3_ < this.levelUpEvent.trait_choices.length)
                  {
                     _loc2_ = this.levelUpEvent.trait_choices[_loc3_];
                     _loc1_.trait = _loc2_;
                     _loc1_.visible = true;
                  }
                  else
                  {
                     _loc1_.trait = null;
                     _loc1_.visible = false;
                  }
                  _loc3_++;
               }
            }
         }
      }
   }
}
