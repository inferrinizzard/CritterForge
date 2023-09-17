package idv.cjcat.stardust.common.particles
{
   public interface ParticleCollection
   {
       
      
      function add(param1:Particle) : void;
      
      function clear() : void;
      
      function getIterator() : ParticleIterator;
      
      function sort() : void;
      
      function get size() : int;
   }
}
