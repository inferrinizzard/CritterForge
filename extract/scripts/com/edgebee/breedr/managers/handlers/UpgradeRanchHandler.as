package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.UpgradeRanchEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class UpgradeRanchHandler extends Handler
   {
      
      public static var RanchUpgradeWav:Class = UpgradeRanchHandler_RanchUpgradeWav;
       
      
      public var data:UpgradeRanchEvent;
      
      public var manager:EventProcessor;
      
      public function UpgradeRanchHandler(param1:UpgradeRanchEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoUpgradeRanch(this));
      }
   }
}

import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.UpgradeRanchEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.UpgradeRanchHandler;
import flash.events.Event;

class DoUpgradeRanch extends HandlerState
{
    
   
   public function DoUpgradeRanch(param1:UpgradeRanchHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Stall = null;
      var _loc5_:uint = 0;
      super.transitionInto(param1);
      var _loc2_:UpgradeRanchEvent = (machine as UpgradeRanchHandler).data;
      player.ranch_level_id = _loc2_.level_id;
      var _loc4_:int = 0;
      while(_loc4_ < player.ranch_level.capacity)
      {
         _loc3_ = player.stalls[_loc4_];
         _loc3_.locked = false;
         _loc4_++;
      }
      if(Boolean(_loc3_) && player.ranch_level.capacity < 24)
      {
         _loc5_ = player.stalls.getItemIndex(_loc3_) + 1;
         _loc3_ = player.stalls.getItemAt(_loc5_) as Stall;
         if(_loc3_)
         {
            _loc3_.dispatchEvent(PropertyChangeEvent.create(_loc3_,"id",null,null));
         }
      }
      UIGlobals.playSound(UpgradeRanchHandler.RanchUpgradeWav);
      gameView.dialogView.dialog = Dialog.getInstanceByName("upgrade_ranch");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
      gameView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
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
