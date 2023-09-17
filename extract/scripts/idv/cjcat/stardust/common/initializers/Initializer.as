package idv.cjcat.stardust.common.initializers
{
   import idv.cjcat.stardust.common.StardustElement;
   import idv.cjcat.stardust.common.events.InitializerEvent;
   import idv.cjcat.stardust.common.particles.InfoRecycler;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleCollection;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   
   public class Initializer extends StardustElement implements InfoRecycler
   {
       
      
      public var active:Boolean;
      
      private var _priority:int;
      
      protected var _supports2D:Boolean;
      
      protected var _supports3D:Boolean;
      
      public function Initializer()
      {
         super();
         this._supports2D = this._supports3D = true;
         this.priority = CommonInitializerPriority.getInstance().getPriority(Object(this).constructor as Class);
         this.active = true;
      }
      
      public function get supports2D() : Boolean
      {
         return this._supports2D;
      }
      
      public function get supports3D() : Boolean
      {
         return this._supports3D;
      }
      
      final public function doInitialize(param1:ParticleCollection) : void
      {
         var _loc2_:Particle = null;
         var _loc3_:ParticleIterator = null;
         if(this.active)
         {
            _loc3_ = param1.getIterator();
            while(_loc2_ = _loc3_.particle)
            {
               this.initialize(_loc2_);
               if(this.needsRecycle())
               {
                  _loc2_.recyclers[this] = this;
               }
               _loc3_.next();
            }
         }
      }
      
      public function initialize(param1:Particle) : void
      {
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
         dispatchEvent(new InitializerEvent(InitializerEvent.PRIORITY_CHANGE,this));
      }
      
      public function recycleInfo(param1:Particle) : void
      {
      }
      
      public function needsRecycle() : Boolean
      {
         return false;
      }
      
      override public function getXMLTagName() : String
      {
         return "Initializer";
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <initializers/>;
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@active = this.active;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@active.length())
         {
            this.active = param1.@active == "true";
         }
      }
   }
}
