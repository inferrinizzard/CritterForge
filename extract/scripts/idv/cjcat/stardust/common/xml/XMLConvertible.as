package idv.cjcat.stardust.common.xml
{
   public interface XMLConvertible
   {
       
      
      function toXML() : XML;
      
      function parseXML(param1:XML, param2:XMLBuilder = null) : void;
   }
}
