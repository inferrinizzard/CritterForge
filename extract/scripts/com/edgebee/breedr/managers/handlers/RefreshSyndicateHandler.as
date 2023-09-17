package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.RefreshSyndicateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class RefreshSyndicateHandler extends Handler
   {
       
      
      public var data:RefreshSyndicateEvent;
      
      public var manager:EventProcessor;
      
      public function RefreshSyndicateHandler(param1:RefreshSyndicateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRefreshSyndicate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.RefreshSyndicateEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.RefreshSyndicateHandler;
import flash.events.Event;

class DoRefreshSyndicate extends HandlerState
{
    
   
   public function DoRefreshSyndicate(param1:RefreshSyndicateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:RefreshSyndicateEvent = (machine as RefreshSyndicateHandler).data;
      if(!_loc2_.stealth && !(player.event_flags & Player.EV_SYNDICATE_VISIT2))
      {
         ++client.criticalComms;
         player.event_flags |= Player.EV_SYNDICATE_VISIT2;
         gameView.dialogView.dialog = Dialog.getInstanceByName("tut_syndicate2_dialog");
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onTutorialDialogComplete,false,0,false);
      }
      _loc2_.syndicate.copyTo(player.syndicate);
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
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:RefreshSyndicateEvent = (machine as RefreshSyndicateHandler).data;
      if(!_loc2_.stealth)
      {
         --client.criticalComms;
      }
   }
}
