package idv.cjcat.stardust.twoD.events
{
   import flash.events.Event;
   import idv.cjcat.stardust.twoD.geom.Vec2D;
   
   public class Vec2DEvent extends Event
   {
      
      public static const CHANGE:String = "stardustVec2DChange";
       
      
      private var _vec:Vec2D;
      
      public function Vec2DEvent(param1:String, param2:Vec2D)
      {
         super(param1);
         this._vec = param2;
      }
      
      public function get vec() : Vec2D
      {
         return this._vec;
      }
   }
}
