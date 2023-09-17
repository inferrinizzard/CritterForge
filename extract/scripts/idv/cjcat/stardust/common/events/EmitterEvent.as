package idv.cjcat.stardust.common.events
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.particles.ParticleCollection;
   
   public class EmitterEvent extends Event
   {
      
      public static const EMITTER_EMPTY:String = "stardustEmitterEmpty";
      
      public static const PARTICLES_ADDED:String = "stardustEmitterParticleAdded";
      
      public static const PARTICLES_REMOVED:String = "stardustEmitterParticleRemoved";
      
      public static const STEPPED:String = "stardustEmitterStepped";
       
      
      private var _particles:ParticleCollection;
      
      public function EmitterEvent(param1:String, param2:ParticleCollection)
      {
         super(param1);
         this._particles = param2;
      }
      
      public function get particles() : ParticleCollection
      {
         return this._particles;
      }
   }
}
