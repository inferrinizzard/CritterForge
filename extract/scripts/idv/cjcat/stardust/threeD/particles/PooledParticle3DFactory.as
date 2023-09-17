package idv.cjcat.stardust.threeD.particles
{
   import idv.cjcat.stardust.common.particles.PooledParticleFactory;
   
   public class PooledParticle3DFactory extends PooledParticleFactory
   {
       
      
      public function PooledParticle3DFactory()
      {
         super();
         particlePool = Particle3DPool.getInstance();
      }
   }
}
