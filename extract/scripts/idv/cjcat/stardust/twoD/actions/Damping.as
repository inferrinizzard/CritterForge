package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Damping extends Action2D
   {
       
      
      public var damping:Number;
      
      private var damp:Number;
      
      public function Damping(param1:Number = 0)
      {
         super();
         this.damping = param1;
      }
      
      override public function preUpdate(param1:Emitter, param2:Number) : void
      {
         this.damp = 1;
         if(this.damping)
         {
            this.damp = Math.pow(1 - this.damping,param2);
         }
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc4_:Particle2D = Particle2D(param2);
         _loc4_.vx *= this.damp;
         _loc4_.vy *= this.damp;
      }
      
      override public function getXMLTagName() : String
      {
         return "Damping";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@damping = this.damping;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@damping.length())
         {
            this.damping = parseFloat(param1.@damping);
         }
      }
   }
}
