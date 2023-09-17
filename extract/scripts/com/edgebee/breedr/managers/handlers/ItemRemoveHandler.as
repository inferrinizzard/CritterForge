package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ItemRemoveEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ItemRemoveHandler extends Handler
   {
       
      
      public var data:ItemRemoveEvent;
      
      public var manager:EventProcessor;
      
      public function ItemRemoveHandler(param1:ItemRemoveEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoItemRemove(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.events.ItemRemoveEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.ItemRemoveHandler;

class DoItemRemove extends HandlerState
{
    
   
   public function DoItemRemove(param1:ItemRemoveHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ItemRemoveEvent = (machine as ItemRemoveHandler).data;
      var _loc3_:ItemInstance = player.items.findItemByProperty("id",_loc2_.id) as ItemInstance;
      player.items.removeItem(_loc3_);
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
