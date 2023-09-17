package idv.cjcat.stardust.common.renderers
{
   import idv.cjcat.stardust.common.StardustElement;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.events.EmitterEvent;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   
   public class Renderer extends StardustElement
   {
       
      
      private var _emitters:Array;
      
      public function Renderer()
      {
         super();
         this._emitters = [];
      }
      
      protected function particlesAdded(param1:EmitterEvent) : void
      {
      }
      
      protected function particlesRemoved(param1:EmitterEvent) : void
      {
      }
      
      protected function render(param1:EmitterEvent) : void
      {
      }
      
      final public function addEmitter(param1:Emitter) : void
      {
         if(this._emitters.indexOf(param1) < 0)
         {
            param1.addEventListener(EmitterEvent.PARTICLES_ADDED,this.particlesAdded);
            param1.addEventListener(EmitterEvent.PARTICLES_REMOVED,this.particlesRemoved);
            param1.addEventListener(EmitterEvent.STEPPED,this.render);
            this._emitters.push(param1);
         }
      }
      
      final public function removeEmitter(param1:Emitter) : void
      {
         var _loc2_:int = this._emitters.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._emitters.splice(_loc2_,1);
            param1.removeEventListener(EmitterEvent.PARTICLES_ADDED,this.particlesAdded);
            param1.removeEventListener(EmitterEvent.PARTICLES_REMOVED,this.particlesRemoved);
            param1.removeEventListener(EmitterEvent.STEPPED,this.render);
         }
      }
      
      final public function clearEmitters() : void
      {
         var _loc1_:Emitter = null;
         for each(_loc1_ in this._emitters)
         {
            this.removeEmitter(_loc1_);
         }
      }
      
      final public function get numParticles() : int
      {
         var _loc2_:Emitter = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._emitters)
         {
            _loc1_ += _loc2_.numParticles;
         }
         return _loc1_;
      }
      
      override public function getRelatedObjects() : Array
      {
         return this._emitters;
      }
      
      override public function getXMLTagName() : String
      {
         return "Renderer";
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <renderers/>;
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Emitter = null;
         var _loc1_:XML = super.toXML();
         if(this._emitters.length > 0)
         {
            _loc1_.appendChild(<emitters/>);
            for each(_loc2_ in this._emitters)
            {
               _loc1_.emitters.appendChild(_loc2_.getXMLTag());
            }
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         var _loc3_:XML = null;
         super.parseXML(param1,param2);
         this.clearEmitters();
         for each(_loc3_ in param1.emitters.*)
         {
            this.addEmitter(param2.getElementByName(_loc3_.@name) as Emitter);
         }
      }
   }
}
