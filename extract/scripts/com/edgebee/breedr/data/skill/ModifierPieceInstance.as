package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.effect.Modifier;
   
   public class ModifierPieceInstance extends Data implements Piece
   {
      
      private static const _classinfo:Object = {
         "name":"ModifierPieceInstance",
         "cls":ModifierPieceInstance
      };
       
      
      public var is_static:Boolean;
      
      public var modifier_piece_id:uint;
      
      public var index:uint;
      
      public var modifiers:DataArray;
      
      private var _level:int = 1;
      
      private var _level_delta:int = 0;
      
      public function ModifierPieceInstance(param1:Object = null)
      {
         this.modifiers = new DataArray(Modifier.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function reset() : void
      {
         this.modifiers.reset();
         super.reset();
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.level != param1)
         {
            _loc2_ = this.level;
            _loc3_ = this.power;
            this._level = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level",_loc2_,this.level));
            dispatchEvent(PropertyChangeEvent.create(this,"power",_loc3_,this.power));
            dispatchEvent(PropertyChangeEvent.create(this,"modifiedLevel",0,this.modifiedLevel));
         }
      }
      
      public function get level_delta() : int
      {
         return this._level_delta;
      }
      
      public function set level_delta(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.level_delta != param1)
         {
            _loc2_ = this.level_delta;
            _loc3_ = this.power;
            this._level_delta = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level_delta",_loc2_,this.level_delta));
            dispatchEvent(PropertyChangeEvent.create(this,"power",_loc3_,this.power));
            dispatchEvent(PropertyChangeEvent.create(this,"modifiedLevel",0,this.modifiedLevel));
         }
      }
      
      public function canUpgrade(param1:CreatureInstance) : Boolean
      {
         return this.modifiedLevel < EffectPiece.MAX_LEVEL && param1.creature.category.level_caps[this.modifiedLevel] <= param1.level;
      }
      
      public function get modifiedLevel() : int
      {
         return this._level + this._level_delta;
      }
      
      public function get power() : int
      {
         if(this.modifier_piece)
         {
            return this.modifier_piece.add + this.modifier_piece.add_level * this.modifiedLevel;
         }
         return 0;
      }
      
      public function get modifier_piece() : ModifierPiece
      {
         return ModifierPiece.getInstanceById(this.modifier_piece_id);
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc3_:Modifier = null;
         var _loc5_:Modifier = null;
         var _loc2_:ModifierPieceInstance = param1 as ModifierPieceInstance;
         _loc2_.is_static = this.is_static;
         _loc2_.index = this.index;
         _loc2_.level = this.level;
         _loc2_.level_delta = this.level_delta;
         _loc2_.modifier_piece_id = this.modifier_piece_id;
         var _loc4_:Array = [];
         for each(_loc5_ in this.modifiers)
         {
            _loc3_ = new Modifier();
            _loc5_.copyTo(_loc3_);
            _loc4_.push(_loc3_);
         }
         _loc2_.modifiers.source = _loc4_;
      }
      
      public function marshal() : Object
      {
         var _loc1_:Object = {};
         _loc1_.id = this.modifier_piece_id;
         _loc1_.level = this.modifiedLevel;
         return _loc1_;
      }
      
      public function getDescription(param1:EffectPiece, param2:CreatureInstance = null) : String
      {
         return this.modifier_piece.getLevelDescription(this.modifiedLevel,param1,param2);
      }
      
      public function get editable() : Boolean
      {
         return !this.is_static;
      }
      
      public function get color() : Color
      {
         return this.modifier_piece.color;
      }
      
      public function getNumber(param1:EffectPiece) : String
      {
         return this.modifier_piece.getLevelNumber(param1,this.modifiedLevel + 1);
      }
      
      public function get icon() : Class
      {
         return this.modifier_piece.icon;
      }
      
      public function get top() : Connector
      {
         return this.modifier_piece.top;
      }
      
      public function get left() : Connector
      {
         return this.modifier_piece.left;
      }
      
      public function get right() : Connector
      {
         return this.modifier_piece.right;
      }
      
      public function get bottom() : Connector
      {
         return this.modifier_piece.bottom;
      }
      
      public function get priority() : int
      {
         return this.modifier_piece.priority;
      }
   }
}
