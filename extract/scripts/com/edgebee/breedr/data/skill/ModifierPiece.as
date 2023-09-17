package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.combat.Condition;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import flash.utils.Dictionary;
   
   public class ModifierPiece extends StaticData implements Piece
   {
      
      public static const TYPE_DAMAGE:uint = 1;
      
      public static const TYPE_BLOCK:uint = 2;
      
      public static const TYPE_TOHIT:uint = 3;
      
      public static const TYPE_RESTORATION_HP:uint = 4;
      
      public static const TYPE_RESTORATION_PP:uint = 5;
      
      public static const TYPE_DISPEL:uint = 6;
      
      public static const TYPE_DURATION:uint = 7;
      
      public static const TYPE_FIRE:uint = 8;
      
      public static const TYPE_ICE:uint = 9;
      
      public static const TYPE_THUNDER:uint = 10;
      
      public static const TYPE_EARTH:uint = 11;
      
      public static const TYPE_BREATH:uint = 12;
      
      public static var DamageIconPng:Class = ModifierPiece_DamageIconPng;
      
      public static var BreathDamageIconPng:Class = ModifierPiece_BreathDamageIconPng;
      
      public static var BlockIconPng:Class = ModifierPiece_BlockIconPng;
      
      public static var TohitIconPng:Class = ModifierPiece_TohitIconPng;
      
      public static var RestoreHPIconPng:Class = ModifierPiece_RestoreHPIconPng;
      
      public static var RestorePPIconPng:Class = ModifierPiece_RestorePPIconPng;
      
      public static var DurationIconPng:Class = ModifierPiece_DurationIconPng;
      
      public static var MDispelIconPng:Class = ModifierPiece_MDispelIconPng;
      
      public static var FireIconPng:Class = ModifierPiece_FireIconPng;
      
      public static var IceIconPng:Class = ModifierPiece_IceIconPng;
      
      public static var ThunderIconPng:Class = ModifierPiece_ThunderIconPng;
      
      public static var EarthIconPng:Class = ModifierPiece_EarthIconPng;
      
      private static const _classinfo:Object = {
         "name":"ModifierPiece",
         "cls":ModifierPiece
      };
       
      
      public var id:uint;
      
      public var type:uint;
      
      public var add:int;
      
      public var add_level:int;
      
      public var pp_cost:Number;
      
      public var pp_cost_level:Number;
      
      public var pre_connector:int;
      
      public var post_connector:int;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var modifiers:DataArray;
      
      public function ModifierPiece(param1:Object = null)
      {
         this.modifiers = new DataArray(ModifierPieceModifierAssociation.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : ModifierPiece
      {
         return StaticData.getInstance(param1,"id","ModifierPiece");
      }
      
      override public function get classinfo() : Object
      {
         return ModifierPiece.classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc2_:ModifierPieceModifierAssociation = null;
         var _loc3_:ModifierPieceModifierAssociation = null;
         param1.id = this.id;
         param1.type = this.type;
         param1.add = this.add;
         param1.add_level = this.add_level;
         param1.pp_cost = this.pp_cost;
         param1.pp_cost_level = this.pp_cost_level;
         param1.pre_connector = this.pre_connector;
         param1.post_connector = this.post_connector;
         for each(_loc2_ in this.modifiers)
         {
            _loc3_ = new ModifierPieceModifierAssociation();
            _loc2_.copyTo(_loc3_);
            param1.modifiers.addItem(_loc3_);
         }
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get preConnector() : Connector
      {
         return new Connector(this.pre_connector);
      }
      
      public function get postConnector() : Connector
      {
         return new Connector(this.post_connector);
      }
      
      public function canConnectTo(param1:*) : Boolean
      {
         if(param1 is EffectPiece)
         {
            return this.preConnector.canConnectTo(param1.right);
         }
         if(param1 is ModifierPiece)
         {
            return this.preConnector.canConnectTo(param1.right);
         }
         if(param1 is ModifierPieceInstance)
         {
            return this.preConnector.canConnectTo(param1.right);
         }
         throw new Error("Invalid skill piece type");
      }
      
      public function instantiate() : ModifierPieceInstance
      {
         var _loc1_:ModifierPieceInstance = new ModifierPieceInstance();
         _loc1_.modifier_piece_id = this.id;
         return _loc1_;
      }
      
      public function get top() : Connector
      {
         return null;
      }
      
      public function get bottom() : Connector
      {
         return null;
      }
      
      public function get right() : Connector
      {
         return new Connector(this.post_connector);
      }
      
      public function get left() : Connector
      {
         return new Connector(this.pre_connector);
      }
      
      public function get editable() : Boolean
      {
         return false;
      }
      
      public function get color() : Color
      {
         switch(this.type)
         {
            case TYPE_DAMAGE:
               return new Color(16747008);
            case TYPE_BLOCK:
               return new Color(52224);
            case TYPE_TOHIT:
               return new Color(16747008);
            case TYPE_RESTORATION_HP:
               return new Color(204);
            case TYPE_RESTORATION_PP:
               return new Color(204);
            case TYPE_DISPEL:
               return new Color(13369548);
            case TYPE_DURATION:
               return new Color(52428);
            case TYPE_BREATH:
               return new Color(16755200);
            case TYPE_FIRE:
               return new Color(16733525);
            case TYPE_ICE:
               return new Color(11206655);
            case TYPE_THUNDER:
               return new Color(16777130);
            case TYPE_EARTH:
               return new Color(5622869);
            default:
               return new Color(16751616);
         }
      }
      
      public function getLevelNumber(param1:EffectPiece, param2:uint) : String
      {
         var _loc3_:ModifierPieceModifierAssociation = null;
         if(this.modifiersForDesc.length == 1)
         {
            _loc3_ = this.modifiersForDesc[0] as ModifierPieceModifierAssociation;
         }
         else
         {
            if(param1 == null)
            {
               return "";
            }
            for each(_loc3_ in this.modifiersForDesc)
            {
               if(_loc3_.effect == param1.effect.type && (_loc3_.condition & param1.effect.condition_type) == (param1.effect.condition_type & Condition.TYPE_MASK))
               {
                  break;
               }
            }
         }
         return Utils.round(_loc3_.modifier.add + _loc3_.modifier.add_level * param2,2).toString();
      }
      
      public function getNumber(param1:EffectPiece) : String
      {
         return this.getLevelNumber(param1,1);
      }
      
      public function get level() : int
      {
         return 1;
      }
      
      public function set level(param1:int) : void
      {
         throw new Error("Cant set level of static ModifierPiece");
      }
      
      public function get level_delta() : int
      {
         return 0;
      }
      
      public function set level_delta(param1:int) : void
      {
         throw new Error("Cant set level_delta of static ModifierPiece");
      }
      
      public function canUpgrade(param1:CreatureInstance) : Boolean
      {
         return false;
      }
      
      public function get modifiedLevel() : int
      {
         return 1;
      }
      
      public function get icon() : Class
      {
         switch(this.type)
         {
            case TYPE_DAMAGE:
               return DamageIconPng;
            case TYPE_BLOCK:
               return BlockIconPng;
            case TYPE_TOHIT:
               return TohitIconPng;
            case TYPE_RESTORATION_HP:
               return RestoreHPIconPng;
            case TYPE_RESTORATION_PP:
               return RestorePPIconPng;
            case TYPE_DURATION:
               return DurationIconPng;
            case TYPE_DISPEL:
               return MDispelIconPng;
            case TYPE_BREATH:
               return BreathDamageIconPng;
            case TYPE_FIRE:
               return FireIconPng;
            case TYPE_ICE:
               return IceIconPng;
            case TYPE_THUNDER:
               return ThunderIconPng;
            case TYPE_EARTH:
               return EarthIconPng;
            default:
               return null;
         }
      }
      
      public function get descriptionAsset() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function get modifiersForDesc() : Array
      {
         var _loc3_:ModifierPieceModifierAssociation = null;
         var _loc4_:String = null;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:Array = [];
         for each(_loc3_ in this.modifiers)
         {
            if(!_loc3_.modifier.hidden)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getLevelDescription(param1:uint, param2:EffectPiece, param3:CreatureInstance = null) : String
      {
         var _loc8_:ModifierPieceModifierAssociation = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc4_:* = "";
         _loc4_ = (_loc4_ = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>") + (Utils.htmlWrap(this.descriptionAsset.value,null,null,0) + "<br>");
         var _loc5_:String = "";
         var _loc6_:String = Utils.round(this.pp_cost + this.pp_cost_level * param1,0).toString();
         var _loc7_:* = (_loc7_ = (_loc6_ = Utils.htmlWrap(_loc6_,null,5635925,0,true)) + " " + Asset.getInstanceByName("PP").value) + ("   " + Asset.getInstanceByName("NEXT_LEVEL").value + " ");
         if(param1 < EffectPiece.MAX_LEVEL)
         {
            _loc6_ = Utils.round(this.pp_cost + this.pp_cost_level * (param1 + 1),0).toString();
            _loc6_ = Utils.htmlWrap(_loc6_,null,5635925,0,true);
            _loc7_ += _loc6_ + " " + Asset.getInstanceByName("PP").value;
         }
         else
         {
            _loc7_ += Utils.htmlWrap("-",null,5635925,0,true);
         }
         _loc7_ += "<br>";
         var _loc9_:ModifierPieceModifierAssociation = null;
         var _loc10_:Boolean = false;
         for each(_loc8_ in this.modifiersForDesc)
         {
            if(param2 == null || _loc8_.effect == param2.effect.type && (_loc8_.condition & param2.effect.condition_type) == (param2.effect.condition_type & Condition.TYPE_MASK))
            {
               if(Boolean(_loc9_) && _loc9_.effect != _loc8_.effect)
               {
                  _loc10_ = true;
                  break;
               }
               _loc9_ = _loc8_;
            }
         }
         _loc8_ = _loc9_ = null;
         for each(_loc8_ in this.modifiersForDesc)
         {
            if(param2 == null || _loc8_.effect == param2.effect.type && (_loc8_.condition & param2.effect.condition_type) == (param2.effect.condition_type & Condition.TYPE_MASK))
            {
               _loc12_ = (_loc11_ = param2 == null && this.modifiersForDesc.length > 1 && _loc10_) && (!_loc9_ || _loc9_.effect != _loc8_.effect);
               _loc7_ += _loc8_.getDescription(param1,_loc11_,_loc12_);
               _loc9_ = _loc8_;
            }
         }
         if(Boolean(param3) && param1 < EffectPiece.MAX_LEVEL)
         {
            _loc13_ = int(param3.creature.category.level_caps[param1]);
            if(param3.level < _loc13_)
            {
               _loc7_ = (_loc7_ += Utils.htmlWrap(Utils.capitalizeFirst(Utils.formatString(Asset.getInstanceByName("SKILL_MIN_LEVEL_REQUIRED").value,{"level":_loc13_})),null,16711680,0,true)) + "<br>";
            }
         }
         _loc7_ = Utils.htmlWrap(_loc7_,null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
         return _loc4_ + _loc7_;
      }
      
      public function getDescription(param1:EffectPiece, param2:CreatureInstance = null) : String
      {
         return this.getLevelDescription(this.modifiedLevel,param1,param2);
      }
      
      public function get priority() : int
      {
         return this.type * 100000;
      }
   }
}
