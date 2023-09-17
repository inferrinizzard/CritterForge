package com.edgebee.breedr.managers.handlers.combat
{
   import com.edgebee.breedr.managers.handlers.Handler;
   import com.edgebee.breedr.managers.handlers.HandlerState;
   import com.edgebee.breedr.ui.SmoothLogger;
   
   public class CombatHandlerState extends HandlerState
   {
       
      
      public function CombatHandlerState(param1:Handler)
      {
         super(param1);
      }
      
      override public function get loggingBox() : SmoothLogger
      {
         return gameView.combatView.combatLogger;
      }
      
      public function get isInQuickCombat() : Boolean
      {
         return gameView.combatView.visible == false;
      }
   }
}
