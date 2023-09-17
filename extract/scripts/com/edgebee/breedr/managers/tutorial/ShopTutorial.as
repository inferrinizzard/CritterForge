package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.breedr.managers.TutorialManager;
   
   public class ShopTutorial extends TutorialMachine
   {
       
      
      public function ShopTutorial()
      {
         super(TutorialManager.STATE_RANCH);
         start(new Initialize(this));
      }
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.data.world.Dialog;
import com.edgebee.breedr.managers.tutorial.ShopTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class Initialize extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function Initialize(param1:ShopTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.navigationBar.visible = false;
      gameView.inventoryView.visible = false;
      gameView.shopView.visible = false;
      gameView.dialogView.dialog = Dialog.getInstanceByName("tut_shop_dialog");
      gameView.dialogView.addEventListener("DIALOG_SHOW_INVENTORY",this.onShowInventory);
      gameView.dialogView.step();
   }
   
   private function onShowInventory(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_SHOW_INVENTORY",this.onShowInventory);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new ShowInventory(machine as ShopTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.ShopTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class ShowInventory extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function ShowInventory(param1:ShopTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.inventoryView.visible = true;
      gameView.inventoryView.optionsBox.enabled = false;
      gameView.dialogView.addEventListener("DIALOG_SHOW_SHOP",this.onShowShop);
   }
   
   private function onShowShop(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_SHOW_SHOP",this.onShowShop);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new ShowShop(machine as ShopTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.ShopTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class ShowShop extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function ShowShop(param1:ShopTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.shopView.visible = true;
      gameView.shopView.enabled = false;
      gameView.dialogView.addEventListener("DIALOG_SHOW_FIRST_FEED",this.onShowFirstFeed);
   }
   
   private function onShowFirstFeed(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_SHOW_FIRST_FEED",this.onShowFirstFeed);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new ShowFirstFeed(machine as ShopTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.ShopTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;
import flash.events.Event;

class ShowFirstFeed extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function ShowFirstFeed(param1:ShopTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.dialogView.addEventListener("DIALOG_UNLOCK_FIRST_FEED",this.onUnlockFirstFeed);
   }
   
   private function onUnlockFirstFeed(param1:Event) : void
   {
      gameView.dialogView.removeEventListener("DIALOG_UNLOCK_FIRST_FEED",this.onUnlockFirstFeed);
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return new Result(Result.TRANSITION,new WaitForPurchase(machine as ShopTutorial));
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
   }
}

import com.adobe.crypto.MD5;
import com.edgebee.atlas.events.ServiceEvent;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.tutorial.ShopTutorial;
import com.edgebee.breedr.managers.tutorial.TutorialState;

class WaitForPurchase extends TutorialState
{
    
   
   private var _complete:Boolean = false;
   
   public function WaitForPurchase(param1:ShopTutorial)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      gameView.shopView.enabled = true;
      gameView.shopView.shopListScrollBar.enabled = false;
      gameView.shopView.filtersBox.enabled = false;
      gameView.inventoryView.disableCostCheck = [MD5.hash("Item:feed_1")];
      client.service.addEventListener("BuyItem",this.onBuyItem);
   }
   
   private function onBuyItem(param1:ServiceEvent) : void
   {
      client.service.removeEventListener("BuyItem",this.onBuyItem);
      gameView.dialogView.step();
      this._complete = true;
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(this._complete)
      {
         return Result.STOP;
      }
      return Result.CONTINUE;
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.inventoryView.disableCostCheck = null;
      gameView.shopView.filtersBox.enabled = true;
      gameView.shopView.shopListScrollBar.enabled = true;
   }
}
