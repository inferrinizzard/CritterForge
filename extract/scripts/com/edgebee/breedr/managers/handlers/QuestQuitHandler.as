package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.QuestQuitEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class QuestQuitHandler extends Handler
   {
      
      public static var QuestQuitWav:Class = QuestQuitHandler_QuestQuitWav;
       
      
      public var data:QuestQuitEvent;
      
      public var manager:EventProcessor;
      
      public function QuestQuitHandler(param1:QuestQuitEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoQuestQuit(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.QuestQuitEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.QuestQuitHandler;
import flash.events.Event;

class DoQuestQuit extends HandlerState
{
    
   
   private var _dialogComplete:Boolean = false;
   
   public function DoQuestQuit(param1:QuestQuitHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:QuestQuitEvent = (machine as QuestQuitHandler).data;
      _loc2_.new_quest.copyTo(player.quest);
      UIGlobals.playSound(QuestQuitHandler.QuestQuitWav);
      gameView.dialogView.dialog = Dialog.getInstanceByName("quest_abandon");
      gameView.dialogView.addEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.dialogView.step();
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      this._dialogComplete = true;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._dialogComplete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
