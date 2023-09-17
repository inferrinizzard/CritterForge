package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.sd;
   import idv.cjcat.stardust.twoD.deflectors.Deflector;
   import idv.cjcat.stardust.twoD.geom.MotionData4D;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Deflect extends Action2D
   {
       
      
      sd var deflectors:Array;
      
      private var p2D:Particle2D;
      
      private var md4D:MotionData4D;
      
      private var deflector:Deflector;
      
      public function Deflect()
      {
         super();
         this.sd::deflectors = [];
      }
      
      public function addDeflector(param1:Deflector) : void
      {
         if(this.sd::deflectors.indexOf(param1) < 0)
         {
            this.sd::deflectors.push(param1);
         }
      }
      
      public function removeDeflector(param1:Deflector) : void
      {
         var _loc2_:int = this.sd::deflectors.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.sd::deflectors.splice(_loc2_,1);
         }
      }
      
      public function clearDeflectors() : void
      {
         this.sd::deflectors = [];
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         this.p2D = Particle2D(param2);
         for each(this.deflector in this.sd::deflectors)
         {
            this.md4D = this.deflector.getMotionData4D(this.p2D);
            if(this.md4D)
            {
               this.p2D.dictionary[this.deflector] = true;
               this.p2D.x = this.md4D.x;
               this.p2D.y = this.md4D.y;
               this.p2D.vx = this.md4D.vx;
               this.p2D.vy = this.md4D.vy;
               this.md4D = null;
            }
            else
            {
               this.p2D.dictionary[this.deflector] = false;
            }
         }
      }
      
      override public function getRelatedObjects() : Array
      {
         return this.sd::deflectors;
      }
      
      override public function getXMLTagName() : String
      {
         return "Deflect";
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Deflector = null;
         var _loc1_:XML = super.toXML();
         if(this.sd::deflectors.length > 0)
         {
            _loc1_.appendChild(<deflectors/>);
            for each(_loc2_ in this.sd::deflectors)
            {
               _loc1_.deflectors.appendChild(_loc2_.getXMLTag());
            }
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         var _loc3_:XML = null;
         super.parseXML(param1,param2);
         this.clearDeflectors();
         for each(_loc3_ in param1.deflectors.*)
         {
            this.addDeflector(param2.getElementByName(_loc3_.@name) as Deflector);
         }
      }
   }
}
