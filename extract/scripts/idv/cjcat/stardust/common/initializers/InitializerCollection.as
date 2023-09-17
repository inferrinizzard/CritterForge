package idv.cjcat.stardust.common.initializers
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.events.InitializerEvent;
   import idv.cjcat.stardust.sd;
   
   public class InitializerCollection implements InitializerCollector
   {
       
      
      sd var initializers:Array;
      
      public function InitializerCollection()
      {
         super();
         this.sd::initializers = [];
      }
      
      final public function addInitializer(param1:Initializer) : void
      {
         if(this.sd::initializers.indexOf(param1) < 0)
         {
            this.sd::initializers.push(param1);
         }
         param1.addEventListener(InitializerEvent.PRIORITY_CHANGE,this.sortInitializers);
         this.sortInitializers();
      }
      
      final public function removeInitializer(param1:Initializer) : void
      {
         var _loc2_:int = 0;
         if((_loc2_ = this.sd::initializers.indexOf(param1)) >= 0)
         {
            param1 = Initializer(this.sd::initializers.splice(_loc2_,1)[0]);
            param1.removeEventListener(InitializerEvent.PRIORITY_CHANGE,this.sortInitializers);
         }
      }
      
      final public function sortInitializers(param1:Event = null) : void
      {
         this.sd::initializers.sortOn("priority",Array.NUMERIC | Array.DESCENDING);
      }
      
      final public function clearInitializers() : void
      {
         var _loc1_:Initializer = null;
         for each(_loc1_ in this.sd::initializers)
         {
            this.removeInitializer(_loc1_);
         }
      }
   }
}
