package idv.cjcat.stardust.common.particles
{
   public class ParticleListIterator implements ParticleIterator
   {
       
      
      internal var node:ParticleNode;
      
      internal var list:ParticleList;
      
      public function ParticleListIterator(param1:ParticleList = null)
      {
         super();
         this.list = param1;
         this.reset();
      }
      
      public function reset() : void
      {
         if(this.list)
         {
            this.node = this.list.head;
         }
      }
      
      public function next() : void
      {
         if(this.node)
         {
            this.node = this.node.next;
         }
      }
      
      public function get particle() : Particle
      {
         if(this.node)
         {
            return this.node.particle;
         }
         return null;
      }
      
      public function remove() : void
      {
         var _loc1_:ParticleNode = null;
         if(this.node)
         {
            if(this.node.prev)
            {
               this.node.prev.next = this.node.next;
            }
            if(this.node.next)
            {
               this.node.next.prev = this.node.prev;
            }
            if(this.node == this.list.head)
            {
               this.list.head = this.node.next;
            }
            if(this.node == this.list.tail)
            {
               this.list.tail = this.node.prev;
            }
            _loc1_ = this.node;
            this.node = this.node.next;
            ParticleNodePool.recycle(_loc1_);
            --this.list.count;
         }
      }
      
      public function clone() : ParticleIterator
      {
         var _loc1_:ParticleListIterator = new ParticleListIterator(this.list);
         _loc1_.node = this.node;
         return _loc1_;
      }
      
      public function dump(param1:ParticleIterator) : ParticleIterator
      {
         var _loc2_:ParticleListIterator = ParticleListIterator(param1);
         if(_loc2_)
         {
            _loc2_.list = this.list;
            _loc2_.node = this.node;
         }
         return param1;
      }
   }
}
