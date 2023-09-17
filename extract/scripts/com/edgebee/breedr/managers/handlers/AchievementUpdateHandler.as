package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.AchievementUpdateEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class AchievementUpdateHandler extends Handler
   {
       
      
      public var data:AchievementUpdateEvent;
      
      public var manager:EventProcessor;
      
      public function AchievementUpdateHandler(param1:AchievementUpdateEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.AchievementUpdateEvent;
import com.edgebee.breedr.managers.handlers.AchievementUpdateHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class Update extends HandlerState
{
    
   
   public function Update(param1:AchievementUpdateHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:AchievementUpdateEvent = (machine as AchievementUpdateHandler).data;
      player.game_achievements.source = _loc2_.achievements.source;
      player.achievementsFetched = true;
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
