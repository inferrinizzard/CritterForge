package idv.cjcat.stardust.twoD.emitters
{
   import flash.errors.IllegalOperationError;
   import flash.utils.getQualifiedClassName;
   import idv.cjcat.stardust.common.actions.Action;
   import idv.cjcat.stardust.common.clocks.Clock;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.initializers.Initializer;
   import idv.cjcat.stardust.common.particles.ParticleList;
   import idv.cjcat.stardust.common.particles.PooledParticleList;
   import idv.cjcat.stardust.sd;
   import idv.cjcat.stardust.twoD.particles.PooledParticle2DFactory;
   
   public class Emitter2D extends Emitter
   {
       
      
      public function Emitter2D(param1:Clock = null)
      {
         super(param1);
         factory = new PooledParticle2DFactory();
         sd::_particles = new PooledParticleList(ParticleList.TWO_D);
      }
      
      final override public function addAction(param1:Action) : void
      {
         if(!param1.supports2D)
         {
            throw new IllegalOperationError("This action does not support 2D: " + getQualifiedClassName(Object(param1).constructor as Class));
         }
         super.addAction(param1);
      }
      
      final override public function addInitializer(param1:Initializer) : void
      {
         if(!param1.supports2D)
         {
            throw new IllegalOperationError("This initializer does not support 2D: " + getQualifiedClassName(Object(param1).constructor as Class));
         }
         super.addInitializer(param1);
      }
      
      override public function getXMLTagName() : String
      {
         return "Emitter2D";
      }
   }
}
