package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.StaticData;
   
   public class FridgeLevel extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"FridgeLevel",
         "cls":FridgeLevel
      };
       
      
      public var id:uint;
      
      public var level:uint;
      
      public var capacity:uint;
      
      public var tokens:uint;
      
      public var credits:int;
      
      public function FridgeLevel(param1:Object = null)
      {
         super(param1,null,["id","level"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : FridgeLevel
      {
         return StaticData.getInstance(param1,"id","FridgeLevel");
      }
      
      public static function getInstanceByLevel(param1:uint) : FridgeLevel
      {
         return StaticData.getInstance(param1,"level","FridgeLevel");
      }
      
      override public function get classinfo() : Object
      {
         return FridgeLevel.classinfo;
      }
   }
}
