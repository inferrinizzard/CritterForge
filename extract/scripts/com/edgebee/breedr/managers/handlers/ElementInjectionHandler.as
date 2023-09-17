package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ElementInjectionEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ElementInjectionHandler extends Handler
   {
      
      public static var InjectElementWav:Class = ElementInjectionHandler_InjectElementWav;
       
      
      public var data:ElementInjectionEvent;
      
      public var manager:EventProcessor;
      
      public function ElementInjectionHandler(param1:ElementInjectionEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoElementInjection(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.events.ElementInjectionEvent;
import com.edgebee.breedr.managers.handlers.ElementInjectionHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoElementInjection extends HandlerState
{
    
   
   public function DoElementInjection(param1:ElementInjectionHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ElementInjectionEvent = (machine as ElementInjectionHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_id) as CreatureInstance;
      _loc3_[_loc2_.accessory_name + "_element_id"] = _loc2_.element_id;
      UIGlobals.playSound(ElementInjectionHandler.InjectElementWav);
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      return Result.STOP;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.ranchView.injectionPopup.doClose();
      --client.criticalComms;
   }
}
