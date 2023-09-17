package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.data.news.News;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.FridgeLevel;
   import com.edgebee.breedr.data.world.Quest;
   import com.edgebee.breedr.data.world.RanchLevel;
   import com.edgebee.breedr.data.world.SafariCard;
   import com.edgebee.breedr.data.world.Stall;
   import com.edgebee.breedr.data.world.SyndicateLevel;
   
   public class Player extends com.edgebee.atlas.data.Player
   {
      
      public static const EV_SYNDICATE_VISIT:Number = 1;
      
      public static const EV_AUCTION_VISIT:Number = 2;
      
      public static const EV_TRAVEL_VISIT:Number = 4;
      
      public static const EV_QUEST_VISIT:Number = 8;
      
      public static const EV_MAX_LEVEL_CREATURE:Number = 16;
      
      public static const EV_SAFARI_WIN:Number = 32;
      
      public static const EV_LEVEL_UP:Number = 64;
      
      public static const EV_FRIDGE_FULL:Number = 256;
      
      public static const EV_SYNDICATE_VISIT2:Number = 512;
      
      public static const EV_FIRST_BREED:Number = 1024;
      
      public static const EV_OUT_OF_STAMINA:Number = 2048;
      
      public static const EV_MAGICAL_ACCESS:Number = 4096;
      
      public static const EV_FIRST_SAFARI:Number = 8192;
      
      public static const EV_LABORATORY_VISIT:Number = 16384;
      
      public static const EV_EXPANSION_LAB:Number = 65536;
      
      public static const EV_EXPANSION_RANCH:Number = 131072;
      
      public static const EV_EXPANSION_SYNDICATE:Number = 262144;
      
      public static const EV_EXPANSION_AUCTION:Number = 524288;
      
      public static const SYN_NONE_FLAG:int = 0;
      
      public static const SYN_CAN_CHALLENGE_FLAG:int = 1;
      
      private static const _classinfo:Object = {
         "name":"Player",
         "cls":com.edgebee.breedr.data.player.Player
      };
       
      
      private var _ranch_level_id:uint;
      
      private var _fridge_level_id:uint;
      
      private var _syndicate_level_id:uint;
      
      private var _safari_creature_id:uint;
      
      private var _achievementsFetched:Boolean = false;
      
      private var _syndicate_flags:int;
      
      public var last_activity:Date;
      
      public var syndicate:com.edgebee.breedr.data.player.Syndicate;
      
      public var news:DataArray;
      
      public var stalls:DataArray;
      
      public var items:DataArray;
      
      public var quest:Quest;
      
      public var game_achievements:DataArray;
      
      public var safari_cards:DataArray;
      
      public var syndicate_wins_l2:uint;
      
      public var syndicate_wins_l3:uint;
      
      public var syndicate_wins_l4:uint;
      
      public var syndicate_wins_l5:uint;
      
      public var syndicate_wins_l6:uint;
      
      public var syndicate_wins_l7:uint;
      
      public var syndicate_wins_l8:uint;
      
      public var syndicate_wins_l9:uint;
      
      public var syndicate_wins_l10:uint;
      
      public var syndicate_wins_l11:uint;
      
      public var area_id:uint = 0;
      
      private var _event_flags:Number = 0;
      
      public var last_safari_prey:DataReference;
      
      private var _creatures:ArrayCollection;
      
      private var _fightingCreatures:ArrayCollection;
      
      private var _credits:uint;
      
      public var _new_news:Boolean;
      
      public function Player(param1:Object = null)
      {
         this._creatures = new ArrayCollection();
         this._fightingCreatures = new ArrayCollection();
         this.syndicate = new com.edgebee.breedr.data.player.Syndicate();
         this.news = new DataArray(News.classinfo);
         this.items = new DataArray(ItemInstance.classinfo);
         this.items.trackContentChanges = true;
         this.items.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onItemsChange);
         this.stalls = new DataArray(Stall.classinfo);
         this.stalls.trackContentChanges = true;
         this.stalls.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onStallsChange);
         this.safari_cards = new DataArray(SafariCard.classinfo);
         this.quest = new Quest();
         this.last_safari_prey = new DataReference(CreatureInstance.classinfo);
         this.game_achievements = new DataArray(PersonalAchievementInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get ranch_level() : RanchLevel
      {
         return RanchLevel.getInstanceById(this.ranch_level_id);
      }
      
      public function get ranch_level_id() : uint
      {
         return this._ranch_level_id;
      }
      
      public function set ranch_level_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._ranch_level_id != param1)
         {
            _loc2_ = this._ranch_level_id;
            this._ranch_level_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"ranch_level",RanchLevel.getInstanceById(_loc2_),this.ranch_level));
         }
      }
      
      public function get fridge_level() : FridgeLevel
      {
         return FridgeLevel.getInstanceById(this.fridge_level_id);
      }
      
      public function get fridge_level_id() : uint
      {
         return this._fridge_level_id;
      }
      
      public function set fridge_level_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._fridge_level_id != param1)
         {
            _loc2_ = this._fridge_level_id;
            this._fridge_level_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"fridge_level",FridgeLevel.getInstanceById(_loc2_),this.fridge_level));
         }
      }
      
      public function get syndicate_level() : SyndicateLevel
      {
         return SyndicateLevel.getInstanceById(this.syndicate_level_id);
      }
      
      public function get syndicate_level_id() : uint
      {
         return this._syndicate_level_id;
      }
      
      public function set syndicate_level_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._syndicate_level_id != param1)
         {
            _loc2_ = this._syndicate_level_id;
            this._syndicate_level_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"syndicate_level",SyndicateLevel.getInstanceById(_loc2_),this.syndicate_level));
         }
      }
      
      public function get safari_creature() : CreatureInstance
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(_loc1_.id == this.safari_creature_id)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get safari_creature_id() : uint
      {
         return this._safari_creature_id;
      }
      
      public function set safari_creature_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._safari_creature_id != param1)
         {
            _loc2_ = this._safari_creature_id;
            this._safari_creature_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"safari_creature",null,this.safari_creature));
         }
      }
      
      public function get achievementsFetched() : Boolean
      {
         return this._achievementsFetched;
      }
      
      public function set achievementsFetched(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._achievementsFetched != param1)
         {
            _loc2_ = this._achievementsFetched;
            this._achievementsFetched = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"achievementsFetched",null,this.achievementsFetched));
         }
      }
      
      public function get syndicate_flags() : int
      {
         return this._syndicate_flags;
      }
      
      public function set syndicate_flags(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._syndicate_flags != param1)
         {
            _loc2_ = this._syndicate_flags;
            this._syndicate_flags = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"syndicate_flags",_loc2_,this.syndicate_flags));
         }
      }
      
      public function getSyndicateWins(param1:uint) : uint
      {
         var _loc2_:String = "syndicate_wins_l" + param1.toString();
         return this[_loc2_];
      }
      
      public function setSyndicateWins(param1:uint, param2:uint) : void
      {
         var _loc3_:String = "syndicate_wins_l" + param1.toString();
         var _loc4_:uint = uint(this[_loc3_]);
         this[_loc3_] = param2;
         dispatchEvent(PropertyChangeEvent.create(this,_loc3_,_loc4_,param2));
      }
      
      public function get area() : Area
      {
         return Area.getInstanceById(this.area_id);
      }
      
      public function set area(param1:Area) : void
      {
         var _loc2_:Area = null;
         if(this.area_id != param1.id)
         {
            _loc2_ = this.area;
            this.area_id = param1.id;
            dispatchEvent(PropertyChangeEvent.create(this,"area",_loc2_,this.area));
         }
      }
      
      public function get event_flags() : Number
      {
         return this._event_flags;
      }
      
      public function set event_flags(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.event_flags != param1)
         {
            _loc2_ = this._event_flags;
            this._event_flags = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"event_flags",_loc2_,param1));
         }
      }
      
      public function get creatures() : ArrayCollection
      {
         return this._creatures;
      }
      
      public function get fightingCreatures() : ArrayCollection
      {
         return this._fightingCreatures;
      }
      
      public function get credits() : uint
      {
         return this._credits;
      }
      
      public function set credits(param1:uint) : void
      {
         var _loc2_:uint = param1;
         this._credits = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"credits",_loc2_,this._credits));
      }
      
      public function get hasMaxedLevelCreature() : Boolean
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(_loc1_.level >= _loc1_.max_level && !_loc1_.isEgg)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get maxedLevelCreature() : CreatureInstance
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(_loc1_.level >= _loc1_.max_level && !_loc1_.isEgg)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get hasCreatureWithSkillPoints() : Boolean
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(_loc1_.skill_points > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get firstCreatureWithSkillPoints() : CreatureInstance
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(_loc1_.skill_points > 0)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get hasCreatureWithoutStamina() : Boolean
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(!_loc1_.isEgg && _loc1_.stamina && _loc1_.stamina.index == 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get firstCreatureWithoutStamina() : CreatureInstance
      {
         var _loc1_:CreatureInstance = null;
         for each(_loc1_ in this.creatures)
         {
            if(!_loc1_.isEgg && _loc1_.stamina && _loc1_.stamina.index == 0)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get hasSeedsOfEachGender() : Boolean
      {
         var _loc3_:ItemInstance = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.items)
         {
            if(!_loc3_.creature.is_quest)
            {
               if(_loc3_.item.type == Item.TYPE_BREED && _loc3_.creature.id > 0)
               {
                  if(_loc3_.creature.is_male)
                  {
                     _loc1_ = true;
                  }
                  else
                  {
                     _loc2_ = true;
                  }
               }
               if(_loc1_ && _loc2_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get hasExtractor() : Boolean
      {
         var _loc1_:ItemInstance = null;
         for each(_loc1_ in this.items)
         {
            if(_loc1_.item.type == Item.TYPE_BREED && _loc1_.creature.id == 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get numInventoriedItems() : uint
      {
         var _loc2_:ItemInstance = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.items)
         {
            if(!_loc2_.not_inventoried)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function get canChallengeOtherSyndicates() : Boolean
      {
         return this.syndicate.leader_id == id || (this.syndicate_flags & SYN_CAN_CHALLENGE_FLAG) == SYN_CAN_CHALLENGE_FLAG;
      }
      
      override public function reset() : void
      {
         this.news.reset();
         this.stalls.reset();
         this.items.reset();
         super.reset();
      }
      
      public function get freeStallCount() : uint
      {
         var _loc2_:Stall = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.stalls)
         {
            if(!_loc2_.locked && _loc2_.creature.id == 0)
            {
               _loc1_ += 1;
            }
         }
         return _loc1_;
      }
      
      public function resetSafari() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SafariCard = null;
         var _loc3_:SafariCard = null;
         if(this.safari_cards.length == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 25)
            {
               _loc2_ = new SafariCard();
               _loc2_.index = _loc1_;
               this.safari_cards.addItem(_loc2_);
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 25)
            {
               _loc2_ = this.safari_cards[_loc1_] as SafariCard;
               _loc3_ = new SafariCard();
               _loc3_.index = _loc1_;
               _loc3_.copyTo(_loc2_);
               _loc1_++;
            }
         }
      }
      
      private function updateCreatures() : void
      {
         var _loc3_:Stall = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         for each(_loc3_ in this.stalls)
         {
            if(_loc3_.creature.id > 0)
            {
               _loc1_.push(_loc3_.creature);
               if(_loc3_.creature.level > 0)
               {
                  _loc2_.push(_loc3_.creature);
               }
            }
         }
         this._creatures.source = _loc1_;
         this._fightingCreatures.source = _loc2_;
      }
      
      private function onItemsChange(param1:*) : void
      {
      }
      
      private function onStallsChange(param1:*) : void
      {
         this.updateCreatures();
      }
   }
}
