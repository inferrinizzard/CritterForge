package idv.cjcat.stardust.common.particles
{
   public class PooledParticleList extends ParticleList
   {
       
      
      public function PooledParticleList(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createNode(param1:Particle) : ParticleNode
      {
         return ParticleNodePool.get(param1);
      }
   }
}
