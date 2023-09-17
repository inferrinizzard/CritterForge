package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.MoveCreatureToStallEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class MoveCreatureToStallHandler extends Handler
   {
      
      public static var RanchMoveWav:Class = MoveCreatureToStallHandler_RanchMoveWav;
       
      
      public var data:MoveCreatureToStallEvent;
      
      public var manager:EventProcessor;
      
      public function MoveCreatureToStallHandler(param1:MoveCreatureToStallEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoMoveCreatureToStall(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.MoveCreatureToStallEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.MoveCreatureToStallHandler;
import com.edgebee.breedr.ui.world.areas.ranch.StallView;

class DoMoveCreatureToStall extends HandlerState
{
    
   
   public function DoMoveCreatureToStall(param1:MoveCreatureToStallHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      var _loc5_:Stall = null;
      var _loc6_:Stall = null;
      super.loop(param1);
      var _loc2_:MoveCreatureToStallEvent = (machine as MoveCreatureToStallHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_id) as CreatureInstance;
      var _loc4_:Stall = player.stalls.findItemByProperty("id",_loc2_.stall_id) as Stall;
      for each(_loc6_ in player.stalls)
      {
         if(_loc6_.creature.id == _loc2_.creature_id)
         {
            _loc5_ = _loc6_;
            break;
         }
      }
      if(gameView.statusWindow.creature)
      {
         gameView.statusWindow.doClose();
      }
      var _loc7_:CreatureInstance = new CreatureInstance();
      if(!_loc4_.empty)
      {
         _loc4_.creature.copyTo(_loc7_);
      }
      var _loc8_:StallView;
      if(_loc8_ = gameView.ranchView.findStallView(_loc4_))
      {
         _loc8_.moving = true;
      }
      _loc3_.copyTo(_loc4_.creature);
      if(_loc8_)
      {
         _loc8_.moving = false;
      }
      if(_loc8_ = gameView.ranchView.findStallView(_loc5_))
      {
         _loc8_.moving = true;
      }
      _loc7_.copyTo(_loc5_.creature);
      if(_loc8_)
      {
         _loc8_.moving = false;
      }
      UIGlobals.playSound(MoveCreatureToStallHandler.RanchMoveWav);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}
