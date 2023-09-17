package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.StaticData;
   
   public class FeederLevel extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"FeederLevel",
         "cls":FeederLevel
      };
       
      
      public var id:uint;
      
      public var level:uint;
      
      public var capacity:uint;
      
      public var tokens:uint;
      
      public var credits:int;
      
      public function FeederLevel(param1:Object = null)
      {
         super(param1,null,["id","level"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : FeederLevel
      {
         return StaticData.getInstance(param1,"id","FeederLevel");
      }
      
      public static function getInstanceByLevel(param1:uint) : FeederLevel
      {
         return StaticData.getInstance(param1,"level","FeederLevel");
      }
      
      override public function get classinfo() : Object
      {
         return FeederLevel.classinfo;
      }
   }
}
