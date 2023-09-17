package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.InvitePlayerEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class InvitePlayerHandler extends Handler
   {
       
      
      public var data:InvitePlayerEvent;
      
      public var manager:EventProcessor;
      
      public function InvitePlayerHandler(param1:InvitePlayerEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoInvitePlayer(this));
      }
   }
}

import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.InvitePlayerEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.InvitePlayerHandler;
import flash.events.Event;

class DoInvitePlayer extends HandlerState
{
    
   
   public function DoInvitePlayer(param1:InvitePlayerHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:InvitePlayerEvent = (machine as InvitePlayerHandler).data;
      player.syndicate.activity.append(_loc2_.log);
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
