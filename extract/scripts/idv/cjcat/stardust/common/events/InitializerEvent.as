package idv.cjcat.stardust.common.events
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.initializers.Initializer;
   
   public class InitializerEvent extends Event
   {
      
      public static const PRIORITY_CHANGE:String = "stardustInitializerPriorityChange";
       
      
      private var _initializer:Initializer;
      
      public function InitializerEvent(param1:String, param2:Initializer)
      {
         super(param1);
         this._initializer = param2;
      }
      
      public function get initializer() : Initializer
      {
         return this._initializer;
      }
   }
}
