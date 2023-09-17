package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.breedr.events.LoginEvent;
   import com.edgebee.breedr.managers.EventProcessor;
   
   public class LoginHandler extends Handler
   {
       
      
      public var data:LoginEvent;
      
      public var manager:EventProcessor;
      
      public function LoginHandler(param1:LoginEvent, param2:EventProcessor)
      {
         super();
         this.data = param1;
         this.manager = param2;
         start(new WaitForGameViewLoaded(this));
      }
   }
}

import com.edgebee.atlas.Client;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.LoginHandler;

class WaitForGameViewLoaded extends HandlerState
{
    
   
   public function WaitForGameViewLoaded(param1:LoginHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      if(client.mode == Client.PRODUCTION)
      {
         timer.delay = 2000;
         timer.start();
      }
      else
      {
         timer.delay = 1000;
         timer.start();
      }
   }
   
   override public function loop(param1:Boolean = false) : *
   {
      super.loop(param1);
      if(!gameView || !gameView.childrenCreated || !timerComplete)
      {
         return Result.CONTINUE;
      }
      return new Result(Result.TRANSITION,new FadeIn(machine as LoginHandler));
   }
   
   override public function transitionOut(param1:Boolean = false) : void
   {
      super.transitionOut(param1);
      gameView.visible = true;
      --client.criticalComms;
   }
}

import com.edgebee.atlas.events.AnimationEvent;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.util.fsm.Result;
import com.edgebee.breedr.managers.handlers.HandlerState;
import com.edgebee.breedr.managers.handlers.LoginHandler;

class FadeIn extends HandlerState
{
    
   
   private var _fadeInComplete:Boolean = false;
   
   public function FadeIn(param1:LoginHandler)
   {
      super(param1);
   }
   
   override public function transitionInto(param1:Boolean = false) : void
   {
      super.transitionInto(param1);
      (UIGlobals.root as breedr_flash).stopProgressIndicator();
      gameView.fadeInInstance.addEventListener(AnimationEvent.STOP,this.onFadeInComplete,false,0,false);
      gameView.fadeInInstance.play();
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
   
   private function onFadeInComplete(param1:AnimationEvent) : void
   {
      gameView.fadeInInstance.removeEventListener(AnimationEvent.STOP,this.onFadeInComplete);
      this._fadeInComplete = true;
      gameView.fadeOverlay.visible = false;
      if(Boolean(client.user.registered) && !client.chatManager.connected)
      {
         client.chatManager.connect();
      }
   }
}
