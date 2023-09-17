package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.SafariPreyEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class SafariPreyHandler extends Handler
   {
       
      
      public var data:SafariPreyEvent;
      
      public var manager:EventProcessor;
      
      public function SafariPreyHandler(param1:SafariPreyEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoSafaryPreyUpdate(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.SafariPreyEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.SafariPreyHandler;
import flash.events.Event;

class DoSafaryPreyUpdate extends HandlerState
{
    
   
   public function DoSafaryPreyUpdate(param1:SafariPreyHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:SafariPreyEvent = (machine as SafariPreyHandler).data;
      player.last_safari_prey.ref = _loc2_.last_safari_prey.ref;
      if(player.last_safari_prey.ref != null && player.area.type == Area.TYPE_SAFARI && !(player.event_flags & Player.EV_SAFARI_WIN))
      {
         ++client.criticalComms;
         player.event_flags |= Player.EV_SAFARI_WIN;
         gameView.dialogView.dialog = Dialog.getInstanceByName("tut_safari_dialog");
         gameView.dialogView.addEventListener(Event.COMPLETE,this.onSafariTutComplete,false,0,false);
         gameView.dialogView.step();
      }
   }
   
   private function onSafariTutComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onSafariTutComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_SAFARI_WIN;
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
   }
}
