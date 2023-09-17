package idv.cjcat.stardust.common.particles
{
   internal class ParticleNode
   {
       
      
      internal var next:ParticleNode;
      
      internal var prev:ParticleNode;
      
      internal var particle:Particle;
      
      public function ParticleNode(param1:Particle = null)
      {
         super();
         this.particle = param1;
      }
   }
}
