package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.combat.Condition;
   import com.edgebee.breedr.data.skill.SkillInstance;
   import com.edgebee.breedr.data.skill.Trait;
   import com.edgebee.breedr.data.skill.TraitInstance;
   
   public class CreatureInstance extends Data
   {
      
      public static const MIN_NAME_LENGTH:uint = 3;
      
      public static const MAX_NAME_LENGTH:uint = 16;
      
      private static const _classinfo:Object = {
         "name":"CreatureInstance",
         "cls":CreatureInstance
      };
       
      
      public var id:uint;
      
      public var owner:Player;
      
      public var creature_id:uint;
      
      public var skills:DataArray;
      
      public var traits:DataArray;
      
      public var conditions:ArrayCollection;
      
      public var rankingNeighbours:DataArray;
      
      public var is_sterile:Boolean;
      
      public var is_quest:Boolean;
      
      public var fight_credits:uint;
      
      public var max_seed_count:uint;
      
      public var _traitsAndCreature:ArrayCollection;
      
      private var _is_male:Boolean;
      
      private var _name:String;
      
      private var _hue:int;
      
      private var _level:int;
      
      private var _max_level:int;
      
      private var _level_progress:Number;
      
      private var _rank:int;
      
      private var _rank_delta:int;
      
      private var _seed_count:int;
      
      private var _happiness:uint;
      
      private var _health:uint;
      
      private var _stamina_id:uint;
      
      private var _max_stamina_id:uint;
      
      private var _horns_id:uint;
      
      private var _wings_id:uint;
      
      private var _mouth_id:uint;
      
      private var _claws_id:uint;
      
      private var _dorsal_id:uint;
      
      private var _tail_id:uint;
      
      private var _horns_element_id:uint;
      
      private var _wings_element_id:uint;
      
      private var _mouth_element_id:uint;
      
      private var _claws_element_id:uint;
      
      private var _dorsal_element_id:uint;
      
      private var _tail_element_id:uint;
      
      private var _max_hp:int;
      
      private var _hp:int;
      
      private var _max_pp:int;
      
      private var _pp:int;
      
      private var _skill_points:int;
      
      private var _skill_points_delta:int;
      
      private var _wins:int;
      
      private var _ties:int;
      
      private var _losses:int;
      
      private var _team_id:uint;
      
      private var _auction_id:uint;
      
      public var hatch_at:Date;
      
      private var _egg_time_left:Number;
      
      public var wakeup_at:Date;
      
      private var _sleep_time_left:Number;
      
      private var _respec_count:uint;
      
      private var _respec_expiration:uint;
      
      public var addToTeamTime:Date;
      
      private var _cant_add_until:Number;
      
      public function CreatureInstance(param1:Object = null)
      {
         this.owner = new Player();
         this.skills = new DataArray(SkillInstance.classinfo);
         this.skills.trackContentChanges = true;
         this.skills.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSkillsChange);
         this.traits = new DataArray(TraitInstance.classinfo);
         this.traits.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onTraitsChange);
         this.conditions = new ArrayCollection();
         this.rankingNeighbours = new DataArray(CreatureInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override protected function finalize() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.skills.length)
         {
            this.skills[_loc1_].originalIndex = _loc1_;
            _loc1_++;
         }
      }
      
      public function get creature() : Creature
      {
         return Creature.getInstanceById(this.creature_id);
      }
      
      public function get modifiable_skills() : ArrayCollection
      {
         return new ArrayCollection(this.skills.source.slice(1));
      }
      
      public function get traitsAndCreature() : ArrayCollection
      {
         var _loc1_:Array = null;
         var _loc2_:TraitInstance = null;
         if(!this._traitsAndCreature)
         {
            _loc1_ = [];
            for each(_loc2_ in this.traits)
            {
               _loc1_.push({
                  "trait":_loc2_,
                  "creature":this
               });
            }
            this._traitsAndCreature = new ArrayCollection(_loc1_);
         }
         return this._traitsAndCreature;
      }
      
      public function get swf_url() : String
      {
         return this.creature.url;
      }
      
      public function get isEgg() : Boolean
      {
         return this.level == 0;
      }
      
      public function get is_male() : Boolean
      {
         return this._is_male;
      }
      
      public function set is_male(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._is_male != param1)
         {
            _loc2_ = this._is_male;
            this._is_male = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"is_male",_loc2_,param1));
         }
      }
      
      public function get name() : String
      {
         if(this._name)
         {
            return this._name;
         }
         if(this.creature)
         {
            return this.creature.name.value;
         }
         return null;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._name != param1)
         {
            _loc2_ = this._name;
            this._name = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"name",_loc2_,param1));
         }
      }
      
      public function get isNamed() : Boolean
      {
         return Boolean(this._name) && this._name.length > 0;
      }
      
      public function get hue() : int
      {
         return this._hue;
      }
      
      public function set hue(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.hue != param1)
         {
            _loc2_ = this._hue;
            this._hue = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"hue",_loc2_,param1));
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
            _loc2_ = this._level;
            this._level = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level",_loc2_,param1));
         }
      }
      
      public function get max_level() : int
      {
         return this._max_level;
      }
      
      public function set max_level(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.max_level != param1)
         {
            _loc2_ = this._max_level;
            this._max_level = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"max_level",_loc2_,param1));
         }
      }
      
      public function get level_progress() : Number
      {
         return this._level_progress;
      }
      
      public function set level_progress(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.level_progress != param1)
         {
            _loc2_ = this._level_progress;
            this._level_progress = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level_progress",_loc2_,param1));
         }
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      public function set rank(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.rank != param1)
         {
            _loc2_ = this._rank;
            this._rank = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"rank",_loc2_,param1));
         }
      }
      
      public function get rank_delta() : int
      {
         return this._rank_delta;
      }
      
      public function set rank_delta(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.rank_delta != param1)
         {
            _loc2_ = this._rank_delta;
            this._rank_delta = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"rank_delta",_loc2_,param1));
         }
      }
      
      public function get seed_count() : int
      {
         return this._seed_count;
      }
      
      public function set seed_count(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.seed_count != param1)
         {
            _loc2_ = this._seed_count;
            this._seed_count = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"seed_count",_loc2_,param1));
         }
      }
      
      public function get happiness() : uint
      {
         return this._happiness;
      }
      
      public function set happiness(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._happiness != param1)
         {
            _loc2_ = this._happiness;
            this._happiness = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"happiness",_loc2_,this.happiness));
         }
      }
      
      public function get health() : uint
      {
         return this._health;
      }
      
      public function set health(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._health != param1)
         {
            _loc2_ = this._health;
            this._health = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"health",_loc2_,this.health));
         }
      }
      
      public function get stamina() : StaminaLevel
      {
         return StaminaLevel.getInstanceById(this.stamina_id);
      }
      
      public function get stamina_id() : uint
      {
         return this._stamina_id;
      }
      
      public function set stamina_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._stamina_id != param1)
         {
            _loc2_ = this._stamina_id;
            this._stamina_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"stamina",StaminaLevel.getInstanceById(_loc2_),this.stamina));
         }
      }
      
      public function get max_stamina() : StaminaLevel
      {
         return StaminaLevel.getInstanceById(this.max_stamina_id);
      }
      
      public function get max_stamina_id() : uint
      {
         return this._max_stamina_id;
      }
      
      public function set max_stamina_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._max_stamina_id != param1)
         {
            _loc2_ = this._max_stamina_id;
            this._max_stamina_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"max_stamina",StaminaLevel.getInstanceById(_loc2_),this.max_stamina));
         }
      }
      
      public function getAccessory(param1:String) : Accessory
      {
         if(Boolean(this.horns_id) && this.horns.matches(param1))
         {
            return this.horns;
         }
         if(Boolean(this.wings_id) && this.wings.matches(param1))
         {
            return this.wings;
         }
         if(Boolean(this.mouth_id) && this.mouth.matches(param1))
         {
            return this.mouth;
         }
         if(Boolean(this.claws_id) && this.claws.matches(param1))
         {
            return this.claws;
         }
         if(Boolean(this.dorsal_id) && this.dorsal.matches(param1))
         {
            return this.dorsal;
         }
         if(Boolean(this.tail_id) && this.tail.matches(param1))
         {
            return this.tail;
         }
         return null;
      }
      
      public function getAccessoryElement(param1:String) : Element
      {
         if(Boolean(this.horns_id) && this.horns.matches(param1))
         {
            return this.horns_element;
         }
         if(Boolean(this.wings_id) && this.wings.matches(param1))
         {
            return this.wings_element;
         }
         if(Boolean(this.mouth_id) && this.mouth.matches(param1))
         {
            return this.mouth_element;
         }
         if(Boolean(this.claws_id) && this.claws.matches(param1))
         {
            return this.claws_element;
         }
         if(Boolean(this.dorsal_id) && this.dorsal.matches(param1))
         {
            return this.dorsal_element;
         }
         if(Boolean(this.tail_id) && this.tail.matches(param1))
         {
            return this.tail_element;
         }
         return null;
      }
      
      public function get horns() : Accessory
      {
         return Accessory.getInstanceById(this._horns_id);
      }
      
      public function get horns_id() : uint
      {
         return this._horns_id;
      }
      
      public function set horns_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._horns_id != param1)
         {
            _loc2_ = this._horns_id;
            this._horns_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"horns",Accessory.getInstanceById(_loc2_),this.horns));
         }
      }
      
      public function get wings() : Accessory
      {
         return Accessory.getInstanceById(this._wings_id);
      }
      
      public function get wings_id() : uint
      {
         return this._wings_id;
      }
      
      public function set wings_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._wings_id != param1)
         {
            _loc2_ = this._wings_id;
            this._wings_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"wings",Accessory.getInstanceById(_loc2_),this.wings));
         }
      }
      
      public function get mouth() : Accessory
      {
         return Accessory.getInstanceById(this._mouth_id);
      }
      
      public function get mouth_id() : uint
      {
         return this._mouth_id;
      }
      
      public function set mouth_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._mouth_id != param1)
         {
            _loc2_ = this._mouth_id;
            this._mouth_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"mouth",Accessory.getInstanceById(_loc2_),this.mouth));
         }
      }
      
      public function get claws() : Accessory
      {
         return Accessory.getInstanceById(this._claws_id);
      }
      
      public function get claws_id() : uint
      {
         return this._claws_id;
      }
      
      public function set claws_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._claws_id != param1)
         {
            _loc2_ = this._claws_id;
            this._claws_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"claws",Accessory.getInstanceById(_loc2_),this.claws));
         }
      }
      
      public function get dorsal() : Accessory
      {
         return Accessory.getInstanceById(this._dorsal_id);
      }
      
      public function get dorsal_id() : uint
      {
         return this._dorsal_id;
      }
      
      public function set dorsal_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._dorsal_id != param1)
         {
            _loc2_ = this._dorsal_id;
            this._dorsal_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"dorsal",Accessory.getInstanceById(_loc2_),this.dorsal));
         }
      }
      
      public function get tail() : Accessory
      {
         return Accessory.getInstanceById(this._tail_id);
      }
      
      public function get tail_id() : uint
      {
         return this._tail_id;
      }
      
      public function set tail_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._tail_id != param1)
         {
            _loc2_ = this._tail_id;
            this._tail_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"tail",Accessory.getInstanceById(_loc2_),this.tail));
         }
      }
      
      public function get horns_element() : Element
      {
         return Element.getInstanceById(this._horns_element_id);
      }
      
      public function get horns_element_id() : uint
      {
         return this._horns_element_id;
      }
      
      public function set horns_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._horns_element_id != param1)
         {
            _loc2_ = this._horns_element_id;
            this._horns_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"horns",Element.getInstanceById(_loc2_),this.horns_element));
         }
      }
      
      public function get wings_element() : Element
      {
         return Element.getInstanceById(this._wings_element_id);
      }
      
      public function get wings_element_id() : uint
      {
         return this._wings_element_id;
      }
      
      public function set wings_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._wings_element_id != param1)
         {
            _loc2_ = this._wings_element_id;
            this._wings_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"wings",Element.getInstanceById(_loc2_),this.wings_element));
         }
      }
      
      public function get mouth_element() : Element
      {
         return Element.getInstanceById(this._mouth_element_id);
      }
      
      public function get mouth_element_id() : uint
      {
         return this._mouth_element_id;
      }
      
      public function set mouth_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._mouth_element_id != param1)
         {
            _loc2_ = this._mouth_element_id;
            this._mouth_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"mouth",Element.getInstanceById(_loc2_),this.mouth_element));
         }
      }
      
      public function get claws_element() : Element
      {
         return Element.getInstanceById(this._claws_element_id);
      }
      
      public function get claws_element_id() : uint
      {
         return this._claws_element_id;
      }
      
      public function set claws_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._claws_element_id != param1)
         {
            _loc2_ = this._claws_element_id;
            this._claws_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"claws",Element.getInstanceById(_loc2_),this.claws_element));
         }
      }
      
      public function get dorsal_element() : Element
      {
         return Element.getInstanceById(this._dorsal_element_id);
      }
      
      public function get dorsal_element_id() : uint
      {
         return this._dorsal_element_id;
      }
      
      public function set dorsal_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._dorsal_element_id != param1)
         {
            _loc2_ = this._dorsal_element_id;
            this._dorsal_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"dorsal",Element.getInstanceById(_loc2_),this.dorsal_element));
         }
      }
      
      public function get tail_element() : Element
      {
         return Element.getInstanceById(this._tail_element_id);
      }
      
      public function get tail_element_id() : uint
      {
         return this._tail_element_id;
      }
      
      public function set tail_element_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._tail_element_id != param1)
         {
            _loc2_ = this._tail_element_id;
            this._tail_element_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"tail",Element.getInstanceById(_loc2_),this.tail_element));
         }
      }
      
      public function get max_hp() : int
      {
         return this._max_hp;
      }
      
      public function set max_hp(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.max_hp != param1)
         {
            _loc2_ = this._max_hp;
            this._max_hp = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"max_hp",_loc2_,param1));
         }
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.hp != param1)
         {
            _loc2_ = this._hp;
            this._hp = param1;
            if(this._hp < 0)
            {
               this._hp = 0;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"hp",_loc2_,param1));
         }
      }
      
      public function get max_pp() : int
      {
         return this._max_pp;
      }
      
      public function set max_pp(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.max_pp != param1)
         {
            _loc2_ = this._max_pp;
            this._max_pp = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"max_pp",_loc2_,param1));
         }
      }
      
      public function get pp() : int
      {
         return this._pp;
      }
      
      public function set pp(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.pp != param1)
         {
            _loc2_ = this._pp;
            this._pp = param1;
            if(this._pp < 0)
            {
               this._pp = 0;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"pp",_loc2_,param1));
         }
      }
      
      public function get modifiedSkillPoints() : int
      {
         return this.skill_points + this.skill_points_delta;
      }
      
      public function get skill_points() : int
      {
         return this._skill_points;
      }
      
      public function set skill_points(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.skill_points != param1)
         {
            _loc2_ = this._skill_points;
            this._skill_points = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"skill_points",_loc2_,param1));
         }
      }
      
      public function get skill_points_delta() : int
      {
         return this._skill_points_delta;
      }
      
      public function set skill_points_delta(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.skill_points_delta != param1)
         {
            _loc2_ = this._skill_points_delta;
            this._skill_points_delta = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"skill_points_delta",_loc2_,param1));
         }
      }
      
      public function get wins() : int
      {
         return this._wins;
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.wins != param1)
         {
            _loc2_ = this._wins;
            this._wins = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"wins",_loc2_,param1));
         }
      }
      
      public function get ties() : int
      {
         return this._ties;
      }
      
      public function set ties(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.ties != param1)
         {
            _loc2_ = this._ties;
            this._ties = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"ties",_loc2_,param1));
         }
      }
      
      public function get losses() : int
      {
         return this._losses;
      }
      
      public function set losses(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.losses != param1)
         {
            _loc2_ = this._losses;
            this._losses = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"losses",_loc2_,param1));
         }
      }
      
      public function get team_id() : int
      {
         return this._team_id;
      }
      
      public function set team_id(param1:int) : void
      {
         var _loc2_:uint = 0;
         if(this.team_id != param1)
         {
            _loc2_ = this._team_id;
            this._team_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"team_id",_loc2_,param1));
         }
      }
      
      public function get auction_id() : uint
      {
         return this._auction_id;
      }
      
      public function set auction_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this.auction_id != param1)
         {
            _loc2_ = this._auction_id;
            this._auction_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"auction_id",_loc2_,param1));
         }
      }
      
      public function get egg_time_left() : Number
      {
         return this._egg_time_left;
      }
      
      public function set egg_time_left(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Date = null;
         if(this.egg_time_left != param1)
         {
            _loc2_ = this._egg_time_left;
            this._egg_time_left = param1;
            _loc3_ = new Date();
            if(this._egg_time_left)
            {
               this.hatch_at = new Date(_loc3_.time + Math.max(0,this._egg_time_left + 10) * 1000);
            }
            else
            {
               this.hatch_at = null;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"egg_time_left",_loc2_,param1));
         }
      }
      
      public function get sleep_time_left() : Number
      {
         return this._sleep_time_left;
      }
      
      public function set sleep_time_left(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Date = null;
         if(this._sleep_time_left != param1)
         {
            _loc2_ = this._sleep_time_left;
            this._sleep_time_left = param1;
            _loc3_ = new Date();
            if(this._sleep_time_left)
            {
               this.wakeup_at = new Date(_loc3_.time + Math.max(0,this._sleep_time_left + 10) * 1000);
            }
            else
            {
               this.wakeup_at = null;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"sleep_time_left",_loc2_,param1));
         }
      }
      
      public function get respec_count() : uint
      {
         return this._respec_count;
      }
      
      public function set respec_count(param1:uint) : void
      {
         if(this._respec_count != param1)
         {
            this._respec_count = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"respec_count",this.respec_count,this.respec_count));
         }
      }
      
      public function get respec_expiration() : uint
      {
         return this._respec_expiration;
      }
      
      public function set respec_expiration(param1:uint) : void
      {
         if(this._respec_expiration != param1)
         {
            this._respec_expiration = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"respec_expiration",this.respec_expiration,this.respec_expiration));
         }
      }
      
      public function get creditsValue() : int
      {
         return 5 * this.level * (this.creature.category.type + 1);
      }
      
      public function get hasNonElementAccessory() : Boolean
      {
         if(this.horns_id > 0 && this.horns_element_id == 0)
         {
            return true;
         }
         if(this.mouth_id > 0 && this.mouth_element_id == 0)
         {
            return true;
         }
         if(this.wings_id > 0 && this.wings_element_id == 0)
         {
            return true;
         }
         if(this.dorsal_id > 0 && this.dorsal_element_id == 0)
         {
            return true;
         }
         if(this.tail_id > 0 && this.tail_element_id == 0)
         {
            return true;
         }
         if(this.claws_id > 0 && this.claws_element_id == 0)
         {
            return true;
         }
         return false;
      }
      
      public function get cant_add_until() : Number
      {
         return this._cant_add_until;
      }
      
      public function set cant_add_until(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Date = null;
         if(this.cant_add_until != param1)
         {
            _loc2_ = this._cant_add_until;
            this._cant_add_until = param1;
            _loc3_ = new Date();
            if(this._cant_add_until)
            {
               this.addToTeamTime = new Date(_loc3_.time + Math.max(0,this._cant_add_until + 10) * 1000);
            }
            else
            {
               this.addToTeamTime = null;
            }
         }
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc3_:SkillInstance = null;
         var _loc4_:SkillInstance = null;
         var _loc5_:TraitInstance = null;
         var _loc6_:TraitInstance = null;
         var _loc7_:CreatureInstance = null;
         var _loc8_:CreatureInstance = null;
         param1.copying = true;
         param1.id = this.id;
         param1.name = this.name;
         param1.level = this.level;
         param1.max_level = this.max_level;
         param1.is_sterile = this.is_sterile;
         param1.seed_count = this.seed_count;
         param1.level_progress = this.level_progress;
         param1.rank = this.rank;
         param1.rank_delta = this.rank_delta;
         param1.skill_points = this.skill_points;
         param1.skill_points_delta = this.skill_points_delta;
         param1.wins = this.wins;
         param1.losses = this.losses;
         param1.hp = this.hp;
         param1.max_hp = this.max_hp;
         param1.pp = this.pp;
         param1.max_pp = this.max_pp;
         param1.is_male = this.is_male;
         param1.creature_id = this.creature_id;
         param1.happiness = this.happiness;
         param1.health = this.health;
         param1.hue = this.hue;
         param1.horns_id = this.horns_id;
         param1.horns_element_id = this.horns_element_id;
         param1.wings_id = this.wings_id;
         param1.wings_element_id = this.wings_element_id;
         param1.mouth_id = this.mouth_id;
         param1.mouth_element_id = this.mouth_element_id;
         param1.claws_id = this.claws_id;
         param1.claws_element_id = this.claws_element_id;
         param1.dorsal_id = this.dorsal_id;
         param1.dorsal_element_id = this.dorsal_element_id;
         param1.tail_id = this.tail_id;
         param1.tail_element_id = this.tail_element_id;
         param1.max_stamina_id = this.max_stamina_id;
         param1.stamina_id = this.stamina_id;
         param1.auction_id = this.auction_id;
         param1.team_id = this.team_id;
         param1.is_quest = this.is_quest;
         param1._egg_time_left = this._egg_time_left;
         param1.hatch_at = this.hatch_at;
         param1._sleep_time_left = this._sleep_time_left;
         param1.wakeup_at = this.wakeup_at;
         param1.respec_count = this.respec_count;
         param1.respec_expiration = this.respec_expiration;
         param1.cant_add_until = this.cant_add_until;
         this.owner.copyTo(param1.owner);
         param1.dispatchEvent(PropertyChangeEvent.create(param1,"id",null,null));
         var _loc2_:Array = [];
         for each(_loc4_ in this.skills)
         {
            _loc3_ = new SkillInstance();
            _loc4_.copyTo(_loc3_);
            _loc2_.push(_loc3_);
         }
         param1.skills.source = _loc2_;
         _loc2_ = [];
         for each(_loc6_ in this.traits)
         {
            _loc5_ = new TraitInstance();
            _loc6_.copyTo(_loc5_);
            _loc2_.push(_loc5_);
         }
         param1.traits.source = _loc2_;
         _loc2_ = [];
         for each(_loc8_ in this.rankingNeighbours)
         {
            _loc7_ = new CreatureInstance();
            _loc8_.copyTo(_loc7_);
            _loc2_.push(_loc7_);
         }
         param1.rankingNeighbours.source = _loc2_;
         param1.copying = false;
      }
      
      override public function equals(param1:Data) : Boolean
      {
         var _loc2_:CreatureInstance = param1 as CreatureInstance;
         if(_loc2_ != null)
         {
            return this.id == _loc2_.id;
         }
         return false;
      }
      
      public function findSkill(param1:uint) : SkillInstance
      {
         var _loc2_:SkillInstance = null;
         for each(_loc2_ in this.skills)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function findTrait(param1:uint) : TraitInstance
      {
         var _loc2_:TraitInstance = null;
         for each(_loc2_ in this.traits)
         {
            if(_loc2_.trait.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function findCondition(param1:uint) : Condition
      {
         var _loc2_:Condition = null;
         for each(_loc2_ in this.conditions)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function canIncreaseTrait(param1:uint) : Boolean
      {
         var _loc2_:TraitInstance = this.findTrait(param1);
         return !_loc2_ || _loc2_.upgradableLevel < Trait.MAX_LEVEL;
      }
      
      private function onSkillsChange(param1:CollectionEvent) : void
      {
         dispatchEvent(PropertyChangeEvent.create(this,"skills",null,null));
      }
      
      private function onTraitsChange(param1:CollectionEvent) : void
      {
         var _loc3_:TraitInstance = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.traits)
         {
            _loc2_.push({
               "trait":_loc3_,
               "creature":this
            });
         }
         this.traitsAndCreature.source = _loc2_;
      }
   }
}
