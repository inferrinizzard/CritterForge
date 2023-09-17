package idv.cjcat.stardust.common.xml
{
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import idv.cjcat.stardust.Stardust;
   import idv.cjcat.stardust.common.StardustElement;
   import idv.cjcat.stardust.common.errors.DuplicateElementNameError;
   
   public class XMLBuilder
   {
       
      
      private var elementClasses:Dictionary;
      
      private var elements:Dictionary;
      
      public function XMLBuilder()
      {
         super();
         this.elementClasses = new Dictionary();
         this.elements = new Dictionary();
      }
      
      public static function buildXML(param1:StardustElement) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:XML = <StardustParticleSystem/>;
         _loc3_.@version = Stardust.VERSION;
         var _loc4_:Dictionary = new Dictionary();
         traverseRelatedObjects(param1,_loc4_);
         var _loc5_:Array = [];
         for each(param1 in _loc4_)
         {
            _loc5_.push(param1);
         }
         _loc5_.sort(elementTypeSorter);
         for each(param1 in _loc5_)
         {
            _loc6_ = param1.toXML();
            _loc7_ = param1.getElementTypeXMLTag();
            if(_loc3_[_loc7_.name()].length() == 0)
            {
               _loc3_.appendChild(_loc7_);
            }
            _loc3_[_loc7_.name()].appendChild(_loc6_);
         }
         return _loc3_;
      }
      
      private static function elementTypeSorter(param1:StardustElement, param2:StardustElement) : Number
      {
         if(param1.getElementTypeXMLTag().name() > param2.getElementTypeXMLTag().name())
         {
            return 1;
         }
         if(param1.getElementTypeXMLTag().name() < param2.getElementTypeXMLTag().name())
         {
            return -1;
         }
         if(param1.getXMLTagName() > param2.getXMLTagName())
         {
            return 1;
         }
         if(param1.getXMLTagName() < param2.getXMLTagName())
         {
            return -1;
         }
         if(param1.name > param2.name)
         {
            return 1;
         }
         return -1;
      }
      
      private static function traverseRelatedObjects(param1:StardustElement, param2:Dictionary) : void
      {
         var _loc3_:StardustElement = null;
         if(!param1)
         {
            return;
         }
         if(param2[param1.name] != undefined)
         {
            if(param2[param1.name] != param1)
            {
               throw new DuplicateElementNameError("Duplicate element name: " + param1.name,param1.name,param2[param1.name],param1);
            }
         }
         else
         {
            param2[param1.name] = param1;
         }
         for each(_loc3_ in param1.getRelatedObjects())
         {
            traverseRelatedObjects(_loc3_,param2);
         }
      }
      
      public function registerClass(param1:Class) : void
      {
         var _loc2_:StardustElement = StardustElement(new param1());
         if(!_loc2_)
         {
            throw new IllegalOperationError("The class is not a subclass of the StardustElement class.");
         }
         if(this.elementClasses[_loc2_.getXMLTagName()] != undefined)
         {
            throw new IllegalOperationError("This element class name is already registered: " + _loc2_.getXMLTagName());
         }
         this.elementClasses[_loc2_.getXMLTagName()] = param1;
      }
      
      public function registerClasses(param1:Array) : void
      {
         var _loc2_:Class = null;
         for each(_loc2_ in param1)
         {
            this.registerClass(_loc2_);
         }
      }
      
      public function registerClassesFromClassPackage(param1:ClassPackage) : void
      {
         this.registerClasses(param1.getClasses());
      }
      
      public function unregisterClass(param1:String) : void
      {
         delete this.elementClasses[param1];
      }
      
      public function getElementByName(param1:String) : StardustElement
      {
         if(this.elements[param1] == undefined)
         {
            throw new IllegalOperationError("Element not found: " + param1);
         }
         return this.elements[param1];
      }
      
      public function buildFromXML(param1:XML) : void
      {
         var _loc2_:StardustElement = null;
         var _loc3_:XML = null;
         var _loc4_:* = undefined;
         if(this.elements)
         {
            for(_loc4_ in this.elements)
            {
               delete this.elements[_loc4_];
            }
         }
         this.elements = new Dictionary();
         for each(_loc3_ in param1.*.*)
         {
            _loc2_ = StardustElement(new this.elementClasses[_loc3_.name()]());
            if(this.elements[_loc3_.@name] != undefined)
            {
               throw new DuplicateElementNameError("Duplicate element name: " + _loc3_.@name,_loc3_.@name,this.elements[_loc3_.@name],_loc2_);
            }
            this.elements[_loc3_.@name.toString()] = _loc2_;
         }
         for each(_loc3_ in param1.*.*)
         {
            _loc2_ = StardustElement(this.elements[_loc3_.@name.toString()]);
            _loc2_.parseXML(_loc3_,this);
         }
      }
   }
}
