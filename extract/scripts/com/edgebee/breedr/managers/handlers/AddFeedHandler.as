package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.AddFeedEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class AddFeedHandler extends Handler
   {
      
      public static var FeederFillWav:Class = AddFeedHandler_FeederFillWav;
       
      
      public var data:AddFeedEvent;
      
      public var manager:EventProcessor;
      
      public function AddFeedHandler(param1:AddFeedEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoAddFeed(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Feeder;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.AddFeedEvent;
import com.edgebee.breedr.managers.handlers.AddFeedHandler;
import com.edgebee.breedr.managers.handlers.HandlerState;

class DoAddFeed extends HandlerState
{
    
   
   public function DoAddFeed(param1:AddFeedHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc3_:Feeder = null;
      var _loc4_:Stall = null;
      super.transitionInto(param1);
      var _loc2_:AddFeedEvent = (machine as AddFeedHandler).data;
      for each(_loc4_ in player.stalls)
      {
         if(_loc4_.feeder.id == _loc2_.feeder_id)
         {
            _loc3_ = _loc4_.feeder;
            break;
         }
      }
      if(!_loc3_)
      {
         throw new Error("Can\'t find feeder with id " + _loc2_.feeder_id);
      }
      _loc3_.quantity = _loc2_.quantity;
      _loc3_.item_id = _loc2_.item_id;
      UIGlobals.playSound(AddFeedHandler.FeederFillWav);
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
