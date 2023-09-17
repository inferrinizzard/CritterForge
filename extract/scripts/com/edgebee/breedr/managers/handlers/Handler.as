package com.edgebee.breedr.managers.handlers
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.fsm.Machine;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.GameView;
   import com.edgebee.breedr.ui.RootView;
   import com.edgebee.breedr.ui.SmoothLogger;
   
   public class Handler extends Machine
   {
       
      
      public function Handler()
      {
         super();
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get rootView() : RootView
      {
         return (UIGlobals.root as breedr_flash).rootView;
      }
      
      public function get gameView() : GameView
      {
         return this.rootView.gameView;
      }
      
      public function get loggingBox() : SmoothLogger
      {
         return this.gameView.loggingBox;
      }
   }
}
