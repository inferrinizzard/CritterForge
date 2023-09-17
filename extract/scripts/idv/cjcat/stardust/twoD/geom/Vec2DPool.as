package idv.cjcat.stardust.twoD.geom
{
   public class Vec2DPool
   {
      
      private static var _vec:Array = [new Vec2D()];
      
      private static var _position:int = 0;
       
      
      public function Vec2DPool()
      {
         super();
      }
      
      public static function get(param1:Number = 0, param2:Number = 0) : Vec2D
      {
         var _loc4_:int = 0;
         if(_position == _vec.length)
         {
            _vec.length <<= 1;
            _loc4_ = _position;
            while(_loc4_ < _vec.length)
            {
               _vec[_loc4_] = new Vec2D();
               _loc4_++;
            }
         }
         ++_position;
         var _loc3_:Vec2D = _vec[_position - 1];
         _loc3_.x = param1;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      public static function recycle(param1:Vec2D) : void
      {
         if(_position == 0)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         _vec[_position - 1] = param1;
         if(_position)
         {
            --_position;
         }
      }
   }
}
