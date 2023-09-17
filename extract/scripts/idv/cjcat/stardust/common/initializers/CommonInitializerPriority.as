package idv.cjcat.stardust.common.initializers
{
   public class CommonInitializerPriority extends InitializerPriority
   {
      
      private static var _instance:idv.cjcat.stardust.common.initializers.CommonInitializerPriority;
       
      
      public function CommonInitializerPriority()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.initializers.CommonInitializerPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.common.initializers.CommonInitializerPriority();
         }
         return _instance;
      }
      
      final override protected function populatePriorities() : void
      {
         priorities[Mask] = 1;
      }
   }
}
