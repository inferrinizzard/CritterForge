package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.RemovePlayerEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class RemovePlayerHandler extends Handler
   {
       
      
      public var data:RemovePlayerEvent;
      
      public var manager:EventProcessor;
      
      public function RemovePlayerHandler(param1:RemovePlayerEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoRemovePlayer(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.ladder.Team;
import com.edgebee.breedr.data.player.Player;
import com.edgebee.breedr.events.RemovePlayerEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.RemovePlayerHandler;

class DoRemovePlayer extends HandlerState
{
    
   
   public function DoRemovePlayer(param1:RemovePlayerHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc4_:Team = null;
      var _loc5_:CreatureInstance = null;
      super.transitionInto(param1);
      var _loc2_:RemovePlayerEvent = (machine as RemovePlayerHandler).data;
      var _loc3_:Player = player.syndicate.members.findItemByProperty("id",_loc2_.player_id) as Player;
      player.syndicate.members.removeItem(_loc3_);
      for each(_loc4_ in player.syndicate.teams)
      {
         for each(_loc5_ in _loc4_.members)
         {
            if(_loc5_.owner.id == _loc2_.player_id)
            {
               _loc4_.members.removeItem(_loc5_);
               break;
            }
         }
      }
      player.syndicate.activity.addItem(_loc2_.log);
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
