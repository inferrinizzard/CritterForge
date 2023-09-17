package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.common.particles.ParticleCollection;
   import idv.cjcat.stardust.common.particles.ParticleIterator;
   import idv.cjcat.stardust.twoD.geom.Vec2D;
   import idv.cjcat.stardust.twoD.geom.Vec2DPool;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Collide extends MutualAction
   {
       
      
      public function Collide()
      {
         super();
         maxDistance = 0;
      }
      
      override public function preUpdate(param1:Emitter, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Particle = null;
         var _loc3_:ParticleCollection = param1.particles;
         if(_loc3_.size <= 1)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc8_:ParticleIterator = _loc3_.getIterator();
         while(_loc7_ = _loc8_.particle)
         {
            if((_loc6_ = _loc7_.collisionRadius * _loc7_.scale) > _loc4_)
            {
               _loc5_ = _loc4_;
               _loc4_ = _loc6_;
            }
            else if(_loc6_ > _loc5_)
            {
               _loc5_ = _loc6_;
            }
            _loc8_.next();
         }
         maxDistance = _loc4_ + _loc5_;
      }
      
      override protected function doMutualAction(param1:Particle2D, param2:Particle2D, param3:Number) : void
      {
         var _loc4_:Number = param1.x - param2.x;
         var _loc5_:Number = param1.y - param2.y;
         var _loc6_:Number = param1.collisionRadius * param1.scale;
         var _loc7_:Number = param2.collisionRadius * param2.scale;
         var _loc8_:Number = _loc6_ + _loc7_;
         if(_loc4_ * _loc4_ + _loc5_ * _loc5_ > _loc8_ * _loc8_)
         {
            return;
         }
         var _loc9_:Vec2D = Vec2DPool.get(_loc4_,_loc5_);
         var _loc10_:Number = 1 / _loc8_;
         var _loc11_:Number = (param1.x * _loc7_ + param2.x * _loc6_) * _loc10_;
         var _loc12_:Number = (param1.y * _loc7_ + param2.y * _loc6_) * _loc10_;
         _loc9_.length = _loc6_;
         param1.x = _loc11_ + _loc9_.x;
         param1.y = _loc12_ + _loc9_.y;
         _loc9_.length = _loc7_;
         param2.x = _loc11_ - _loc9_.x;
         param2.y = _loc12_ - _loc9_.y;
         var _loc13_:Number = param1.mass * param1.scale;
         var _loc14_:Number = param2.mass * param2.scale;
         var _loc15_:Number = 1 / (_loc13_ + _loc14_);
         var _loc16_:Vec2D = Vec2DPool.get(param1.vx,param1.vy);
         var _loc17_:Vec2D = Vec2DPool.get(param2.vx,param2.vy);
         _loc16_.projectThis(_loc9_);
         _loc17_.projectThis(_loc9_);
         var _loc18_:Vec2D = Vec2DPool.get(param1.vx - _loc16_.x,param1.vy - _loc16_.y);
         var _loc19_:Vec2D = Vec2DPool.get(param2.vx - _loc17_.x,param2.vy - _loc17_.y);
         var _loc20_:Vec2D = Vec2DPool.get(_loc16_.x - _loc17_.x,_loc16_.y - _loc17_.y);
         var _loc21_:Number = _loc13_ - _loc14_;
         _loc16_.x = (_loc21_ * _loc16_.x + 2 * _loc14_ * _loc17_.x) * _loc15_;
         _loc16_.y = (_loc21_ * _loc16_.y + 2 * _loc14_ * _loc17_.y) * _loc15_;
         _loc17_.x = _loc20_.x + _loc16_.x;
         _loc17_.y = _loc20_.y + _loc16_.y;
         param1.vx = _loc16_.x + _loc18_.x;
         param1.vy = _loc16_.y + _loc18_.y;
         param2.vx = _loc17_.x + _loc19_.x;
         param2.vy = _loc17_.y + _loc19_.y;
         Vec2DPool.recycle(_loc9_);
         Vec2DPool.recycle(_loc16_);
         Vec2DPool.recycle(_loc17_);
         Vec2DPool.recycle(_loc18_);
         Vec2DPool.recycle(_loc19_);
         Vec2DPool.recycle(_loc20_);
      }
      
      override public function getXMLTagName() : String
      {
         return "Collide";
      }
   }
}
