package idv.cjcat.stardust.twoD.initializers
{
   import flash.display.DisplayObject;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.twoD.display.IStardustSprite;
   import idv.cjcat.stardust.twoD.utils.DisplayObjectPool;
   
   public class PooledDisplayObjectClass extends Initializer2D
   {
       
      
      private var _constructorParams:Array;
      
      private var _pool:DisplayObjectPool;
      
      private var _displayObjectClass:Class;
      
      public function PooledDisplayObjectClass(param1:Class = null, param2:Array = null)
      {
         super();
         this._pool = new DisplayObjectPool();
         this.displayObjectClass = param1;
         this.constructorParams = param2;
      }
      
      override public function initialize(param1:Particle) : void
      {
         if(!this.displayObjectClass)
         {
            return;
         }
         param1.target = this._pool.get();
      }
      
      public function get displayObjectClass() : Class
      {
         return this._displayObjectClass;
      }
      
      public function set displayObjectClass(param1:Class) : void
      {
         this._displayObjectClass = param1;
         this._pool.reset(this._displayObjectClass,this._constructorParams);
      }
      
      public function get constructorParams() : Array
      {
         return this._constructorParams;
      }
      
      public function set constructorParams(param1:Array) : void
      {
         this._constructorParams = param1;
         this._pool.reset(this._displayObjectClass,this._constructorParams);
      }
      
      override public function recycleInfo(param1:Particle) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(_loc2_)
         {
            if(_loc2_ is IStardustSprite)
            {
               IStardustSprite(_loc2_).disable();
            }
            if(_loc2_ is this._displayObjectClass)
            {
               this._pool.recycle(_loc2_);
            }
         }
      }
      
      override public function needsRecycle() : Boolean
      {
         return true;
      }
      
      override public function getXMLTagName() : String
      {
         return "PooledDisplayObjectClass";
      }
   }
}
