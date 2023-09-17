package idv.cjcat.stardust.common.particles
{
   internal class ParticleListSorter
   {
      
      private static var _instance:ParticleListSorter;
       
      
      public function ParticleListSorter()
      {
         super();
      }
      
      public static function getInstane() : ParticleListSorter
      {
         if(!_instance)
         {
            _instance = new ParticleListSorter();
         }
         return _instance;
      }
      
      public function sort(param1:ParticleList) : void
      {
      }
   }
}
