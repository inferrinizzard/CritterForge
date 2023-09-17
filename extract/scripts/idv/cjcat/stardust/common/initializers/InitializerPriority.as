package idv.cjcat.stardust.common.initializers
{
   import flash.utils.Dictionary;
   
   public class InitializerPriority
   {
      
      private static var _instance:idv.cjcat.stardust.common.initializers.InitializerPriority;
       
      
      protected var priorities:Dictionary;
      
      public function InitializerPriority()
      {
         super();
         this.priorities = new Dictionary();
         this.populatePriorities();
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.initializers.InitializerPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.common.initializers.InitializerPriority();
         }
         return _instance;
      }
      
      public function getPriority(param1:Class) : int
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
