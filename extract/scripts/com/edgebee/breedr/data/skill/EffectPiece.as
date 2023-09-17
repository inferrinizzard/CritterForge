package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.combat.Condition;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.effect.Effect;
   
   public class EffectPiece extends StaticData implements Piece
   {
      
      public static var ClawIconPng:Class = EffectPiece_ClawIconPng;
      
      public static var BiteIconPng:Class = EffectPiece_BiteIconPng;
      
      public static var CrushIconPng:Class = EffectPiece_CrushIconPng;
      
      public static var SpearIconPng:Class = EffectPiece_SpearIconPng;
      
      public static var BreathIconPng:Class = EffectPiece_BreathIconPng;
      
      public static var BlockIconPng:Class = EffectPiece_BlockIconPng;
      
      public static var FizzleIconPng:Class = EffectPiece_FizzleIconPng;
      
      public static var RestoreIconPng:Class = EffectPiece_RestoreIconPng;
      
      public static var DispelIconPng:Class = EffectPiece_DispelIconPng;
      
      public static var PreventMoveIconPng:Class = EffectPiece_PreventMoveIconPng;
      
      public static var PreventThinkIconPng:Class = EffectPiece_PreventThinkIconPng;
      
      public static var PreventAiIconPng:Class = EffectPiece_PreventAiIconPng;
      
      public static var BoostStrIconPng:Class = EffectPiece_BoostStrIconPng;
      
      public static var BoostAgiIconPng:Class = EffectPiece_BoostAgiIconPng;
      
      public static var BoostResIconPng:Class = EffectPiece_BoostResIconPng;
      
      public static var BoostIntIconPng:Class = EffectPiece_BoostIntIconPng;
      
      public static var ReduceStrIconPng:Class = EffectPiece_ReduceStrIconPng;
      
      public static var ReduceAgiIconPng:Class = EffectPiece_ReduceAgiIconPng;
      
      public static var ReduceResIconPng:Class = EffectPiece_ReduceResIconPng;
      
      public static var ReduceIntIconPng:Class = EffectPiece_ReduceIntIconPng;
      
      public static const MAX_LEVEL:uint = 15;
      
      private static const _classinfo:Object = {
         "name":"EffectPiece",
         "cls":EffectPiece
      };
       
      
      public var id:uint;
      
      public var pp_cost:Number;
      
      public var pp_cost_level:Number;
      
      public var max_slots:uint;
      
      public var pre_connector:int;
      
      public var post_connector:int;
      
      public var modifier_connector:int;
      
      public var effect_id:uint;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public function EffectPiece(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : EffectPiece
      {
         return StaticData.getInstance(param1,"id","EffectPiece");
      }
      
      override public function get classinfo() : Object
      {
         return EffectPiece.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get effect() : Effect
      {
         return Effect.getInstanceById(this.effect_id);
      }
      
      public function canConnectTo(param1:EffectPiece) : Boolean
      {
         return this.top.canConnectTo(param1.bottom);
      }
      
      public function instantiate() : EffectPieceInstance
      {
         var _loc1_:EffectPieceInstance = new EffectPieceInstance();
         _loc1_.effect_piece_id = this.id;
         return _loc1_;
      }
      
      public function get top() : Connector
      {
         return new Connector(this.pre_connector);
      }
      
      public function get bottom() : Connector
      {
         return new Connector(this.post_connector);
      }
      
      public function get right() : Connector
      {
         return new Connector(this.modifier_connector);
      }
      
      public function get left() : Connector
      {
         return null;
      }
      
      public function get editable() : Boolean
      {
         return false;
      }
      
      public function get color() : Color
      {
         switch(this.effect.type)
         {
            case Effect.TYPE_ATTACK:
               return new Color(16711680);
            case Effect.TYPE_DAMAGE:
               return new Color(16776960);
            case Effect.TYPE_BLOCK:
               return new Color(65280);
            case Effect.TYPE_FIZZLE:
               return new Color(65535);
            case Effect.TYPE_RESTORATION:
               return new Color(255);
            case Effect.TYPE_DISPEL:
               if(this.effect.targets == Effect.TARGET_SELF)
               {
                  return new Color(8913151);
               }
               return new Color(16711816);
               break;
            case Effect.TYPE_CONDITION:
               if(this.effect.targets == Effect.TARGET_SELF)
               {
                  return new Color(35071);
               }
               return new Color(65416);
               break;
            default:
               return new Color(16777215);
         }
      }
      
      public function getNumber(param1:EffectPiece) : String
      {
         return "";
      }
      
      public function get level() : int
      {
         return 1;
      }
      
      public function set level(param1:int) : void
      {
         throw new Error("Cant set level of static EffectPiece");
      }
      
      public function get level_delta() : int
      {
         return 0;
      }
      
      public function set level_delta(param1:int) : void
      {
         throw new Error("Cant set level_delta of static EffectPiece");
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
         switch(this.effect.type)
         {
            case Effect.TYPE_ATTACK:
               switch(this.effect.attack_type)
               {
                  case Effect.ATTACK_TYPE_CLAW:
                     return ClawIconPng;
                  case Effect.ATTACK_TYPE_BITE:
                     return BiteIconPng;
                  case Effect.ATTACK_TYPE_CRUSH:
                     return CrushIconPng;
                  case Effect.ATTACK_TYPE_SPEAR:
                     return SpearIconPng;
                  default:
                     return ClawIconPng;
               }
               break;
            case Effect.TYPE_DAMAGE:
               return BreathIconPng;
            case Effect.TYPE_BLOCK:
               return BlockIconPng;
            case Effect.TYPE_FIZZLE:
               return FizzleIconPng;
            case Effect.TYPE_RESTORATION:
               return RestoreIconPng;
            case Effect.TYPE_DISPEL:
               return DispelIconPng;
            case Effect.TYPE_CONDITION:
               if(this.effect.condition_type & Condition.TYPE_PREVENT_MOVEMENT)
               {
                  return PreventMoveIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_PREVENT_THINKING)
               {
                  return PreventThinkIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_PREVENT_AI)
               {
                  return PreventAiIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_BOOST_STRENGTH)
               {
                  return BoostStrIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_BOOST_SPEED)
               {
                  return BoostAgiIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_BOOST_RESILIENCE)
               {
                  return BoostResIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_BOOST_INTELLIGENCE)
               {
                  return BoostIntIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_REDUCE_STRENGTH)
               {
                  return ReduceStrIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_REDUCE_SPEED)
               {
                  return ReduceAgiIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_REDUCE_RESILIENCE)
               {
                  return ReduceResIconPng;
               }
               if(this.effect.condition_type & Condition.TYPE_REDUCE_INTELLIGENCE)
               {
                  return ReduceIntIconPng;
               }
               break;
         }
         return null;
      }
      
      public function get_slot_count(param1:uint) : uint
      {
         if(param1 >= 15)
         {
            return Math.min(this.max_slots,4);
         }
         if(param1 >= 10)
         {
            return Math.min(this.max_slots,3);
         }
         if(param1 >= 5)
         {
            return Math.min(this.max_slots,2);
         }
         if(param1 >= 2)
         {
            return Math.min(this.max_slots,1);
         }
         return 0;
      }
      
      public function get descriptionAsset() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
      
      public function get targetDescription() : String
      {
         var _loc1_:String = null;
         if(this.effect.targets & Effect.TARGET_SELF)
         {
            _loc1_ = Asset.getInstanceByName("SELF").value;
         }
         else
         {
            if(!(this.effect.targets & Effect.TARGET_ENEMY))
            {
               throw new Error("Unkown target type");
            }
            _loc1_ = Asset.getInstanceByName("ENEMY").value;
         }
         return _loc1_;
      }
      
      public function getLevelDescription(param1:uint, param2:EffectPiece, param3:CreatureInstance = null) : String
      {
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc4_:* = "";
         _loc4_ = (_loc4_ = Utils.htmlWrap(Utils.capitalizeFirst(this.name.value),null,null,0,true) + "<br>") + (Utils.htmlWrap(this.descriptionAsset.value,null,null,0) + "<br>");
         var _loc5_:String = "";
         var _loc6_:* = "";
         var _loc7_:uint = this.get_slot_count(param1);
         var _loc8_:uint;
         if((_loc8_ = uint(this.max_slots - _loc7_)) > 0)
         {
            _loc11_ = 0;
            while(this.get_slot_count(param1 + ++_loc11_) == _loc7_)
            {
            }
            if(_loc11_ > 1)
            {
               _loc6_ += Utils.formatString(Asset.getInstanceByName("MAX_PIECES_CAPACITY_PL").value,{
                  "max":Utils.htmlWrap(this.max_slots.toString(),null,"#FFFF77"),
                  "amount":Utils.htmlWrap(_loc11_.toString(),null,"#FFFF77")
               }) + "<br>";
            }
            else
            {
               _loc6_ += Utils.formatString(Asset.getInstanceByName("MAX_PIECES_CAPACITY").value,{
                  "max":Utils.htmlWrap(this.max_slots.toString(),null,"#FFFF77"),
                  "amount":Utils.htmlWrap(_loc11_.toString(),null,"#FFFF77")
               }) + "<br>";
            }
         }
         var _loc9_:String = Utils.round(this.pp_cost + this.pp_cost_level * param1,0).toString();
         _loc9_ = Utils.htmlWrap(_loc9_,null,5635925,0,true);
         _loc6_ = (_loc6_ += _loc9_ + " " + Asset.getInstanceByName("PP").value) + ("   " + Asset.getInstanceByName("NEXT_LEVEL").value + " ");
         if(param1 < MAX_LEVEL)
         {
            _loc9_ = Utils.round(this.pp_cost + this.pp_cost_level * (param1 + 1),0).toString();
            _loc9_ = Utils.htmlWrap(_loc9_,null,5635925,0,true);
            _loc6_ += _loc9_ + " " + Asset.getInstanceByName("PP").value;
         }
         else
         {
            _loc6_ += Utils.htmlWrap("-",null,5635925,0,true);
         }
         _loc6_ += "<br>";
         var _loc10_:String = this.targetDescription;
         _loc6_ += Utils.capitalizeFirst(_loc10_) + "<br>";
         if(this.effect.requiresMoving || this.effect.requiresThinking)
         {
            _loc12_ = Asset.getInstanceByName("REQUIRES").value;
            _loc13_ = new Array();
            if(this.effect.requiresMoving)
            {
               _loc13_.push(Asset.getInstanceByName("MOVEMENT").value);
            }
            if(this.effect.requiresThinking)
            {
               _loc13_.push(Asset.getInstanceByName("THINKING").value);
            }
            _loc12_ += " " + _loc13_.join(", ");
            _loc6_ += Utils.capitalizeFirst(_loc12_) + "<br>";
         }
         _loc6_ += this.effect.getDescription(param1);
         if(Boolean(param3) && param1 < EffectPiece.MAX_LEVEL)
         {
            _loc14_ = int(param3.creature.category.level_caps[param1]);
            if(param3.level < _loc14_)
            {
               _loc6_ = (_loc6_ += Utils.htmlWrap(Utils.capitalizeFirst(Utils.formatString(Asset.getInstanceByName("SKILL_MIN_LEVEL_REQUIRED").value,{"level":_loc14_})),null,16711680,0,true)) + "<br>";
            }
         }
         _loc6_ = Utils.htmlWrap(_loc6_,null,null,UIGlobals.styleManager.getStyle("SmallFontSize",9));
         return _loc4_ + _loc6_;
      }
      
      public function getDescription(param1:EffectPiece, param2:CreatureInstance = null) : String
      {
         return this.getLevelDescription(this.modifiedLevel,param1,param2);
      }
      
      public function get priority() : int
      {
         return this.effect.type * 1000 + this.effect.attack_type + this.effect.condition_type;
      }
   }
}
