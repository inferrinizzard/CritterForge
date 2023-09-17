package com.edgebee.breedr.data.skill
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.util.Utils;
   
   public class Rule extends StaticData
   {
      
      public static const TYPE_NORMAL:Number = 0;
      
      public static const TYPE_VALUE:Number = 1;
      
      public static const TYPE_RATIO:Number = 2;
      
      public static const TYPE_CONDITION:Number = 3;
      
      public static const TYPE_TRAIT:Number = 4;
      
      public static const THRESHOLD_INT:Number = 1;
      
      public static const THRESHOLD_FLOAT:Number = 2;
      
      public static const THRESHOLD_STRING:Number = 4;
      
      public static const EQUALS:Number = 0;
      
      public static const DIFFERS:Number = 1;
      
      public static const LOWER:Number = 2;
      
      public static const HIGHER:Number = 3;
      
      public static const HAS:Number = 0;
      
      public static const HAS_NOT:Number = 1;
      
      public static const SELF:Number = 0;
      
      public static const ENEMY:Number = 1;
      
      public static const CLASSIFICATION_NONE:Number = 0;
      
      public static const CLASSIFICATION_RANDOM:Number = 1;
      
      public static const CLASSIFICATION_ROUND:Number = 2;
      
      public static const CLASSIFICATION_HEALTH:Number = 3;
      
      public static const CLASSIFICATION_POWER:Number = 4;
      
      public static const CLASSIFICATION_CONDITIONS:Number = 5;
      
      public static const CLASSIFICATION_CONDITIONS_SPECIAL:Number = 6;
      
      public static const CLASSIFICATION_CONDITIONS_BOOST:Number = 7;
      
      public static const CLASSIFICATION_CONDITIONS_REDUCE:Number = 8;
      
      public static const CLASSIFICATION_TRAIT:Number = 9;
      
      private static const _classinfo:Object = {
         "name":"Rule",
         "cls":Rule
      };
       
      
      public var id:uint;
      
      public var uid:String;
      
      public var classification:Number;
      
      public var type:Number;
      
      public var description_id:uint;
      
      public var trait_id:uint;
      
      public var min_level:int;
      
      public function Rule(param1:Object = null)
      {
         super(param1,null,["id","uid"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Rule
      {
         return StaticData.getInstance(param1,"id","Rule");
      }
      
      public static function getInstanceByUid(param1:String) : Rule
      {
         return StaticData.getInstance(param1,"uid","Rule");
      }
      
      public static function getInstanceByName(param1:String) : Rule
      {
         return getInstanceByUid(MD5.hash("Rule:" + param1));
      }
      
      override public function get classinfo() : Object
      {
         return Rule.classinfo;
      }
      
      public function get trait() : Trait
      {
         return Trait.getInstanceById(this.trait_id);
      }
      
      public function get description() : *
      {
         if(this.type == TYPE_TRAIT)
         {
            return Utils.formatString(Asset.getInstanceById(this.description_id).value,{"trait":this.trait.name.value});
         }
         return Asset.getInstanceById(this.description_id);
      }
   }
}
