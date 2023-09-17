package idv.cjcat.stardust.twoD.particles
{
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticlePool;
   
   public class Particle2DPool extends ParticlePool
   {
      
      private static var _instance:idv.cjcat.stardust.twoD.particles.Particle2DPool;
       
      
      public function Particle2DPool()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.twoD.particles.Particle2DPool
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.twoD.particles.Particle2DPool();
         }
         return _instance;
      }
      
      override protected function createNewParticle() : Particle
      {
         return new Particle2D();
      }
   }
}
