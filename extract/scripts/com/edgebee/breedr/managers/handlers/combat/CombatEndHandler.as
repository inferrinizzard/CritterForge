package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.CombatEndEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class CombatEndHandler extends Handler
   {
      
      public static var VictoryWav:Class = CombatEndHandler_VictoryWav;
      
      public static var DefeatWav:Class = CombatEndHandler_DefeatWav;
       
      
      public var data:CombatEndEvent;
      
      public var manager:EventProcessor;
      
      public function CombatEndHandler(param1:CombatEndEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoCombatEnd(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.events.combat.CombatEndEvent;
import com.edgebee.breedr.managers.handlers.combat.CombatEndHandler;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.ui.combat.CombatView;

class DoCombatEnd extends CombatHandlerState
{
    
   
   public function DoCombatEnd(param1:CombatEndHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:CombatEndEvent = (machine as CombatEndHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      if(!client.currentReplay.is_replay)
      {
         if(_loc2_.winner_id == _loc3_.creature1.id)
         {
            UIGlobals.playSound(CombatEndHandler.VictoryWav);
            _loc3_.announcer.color.hex = 255;
            _loc3_.announcer.start(Asset.getInstanceByName("VICTORY"));
         }
         else if(_loc2_.winner_id == _loc3_.creature2.id)
         {
            UIGlobals.playSound(CombatEndHandler.DefeatWav);
            _loc3_.announcer.color.hex = 16711680;
            _loc3_.announcer.start(Asset.getInstanceByName("DEFEAT"));
         }
         else
         {
            UIGlobals.playSound(CombatEndHandler.DefeatWav);
            _loc3_.announcer.color.hex = 16776960;
            _loc3_.announcer.start(Asset.getInstanceByName("CHALLENGE_RESULTS_TIE"));
         }
      }
      client.sndManager.stopMusic();
      timer.delay = 3000;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(timerComplete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.combatView.reset();
      gameView.combatView.visible = false;
      gameView.npcView.visible = true;
      gameView.navigationBar.visible = true;
      gameView.backgroundImage.source = UIGlobals.getAssetPath(player.area.getImageForPlayer(player));
      switch(player.area.type)
      {
         case Area.TYPE_RANCH:
            gameView.ranchView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_LABORATORY:
            gameView.labView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_SHOP:
            gameView.shopView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_ARENA:
            gameView.arenaView.visible = true;
            gameView.inventoryView.visible = true;
            break;
         case Area.TYPE_SAFARI:
            gameView.safariView.visible = true;
            gameView.inventoryView.visible = true;
            gameView.navigationBar.visible = false;
            break;
         case Area.TYPE_TRAVEL:
            gameView.travelView.visible = true;
            break;
         case Area.TYPE_AUCTION:
            gameView.auctionView.visible = true;
            break;
         case Area.TYPE_SYNDICATE:
            gameView.syndicateView.visible = true;
            break;
         case Area.TYPE_QUEST:
            gameView.questView.visible = true;
            gameView.inventoryView.visible = true;
      }
      client.sndManager.playMusic(player.area.music,0,int.MAX_VALUE);
      if(gameView.combatResultsWindow.showAfterReplay)
      {
         gameView.combatResultsWindow.showAfterReplay = false;
         gameView.combatResultsWindow.visible = true;
      }
   }
}
