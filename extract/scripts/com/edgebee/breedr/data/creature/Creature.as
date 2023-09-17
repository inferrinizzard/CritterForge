package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.breedr.data.item.Item;
   
   public class Creature extends StaticData
   {
      
      public static const FAMILY_WOLF:uint = 0;
      
      public static const FAMILY_LIZARD:uint = 1;
      
      public static const FAMILY_FISH:uint = 2;
      
      public static const FAMILY_MOTH:uint = 3;
      
      public static const FAMILY_BIRD:uint = 4;
      
      public static const COMMON_FAMILIES:Array = [FAMILY_WOLF,FAMILY_LIZARD,FAMILY_FISH,FAMILY_MOTH,FAMILY_BIRD];
      
      public static const FAMILY_TOAD:uint = 5;
      
      public static const FAMILY_CRUSTACEAN:uint = 6;
      
      public static const FAMILY_SPIDER:uint = 7;
      
      public static const FAMILY_RAPTOR:uint = 8;
      
      public static const FAMILY_OWLBEAR:uint = 9;
      
      public static const UNCOMMON_FAMILIES:Array = [FAMILY_TOAD,FAMILY_CRUSTACEAN,FAMILY_SPIDER,FAMILY_RAPTOR,FAMILY_OWLBEAR];
      
      public static const FAMILY_WALRUS:uint = 10;
      
      public static const FAMILY_CALAMARI:uint = 11;
      
      public static const FAMILY_CROCODILE:uint = 12;
      
      public static const FAMILY_HORNET:uint = 13;
      
      public static const FAMILY_MAMMOTH:uint = 14;
      
      public static const FAMILY_STEED:uint = 15;
      
      public static const RARE_FAMILIES:Array = [FAMILY_WALRUS,FAMILY_CALAMARI,FAMILY_CROCODILE,FAMILY_HORNET,FAMILY_MAMMOTH,FAMILY_STEED];
      
      public static const FAMILY_TORTOISE:uint = 16;
      
      public static const FAMILY_DRAGON:uint = 17;
      
      public static const FAMILY_MANTIS:uint = 18;
      
      public static const FAMILY_HYDRA:uint = 19;
      
      public static const FAMILY_GORILLA:uint = 20;
      
      public static const FAMILY_LION:uint = 21;
      
      public static const LEGENDARY_FAMILIES:Array = [FAMILY_TORTOISE,FAMILY_DRAGON,FAMILY_MANTIS,FAMILY_HYDRA,FAMILY_GORILLA,FAMILY_LION];
      
      public static const FAMILY_WYRM:uint = 22;
      
      public static const FAMILY_CERBERUS:uint = 23;
      
      public static const FAMILY_BEHOLDER:uint = 24;
      
      public static const MYTHIC_FAMILIES:Array = [FAMILY_WYRM,FAMILY_CERBERUS,FAMILY_BEHOLDER];
      
      public static const FAMILY_MAX:uint = 25;
      
      private static const _classinfo:Object = {
         "name":"Creature",
         "cls":Creature
      };
       
      
      public var id:uint;
      
      public var name_id:uint;
      
      public var code_name:String;
      
      public var category_id:uint;
      
      public var family_index:uint;
      
      public var splicer_id:uint;
      
      public function Creature(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Creature
      {
         return StaticData.getInstance(param1,"id","Creature");
      }
      
      override public function get classinfo() : Object
      {
         return Creature.classinfo;
      }
      
      public function get url() : String
      {
         return "breedr/creatures/" + this.code_name + ".swf";
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get splicer() : Item
      {
         return Item.getInstanceById(this.splicer_id);
      }
      
      public function get category() : Category
      {
         return Category.getInstanceById(this.category_id);
      }
   }
}
