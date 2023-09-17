package idv.cjcat.stardust.common.actions
{
   import idv.cjcat.stardust.common.actions.triggers.DeathTrigger;
   import idv.cjcat.stardust.common.actions.triggers.LifeTrigger;
   
   public class CommonActionPriority extends ActionPriority
   {
      
      private static var _instance:idv.cjcat.stardust.common.actions.CommonActionPriority;
       
      
      public function CommonActionPriority()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.actions.CommonActionPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.common.actions.CommonActionPriority();
         }
         return _instance;
      }
      
      final override protected function populatePriorities() : void
      {
         priorities[DeathLife] = -1;
         priorities[DeathTrigger] = -5;
         priorities[LifeTrigger] = -5;
      }
   }
}
