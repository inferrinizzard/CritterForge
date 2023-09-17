package com.edgebee.breedr.data.item
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.effect.Modifier;
   import com.edgebee.breedr.data.skill.Trait;
   
   public class Item extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Item",
         "cls":Item
      };
      
      public static const TYPE_USE:uint = 0;
      
      public static const TYPE_FEED:uint = 1;
      
      public static const TYPE_PLAY:uint = 2;
      
      public static const TYPE_NURTURE:uint = 3;
      
      public static const TYPE_BREED:uint = 4;
      
      public static const USE_RESTORE_STAMINA:uint = 0;
      
      public static const USE_RESTORE_HEALTH:uint = 1;
      
      public static const USE_RESTORE_HAPPINESS:uint = 2;
      
      public static const USE_INJECT_FIRE:uint = 3;
      
      public static const USE_INJECT_ICE:uint = 4;
      
      public static const USE_INJECT_THUNDER:uint = 5;
      
      public static const USE_INJECT_EARTH:uint = 6;
      
      public static const USE_ACCELERATE_GESTATION:uint = 7;
      
      public static const USE_INJECT_TRAIT:uint = 8;
      
      public static const USE_SEX_CHANGE:uint = 9;
      
      public static const USE_CLONE:uint = 10;
      
      public static const USE_RESTORE_SEEDS:uint = 11;
      
      public static const QUALITY_POOR:uint = 0;
      
      public static const QUALITY_NORMAL:uint = 1;
      
      public static const QUALITY_GOOD:uint = 2;
      
      public static const QUALITY_GREAT:uint = 3;
      
      public static const QUALITY_BEST:uint = 4;
      
      public static const PLAY_THROW:uint = 0;
      
      public static const PLAY_MIND:uint = 1;
      
      public static const PLAY_TRAIN:uint = 2;
      
      public static const NURTURE_HEAL:uint = 0;
      
      public static const NURTURE_COMFORT:uint = 1;
      
      public static const NURTURE_GENERIC:uint = 2;
      
      public static const FOOD_GENERIC:uint = 0;
      
      public static const FOOD_MEAT:uint = 1;
      
      public static const FOOD_SEA:uint = 2;
      
      public static const FOOD_VEGE:uint = 3;
       
      
      public var id:uint;
      
      public var uid:String;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var image_url:String;
      
      public var modifiers:DataArray;
      
      public var credits:int;
      
      public var tokens:int;
      
      public var max_uses:int;
      
      public var show_charges:Boolean;
      
      public var type:uint;
      
      public var subtype:uint;
      
      public var quality:uint;
      
      public var stamina:Number = 0;
      
      public var happiness:Number = 0;
      
      public var health:Number = 0;
      
      public var amount:Number = 0;
      
      public var glow:int = 0;
      
      public var hue:Number = 0;
      
      public var saturation:Number = 0;
      
      public var trait_id:uint;
      
      public function Item(param1:Object = null)
      {
         this.modifiers = new DataArray(Modifier.classinfo);
         super(param1,null,["id","uid"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Item
      {
         return StaticData.getInstance(param1,"id","Item");
      }
      
      override public function get classinfo() : Object
      {
         return Item.classinfo;
      }
      
      public function get trait() : Trait
      {
         return Trait.getInstanceById(this.trait_id);
      }
      
      public function get maxCharges() : int
      {
         if(!this.show_charges)
         {
            return -1;
         }
         if(this.max_uses == 0)
         {
            return 1;
         }
         return this.max_uses;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get description() : String
      {
         var _loc4_:Modifier = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc1_:* = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>";
         _loc1_ += Utils.htmlWrap(Utils.capitalizeFirst(Asset.getInstanceById(this.description_id).value),null,null,0) + "<br>";
         if(this.trait_id > 0)
         {
            _loc1_ = Utils.capitalizeFirst(Utils.formatString(_loc1_,{"trait":Utils.htmlWrap(this.trait.name.value,null,5636095,0,true)}));
         }
         var _loc2_:int = _loc1_.lastIndexOf("{tech}");
         if(_loc2_ != -1)
         {
            _loc1_ = (_loc5_ = _loc1_.split(/\{tech\}/)).shift();
            for each(_loc6_ in _loc5_)
            {
               _loc1_ += Utils.htmlWrap(Utils.capitalizeFirst(_loc6_),null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
            }
         }
         if((this.type == TYPE_FEED && this.subtype != FOOD_GENERIC || this.type == TYPE_PLAY || this.type == TYPE_NURTURE) && this.quality < QUALITY_BEST)
         {
            _loc6_ = Utils.capitalizeFirst(Utils.formatString(Asset.getInstanceByName("FOOD_TIER").value,{"tier":this.quality + 1}));
            _loc1_ += Utils.htmlWrap(_loc6_,null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9),false,true);
         }
         var _loc3_:String = "";
         for each(_loc4_ in this.modifiers)
         {
            if(!_loc4_.hidden)
            {
               _loc3_ += _loc4_.getDescription(0) + "<br>";
            }
         }
         if(_loc3_)
         {
            _loc1_ += "<br>" + _loc3_;
         }
         return _loc1_;
      }
   }
}
