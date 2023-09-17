package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.ItemUseEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class ItemUseHandler extends Handler
   {
      
      public static var ItemUseWav:Class = ItemUseHandler_ItemUseWav;
      
      public static var ItemPlayWav:Class = ItemUseHandler_ItemPlayWav;
      
      public static var ItemBrushWav:Class = ItemUseHandler_ItemBrushWav;
      
      public static var ItemCreamWav:Class = ItemUseHandler_ItemCreamWav;
      
      public static var ItemEnergyWav:Class = ItemUseHandler_ItemEnergyWav;
       
      
      public var data:ItemUseEvent;
      
      public var manager:EventProcessor;
      
      public function ItemUseHandler(param1:ItemUseEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new DoItemUse(this));
      }
   }
}

import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.creature.CreatureInstance;
import com.edgebee.breedr.data.item.Item;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.data.world.Area;
import com.edgebee.breedr.data.world.Stall;
import com.edgebee.breedr.events.ItemUseEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.ItemUseHandler;
import com.edgebee.breedr.ui.creature.UseItemEffect;
import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
import com.edgebee.breedr.ui.world.areas.ranch.StallView;
import flash.geom.Point;

class DoItemUse extends HandlerState
{
    
   
   public function DoItemUse(param1:ItemUseHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      var _loc8_:UseItemEffect = null;
      var _loc9_:Point = null;
      var _loc10_:StallView = null;
      var _loc11_:String = null;
      super.transitionInto(param1);
      var _loc2_:ItemUseEvent = (machine as ItemUseHandler).data;
      var _loc3_:CreatureInstance = player.creatures.findItemByProperty("id",_loc2_.creature_id) as CreatureInstance;
      var _loc4_:Stall = player.stalls.findItemByProperty("id",_loc2_.stall_id) as Stall;
      var _loc5_:ItemInstance = player.items.findItemByProperty("id",_loc2_.id) as ItemInstance;
      var _loc6_:Boolean = false;
      var _loc7_:Boolean = false;
      switch(_loc5_.item.type)
      {
         case Item.TYPE_USE:
            _loc6_ = true;
            switch(_loc5_.item.subtype)
            {
               case Item.USE_RESTORE_STAMINA:
                  UIGlobals.playSound(ItemUseHandler.ItemEnergyWav);
                  break;
               default:
                  UIGlobals.playSound(ItemUseHandler.ItemUseWav);
            }
            break;
         case Item.TYPE_PLAY:
            _loc6_ = true;
            switch(_loc5_.item.subtype)
            {
               case Item.PLAY_THROW:
                  UIGlobals.playSound(ItemUseHandler.ItemPlayWav);
                  break;
               default:
                  UIGlobals.playSound(ItemUseHandler.ItemUseWav);
            }
            break;
         case Item.TYPE_NURTURE:
            _loc6_ = true;
            switch(_loc5_.item.subtype)
            {
               case Item.NURTURE_HEAL:
                  UIGlobals.playSound(ItemUseHandler.ItemCreamWav);
                  break;
               case Item.NURTURE_COMFORT:
                  UIGlobals.playSound(ItemUseHandler.ItemBrushWav);
                  break;
               default:
                  UIGlobals.playSound(ItemUseHandler.ItemUseWav);
            }
            break;
         case Item.TYPE_FEED:
            _loc7_ = true;
            UIGlobals.playSound(ItemUseHandler.ItemUseWav);
            break;
         default:
            UIGlobals.playSound(ItemUseHandler.ItemUseWav);
      }
      if(_loc6_ || _loc7_)
      {
         (_loc8_ = new UseItemEffect()).useEvent = _loc2_;
         if(player.area.type == Area.TYPE_RANCH)
         {
            for each(_loc11_ in RanchView.views)
            {
               _loc10_ = gameView.ranchView[_loc11_];
               if(_loc6_ && _loc10_.creature && _loc10_.creature.id == _loc3_.id)
               {
                  break;
               }
               if(_loc7_ && _loc10_.stall.id == _loc4_.id)
               {
                  break;
               }
               _loc10_ = null;
            }
            if(_loc10_)
            {
               _loc9_ = new Point(_loc10_.x + _loc10_.width / 2,_loc10_.y + _loc10_.height / 2);
               _loc9_ = _loc10_.parent.localToGlobal(_loc9_);
               _loc9_ = gameView.ranchView.globalToLocal(_loc9_);
               _loc8_.center = _loc9_;
               gameView.ranchView.addChild(_loc8_);
            }
         }
         if(player.area.type == Area.TYPE_SAFARI)
         {
            _loc9_ = new Point(gameView.safariView.creatureView.x + gameView.safariView.creatureView.width / 2,gameView.safariView.creatureView.y + gameView.safariView.creatureView.height / 2);
            _loc9_ = gameView.safariView.creatureView.parent.localToGlobal(_loc9_);
            _loc9_ = gameView.safariView.globalToLocal(_loc9_);
            _loc8_.center = _loc9_;
            gameView.safariView.addChild(_loc8_);
         }
         if(player.area.type == Area.TYPE_ARENA)
         {
            _loc9_ = gameView.arenaView.creatureView.bodyCenter;
            _loc9_ = gameView.globalToLocal(_loc9_);
            _loc8_.center = _loc9_;
            gameView.addChild(_loc8_);
         }
      }
      if(_loc2_.destroy)
      {
         player.items.removeItem(_loc5_);
      }
      else if(_loc5_.item.max_uses > 0)
      {
         ++_loc5_.use_count;
      }
      timer.delay = 600;
      timer.start();
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      var _loc2_:ItemUseEvent = null;
      super.loop(param1);
      if(timerComplete)
      {
         _loc2_ = (machine as ItemUseHandler).data;
         if(_loc2_.breaks)
         {
            return new Result(Result.TRANSITION,new BreakItem(machine as ItemUseHandler));
         }
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      --client.criticalComms;
   }
}

import com.edgebee.atlas.data.l10n.Asset;
import com.edgebee.atlas.util.Utils;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.item.ItemInstance;
import com.edgebee.breedr.events.ItemUseEvent;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.ItemUseHandler;

class BreakItem extends HandlerState
{
    
   
   public function BreakItem(param1:ItemUseHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      var _loc2_:ItemUseEvent = (machine as ItemUseHandler).data;
      var _loc3_:ItemInstance = player.items.findItemByProperty("id",_loc2_.id) as ItemInstance;
      loggingBox.print(Utils.formatString(Asset.getInstanceByName("ITEM_BREAK_LOG").value,{"item":_loc3_.item.name.value}));
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
