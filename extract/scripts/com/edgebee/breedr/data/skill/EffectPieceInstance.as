package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Element;
   
   public class EffectPieceInstance extends Data implements Piece
   {
      
      private static const _classinfo:Object = {
         "name":"EffectPieceInstance",
         "cls":EffectPieceInstance
      };
       
      
      public var id:uint;
      
      public var pp_cost:uint;
      
      public var pieces:DataArray;
      
      private var _effect_piece_id:uint;
      
      private var _level:int = 1;
      
      private var _level_delta:int = 0;
      
      public function EffectPieceInstance(param1:Object = null)
      {
         this.pieces = new DataArray(ModifierPieceInstance.classinfo);
         this.pieces.trackContentChanges = true;
         this.pieces.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPiecesChange);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get effect_piece() : EffectPiece
      {
         return EffectPiece.getInstanceById(this.effect_piece_id);
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc2_:ModifierPieceInstance = null;
         var _loc4_:ModifierPieceInstance = null;
         param1.id = this.id;
         param1.effect_piece_id = this.effect_piece_id;
         param1.level = this.level;
         param1.level_delta = this.level_delta;
         param1.pp_cost = this.pp_cost;
         var _loc3_:Array = [];
         for each(_loc4_ in this.pieces)
         {
            _loc2_ = new ModifierPieceInstance();
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
      
      public function get slot_count() : uint
      {
         if(this.effect_piece)
         {
            return this.effect_piece.get_slot_count(this.modifiedLevel);
         }
         return 1;
      }
      
      public function get effect_piece_id() : uint
      {
         return this._effect_piece_id;
      }
      
      public function set effect_piece_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.effect_piece_id != param1)
         {
            _loc2_ = this.effect_piece_id;
            this._effect_piece_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"effect_piece_id",_loc2_,this.effect_piece_id));
            dispatchEvent(PropertyChangeEvent.create(this,"slot_count",0,this.slot_count));
         }
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.level != param1)
         {
            _loc2_ = this.level;
            this._level = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level",_loc2_,this.level));
            dispatchEvent(PropertyChangeEvent.create(this,"slot_count",0,this.slot_count));
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
         if(this.level_delta != param1)
         {
            _loc2_ = this.level_delta;
            this._level_delta = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level_delta",_loc2_,this.level_delta));
            dispatchEvent(PropertyChangeEvent.create(this,"slot_count",0,this.slot_count));
            dispatchEvent(PropertyChangeEvent.create(this,"modifiedLevel",0,this.modifiedLevel));
         }
      }
      
      public function canUpgrade(param1:CreatureInstance) : Boolean
      {
         var _loc2_:Array = param1.creature.category.level_caps;
         return this.modifiedLevel < EffectPiece.MAX_LEVEL && _loc2_[this.modifiedLevel] <= param1.level;
      }
      
      public function get modifiedLevel() : int
      {
         return this._level + this._level_delta;
      }
      
      public function get full() : Boolean
      {
         return this.slot_count == this.pieces.length;
      }
      
      public function get element() : Element
      {
         var _loc1_:ModifierPieceInstance = null;
         for each(_loc1_ in this.pieces)
         {
            switch(_loc1_.modifier_piece.type)
            {
               case ModifierPiece.TYPE_FIRE:
                  return Element.getInstanceByType(Element.TYPE_FIRE);
               case ModifierPiece.TYPE_ICE:
                  return Element.getInstanceByType(Element.TYPE_ICE);
               case ModifierPiece.TYPE_THUNDER:
                  return Element.getInstanceByType(Element.TYPE_THUNDER);
               case ModifierPiece.TYPE_EARTH:
                  return Element.getInstanceByType(Element.TYPE_EARTH);
            }
         }
         return null;
      }
      
      public function marshal() : Object
      {
         var _loc2_:ModifierPieceInstance = null;
         var _loc1_:Object = {};
         _loc1_.id = this.id;
         _loc1_.effect_piece_id = this.effect_piece_id;
         _loc1_.level = this.modifiedLevel;
         _loc1_.pieces = [];
         for each(_loc2_ in this.pieces)
         {
            _loc1_.pieces.push(_loc2_.marshal());
         }
         return _loc1_;
      }
      
      public function get editable() : Boolean
      {
         return this.id == 0;
      }
      
      public function get color() : Color
      {
         return this.effect_piece.color;
      }
      
      public function getNumber(param1:EffectPiece) : String
      {
         return this.slot_count.toString();
      }
      
      public function get icon() : Class
      {
         return this.effect_piece.icon;
      }
      
      public function get top() : Connector
      {
         return this.effect_piece.top;
      }
      
      public function get left() : Connector
      {
         return this.effect_piece.left;
      }
      
      public function get right() : Connector
      {
         return this.effect_piece.right;
      }
      
      public function get bottom() : Connector
      {
         return this.effect_piece.bottom;
      }
      
      private function onPiecesChange(param1:CollectionEvent) : void
      {
         dispatchEvent(PropertyChangeEvent.create(this,"pieces",this.pieces,this.pieces));
      }
      
      public function getDescription(param1:EffectPiece, param2:CreatureInstance = null) : String
      {
         return this.effect_piece.getLevelDescription(this.modifiedLevel,param1,param2);
      }
      
      public function get priority() : int
      {
         return this.effect_piece.priority;
      }
   }
}
