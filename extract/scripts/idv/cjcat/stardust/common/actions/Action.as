package idv.cjcat.stardust.common.actions
{
   import idv.cjcat.stardust.common.StardustElement;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.events.ActionEvent;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleCollection;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   
   public class Action extends StardustElement
   {
       
      
      public var active:Boolean;
      
      public var skipThisAction:Boolean;
      
      private var _mask:int;
      
      private var _priority:int;
      
      protected var _supports2D:Boolean;
      
      protected var _supports3D:Boolean;
      
      public function Action()
      {
         super();
         this._supports2D = this._supports3D = true;
         this.priority = CommonActionPriority.getInstance().getPriority(Class(Object(this).constructor));
         this.active = true;
         this._mask = 1;
      }
      
      public function get supports2D() : Boolean
      {
         return this._supports2D;
      }
      
      public function get supports3D() : Boolean
      {
         return this._supports3D;
      }
      
      final public function doUpdate(param1:Emitter, param2:ParticleCollection, param3:Number) : void
      {
         var _loc4_:Particle = null;
         var _loc5_:ParticleIterator = null;
         this.skipThisAction = false;
         if(this.active)
         {
            _loc5_ = param2.getIterator();
            while(_loc4_ = _loc5_.particle)
            {
               if(this.mask & _loc4_.mask)
               {
                  this.update(param1,_loc4_,param3);
               }
               if(this.skipThisAction)
               {
                  return;
               }
               _loc5_.next();
            }
         }
      }
      
      public function preUpdate(param1:Emitter, param2:Number) : void
      {
      }
      
      public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
      }
      
      public function postUpdate(param1:Emitter, param2:Number) : void
      {
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
         dispatchEvent(new ActionEvent(ActionEvent.PRIORITY_CHANGE,this));
      }
      
      public function get needsSortedParticles() : Boolean
      {
         return false;
      }
      
      public function get mask() : int
      {
         return this._mask;
      }
      
      public function set mask(param1:int) : void
      {
         this._mask = param1;
      }
      
      override public function getXMLTagName() : String
      {
         return "Action";
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <actions/>;
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@active = this.active;
         _loc1_.@mask = this.mask;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@active.length())
         {
            this.active = param1.@active == "true";
         }
         if(param1.@mask.length())
         {
            this.mask = parseInt(param1.@mask);
         }
      }
   }
}
