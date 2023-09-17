package idv.cjcat.stardust.common.particles
{
   public class ParticleListIteratorPool
   {
      
      private static var _vec:Array = [new ParticleListIterator()];
      
      private static var _position:int = 0;
       
      
      public function ParticleListIteratorPool()
      {
         super();
      }
      
      public static function get() : ParticleListIterator
      {
         var _loc2_:int = 0;
         if(_position == _vec.length)
         {
            _vec.length <<= 1;
            _loc2_ = _position;
            while(_loc2_ < _vec.length)
            {
               _vec[_loc2_] = new ParticleListIterator();
               _loc2_++;
            }
         }
         ++_position;
         return _vec[_position - 1];
      }
      
      public static function recycle(param1:ParticleListIterator) : void
      {
         if(_position == 0)
         {
            return;
         }
         param1.list = null;
         param1.node = null;
         _vec[_position - 1] = param1;
         if(_position)
         {
            --_position;
         }
      }
   }
}
