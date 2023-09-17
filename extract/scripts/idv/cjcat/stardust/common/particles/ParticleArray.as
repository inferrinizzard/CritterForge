package idv.cjcat.stardust.common.particles
{
   public class ParticleArray implements ParticleCollection
   {
       
      
      internal var array:Array;
      
      public function ParticleArray()
      {
         this.array = [];
         super();
      }
      
      public function add(param1:Particle) : void
      {
         this.array.push(param1);
      }
      
      public function getIterator() : ParticleIterator
      {
         return new ParticleArrayIterator(this);
      }
      
      public function sort() : void
      {
         this.array.sortOn("x",Array.NUMERIC);
      }
      
      public function get size() : int
      {
         return this.array.length;
      }
      
      public function clear() : void
      {
         this.array = [];
      }
   }
}
