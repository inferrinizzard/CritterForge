package idv.cjcat.stardust.common.events
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.actions.Action;
   
   public class ActionEvent extends Event
   {
      
      public static const PRIORITY_CHANGE:String = "stardustActoinPriorityChange";
       
      
      private var _action:Action;
      
      public function ActionEvent(param1:String, param2:Action)
      {
         super(param1);
         this._action = param2;
      }
      
      public function get action() : Action
      {
         return this._action;
      }
   }
}
