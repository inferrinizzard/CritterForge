package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   import idv.cjcat.stardust.twoD.zones.Zone;
   
   public class DeathZone extends Action2D
   {
       
      
      public var zone:Zone;
      
      public var inverted:Boolean;
      
      public function DeathZone(param1:Zone = null, param2:Boolean = false)
      {
         super();
         this.zone = param1;
         this.inverted = param2;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         if(!this.zone)
         {
            return;
         }
         var _loc4_:Particle2D = Particle2D(param2);
         var _loc5_:* = this.zone.contains(_loc4_.x,_loc4_.y);
         if(this.inverted)
         {
            _loc5_ = !_loc5_;
         }
         if(_loc5_)
         {
            param2.isDead = true;
         }
      }
      
      override public function getRelatedObjects() : Array
      {
         if(!this.zone)
         {
            return [];
         }
         return [this.zone];
      }
      
      override public function getXMLTagName() : String
      {
         return "DeathZone";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(!this.zone)
         {
            _loc1_.@zone = "null";
         }
         else
         {
            _loc1_.@zone = this.zone.name;
         }
         _loc1_.@inverted = this.inverted;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@zone == "null")
         {
            this.zone = null;
         }
         else if(param1.@zone.length())
         {
            this.zone = param2.getElementByName(param1.@zone) as Zone;
         }
         if(param1.@inverted.length())
         {
            this.inverted = param1.@inverted == "true";
         }
      }
   }
}
