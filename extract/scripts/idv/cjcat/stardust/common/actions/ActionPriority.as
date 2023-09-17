package idv.cjcat.stardust.common.actions
{
   import flash.utils.Dictionary;
   
   public class ActionPriority
   {
      
      private static var _instance:idv.cjcat.stardust.common.actions.ActionPriority;
       
      
      protected var priorities:Dictionary;
      
      public function ActionPriority()
      {
         super();
         this.priorities = new Dictionary();
         this.populatePriorities();
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.actions.ActionPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.common.actions.ActionPriority();
         }
         return _instance;
      }
      
      final public function getPriority(param1:Class) : int
      {
         if(this.priorities[param1] == undefined)
         {
            return 0;
         }
         return this.priorities[param1];
      }
      
      protected function populatePriorities() : void
      {
      }
   }
}
