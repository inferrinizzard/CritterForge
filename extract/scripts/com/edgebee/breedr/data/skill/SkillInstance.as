package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Element;
   import com.edgebee.breedr.data.effect.Effect;
   
   public class SkillInstance extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SkillInstance",
         "cls":SkillInstance
      };
      
      public static const FLAG_REQUIRES_SPEAKING:Number = 1;
      
      public static const FLAG_REQUIRES_MOVING:Number = 2;
      
      public static const FLAG_IS_SPELL:Number = 4;
      
      public static const FLAG_IS_TRAIT:Number = 8;
      
      public static const FLAG_IS_COUNTER:Number = 16;
      
      public static const FLAG_CANNOT_BE_COUNTERED:Number = 32;
      
      public static const SOUND_TYPE_ATTACK:String = "SOUND_TYPE_ATTACK";
      
      public static const SOUND_TYPE_DAMAGE:String = "SOUND_TYPE_DAMAGE";
      
      public static const SOUND_TYPE_ELEMENTAL:String = "SOUND_TYPE_ATTACK";
      
      public static const SOUND_TYPE_ACTION:String = "SOUND_TYPE_ACTION";
       
      
      public var id:uint;
      
      public var is_trait:Boolean;
      
      public var targets:int;
      
      public var flags:int;
      
      public var pp_cost:uint;
      
      public var pieces:DataArray;
      
      public var rule_id:uint;
      
      public var rule_targets_enemy:Boolean;
      
      public var originalIndex:uint;
      
      private var _hidden:Boolean;
      
      private var _name:String;
      
      public function SkillInstance(param1:Object = null)
      {
         this.pieces = new DataArray(EffectPieceInstance.classinfo);
         this.pieces.trackContentChanges = true;
         this.pieces.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPiecesChange);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc4_:EffectPieceInstance = null;
         param1.id = this.id;
         param1.is_trait = this.is_trait;
         param1.targets = this.targets;
         param1.flags = this.flags;
         param1.pp_cost = this.pp_cost;
         param1.name = this.name;
         param1.originalIndex = this.originalIndex;
         param1.rule_id = this.rule_id;
         param1.rule_targets_enemy = this.rule_targets_enemy;
         var _loc3_:Array = [];
         for each(_loc4_ in this.pieces)
         {
            _loc2_ = new EffectPieceInstance();
            _loc4_.copyTo(_loc2_);
            _loc3_.push(_loc2_);
         }
         param1.pieces.source = _loc3_;
      }
      
      override public function reset() : void
      {
         this.pieces.reset();
         super.reset();
      }
      
      public function get primary() : EffectPieceInstance
      {
         return this.pieces[0] as EffectPieceInstance;
      }
      
      public function get secondary() : EffectPieceInstance
      {
         if(this.pieces.length > 1)
         {
            return this.pieces[1] as EffectPieceInstance;
         }
         return null;
      }
      
      public function get soundType() : String
      {
         if(this.pieces.length > 0)
         {
            switch(this.primary.effect_piece.effect.type)
            {
               case Effect.TYPE_ATTACK:
                  return SOUND_TYPE_ATTACK;
               case Effect.TYPE_DAMAGE:
                  if(this.primary.element != null)
                  {
                     return SOUND_TYPE_ELEMENTAL;
                  }
                  return SOUND_TYPE_DAMAGE;
            }
         }
         return SOUND_TYPE_ACTION;
      }
      
      public function get primaryType() : Number
      {
         if(this.pieces.length > 0)
         {
            return this.primary.effect_piece.effect.type;
         }
         return 0;
      }
      
      public function get primaryElementType() : Element
      {
         if(this.pieces.length > 0)
         {
            return this.primary.element;
         }
         return null;
      }
      
      public function get dynamicPPCost() : uint
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc3_:ModifierPieceInstance = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.pieces)
         {
            _loc1_ += Utils.round(_loc2_.effect_piece.pp_cost + _loc2_.effect_piece.pp_cost_level * (_loc2_.level + _loc2_.level_delta),0);
            for each(_loc3_ in _loc2_.pieces)
            {
               _loc1_ += Utils.round(_loc3_.modifier_piece.pp_cost + _loc3_.modifier_piece.pp_cost_level * (_loc3_.level + _loc3_.level_delta),0);
            }
         }
         return _loc1_;
      }
      
      public function get temporaryPieces() : Array
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc3_:ModifierPieceInstance = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.pieces)
         {
            if(_loc2_.id == 0)
            {
               _loc1_.push(_loc2_);
            }
            else
            {
               for each(_loc3_ in _loc2_.pieces)
               {
                  if(!_loc3_.is_static)
                  {
                     _loc1_.push(_loc3_);
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function removePiece(param1:Piece, param2:CreatureInstance = null) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:Piece = null;
         var _loc8_:Array = null;
         var _loc9_:ModifierPieceInstance = null;
         var _loc3_:Array = [];
         var _loc4_:Array;
         var _loc5_:int = (_loc4_ = this.orderedPieces).indexOf(param1);
         if(param1 is EffectPieceInstance && this.pieces.getItemIndex(param1) != -1)
         {
            _loc3_.push(param1);
            _loc6_ = _loc5_ + 1;
            while(_loc6_ < _loc4_.length)
            {
               _loc3_.push(_loc4_[_loc6_]);
               _loc6_++;
            }
            _loc8_ = _loc3_.reverse();
            for each(_loc7_ in _loc8_)
            {
               if(_loc7_ is EffectPieceInstance)
               {
                  if(param2)
                  {
                     param2.skill_points_delta += _loc7_.level_delta;
                     for each(_loc9_ in (_loc7_ as EffectPieceInstance).pieces)
                     {
                        param2.skill_points_delta += _loc9_.level_delta;
                     }
                  }
                  this.pieces.removeItem(_loc7_);
               }
            }
         }
         else if(param1 is ModifierPieceInstance)
         {
            _loc3_.push(param1);
            _loc6_ = _loc5_ + 1;
            while(_loc6_ < _loc4_.length && !(_loc4_[_loc6_] is EffectPieceInstance))
            {
               _loc3_.push(_loc4_[_loc6_]);
               _loc6_++;
            }
            for each(_loc7_ in this.pieces)
            {
               if((_loc7_ as EffectPieceInstance).pieces.getItemIndex(param1) >= 0)
               {
                  break;
               }
            }
            for each(param1 in _loc3_)
            {
               if(param2)
               {
                  param2.skill_points_delta += param1.level_delta;
               }
               (_loc7_ as EffectPieceInstance).pieces.removeItem(param1);
            }
         }
         return _loc3_;
      }
      
      private function get orderedPieces() : Array
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc3_:ModifierPieceInstance = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.pieces)
         {
            _loc1_.push(_loc2_);
            for each(_loc3_ in _loc2_.pieces)
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function get hidden() : Boolean
      {
         return this._hidden;
      }
      
      public function set hidden(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this.hidden != param1)
         {
            _loc2_ = this._hidden;
            this._hidden = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"hidden",_loc2_,param1));
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.name != param1)
         {
            _loc2_ = this._name;
            this._name = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"name",_loc2_,param1));
         }
      }
      
      public function get rule() : Rule
      {
         return Rule.getInstanceById(this.rule_id);
      }
      
      public function marshal(param1:uint) : Object
      {
         var _loc3_:EffectPieceInstance = null;
         var _loc2_:Object = {};
         _loc2_.skill_id = this.id;
         _loc2_.index = param1;
         _loc2_.name = this.name;
         _loc2_.rule_id = this.rule_id;
         _loc2_.rule_targets_enemy = this.rule_targets_enemy;
         _loc2_.pieces = [];
         for each(_loc3_ in this.pieces)
         {
            _loc2_.pieces.push(_loc3_.marshal());
         }
         return _loc2_;
      }
      
      private function onPiecesChange(param1:CollectionEvent) : void
      {
         dispatchEvent(PropertyChangeEvent.create(this,"pieces",this.pieces,this.pieces));
      }
   }
}
