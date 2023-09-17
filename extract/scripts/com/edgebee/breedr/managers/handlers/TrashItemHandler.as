package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.TrashItemEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class TrashItemHandler extends Handler
   {
      
      public static var ThrashWav:Class = TrashItemHandler_ThrashWav;
       
      
      public var data:TrashItemEvent;
      
      public var manager:EventProcessor;
      
      public function TrashItemHandler(param1:TrashItemEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoTrashItem(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.events.TrashItemEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.TrashItemHandler;

class DoTrashItem extends HandlerState
{
    
   
   public function DoTrashItem(param1:TrashItemHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:TrashItemEvent = (machine as TrashItemHandler).data;
      var _loc3_:ItemInstance = player.items.findItemByProperty("id",_loc2_.id) as ItemInstance;
      if(_loc3_)
      {
         player.items.removeItem(_loc3_);
         UIGlobals.playSound(TrashItemHandler.ThrashWav);
      }
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
