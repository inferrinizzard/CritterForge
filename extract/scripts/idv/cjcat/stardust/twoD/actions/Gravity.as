package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.sd;
   import idv.cjcat.stardust.twoD.fields.Field;
   import idv.cjcat.stardust.twoD.geom.MotionData2D;
   import idv.cjcat.stardust.twoD.geom.MotionData2DPool;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Gravity extends Action2D
   {
       
      
      sd var fields:Array;
      
      private var p2D:Particle2D;
      
      private var md2D:MotionData2D;
      
      private var field:Field;
      
      public function Gravity()
      {
         super();
         this.sd::fields = [];
      }
      
      public function addField(param1:Field) : void
      {
         if(this.sd::fields.indexOf(param1) < 0)
         {
            this.sd::fields.push(param1);
         }
      }
      
      public function removeField(param1:Field) : void
      {
         var _loc2_:int = this.sd::fields.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.sd::fields.splice(_loc2_,1);
         }
      }
      
      public function clearFields() : void
      {
         this.sd::fields = [];
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         this.p2D = Particle2D(param2);
         for each(this.field in this.sd::fields)
         {
            this.md2D = this.field.getMotionData2D(this.p2D);
            if(this.md2D)
            {
               this.p2D.vx += this.md2D.x * param3;
               this.p2D.vy += this.md2D.y * param3;
               MotionData2DPool.recycle(this.md2D);
            }
         }
      }
      
      override public function getRelatedObjects() : Array
      {
         return this.sd::fields;
      }
      
      override public function getXMLTagName() : String
      {
         return "Gravity";
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Field = null;
         var _loc1_:XML = super.toXML();
         if(this.sd::fields.length > 0)
         {
            _loc1_.appendChild(<fields/>);
            for each(_loc2_ in this.sd::fields)
            {
               _loc1_.fields.appendChild(_loc2_.getXMLTag());
            }
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         var _loc3_:XML = null;
         super.parseXML(param1,param2);
         this.clearFields();
         for each(_loc3_ in param1.fields.*)
         {
            this.addField(param2.getElementByName(_loc3_.@name) as Field);
         }
      }
   }
}
