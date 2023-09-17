package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   
   public class Category extends StaticData
   {
      
      public static const CATEGORY_COMMON:int = 0;
      
      public static const CATEGORY_UNCOMMON:int = 1;
      
      public static const CATEGORY_RARE:int = 2;
      
      public static const CATEGORY_LEGEND:int = 3;
      
      public static const CATEGORY_MYSTIC:int = 4;
      
      private static const _classinfo:Object = {
         "name":"Category",
         "cls":Category
      };
       
      
      public var id:uint;
      
      public var type:int;
      
      public var level_caps:Array;
      
      public function Category(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Category
      {
         return StaticData.getInstance(param1,"id","Category");
      }
      
      override public function get classinfo() : Object
      {
         return Category.classinfo;
      }
   }
}
