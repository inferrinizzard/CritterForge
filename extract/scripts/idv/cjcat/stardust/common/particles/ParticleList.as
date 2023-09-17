package idv.cjcat.stardust.common.particles
{
   import idv.cjcat.stardust.sd;
   
   public class ParticleList implements ParticleCollection
   {
      
      public static const TWO_D:Boolean = true;
      
      public static const THREE_D:Boolean = false;
       
      
      sd var sorter:ParticleListSorter;
      
      internal var count:int;
      
      internal var head:ParticleNode;
      
      internal var tail:ParticleNode;
      
      private var node:ParticleNode;
      
      public function ParticleList(param1:Boolean = true)
      {
         super();
         this.head = this.tail = null;
         this.count = 0;
         if(param1)
         {
            this.sd::sorter = Particle2DListSorter.getInstance();
         }
         else
         {
            this.sd::sorter = Particle3DListSorter.getInstance();
         }
      }
      
      public function add(param1:Particle) : void
      {
         this.node = this.createNode(param1);
         if(this.head)
         {
            this.tail.next = this.node;
            this.node.prev = this.tail;
            this.tail = this.node;
         }
         else
         {
            this.head = this.tail = this.node;
         }
         ++this.count;
      }
      
      protected function createNode(param1:Particle) : ParticleNode
      {
         return new ParticleNode(param1);
      }
      
      public function clear() : void
      {
         var _loc1_:ParticleNode = null;
         var _loc2_:ParticleListIterator = ParticleListIterator(this.getIterator());
         while(_loc1_ = _loc2_.node)
         {
            ParticleNodePool.recycle(_loc1_);
            _loc2_.next();
         }
         this.head = this.tail = null;
         this.count = 0;
      }
      
      public function getIterator() : ParticleIterator
      {
         return new ParticleListIterator(this);
      }
      
      public function get size() : int
      {
         return this.count;
      }
      
      public function isEmpty() : Boolean
      {
         return this.count == 0;
      }
      
      public function sort() : void
      {
         this.sd::sorter.sort(this);
      }
   }
}
