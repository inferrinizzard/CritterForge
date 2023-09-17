package idv.cjcat.stardust.common.actions
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.events.ActionEvent;
   import idv.cjcat.stardust.sd;
   
   public class ActionCollection implements ActionCollector
   {
       
      
      sd var actions:Array;
      
      public function ActionCollection()
      {
         super();
         this.sd::actions = [];
      }
      
      final public function addAction(param1:Action) : void
      {
         this.sd::actions.push(param1);
         param1.addEventListener(ActionEvent.PRIORITY_CHANGE,this.sortActions);
         this.sortActions();
      }
      
      final public function removeAction(param1:Action) : void
      {
         var _loc2_:int = 0;
         while((_loc2_ = this.sd::actions.indexOf(param1)) >= 0)
         {
            param1 = Action(this.sd::actions.splice(_loc2_,1)[0]);
            param1.removeEventListener(ActionEvent.PRIORITY_CHANGE,this.sortActions);
         }
      }
      
      final public function clearActions() : void
      {
         var _loc1_:Action = null;
         for each(_loc1_ in this.sd::actions)
         {
            this.removeAction(_loc1_);
         }
      }
      
      final public function sortActions(param1:Event = null) : void
      {
         this.sd::actions.sortOn("priority",Array.NUMERIC | Array.DESCENDING);
      }
   }
}
