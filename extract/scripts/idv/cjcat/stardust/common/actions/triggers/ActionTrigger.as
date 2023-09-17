package idv.cjcat.stardust.common.actions.triggers
{
   import idv.cjcat.stardust.common.actions.Action;
   import idv.cjcat.stardust.common.actions.CompositeAction;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.sd;
   
   public class ActionTrigger extends CompositeAction
   {
       
      
      public var inverted:Boolean;
      
      public function ActionTrigger(param1:Boolean = false)
      {
         super();
         this.inverted = param1;
      }
      
      public function testTrigger(param1:Emitter, param2:Particle, param3:Number) : Boolean
      {
         return false;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc6_:Action = null;
         var _loc4_:Array = sd::actionCollection.sd::actions;
         var _loc5_:* = this.testTrigger(param1,param2,param3);
         if(this.inverted)
         {
            _loc5_ = !_loc5_;
         }
         if(_loc5_)
         {
            for each(_loc6_ in _loc4_)
            {
               _loc6_.update(param1,param2,param3);
            }
         }
      }
      
      override public function getXMLTagName() : String
      {
         return "ActionTrigger";
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <triggers/>;
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(_loc1_.@inverted.length())
         {
            _loc1_.@inverted = this.inverted;
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         this.inverted = param1.@inverted == "true";
      }
   }
}
