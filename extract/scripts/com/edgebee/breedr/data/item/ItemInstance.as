package com.edgebee.breedr.data.item
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Stall;
   
   public class ItemInstance extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ItemInstance",
         "cls":ItemInstance
      };
       
      
      public var id:uint;
      
      public var item_id:uint;
      
      public var creature:CreatureInstance;
      
      public var not_inventoried:Boolean;
      
      public var note:String = "";
      
      private var _use_count:int;
      
      private var _auction_id:uint;
      
      public function ItemInstance(param1:Object = null)
      {
         this.creature = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get use_count() : int
      {
         return this._use_count;
      }
      
      public function set use_count(param1:int) : void
      {
         var _loc2_:int = this.charges;
         this._use_count = param1;
         param1 = this.charges;
         dispatchEvent(PropertyChangeEvent.create(this,"charges",_loc2_,param1));
      }
      
      public function set charges(param1:int) : void
      {
         var _loc2_:int = this.charges;
         this.use_count = this.item.maxCharges - param1;
         dispatchEvent(PropertyChangeEvent.create(this,"charges",_loc2_,param1));
      }
      
      public function get charges() : int
      {
         if(!this.item)
         {
            return -1;
         }
         if(!this.item.show_charges)
         {
            return -1;
         }
         if(this.item.max_uses == 0)
         {
            return 1;
         }
         return this.item.maxCharges - this.use_count;
      }
      
      public function get sellPrice() : int
      {
         var _loc1_:int = -1;
         if(this.item.credits > 0)
         {
            if(this.item.max_uses > 0)
            {
               _loc1_ = int(this.item.credits * Math.pow(0.75,this.use_count));
            }
            else
            {
               _loc1_ = int(this.item.credits * 0.75);
            }
         }
         return _loc1_;
      }
      
      public function canUseItem(param1:*) : Boolean
      {
         var _loc2_:Stall = null;
         var _loc3_:CreatureInstance = null;
         if(param1 is Stall)
         {
            _loc2_ = param1 as Stall;
            _loc3_ = _loc2_.creature;
         }
         else if(param1 is CreatureInstance)
         {
            _loc3_ = param1 as CreatureInstance;
         }
         switch(this.item.type)
         {
            case Item.TYPE_FEED:
               return Boolean(_loc2_) && !_loc2_.locked;
            case Item.TYPE_BREED:
               return _loc3_.id > 0 && !_loc3_.isEgg && !_loc3_.is_sterile && _loc3_.auction_id == 0 && _loc3_.stamina.index > 0 && this.creature.id == 0;
            case Item.TYPE_NURTURE:
               return _loc3_.id > 0 && !_loc3_.isEgg;
            case Item.TYPE_PLAY:
               return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.stamina.index > 0;
            case Item.TYPE_USE:
               switch(this.item.subtype)
               {
                  case Item.USE_INJECT_EARTH:
                  case Item.USE_INJECT_FIRE:
                  case Item.USE_INJECT_ICE:
                  case Item.USE_INJECT_THUNDER:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.hasNonElementAccessory;
                  case Item.USE_RESTORE_STAMINA:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.stamina_id != _loc3_.max_stamina_id;
                  case Item.USE_RESTORE_HEALTH:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.health < 100;
                  case Item.USE_RESTORE_HAPPINESS:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.happiness < 100;
                  case Item.USE_ACCELERATE_GESTATION:
                     return _loc3_.id > 0 && _loc3_.isEgg;
                  case Item.USE_INJECT_TRAIT:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.canIncreaseTrait(this.item.trait_id);
                  case Item.USE_SEX_CHANGE:
                     return _loc3_.id > 0 && !_loc3_.isEgg;
                  case Item.USE_CLONE:
                     return _loc3_.id > 0 && !_loc3_.isEgg && this.player.freeStallCount > 0;
                  case Item.USE_RESTORE_SEEDS:
                     return _loc3_.id > 0 && !_loc3_.isEgg && _loc3_.max_seed_count > 0 && _loc3_.max_seed_count != _loc3_.seed_count;
               }
         }
         return false;
      }
      
      public function get item() : Item
      {
         return Item.getInstanceById(this.item_id);
      }
      
      public function get image_url() : String
      {
         if(this.creature.id > 0)
         {
            return this.item.image_url.substr(0,this.item.image_url.length - 4) + "_full.png";
         }
         return this.item.image_url;
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
      
      private function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      private function get player() : Player
      {
         return this.client.player;
      }
      
      public function get priority() : int
      {
         return this.item.type * 100000 + this.item.subtype * 1000 + (!!this.creature.id ? 100 : 0) + this.item.quality;
      }
   }
}
