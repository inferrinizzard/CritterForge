package idv.cjcat.stardust.common.initializers
{
   import idv.cjcat.stardust.common.math.Random;
   import idv.cjcat.stardust.common.math.UniformRandom;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   
   public class Life extends Initializer
   {
       
      
      private var _random:Random;
      
      public function Life(param1:Random = null)
      {
         super();
         this.random = param1;
      }
      
      override public function initialize(param1:Particle) : void
      {
         param1.initLife = param1.life = this.random.random();
      }
      
      public function get random() : Random
      {
         return this._random;
      }
      
      public function set random(param1:Random) : void
      {
         if(!param1)
         {
            param1 = new UniformRandom(0,0);
         }
         this._random = param1;
      }
      
      override public function getRelatedObjects() : Array
      {
         return [this._random];
      }
      
      override public function getXMLTagName() : String
      {
         return "Life";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@random = this._random.name;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@random.length())
         {
            this.random = param2.getElementByName(param1.@random) as Random;
         }
      }
   }
}
