package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   
   public class StaminaLevel extends Level
   {
      
      private static const _classinfo:Object = {
         "name":"StaminaLevel",
         "cls":StaminaLevel
      };
       
      
      public function StaminaLevel(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : StaminaLevel
      {
         return StaticData.getInstance(param1,"id","StaminaLevel");
      }
      
      public static function getInstanceByLevel(param1:uint) : StaminaLevel
      {
         return StaticData.getInstance(param1,"index","StaminaLevel");
      }
      
      override public function get classinfo() : Object
      {
         return StaminaLevel.classinfo;
      }
      
      override public function getMaximum(param1:* = null) : Level
      {
         var _loc2_:CreatureInstance = param1 as CreatureInstance;
         return _loc2_.max_stamina;
      }
   }
}
