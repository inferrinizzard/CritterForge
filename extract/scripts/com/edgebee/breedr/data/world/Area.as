package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.player.Player;
   
   public class Area extends StaticData
   {
      
      public static const TYPE_NORMAL:uint = 0;
      
      public static const TYPE_RANCH:uint = 1;
      
      public static const TYPE_LABORATORY:uint = 2;
      
      public static const TYPE_SHOP:uint = 3;
      
      public static const TYPE_ARENA:uint = 4;
      
      public static const TYPE_TRAVEL:uint = 5;
      
      public static const TYPE_AUCTION:uint = 6;
      
      public static const TYPE_SYNDICATE:uint = 7;
      
      public static const TYPE_SAFARI:uint = 8;
      
      public static const TYPE_QUEST:uint = 9;
      
      public static const TYPE_SAFARI_PLAINS:uint = 0;
      
      public static const TYPE_SAFARI_FOREST:uint = 1;
      
      public static const TYPE_SAFARI_MOUNTAINS:uint = 2;
      
      public static const TYPE_SAFARI_CORAL:uint = 3;
      
      public static const TYPE_SAFARI_SWAMP:uint = 4;
      
      public static const TYPE_SAFARI_DESERT:uint = 5;
      
      public static const TYPE_SAFARI_TROPICAL:uint = 6;
      
      public static const TYPE_SAFARI_MAGICAL:uint = 7;
      
      public static var AmbPlainsWav:Class = Area_AmbPlainsWav;
      
      public static var AmbForestWav:Class = Area_AmbForestWav;
      
      public static var AmbMountainsWav:Class = Area_AmbMountainsWav;
      
      public static var AmbCoralWav:Class = Area_AmbCoralWav;
      
      public static var AmbSwampWav:Class = Area_AmbSwampWav;
      
      public static var AmbDesertWav:Class = Area_AmbDesertWav;
      
      public static var AmbTropicalWav:Class = Area_AmbTropicalWav;
      
      public static var AmbMagicalWav:Class = Area_AmbMagicalWav;
      
      private static const _classinfo:Object = {
         "name":"Area",
         "cls":Area
      };
       
      
      public var id:uint;
      
      public var type:uint;
      
      public var name_id:uint;
      
      public var npc_id:uint;
      
      public var description_id:uint;
      
      public var image_url:String;
      
      public var links_ids:Array;
      
      public var items_ids:Array;
      
      public var destinations:DataArray;
      
      public var welcome_id:uint;
      
      public var safari_type:uint;
      
      private var _links:ArrayCollection;
      
      private var _items:ArrayCollection;
      
      public function Area(param1:Object = null)
      {
         this.destinations = new DataArray(Destination.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Area
      {
         return StaticData.getInstance(param1,"id","Area");
      }
      
      override public function get classinfo() : Object
      {
         return Area.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get description() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function get npc() : NonPlayerCharacter
      {
         return NonPlayerCharacter.getInstanceById(this.npc_id);
      }
      
      public function get welcome() : Dialog
      {
         return Dialog.getInstanceById(this.welcome_id);
      }
      
      public function get music() : *
      {
         switch(this.type)
         {
            case TYPE_SAFARI:
               switch(this.safari_type)
               {
                  case TYPE_SAFARI_PLAINS:
                     return AmbPlainsWav;
                  case TYPE_SAFARI_FOREST:
                     return AmbForestWav;
                  case TYPE_SAFARI_MOUNTAINS:
                     return AmbMountainsWav;
                  case TYPE_SAFARI_CORAL:
                     return AmbCoralWav;
                  case TYPE_SAFARI_SWAMP:
                     return AmbSwampWav;
                  case TYPE_SAFARI_DESERT:
                     return AmbDesertWav;
                  case TYPE_SAFARI_TROPICAL:
                     return AmbTropicalWav;
                  case TYPE_SAFARI_MAGICAL:
                     return AmbMagicalWav;
                  default:
                     return null;
               }
               break;
            case TYPE_ARENA:
               return null;
            default:
               return UIGlobals.getAssetPath("breedr/sounds/music/manage.mp3");
         }
      }
      
      public function getImageForPlayer(param1:Player) : String
      {
         if(this.type == TYPE_RANCH)
         {
            if(param1.ranch_level.level > 6)
            {
               return this.image_url.split(".")[0] + "_2.jpg";
            }
            return this.image_url.split(".")[0] + "_1.jpg";
         }
         return this.image_url;
      }
      
      public function get links() : ArrayCollection
      {
         var _loc1_:uint = 0;
         if(!this._links)
         {
            this._links = new ArrayCollection();
            for each(_loc1_ in this.links_ids)
            {
               this._links.addItem(Link.getInstanceById(_loc1_));
            }
         }
         return this._links;
      }
      
      public function get items() : ArrayCollection
      {
         var _loc1_:uint = 0;
         if(!this._items)
         {
            this._items = new ArrayCollection();
            for each(_loc1_ in this.items_ids)
            {
               this._items.addItem(Item.getInstanceById(_loc1_));
            }
         }
         return this._items;
      }
   }
}
