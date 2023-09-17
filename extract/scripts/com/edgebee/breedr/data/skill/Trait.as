package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.effect.Modifier;
   
   public class Trait extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Trait",
         "cls":Trait
      };
      
      public static const MAX_LEVEL:uint = 15;
       
      
      public var id:uint;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var image_url:String;
      
      public var modifiers:DataArray;
      
      public function Trait(param1:Object = null)
      {
         this.modifiers = new DataArray(Modifier.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Trait
      {
         return StaticData.getInstance(param1,"id","Trait");
      }
      
      override public function get classinfo() : Object
      {
         return Trait.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get descriptionAsset() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function getLevelDescription(param1:uint, param2:CreatureInstance = null) : String
      {
         var _loc6_:Modifier = null;
         var _loc7_:int = 0;
         var _loc3_:* = "";
         _loc3_ = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>";
         _loc3_ += Utils.htmlWrap(this.descriptionAsset.value,null,null,0) + "<br>";
         var _loc4_:String = "";
         var _loc5_:* = Utils.capitalizeFirst(Asset.getInstanceByName("LEVEL").value) + " " + param1.toString() + "<br>";
         for each(_loc6_ in this.modifiers)
         {
            if(!_loc6_.hidden)
            {
               _loc5_ += _loc6_.getDescription(param1) + "<br>";
            }
         }
         if(Boolean(param2) && param1 < Trait.MAX_LEVEL)
         {
            _loc7_ = int(param2.creature.category.level_caps[param1]);
            if(param2.level < _loc7_)
            {
               _loc5_ = (_loc5_ += Utils.htmlWrap(Utils.capitalizeFirst(Utils.formatString(Asset.getInstanceByName("SKILL_MIN_LEVEL_REQUIRED").value,{"level":_loc7_})),null,16711680,0,true)) + "<br>";
            }
         }
         _loc5_ = Utils.htmlWrap(_loc5_,null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
         return _loc3_ + _loc5_;
      }
      
      public function getDescription(param1:CreatureInstance = null) : String
      {
         return this.getLevelDescription(1,param1);
      }
   }
}
