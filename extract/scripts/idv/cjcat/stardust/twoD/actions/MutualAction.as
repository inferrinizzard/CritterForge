package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.common.particles.ParticleListIterator;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class MutualAction extends Action2D
   {
       
      
      public var maxDistance:Number;
      
      private var j:ParticleListIterator;
      
      public function MutualAction()
      {
         this.j = new ParticleListIterator();
         super();
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc5_:Particle2D = null;
         var _loc4_:Particle2D = Particle2D(param2);
         var _loc6_:ParticleIterator = param2.sortedIndexIterator;
         while(_loc4_ = Particle2D(_loc6_.particle))
         {
            _loc4_.sortedIndexIterator.dump(this.j);
            this.j.next();
            while(_loc5_ = Particle2D(this.j.particle))
            {
               if(_loc5_.x - _loc4_.x > this.maxDistance)
               {
                  break;
               }
               if(_loc4_.mask & _loc5_.mask)
               {
                  this.doMutualAction(_loc4_,_loc5_,param3);
               }
               this.j.next();
            }
            _loc6_.next();
         }
      }
      
      protected function doMutualAction(param1:Particle2D, param2:Particle2D, param3:Number) : void
      {
      }
      
      final override public function get needsSortedParticles() : Boolean
      {
         return active;
      }
      
      override public function getXMLTagName() : String
      {
         return "MutualAction";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@maxDistance = this.maxDistance;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@maxDistance.length())
         {
            this.maxDistance = parseFloat(param1.@maxDistance);
         }
      }
   }
}
