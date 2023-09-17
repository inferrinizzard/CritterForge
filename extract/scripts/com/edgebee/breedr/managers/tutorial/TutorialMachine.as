package com.edgebee.breedr.managers.tutorial
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.fsm.Machine;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.GameView;
   
   public class TutorialMachine extends Machine
   {
       
      
      public var state:int = 0;
      
      public var skipped:Boolean = false;
      
      public function TutorialMachine(param1:int)
      {
         super();
         this.state = param1;
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
   }
}
