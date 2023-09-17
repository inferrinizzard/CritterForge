package idv.cjcat.stardust.common.particles
{
   import idv.cjcat.stardust.sd;
   
   public class ParticlePool
   {
      
      private static var _instance:idv.cjcat.stardust.common.particles.ParticlePool;
       
      
      sd var particleClass:Class;
      
      private var _array:Array;
      
      private var _position:int;
      
      public function ParticlePool()
      {
         super();
         this._array = [this.createNewParticle()];
         this._position = 0;
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.particles.ParticlePool
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.common.particles.ParticlePool();
         }
         return _instance;
      }
      
      protected function createNewParticle() : Particle
      {
         return new Particle();
      }
      
      final public function get() : Particle
      {
         var _loc1_:int = 0;
         if(this._position == this._array.length)
         {
            this._array.length <<= 1;
            _loc1_ = this._position;
            while(_loc1_ < this._array.length)
            {
               this._array[_loc1_] = this.createNewParticle();
               _loc1_++;
            }
         }
         ++this._position;
         return this._array[this._position - 1];
      }
      
      final public function recycle(param1:Particle) : void
      {
         if(this._position == 0)
         {
            return;
         }
         this._array[this._position - 1] = param1;
         if(this._position)
         {
            --this._position;
         }
      }
   }
}
