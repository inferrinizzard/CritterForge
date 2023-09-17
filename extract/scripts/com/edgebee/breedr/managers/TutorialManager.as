package com.edgebee.breedr.managers
{
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.fsm.Machine;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.managers.tutorial.Combat2Tutorial;
   import com.edgebee.breedr.managers.tutorial.CombatTutorial;
   import com.edgebee.breedr.managers.tutorial.Feed2Tutorial;
   import com.edgebee.breedr.managers.tutorial.FeedTutorial;
   import com.edgebee.breedr.managers.tutorial.FinalTutorial;
   import com.edgebee.breedr.managers.tutorial.GreetingTutorial;
   import com.edgebee.breedr.managers.tutorial.HatchingTutorial;
   import com.edgebee.breedr.managers.tutorial.MoneyTutorial;
   import com.edgebee.breedr.managers.tutorial.RanchTutorial;
   import com.edgebee.breedr.managers.tutorial.Shop2Tutorial;
   import com.edgebee.breedr.managers.tutorial.ShopTutorial;
   import com.edgebee.breedr.managers.tutorial.TutorialMachine;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.Event;
   
   public class TutorialManager
   {
      
      public static const STATE_COMPLETED:Number = 0;
      
      public static const STATE_GREETING:Number = 1;
      
      public static const STATE_HATCHING:Number = 2;
      
      public static const STATE_RANCH:Number = 3;
      
      public static const STATE_SHOP:Number = 4;
      
      public static const STATE_SHOP2:Number = 5;
      
      public static const STATE_FEED:Number = 6;
      
      public static const STATE_FEED2:Number = 7;
      
      public static const STATE_MONEY:Number = 8;
      
      public static const STATE_COMBAT:Number = 9;
      
      public static const STATE_COMBAT2:Number = 10;
      
      public static const STATE_FINAL:Number = 11;
      
      private static var _stateInfos:Object;
       
      
      public var client:Client;
      
      private var _state:int = 0;
      
      public var currentTutorial:TutorialMachine;
      
      public function TutorialManager(param1:Client)
      {
         super();
         this.client = param1;
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.client.service.addEventListener("TutorialComplete",this.onTutorialComplete);
         if(!_stateInfos)
         {
            _stateInfos = {};
            _stateInfos[STATE_GREETING] = {
               "machine":GreetingTutorial,
               "updates":true
            };
            _stateInfos[STATE_HATCHING] = {
               "machine":HatchingTutorial,
               "updates":false
            };
            _stateInfos[STATE_RANCH] = {
               "machine":RanchTutorial,
               "updates":false
            };
            _stateInfos[STATE_SHOP] = {
               "machine":ShopTutorial,
               "updates":false
            };
            _stateInfos[STATE_SHOP2] = {
               "machine":Shop2Tutorial,
               "updates":false
            };
            _stateInfos[STATE_FEED] = {
               "machine":FeedTutorial,
               "updates":false
            };
            _stateInfos[STATE_FEED2] = {
               "machine":Feed2Tutorial,
               "updates":true
            };
            _stateInfos[STATE_MONEY] = {
               "machine":MoneyTutorial,
               "updates":false
            };
            _stateInfos[STATE_COMBAT] = {
               "machine":com.edgebee.breedr.managers.tutorial.CombatTutorial,
               "updates":false
            };
            _stateInfos[STATE_COMBAT2] = {
               "machine":Combat2Tutorial,
               "updates":false
            };
            _stateInfos[STATE_FINAL] = {
               "machine":FinalTutorial,
               "updates":true
            };
         }
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         if(this.state != param1)
         {
            this._state = param1;
            this.initializeState();
         }
      }
      
      private function initializeState() : void
      {
         if(this.state > 0)
         {
            this.currentTutorial = new _stateInfos[this.state].machine();
            this.currentTutorial.addEventListener(Machine.STOPPED,this.onTutorialStepComplete);
            this.currentTutorial.execute();
            UIGlobals.root.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.currentTutorial.execute();
      }
      
      private function onTutorialStepComplete(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(_stateInfos[this.state].updates)
         {
            _loc2_ = this.client.createInput();
            _loc2_.state = this.currentTutorial.state;
            this.client.service.TutorialComplete(_loc2_);
            ++this.client.criticalComms;
         }
         UIGlobals.root.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.currentTutorial.removeEventListener(Machine.STOPPED,this.onTutorialStepComplete);
         this.currentTutorial = null;
      }
      
      private function onTutorialComplete(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "TutorialComplete")
         {
            --this.client.criticalComms;
         }
      }
   }
}
