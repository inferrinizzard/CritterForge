package idv.cjcat.stardust.twoD.actions.triggers
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.deflectors.Deflector;
   
   public class DeflectorTrigger extends ActionTrigger2D
   {
       
      
      public var deflector:Deflector;
      
      public function DeflectorTrigger(param1:Deflector = null)
      {
         super();
         this.deflector = param1;
      }
      
      override public function testTrigger(param1:Emitter, param2:Particle, param3:Number) : Boolean
      {
         return Boolean(param2.dictionary[this.deflector]);
      }
      
      override public function getRelatedObjects() : Array
      {
         return [this.deflector];
      }
      
      override public function getXMLTagName() : String
      {
         return "DeflectorTrigger";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(this.deflector)
         {
            _loc1_.@deflector = this.deflector.name;
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@deflector.length())
         {
            this.deflector = param2.getElementByName(param1.@deflector) as Deflector;
         }
      }
   }
}
