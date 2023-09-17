package idv.cjcat.stardust.common.particles
{
   public interface ParticleIterator
   {
       
      
      function get particle() : Particle;
      
      function reset() : void;
      
      function next() : void;
      
      function clone() : ParticleIterator;
      
      function dump(param1:ParticleIterator) : ParticleIterator;
      
      function remove() : void;
   }
}
