package idv.cjcat.stardust.common.actions
{
   public interface ActionCollector
   {
       
      
      function addAction(param1:Action) : void;
      
      function removeAction(param1:Action) : void;
      
      function clearActions() : void;
   }
}
