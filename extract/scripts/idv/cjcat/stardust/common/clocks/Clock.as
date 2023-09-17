package idv.cjcat.stardust.common.clocks
{
   import idv.cjcat.stardust.common.StardustElement;
   
   public class Clock extends StardustElement
   {
       
      
      public function Clock()
      {
         super();
      }
      
      public function getTicks(param1:Number) : int
      {
         return 0;
      }
      
      override public function getElementTypeXMLTag() : XML
      {
         return <clocks/>;
      }
   }
}
