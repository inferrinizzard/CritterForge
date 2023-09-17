package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ExtractSeedEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ExtractSeedHandler extends Handler
   {
      
      public static var ExtractSuccessWav:Class = ExtractSeedHandler_ExtractSuccessWav;
      
      public static var ExtractFailureWav:Class = ExtractSeedHandler_ExtractFailureWav;
       
      
      public var data:ExtractSeedEvent;
      
      public var manager:EventProcessor;
      
      public function ExtractSeedHandler(param1:ExtractSeedEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoExtractSeed(this));
      }
   }
}

import com.edgebee.atlas.events.PropertyChangeEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.data.world.NonPlayerCharacter;
import com.edgebee.breedr.events.ExtractSeedEvent;
import com.edgebee.breedr.managers.handlers.ExtractSeedHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;
import flash.events.Event;

class DoExtractSeed extends HandlerState
{
    
   
   public function DoExtractSeed(param1:ExtractSeedHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:ItemInstance = null;
      var _loc4_:CreatureInstance = null;
      super.transitionInto(param1);
      var _loc2_:ExtractSeedEvent = (machine as ExtractSeedHandler).data;
      if(_loc2_.success)
      {
         _loc3_ = player.items.findItemByProperty("id",_loc2_.item_id) as ItemInstance;
         _loc3_.creature.update(_loc2_.creature);
         _loc3_.dispatchEvent(PropertyChangeEvent.create(_loc3_,"creature",null,_loc3_.creature));
         UIGlobals.playSound(ExtractSeedHandler.ExtractSuccessWav);
         if(_loc2_.source_creature_id)
         {
            --(_loc4_ = player.creatures.findItemByProperty("id",_loc2_.source_creature_id) as CreatureInstance).seed_count;
            if(_loc2_.source_creature_is_sterile)
            {
               _loc4_.is_sterile = true;
            }
         }
      }
      else
      {
         UIGlobals.playSound(ExtractSeedHandler.ExtractFailureWav);
      }
   }
   
   private function onDialogComplete(param1:Event) : void
   {
      --client.criticalComms;
      gameView.dialogView.removeEventListener(Event.COMPLETE,this.onDialogComplete);
      gameView.npcView.setNpcAndExpression(player.area.npc,NonPlayerCharacter.EXPRESSION_NEUTRAL);
      var _loc2_:Object = client.createInput();
      _loc2_.flags = Player.EV_FRIDGE_FULL;
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
