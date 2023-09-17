package com.edgebee.breedr.data.effect
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.util.Utils;
   
   public class Effect extends StaticData
   {
      
      public static const TYPE_ATTACK:Number = 1;
      
      public static const TYPE_DAMAGE:Number = 2;
      
      public static const TYPE_RESTORATION:Number = 3;
      
      public static const TYPE_BLOCK:Number = 4;
      
      public static const TYPE_CONDITION:Number = 5;
      
      public static const TYPE_DISPEL:Number = 6;
      
      public static const TYPE_FIZZLE:Number = 7;
      
      public static const TYPE_NAMES:Object = {
         1:"EFFECT_PIECE_ATTACK_NAME",
         2:"EFFECT_PIECE_DAMAGE_NAME",
         3:"EFFECT_PIECE_RESTORATION_NAME",
         4:"EFFECT_PIECE_BLOCK_NAME",
         5:"EFFECT_PIECE_CONDITION_NAME",
         6:"EFFECT_PIECE_DISPEL_NAME",
         7:"EFFECT_PIECE_FIZZLE_NAME"
      };
      
      public static const ATTACK_TYPE_CLAW:Number = 0;
      
      public static const ATTACK_TYPE_BITE:Number = 1;
      
      public static const ATTACK_TYPE_CRUSH:Number = 2;
      
      public static const ATTACK_TYPE_SPEAR:Number = 3;
      
      public static const TARGET_NONE:int = 0;
      
      public static const TARGET_SELF:int = 1;
      
      public static const TARGET_ENEMY:int = 4;
      
      public static const FLAG_IS_EMPTY:int = 1;
      
      public static const FLAG_IS_TRAIT:int = 2;
      
      public static const FLAG_REQUIRES_MOVING:int = 4;
      
      public static const FLAG_REQUIRES_THINKING:int = 8;
      
      public static const FLAG_IS_COUNTER:int = 16;
      
      public static const FLAG_CANNOT_BE_COUNTERED:int = 32;
      
      private static const _classinfo:Object = {
         "name":"Effect",
         "cls":Effect
      };
       
      
      public var id:uint;
      
      public var type:int;
      
      public var condition_type:int;
      
      public var attack_type:int;
      
      public var flags:int;
      
      public var targets:int;
      
      public var modifiers:DataArray;
      
      public var secondaries:Array;
      
      public function Effect(param1:Object = null)
      {
         this.secondaries = [];
         this.modifiers = new DataArray(Modifier.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Effect
      {
         return StaticData.getInstance(param1,"id","Effect");
      }
      
      override public function get classinfo() : Object
      {
         return Effect.classinfo;
      }
      
      override public function reset() : void
      {
         this.modifiers.reset();
         this.secondaries = [];
         super.reset();
      }
      
      public function get secondaryEffects() : Array
      {
         var _loc2_:uint = 0;
         var _loc1_:Array = [];
         for each(_loc2_ in this.secondaries)
         {
            _loc1_.push(Effect.getInstanceById(_loc2_));
         }
         return _loc1_;
      }
      
      public function get requiresMoving() : Boolean
      {
         return (this.flags & FLAG_REQUIRES_MOVING) != 0;
      }
      
      public function get requiresThinking() : Boolean
      {
         return (this.flags & FLAG_REQUIRES_THINKING) != 0;
      }
      
      public function get isCounter() : Boolean
      {
         return (this.flags & FLAG_IS_COUNTER) != 0;
      }
      
      public function get cannotBeCountered() : Boolean
      {
         return (this.flags & FLAG_CANNOT_BE_COUNTERED) != 0;
      }
      
      public function getDescription(param1:uint, param2:uint = 0) : String
      {
         var _loc4_:Modifier = null;
         var _loc5_:Effect = null;
         var _loc3_:String = "";
         for each(_loc4_ in this.modifiers)
         {
            if(_loc4_.min_level <= param1 && !_loc4_.hidden)
            {
               _loc3_ += Utils.getIndent(param2 + 1) + _loc4_.getDescription(param1 - _loc4_.min_level) + "<br>";
            }
         }
         for each(_loc5_ in this.secondaryEffects)
         {
            _loc3_ += _loc5_.getDescription(param1,param2);
         }
         return _loc3_;
      }
   }
}
