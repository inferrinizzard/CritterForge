package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.UpgradeSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class UpgradeSyndicateHandler extends Handler
   {
      
      public static var SyndicateUpgradeWav:Class = UpgradeSyndicateHandler_SyndicateUpgradeWav;
       
      
      public var data:UpgradeSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function UpgradeSyndicateHandler(param1:UpgradeSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoUpgradeSyndicate(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.UpgradeSyndicateEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.UpgradeSyndicateHandler;
import flash.events.Event;

class DoUpgradeSyndicate extends HandlerState
{
    
   
   public function DoUpgradeSyndicate(param1:UpgradeSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Player = null;
      super.transitionInto(param1);
      var _loc2_:UpgradeSyndicateEvent = (machine as UpgradeSyndicateHandler).data;
      player.syndicate_level_id = _loc2_.level_id;
      if(_loc2_.syndicate.id > 0)
      {
         _loc2_.syndicate.copyTo(player.syndicate);
      }
      else
      {
         for each(_loc3_ in player.syndicate.members)
         {
            if(_loc3_.id == player.id)
            {
               _loc3_.syndicate_level_id = _loc2_.level_id;
               break;
            }
         }
      }
      UIGlobals.playSound(UpgradeSyndicateHandler.SyndicateUpgradeWav);
      if(player.syndicate_level.level >= 8)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_friendly" + Utils.randomInt(1,3));
      }
      else
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_annoyed" + Utils.randomInt(1,5));
      }
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
      --client.criticalComms;
   }
}
