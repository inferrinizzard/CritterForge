package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.CreateSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class CreateSyndicateHandler extends Handler
   {
       
      
      public var data:CreateSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function CreateSyndicateHandler(param1:CreateSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoCreateSyndicate(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.CreateSyndicateEvent;
import com.edgebee.breedr.managers.handlers.CreateSyndicateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import flash.events.Event;

class DoCreateSyndicate extends HandlerState
{
    
   
   public function DoCreateSyndicate(param1:CreateSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CreateSyndicateEvent = (machine as CreateSyndicateHandler).data;
      _loc2_.syndicate.copyTo(player.syndicate);
      if(!(player.event_flags & Player.EV_SYNDICATE_VISIT2))
      {
         ++client.criticalComms;
         player.event_flags |= Player.EV_SYNDICATE_VISIT2;
         gameView.dialogView.dialog = Dialog.getInstanceByName("tut_syndicate2_dialog");
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onTutorialDialogComplete,false,0,false);
      }
      else if(player.syndicate_level.level >= 8)
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_friendly" + Utils.randomInt(1,3));
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
      }
      else
      {
         gameView.dialogView.dialog = Dialog.getInstanceByName("syndicate_annoyed" + Utils.randomInt(1,5));
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete,false,0,false);
      }
      gameView.dialogView.step();
   }
   
   private function onTutorialDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onTutorialDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_SYNDICATE_VISIT2;
      client.service.SetPlayerEventFlag(_loc2_);
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
