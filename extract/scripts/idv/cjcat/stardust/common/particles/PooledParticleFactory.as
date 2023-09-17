package idv.cjcat.stardust.common.particles
{
   public class PooledParticleFactory extends ParticleFactory
   {
       
      
      protected var particlePool:idv.cjcat.stardust.common.particles.ParticlePool;
      
      public function PooledParticleFactory()
      {
         super();
         this.particlePool = idv.cjcat.stardust.common.particles.ParticlePool.getInstance();
      }
      
      override protected function createNewParticle() : Particle
      {
         return this.particlePool.get();
      }
      
      public function recycle(param1:Particle) : void
      {
         this.particlePool.recycle(param1);
      }
   }
}
