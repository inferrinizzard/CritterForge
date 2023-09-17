package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.QuestCompleteEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class QuestCompleteHandler extends Handler
   {
      
      public static var QuestCompleteWav:Class = QuestCompleteHandler_QuestCompleteWav;
       
      
      public var data:QuestCompleteEvent;
      
      public var manager:EventProcessor;
      
      public function QuestCompleteHandler(param1:QuestCompleteEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoQuestComplete(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.QuestCompleteEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.QuestCompleteHandler;
import flash.events.Event;

class DoQuestComplete extends HandlerState
{
    
   
   private var _dialogComplete:Boolean = false;
   
   public function DoQuestComplete(param1:QuestCompleteHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:QuestCompleteEvent = (machine as QuestCompleteHandler).data;
      _loc2_.new_quest.copyTo(player.quest);
      UIGlobals.playSound(QuestCompleteHandler.QuestCompleteWav);
      gameView.dialogView.dialog = Dialog.getInstanceByName("quest_complete");
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
