package idv.cjcat.stardust.common.actions.triggers
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   
   public class DeathTrigger extends ActionTrigger
   {
       
      
      public function DeathTrigger()
      {
         super();
      }
      
      override public function testTrigger(param1:Emitter, param2:Particle, param3:Number) : Boolean
      {
         return param2.isDead;
      }
      
      override public function getXMLTagName() : String
      {
         return "DeathTrigger";
      }
   }
}
