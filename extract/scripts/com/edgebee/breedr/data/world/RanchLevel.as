package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.StaticData;
   
   public class RanchLevel extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"RanchLevel",
         "cls":RanchLevel
      };
       
      
      public var id:uint;
      
      public var level:uint;
      
      public var capacity:uint;
      
      public var tokens:uint;
      
      public var credits:int;
      
      public function RanchLevel(param1:Object = null)
      {
         super(param1,null,["id","level"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : RanchLevel
      {
         return StaticData.getInstance(param1,"id","RanchLevel");
      }
      
      public static function getInstanceByLevel(param1:uint) : RanchLevel
      {
         return StaticData.getInstance(param1,"level","RanchLevel");
      }
      
      override public function get classinfo() : Object
      {
         return RanchLevel.classinfo;
      }
   }
}
