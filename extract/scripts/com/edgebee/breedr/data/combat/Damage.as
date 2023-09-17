package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.Data;
   
   public class Damage extends Data
   {
      
      public static const DAMAGE_PHYSICAL:Number = 0;
      
      public static const DAMAGE_CLAW:Number = 1;
      
      public static const DAMAGE_BITE:Number = 2;
      
      public static const DAMAGE_CRUSH:Number = 3;
      
      public static const DAMAGE_SPEAR:Number = 4;
      
      public static const DAMAGE_ELEMENTAL:Number = 5;
      
      public static const DAMAGE_FIRE:Number = 6;
      
      public static const DAMAGE_ICE:Number = 7;
      
      public static const DAMAGE_THUNDER:Number = 8;
      
      public static const DAMAGE_EARTH:Number = 9;
      
      public static const DAMAGE_PP:Number = 10;
      
      private static const _classinfo:Object = {
         "name":"Damage",
         "cls":Damage
      };
       
      
      public var type:int;
      
      public var value:int;
      
      public function Damage(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
