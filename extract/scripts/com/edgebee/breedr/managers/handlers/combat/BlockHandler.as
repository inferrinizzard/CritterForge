package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.events.combat.BlockEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   import com.edgebee.breedr.managers.handlers.Handler;
   
   public class BlockHandler extends Handler
   {
       
      
      public var data:BlockEvent;
      
      public var manager:EventProcessor;
      
      public function BlockHandler(param1:BlockEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoBlock(this));
      }
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.combat.BlockEvent;
import com.edgebee.breedr.managers.handlers.combat.BlockHandler;
import com.edgebee.breedr.managers.handlers.combat.CombatHandlerState;
import com.edgebee.breedr.ui.combat.ActorView;
import com.edgebee.breedr.ui.combat.CombatView;

class DoBlock extends CombatHandlerState
{
    
   
   public function DoBlock(param1:BlockHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:BlockEvent = (machine as BlockHandler).data;
      var _loc3_:CombatView = gameView.combatView;
      var _loc4_:CreatureInstance = _loc3_.getCreatureById(_loc2_.afflicted_id);
      var _loc5_:ActorView = _loc3_.getViewById(_loc2_.afflicted_id);
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("BREED_COMBAT_BLOCK_LOG").value,{
         "name":decorateName(_loc4_.name),
         "amount":_loc2_.total
      }));
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
