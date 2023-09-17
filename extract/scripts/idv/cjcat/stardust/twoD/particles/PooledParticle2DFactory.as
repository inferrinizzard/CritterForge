package idv.cjcat.stardust.twoD.particles
{
   import idv.cjcat.stardust.common.particles.PooledParticleFactory;
   
   public class PooledParticle2DFactory extends PooledParticleFactory
   {
       
      
      public function PooledParticle2DFactory()
      {
         super();
         particlePool = Particle2DPool.getInstance();
      }
   }
}
