package idv.cjcat.stardust.common.xml
{
   public class ClassPackage
   {
      
      private static var _instance:idv.cjcat.stardust.common.xml.ClassPackage;
       
      
      protected var classes:Array;
      
      public function ClassPackage()
      {
         super();
         this.classes = [];
         this.populateClasses();
      }
      
      public static function getInstance() : idv.cjcat.stardust.common.xml.ClassPackage
      {
         if(_instance)
         {
            _instance = new idv.cjcat.stardust.common.xml.ClassPackage();
         }
         return _instance;
      }
      
      final public function getClasses() : Array
      {
         return this.classes.concat();
      }
      
      protected function populateClasses() : void
      {
      }
   }
}
