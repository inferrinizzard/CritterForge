package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.StaticData;
   
   public class SyndicateLevel extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"SyndicateLevel",
         "cls":SyndicateLevel
      };
       
      
      public var id:uint;
      
      public var level:uint;
      
      public var capacity:uint;
      
      public var tokens:uint;
      
      public var credits:int;
      
      public function SyndicateLevel(param1:Object = null)
      {
         super(param1,null,["id","level"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : SyndicateLevel
      {
         return StaticData.getInstance(param1,"id","SyndicateLevel");
      }
      
      public static function getInstanceByLevel(param1:uint) : SyndicateLevel
      {
         return StaticData.getInstance(param1,"level","SyndicateLevel");
      }
      
      override public function get classinfo() : Object
      {
         return SyndicateLevel.classinfo;
      }
   }
}
