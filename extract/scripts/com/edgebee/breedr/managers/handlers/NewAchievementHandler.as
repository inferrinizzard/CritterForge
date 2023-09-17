package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.NewAchievementEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class NewAchievementHandler extends Handler
   {
       
      
      public var data:NewAchievementEvent;
      
      public var manager:EventProcessor;
      
      public function NewAchievementHandler(param1:NewAchievementEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new Update(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.NewAchievementEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.NewAchievementHandler;

class Update extends HandlerState
{
    
   
   public function Update(param1:NewAchievementHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:NewAchievementEvent = (machine as NewAchievementHandler).data;
      player.game_achievements.addItem(_loc2_.achievement_instance);
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
