package idv.cjcat.stardust.common.particles
{
   import idv.cjcat.stardust.common.initializers.Initializer;
   import idv.cjcat.stardust.common.initializers.InitializerCollection;
   import idv.cjcat.stardust.common.initializers.InitializerCollector;
   import idv.cjcat.stardust.sd;
   
   public class ParticleFactory implements InitializerCollector
   {
       
      
      sd var initializerCollection:InitializerCollection;
      
      public function ParticleFactory()
      {
         super();
         this.sd::initializerCollection = new InitializerCollection();
      }
      
      final public function createParticles(param1:int) : ParticleList
      {
         var _loc4_:Initializer = null;
         var _loc5_:Particle = null;
         var _loc2_:ParticleList = new ParticleList();
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            (_loc5_ = this.createNewParticle()).init();
            _loc2_.add(_loc5_);
            _loc3_++;
         }
         for each(_loc4_ in this.sd::initializerCollection.sd::initializers)
         {
            _loc4_.doInitialize(_loc2_);
         }
         return _loc2_;
      }
      
      protected function createNewParticle() : Particle
      {
         return new Particle();
      }
      
      public function addInitializer(param1:Initializer) : void
      {
         this.sd::initializerCollection.addInitializer(param1);
      }
      
      final public function removeInitializer(param1:Initializer) : void
      {
         this.sd::initializerCollection.removeInitializer(param1);
      }
      
      final public function clearInitializers() : void
      {
         this.sd::initializerCollection.clearInitializers();
      }
   }
}
