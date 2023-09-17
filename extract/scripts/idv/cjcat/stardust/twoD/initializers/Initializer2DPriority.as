package idv.cjcat.stardust.twoD.initializers
{
   import idv.cjcat.stardust.common.initializers.InitializerPriority;
   
   public class Initializer2DPriority extends InitializerPriority
   {
      
      private static var _instance:idv.cjcat.stardust.twoD.initializers.Initializer2DPriority;
       
      
      public function Initializer2DPriority()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.twoD.initializers.Initializer2DPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.twoD.initializers.Initializer2DPriority();
         }
         return _instance;
      }
      
      final override protected function populatePriorities() : void
      {
         priorities[DisplayObjectClass] = 1;
         priorities[DisplayObjectParent] = 1;
         priorities[PooledDisplayObjectClass] = 1;
      }
   }
}
