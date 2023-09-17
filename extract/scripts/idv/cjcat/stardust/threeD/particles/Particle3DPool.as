package idv.cjcat.stardust.threeD.particles
{
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticlePool;
   
   public class Particle3DPool extends ParticlePool
   {
      
      private static var _instance:idv.cjcat.stardust.threeD.particles.Particle3DPool;
       
      
      public function Particle3DPool()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.threeD.particles.Particle3DPool
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.threeD.particles.Particle3DPool();
         }
         return _instance;
      }
      
      override protected function createNewParticle() : Particle
      {
         return new Particle3D();
      }
   }
}
