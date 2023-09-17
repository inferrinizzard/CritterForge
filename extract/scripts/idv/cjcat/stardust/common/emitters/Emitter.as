package idv.cjcat.stardust.common.emitters
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.StardustElement;
   import idv.cjcat.stardust.common.actions.Action;
   import idv.cjcat.stardust.common.actions.ActionCollection;
   import idv.cjcat.stardust.common.actions.ActionCollector;
   import idv.cjcat.stardust.common.clocks.Clock;
   import idv.cjcat.stardust.common.clocks.SteadyClock;
   import idv.cjcat.stardust.common.events.EmitterEvent;
   import idv.cjcat.stardust.common.initializers.Initializer;
   import idv.cjcat.stardust.common.initializers.InitializerCollector;
   import idv.cjcat.stardust.common.particles.InfoRecycler;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleArray;
   import idv.cjcat.stardust.common.particles.ParticleCollection;
   import idv.cjcat.stardust.common.particles.ParticleCollectionType;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.common.particles.ParticleList;
   import idv.cjcat.stardust.common.particles.ParticleListIterator;
   import idv.cjcat.stardust.common.particles.ParticleListIteratorPool;
   import idv.cjcat.stardust.common.particles.PooledParticleFactory;
   import idv.cjcat.stardust.common.particles.PooledParticleList;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.sd;
   import idv.cjcat.stardust.threeD.emitters.Emitter3D;
   import idv.cjcat.stardust.twoD.emitters.Emitter2D;
   
   public class Emitter extends StardustElement implements ActionCollector, InitializerCollector
   {
       
      
      private var _clock:Clock;
      
      public var active:Boolean;
      
      public var needsSort:Boolean;
      
      sd var _particles:ParticleCollection;
      
      protected var factory:PooledParticleFactory;
      
      private var _actionCollection:ActionCollection;
      
      public var stepTimeInterval:Number = 1;
      
      private var deadParticles:ParticleCollection;
      
      public function Emitter(param1:Clock = null)
      {
         this.deadParticles = new PooledParticleList();
         super();
         this.needsSort = false;
         this.clock = param1;
         this.active = true;
         this._actionCollection = new ActionCollection();
         this.sd::_particles = new PooledParticleList();
      }
      
      public function get clock() : Clock
      {
         return this._clock;
      }
      
      public function set clock(param1:Clock) : void
      {
         if(!param1)
         {
            param1 = new SteadyClock(0);
         }
         this._clock = param1;
      }
      
      final public function step(param1:Event = null) : void
      {
         var _loc2_:Action = null;
         var _loc3_:Array = null;
         var _loc4_:Particle = null;
         var _loc5_:ParticleIterator = null;
         var _loc6_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:ParticleCollection = null;
         var _loc10_:* = undefined;
         var _loc11_:InfoRecycler = null;
         var _loc7_:Boolean = false;
         if(this.active)
         {
            _loc8_ = this.clock.getTicks(this.stepTimeInterval);
            _loc9_ = this.factory.createParticles(_loc8_);
            this.addParticles(_loc9_);
         }
         _loc3_ = [];
         for each(_loc2_ in this.sd::actions)
         {
            if(_loc2_.active)
            {
               if(_loc2_.mask)
               {
                  _loc3_.push(_loc2_);
               }
            }
         }
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.needsSortedParticles)
            {
               this.particles.sort();
               _loc5_ = this.sd::_particles.getIterator();
               while(_loc4_ = _loc5_.particle)
               {
                  _loc4_.sortedIndexIterator = _loc5_.dump(ParticleListIteratorPool.get());
                  _loc5_.next();
               }
               _loc7_ = true;
               break;
            }
         }
         if(_loc4_ = (_loc5_ = this.particles.getIterator()).particle)
         {
            _loc6_ = true;
            for each(_loc2_ in _loc3_)
            {
               _loc2_.preUpdate(this,this.stepTimeInterval);
               if(_loc2_.mask & _loc4_.mask)
               {
                  _loc2_.update(this,_loc4_,this.stepTimeInterval);
               }
               if(_loc6_ && _loc4_.isDead)
               {
                  this.deadParticles.add(_loc4_);
                  _loc6_ = false;
               }
            }
            if(_loc6_)
            {
               _loc5_.next();
            }
            else
            {
               _loc5_.remove();
            }
         }
         while(_loc4_ = _loc5_.particle)
         {
            _loc6_ = true;
            for each(_loc2_ in _loc3_)
            {
               if(_loc4_.mask & _loc2_.mask)
               {
                  _loc2_.update(this,_loc4_,this.stepTimeInterval);
               }
               if(_loc6_ && _loc4_.isDead)
               {
                  this.deadParticles.add(_loc4_);
                  _loc6_ = false;
               }
            }
            if(_loc6_)
            {
               _loc5_.next();
            }
            else
            {
               _loc5_.remove();
            }
         }
         for each(_loc2_ in _loc3_)
         {
            _loc2_.postUpdate(this,this.stepTimeInterval);
         }
         if(_loc7_)
         {
            _loc5_ = this.sd::_particles.getIterator();
            while(_loc4_ = _loc5_.particle)
            {
               ParticleListIteratorPool.recycle(ParticleListIterator(_loc4_.sortedIndexIterator));
               _loc5_.next();
            }
            _loc5_ = this.deadParticles.getIterator();
            while(_loc4_ = _loc5_.particle)
            {
               ParticleListIteratorPool.recycle(ParticleListIterator(_loc4_.sortedIndexIterator));
               _loc5_.next();
            }
         }
         if(this.deadParticles.size)
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_REMOVED,this.deadParticles));
         }
         _loc5_ = this.deadParticles.getIterator();
         while(_loc4_ = _loc5_.particle)
         {
            for(_loc10_ in _loc4_.recyclers)
            {
               if(_loc11_ = _loc10_ as InfoRecycler)
               {
                  _loc11_.recycleInfo(_loc4_);
               }
            }
            _loc4_.destroy();
            this.factory.recycle(_loc4_);
            _loc5_.next();
         }
         this.deadParticles.clear();
         dispatchEvent(new EmitterEvent(EmitterEvent.STEPPED,this.sd::_particles));
         if(!this.numParticles)
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.EMITTER_EMPTY,null));
         }
      }
      
      final sd function get actions() : Array
      {
         return this._actionCollection.sd::actions;
      }
      
      public function addAction(param1:Action) : void
      {
         this._actionCollection.addAction(param1);
      }
      
      final public function removeAction(param1:Action) : void
      {
         this._actionCollection.removeAction(param1);
      }
      
      final public function clearActions() : void
      {
         this._actionCollection.clearActions();
      }
      
      final sd function get initializers() : Array
      {
         return this.factory.sd::initializerCollection.sd::initializers;
      }
      
      public function addInitializer(param1:Initializer) : void
      {
         this.factory.addInitializer(param1);
      }
      
      final public function removeInitializer(param1:Initializer) : void
      {
         this.factory.removeInitializer(param1);
      }
      
      final public function clearInitializers() : void
      {
         this.factory.clearInitializers();
      }
      
      final public function get numParticles() : int
      {
         return this.sd::_particles.size;
      }
      
      final public function addParticles(param1:ParticleCollection) : void
      {
         var _loc2_:Particle = null;
         var _loc3_:ParticleIterator = param1.getIterator();
         while(_loc2_ = _loc3_.particle)
         {
            this.sd::_particles.add(_loc2_);
            _loc3_.next();
         }
         if(param1.size)
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_ADDED,param1));
         }
      }
      
      final public function clearParticles() : void
      {
         var _loc2_:Particle = null;
         var _loc1_:ParticleCollection = this.sd::_particles;
         this.sd::_particles = new ParticleList();
         if(_loc1_.size)
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_REMOVED,_loc1_));
         }
         var _loc3_:ParticleIterator = this.sd::_particles.getIterator();
         while(_loc2_ = _loc3_.particle)
         {
            _loc2_.destroy();
            this.factory.recycle(_loc2_);
            _loc3_.remove();
         }
      }
      
      public function get particles() : ParticleCollection
      {
         return this.sd::_particles;
      }
      
      public function get particleCollectionType() : int
      {
         if(this.sd::_particles is ParticleList)
         {
            return ParticleCollectionType.LINKED_LIST;
         }
         if(this.sd::_particles is ParticleArray)
         {
            return ParticleCollectionType.ARRAY;
         }
         return -1;
      }
      
      public function set particleCollectionType(param1:int) : void
      {
         var _loc2_:ParticleCollection = null;
         var _loc4_:Particle = null;
         switch(param1)
         {
            case ParticleCollectionType.LINKED_LIST:
               if(this is Emitter2D)
               {
                  _loc2_ = new PooledParticleList(ParticleList.TWO_D);
               }
               else if(this is Emitter3D)
               {
                  _loc2_ = new PooledParticleList(ParticleList.THREE_D);
               }
               break;
            case ParticleCollectionType.ARRAY:
               _loc2_ = new ParticleArray();
         }
         var _loc3_:ParticleIterator = this.sd::_particles.getIterator();
         while(_loc4_ = _loc3_.particle)
         {
            _loc2_.add(_loc4_);
            _loc3_.remove();
         }
         this.sd::_particles = _loc2_;
      }
      
      override public function getRelatedObjects() : Array
      {
         return [this._clock].concat(this.sd::initializers).concat(this.sd::actions);
      }
      
      override public function getXMLTagName() : String
      {
         return "Emitter";
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <emitters/>;
      }
      
      override public function toXML() : XML
      {
         var _loc2_:Action = null;
         var _loc3_:Initializer = null;
         var _loc1_:XML = super.toXML();
         _loc1_.@active = this.active.toString();
         _loc1_.@clock = this._clock.name;
         if(this.sd::actions.length)
         {
            _loc1_.appendChild(<actions/>);
            for each(_loc2_ in this.sd::actions)
            {
               _loc1_.actions.appendChild(_loc2_.getXMLTag());
            }
         }
         if(this.sd::initializers.length)
         {
            _loc1_.appendChild(<initializers/>);
            for each(_loc3_ in this.sd::initializers)
            {
               _loc1_.initializers.appendChild(_loc3_.getXMLTag());
            }
         }
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         var _loc3_:XML = null;
         super.parseXML(param1,param2);
         this._actionCollection.clearActions();
         this.factory.clearInitializers();
         if(param1.@active.length())
         {
            this.active = param1.@active == "true";
         }
         if(param1.@clock.length())
         {
            this.clock = param2.getElementByName(param1.@clock) as Clock;
         }
         for each(_loc3_ in param1.actions.*)
         {
            this.addAction(param2.getElementByName(_loc3_.@name) as Action);
         }
         for each(_loc3_ in param1.initializers.*)
         {
            this.addInitializer(param2.getElementByName(_loc3_.@name) as Initializer);
         }
      }
   }
}
