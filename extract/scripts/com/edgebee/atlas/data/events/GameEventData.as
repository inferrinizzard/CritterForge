package com.edgebee.atlas.data.events
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.interfaces.IExecutable;
   import com.edgebee.atlas.ui.UIGlobals;
   
   public class GameEventData extends Data implements IExecutable
   {
       
      
      public function GameEventData(param1:Object = null)
      {
         super(param1);
      }
      
      public function get active() : Boolean
      {
         return false;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client;
      }
      
      public function execute() : void
      {
      }
   }
}
