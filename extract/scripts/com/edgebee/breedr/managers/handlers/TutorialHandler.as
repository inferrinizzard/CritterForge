package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.TutorialEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class TutorialHandler extends Handler
   {
      
      public static var CreditsChangeWav:Class = TutorialHandler_CreditsChangeWav;
       
      
      public var data:TutorialEvent;
      
      public var manager:EventProcessor;
      
      public function TutorialHandler(param1:TutorialEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoTutorial(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.TutorialEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TutorialHandler;

class DoTutorial extends HandlerState
{
    
   
   public function DoTutorial(param1:TutorialHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:TutorialEvent = (machine as TutorialHandler).data;
      client.tutorialManager.state = _loc2_.state;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      var _loc2_:TutorialEvent = (machine as TutorialHandler).data;
      if(!_loc2_.is_stealth)
      {
         --client.criticalComms;
      }
   }
}
