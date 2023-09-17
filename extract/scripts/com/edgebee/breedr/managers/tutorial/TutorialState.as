package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.fsm.State;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.GameView;
   import flash.events.TimerEvent;
   
   public class TutorialState extends State
   {
       
      
      protected var timer:Timer;
      
      protected var timerComplete:Boolean = false;
      
      public function TutorialState(param1:TutorialMachine)
      {
         this.timer = new Timer(1000);
         super(param1);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get gameView() : GameView
      {
         return (UIGlobals.root as breedr_flash).rootView.gameView;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override public function transitionInto(param1:Boolean = false) : void
      {
         super.transitionInto(param1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerComplete);
      }
      
      override public function transitionOut(param1:Boolean = false) : void
      {
         super.transitionOut(param1);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerComplete);
      }
      
      public function decorateName(param1:String) : String
      {
         return Utils.htmlWrap(param1,null,UIGlobals.getStyle("LogNameColor"),0,true);
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.timer.stop();
         this.timerComplete = true;
      }
   }
}
