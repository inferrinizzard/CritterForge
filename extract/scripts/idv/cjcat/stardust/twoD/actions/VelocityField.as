package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.fields.Field;
   import idv.cjcat.stardust.twoD.geom.MotionData2D;
   import idv.cjcat.stardust.twoD.geom.MotionData2DPool;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class VelocityField extends Action2D
   {
       
      
      public var field:Field;
      
      public function VelocityField(param1:Field = null)
      {
         super();
         this.field = param1;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc5_:MotionData2D = null;
         if(!this.field)
         {
            return;
         }
         var _loc4_:Particle2D = Particle2D(param2);
         _loc5_ = this.field.getMotionData2D(_loc4_);
         _loc4_.vx = _loc5_.x;
         _loc4_.vy = _loc5_.y;
         MotionData2DPool.recycle(_loc5_);
      }
      
      override public function getRelatedObjects() : Array
      {
         if(this.field != null)
         {
            return [this.field];
         }
         return [];
      }
      
      override public function getXMLTagName() : String
      {
         return "VelocityField";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(!this.field)
         {
            _loc1_.@field = "null";
         }
         else
         {
            _loc1_.@field = this.field.name;
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@field == "null")
         {
            this.field = null;
         }
         else if(param1.@field.length())
         {
            this.field = param2.getElementByName(param1.@field) as Field;
         }
      }
   }
}
