package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Move extends Action2D
   {
       
      
      public var multiplier:Number;
      
      private var p2D:Particle2D;
      
      private var factor:Number;
      
      public function Move(param1:Number = 1)
      {
         super();
         this.multiplier = param1;
      }
      
      override public function preUpdate(param1:Emitter, param2:Number) : void
      {
         this.factor = param2 * this.multiplier;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         this.p2D = Particle2D(param2);
         this.p2D.x += this.p2D.vx * this.factor;
         this.p2D.y += this.p2D.vy * this.factor;
      }
      
      override public function getXMLTagName() : String
      {
         return "Move";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@multiplier = this.multiplier;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@multiplier.length())
         {
            this.multiplier = parseFloat(param1.@multiplier);
         }
      }
   }
}
