package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class TraitInstance extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"TraitInstance",
         "cls":TraitInstance
      };
       
      
      public var id:uint;
      
      public var trait_id:uint;
      
      private var _min_level:int = 0;
      
      private var _level:int = 0;
      
      private var _level_delta:int = 0;
      
      public function TraitInstance(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get trait() : Trait
      {
         return Trait.getInstanceById(this.trait_id);
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.trait_id = this.trait_id;
         param1.level = this.level;
         param1.level_delta = this.level_delta;
         param1.min_level = this.min_level;
      }
      
      public function getDescription(param1:CreatureInstance = null) : String
      {
         return this.trait.getLevelDescription(this.modifiedLevel,param1);
      }
      
      public function get min_level() : int
      {
         return this._min_level;
      }
      
      public function set min_level(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.min_level != param1)
         {
            _loc2_ = this.min_level;
            this._min_level = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"min_level",_loc2_,this.min_level));
            dispatchEvent(PropertyChangeEvent.create(this,"upgradableLevel",0,this.upgradableLevel));
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
            dispatchEvent(PropertyChangeEvent.create(this,"modifiedLevel",0,this.modifiedLevel));
            dispatchEvent(PropertyChangeEvent.create(this,"upgradableLevel",0,this.upgradableLevel));
         }
      }
      
      public function canUpgrade(param1:CreatureInstance) : Boolean
      {
         var _loc2_:Array = param1.creature.category.level_caps;
         return this.upgradableLevel < Trait.MAX_LEVEL && _loc2_[this.modifiedLevel] <= param1.level;
      }
      
      public function get modifiedLevel() : int
      {
         return Math.min(Trait.MAX_LEVEL,this._level + this._level_delta);
      }
      
      public function get upgradableLevel() : int
      {
         return this._min_level + this._level_delta;
      }
      
      public function get spentSkillPoints() : int
      {
         return Math.abs(this.level_delta);
      }
      
      public function marshal() : Object
      {
         var _loc1_:Object = {};
         _loc1_.id = this.id;
         _loc1_.level = this.modifiedLevel;
         return _loc1_;
      }
   }
}
