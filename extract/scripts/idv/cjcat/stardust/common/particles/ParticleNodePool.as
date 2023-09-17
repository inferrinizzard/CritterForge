package idv.cjcat.stardust.common.particles
{
   internal class ParticleNodePool
   {
      
      private static var _vec:Array = [new ParticleNode()];
      
      private static var _position:int = 0;
       
      
      public function ParticleNodePool()
      {
         super();
      }
      
      public static function get(param1:Particle) : ParticleNode
      {
         var _loc3_:int = 0;
         if(_position == _vec.length)
         {
            _vec.length <<= 1;
            _loc3_ = _position;
            while(_loc3_ < _vec.length)
            {
               _vec[_loc3_] = new ParticleNode();
               _loc3_++;
            }
         }
         ++_position;
         var _loc2_:ParticleNode = _vec[_position - 1];
         _loc2_.particle = param1;
         return _loc2_;
      }
      
      public static function recycle(param1:ParticleNode) : void
      {
         if(_position == 0)
         {
            return;
         }
         param1.particle = null;
         param1.next = param1.prev = null;
         _vec[_position - 1] = param1;
         if(_position)
         {
            --_position;
         }
      }
   }
}
