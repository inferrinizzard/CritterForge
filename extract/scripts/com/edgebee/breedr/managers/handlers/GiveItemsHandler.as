package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.GiveItemsEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class GiveItemsHandler extends Handler
   {
       
      
      public var data:GiveItemsEvent;
      
      public var manager:EventProcessor;
      
      public function GiveItemsHandler(param1:GiveItemsEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoGive(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.events.GiveItemsEvent;
import com.edgebee.breedr.managers.handlers.GiveItemsHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoGive extends HandlerState
{
    
   
   public function DoGive(param1:GiveItemsHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:GiveItemsEvent = (machine as GiveItemsHandler).data;
      player.items.addItems(_loc2_.items.source);
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
