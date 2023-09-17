package idv.cjcat.stardust.twoD.geom
{
   import flash.events.EventDispatcher;
   import idv.cjcat.stardust.common.math.StardustMath;
   import idv.cjcat.stardust.twoD.events.Vec2DEvent;
   
   public class Vec2D extends EventDispatcher
   {
       
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function Vec2D(param1:Number = 0, param2:Number = 0)
      {
         super();
         this._x = param1;
         this._y = param2;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      public function clone() : Vec2D
      {
         return new Vec2D(this._x,this._y);
      }
      
      public function dot(param1:Vec2D) : Number
      {
         return this._x * param1._x + this._y * param1._y;
      }
      
      public function project(param1:Vec2D) : Vec2D
      {
         var _loc2_:Vec2D = this.clone();
         _loc2_.projectThis(param1);
         return _loc2_;
      }
      
      public function projectThis(param1:Vec2D) : void
      {
         var _loc2_:Vec2D = Vec2DPool.get(param1._x,param1._y);
         _loc2_.length = 1;
         _loc2_.length = this.dot(_loc2_);
         this._x = _loc2_._x;
         this._y = _loc2_._y;
         Vec2DPool.recycle(_loc2_);
      }
      
      public function rotate(param1:Number, param2:Boolean = false) : Vec2D
      {
         var _loc3_:Vec2D = new Vec2D(this._x,this._y);
         _loc3_.rotateThis(param1,param2);
         return _loc3_;
      }
      
      public function rotateThis(param1:Number, param2:Boolean = false) : void
      {
         if(!param2)
         {
            param1 *= StardustMath.DEGREE_TO_RADIAN;
         }
         var _loc3_:Number = this._x;
         this._x = _loc3_ * Math.cos(param1) - this._y * Math.sin(param1);
         this._y = _loc3_ * Math.sin(param1) + this._y * Math.cos(param1);
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      public function unitVec() : Vec2D
      {
         if(this.length == 0)
         {
            return new Vec2D();
         }
         var _loc1_:Number = 1 / this.length;
         return new Vec2D(this._x * _loc1_,this._y * _loc1_);
      }
      
      public function get length() : Number
      {
         return Math.sqrt(this._x * this._x + this._y * this._y);
      }
      
      public function set length(param1:Number) : void
      {
         if(this._x == 0 && this._y == 0)
         {
            return;
         }
         var _loc2_:Number = param1 / this.length;
         this._x *= _loc2_;
         this._y *= _loc2_;
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      public function set(param1:Number, param2:Number) : void
      {
         this._x = param1;
         this._y = param2;
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      public function get angle() : Number
      {
         return Math.atan2(this._y,this._x) * StardustMath.RADIAN_TO_DEGREE;
      }
      
      public function set angle(param1:Number) : void
      {
         var _loc2_:Number = this.length;
         var _loc3_:Number = param1 * StardustMath.DEGREE_TO_RADIAN;
         this._x = _loc2_ * Math.cos(_loc3_);
         this._y = _loc2_ * Math.sin(_loc3_);
         dispatchEvent(new Vec2DEvent(Vec2DEvent.CHANGE,this));
      }
      
      override public function toString() : String
      {
         return "[Vec2D" + " x=" + this._x + " y=" + this._y + "]";
      }
   }
}
