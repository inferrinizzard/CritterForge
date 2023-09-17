package idv.cjcat.stardust.twoD.renderers
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import idv.cjcat.stardust.common.events.EmitterEvent;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.common.renderers.Renderer;
   import idv.cjcat.stardust.common.xml.XMLBuilder;
   import idv.cjcat.stardust.twoD.display.AddChildMode;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class DisplayObjectRenderer extends Renderer
   {
       
      
      public var addChildMode:int;
      
      public var container:DisplayObjectContainer;
      
      public var forceParentChange:Boolean;
      
      public function DisplayObjectRenderer(param1:DisplayObjectContainer = null, param2:int = 0)
      {
         super();
         this.container = param1;
         this.addChildMode = param2;
         this.forceParentChange = false;
      }
      
      override protected function particlesAdded(param1:EmitterEvent) : void
      {
         var _loc2_:Particle = null;
         var _loc4_:DisplayObject = null;
         if(!this.container)
         {
            return;
         }
         var _loc3_:ParticleIterator = param1.particles.getIterator();
         while(_loc2_ = _loc3_.particle)
         {
            _loc4_ = DisplayObject(_loc2_.target);
            if(!this.forceParentChange)
            {
               if(_loc4_.parent)
               {
                  _loc3_.next();
                  continue;
               }
            }
            switch(this.addChildMode)
            {
               case AddChildMode.RANDOM:
                  this.container.addChildAt(_loc4_,Math.floor(Math.random() * this.container.numChildren));
                  break;
               case AddChildMode.TOP:
                  this.container.addChild(_loc4_);
                  break;
               case AddChildMode.BOTTOM:
                  this.container.addChildAt(_loc4_,0);
                  break;
               default:
                  this.container.addChildAt(_loc4_,Math.floor(Math.random() * this.container.numChildren));
            }
            _loc3_.next();
         }
      }
      
      override protected function particlesRemoved(param1:EmitterEvent) : void
      {
         var _loc2_:Particle = null;
         var _loc4_:DisplayObject = null;
         var _loc3_:ParticleIterator = param1.particles.getIterator();
         while(_loc2_ = _loc3_.particle)
         {
            if((_loc4_ = DisplayObject(_loc2_.target)).parent)
            {
               DisplayObjectContainer(_loc4_.parent).removeChild(_loc4_);
            }
            _loc3_.next();
         }
      }
      
      override protected function render(param1:EmitterEvent) : void
      {
         var _loc2_:Particle2D = null;
         var _loc4_:DisplayObject = null;
         var _loc3_:ParticleIterator = param1.particles.getIterator();
         while(_loc2_ = Particle2D(_loc3_.particle))
         {
            (_loc4_ = DisplayObject(_loc2_.target)).x = _loc2_.x;
            _loc4_.y = _loc2_.y;
            _loc4_.rotation = _loc2_.rotation;
            _loc4_.scaleX = _loc4_.scaleY = _loc2_.scale;
            _loc4_.alpha = _loc2_.alpha;
            _loc4_.transform.colorTransform = _loc2_.colorTransform;
            _loc3_.next();
         }
      }
      
      override public function getXMLTagName() : String
      {
         return "DisplayObjectRenderer";
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@addChildMode = this.addChildMode;
         _loc1_.@forceParentChange = this.forceParentChange;
         return _loc1_;
      }
      
      override public function parseXML(param1:XML, param2:XMLBuilder = null) : void
      {
         super.parseXML(param1,param2);
         if(param1.@addChildMode.length())
         {
            this.addChildMode = parseInt(param1.@addChildMode);
         }
         if(param1.@forceParentChange.length())
         {
            this.forceParentChange = param1.@forceParentChange == "true";
         }
      }
   }
}
