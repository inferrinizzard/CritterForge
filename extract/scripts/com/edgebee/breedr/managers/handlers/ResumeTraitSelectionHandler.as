package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ResumeTraitSelectionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ResumeTraitSelectionHandler extends Handler
   {
       
      
      public var data:ResumeTraitSelectionEvent;
      
      public var manager:EventProcessor;
      
      public function ResumeTraitSelectionHandler(param1:ResumeTraitSelectionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Resume(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.ResumeTraitSelectionEvent;
import com.edgebee.breedr.events.combat.LevelUpEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.ResumeTraitSelectionHandler;
import com.edgebee.breedr.ui.creature.TraitPickerWindow;
import flash.events.Event;

class Resume extends HandlerState
{
    
   
   private var _pickerDone:Boolean = false;
   
   private var _pickerWindow:TraitPickerWindow;
   
   public function Resume(param1:ResumeTraitSelectionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:LevelUpEvent = null;
      super.transitionInto(param1);
      var _loc2_:ResumeTraitSelectionEvent = (machine as ResumeTraitSelectionHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_instance_id) as CreatureInstance;
      (_loc4_ = new LevelUpEvent()).creature_instance_id = _loc2_.creature_instance_id;
      _loc4_.trait_choices.source = _loc2_.trait_choices.source;
      this._pickerWindow = new TraitPickerWindow();
      this._pickerWindow.title = Utils.formatString(Asset.getInstanceByName("MISSING_TRAIT_MESSAGE").value,{"name":_loc3_.name});
      this._pickerWindow.levelUpEvent = _loc4_;
      this._pickerWindow.addEventListener(Event.CLOSE,this.onPickerClosed);
      UIGlobals.popUpManager.addPopUp(this._pickerWindow,gameView,true);
      UIGlobals.popUpManager.centerPopUp(this._pickerWindow);
   }
   
   private function onPickerClosed(param1:Event) : void
   {
      this._pickerWindow.removeEventListener(Event.CLOSE,this.onPickerClosed);
      this._pickerWindow = null;
      this._pickerDone = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}
