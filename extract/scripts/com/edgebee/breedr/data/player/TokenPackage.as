package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.StaticData;
   
   public class TokenPackage extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"TokenPackage",
         "cls":TokenPackage
      };
      
      public static const TYPE_RESET_SKILLS:uint = 3;
      
      public static const TYPE_ADD_MANIPULATIONS:uint = 4;
      
      public static const TYPE_EXTRACT_FOURTH_TIER:uint = 5;
      
      public static const TYPE_RENAME_CREATURE:uint = 6;
      
      public static const TYPE_EXTRACT_FIFTH_TIER:uint = 7;
       
      
      public var id:uint;
      
      public var type:uint;
      
      public var tokens:uint;
      
      public var value:uint;
      
      public function TokenPackage(param1:Object = null)
      {
         super(param1,null,["type"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceByType(param1:uint) : TokenPackage
      {
         return StaticData.getInstance(param1,"type","TokenPackage");
      }
      
      override public function get classinfo() : Object
      {
         return TokenPackage.classinfo;
      }
   }
}
