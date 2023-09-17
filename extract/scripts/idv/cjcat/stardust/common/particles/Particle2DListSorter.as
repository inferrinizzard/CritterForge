package idv.cjcat.stardust.common.particles
{
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   internal class Particle2DListSorter extends ParticleListSorter
   {
      
      private static var _instance:Particle2DListSorter;
       
      
      public function Particle2DListSorter()
      {
         super();
      }
      
      public static function getInstance() : Particle2DListSorter
      {
         if(!_instance)
         {
            _instance = new Particle2DListSorter();
         }
         return _instance;
      }
      
      override public function sort(param1:ParticleList) : void
      {
         param1.head = this.mergeSort(param1.head);
      }
      
      private function mergeSort(param1:ParticleNode) : ParticleNode
      {
         var _loc3_:ParticleNode = null;
         var _loc4_:ParticleNode = null;
         var _loc5_:ParticleNode = null;
         var _loc6_:ParticleNode = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(!param1)
         {
            return null;
         }
         var _loc2_:ParticleNode = param1;
         var _loc7_:* = 1;
         while(true)
         {
            _loc3_ = _loc2_;
            _loc2_ = _loc6_ = null;
            _loc8_ = 0;
            while(_loc3_)
            {
               _loc8_++;
               _loc11_ = 0;
               _loc9_ = 0;
               _loc4_ = _loc3_;
               while(_loc11_ < _loc7_)
               {
                  _loc9_++;
                  if(!(_loc4_ = _loc4_.next))
                  {
                     break;
                  }
                  _loc11_++;
               }
               _loc10_ = _loc7_;
               while(_loc9_ > 0 || _loc10_ > 0 && _loc4_)
               {
                  if(_loc9_ == 0)
                  {
                     _loc5_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else if(_loc10_ == 0 || !_loc4_)
                  {
                     _loc5_ = _loc3_;
                     _loc3_ = _loc3_.next;
                     _loc9_--;
                  }
                  else if(Particle2D(_loc3_.particle).x - Particle2D(_loc4_.particle).x <= 0)
                  {
                     _loc5_ = _loc3_;
                     _loc3_ = _loc3_.next;
                     _loc9_--;
                  }
                  else
                  {
                     _loc5_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  if(_loc6_)
                  {
                     _loc6_.next = _loc5_;
                  }
                  else
                  {
                     _loc2_ = _loc5_;
                  }
                  _loc5_.prev = _loc6_;
                  _loc6_ = _loc5_;
               }
               _loc3_ = _loc4_;
            }
            param1.prev = _loc6_;
            _loc6_.next = null;
            if(_loc8_ <= 1)
            {
               break;
            }
            _loc7_ <<= 1;
         }
         _loc2_.prev = null;
         return _loc2_;
      }
   }
}
