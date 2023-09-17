package idv.cjcat.stardust.common.particles
{
   public class ParticleArrayIterator implements ParticleIterator
   {
       
      
      internal var index:int;
      
      internal var array:ParticleArray;
      
      public function ParticleArrayIterator(param1:ParticleArray)
      {
         super();
         this.array = param1;
         this.reset();
      }
      
      public function reset() : void
      {
         if(this.array)
         {
            this.index = 0;
         }
      }
      
      public function next() : void
      {
         if(this.index < this.array.array.length)
         {
            ++this.index;
         }
      }
      
      public function get particle() : Particle
      {
         if(this.index == this.array.array.length)
         {
            return null;
         }
         return this.array.array[this.index];
      }
      
      public function remove() : void
      {
         if(this.array.array[this.index])
         {
            this.array.array.splice(this.index,1);
         }
      }
      
      public function clone() : ParticleIterator
      {
         var _loc1_:ParticleArrayIterator = new ParticleArrayIterator(this.array);
         _loc1_.index = this.index;
         return _loc1_;
      }
      
      public function dump(param1:ParticleIterator) : ParticleIterator
      {
         var _loc2_:ParticleArrayIterator = ParticleArrayIterator(param1);
         if(_loc2_)
         {
            _loc2_.array = this.array;
            _loc2_.index = this.index;
         }
         return param1;
      }
   }
}
