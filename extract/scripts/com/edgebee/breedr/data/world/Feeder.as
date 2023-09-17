package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.item.Item;
   
   public class Feeder extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Feeder",
         "cls":Feeder
      };
       
      
      public var id:uint;
      
      private var _quantity:uint;
      
      private var _level_id:uint;
      
      private var _item_id:uint;
      
      public function Feeder(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get item() : Item
      {
         return Item.getInstanceById(this.item_id);
      }
      
      public function get level() : FeederLevel
      {
         return FeederLevel.getInstanceById(this.level_id);
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
      
      public function set quantity(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._quantity != param1)
         {
            _loc2_ = this._quantity;
            this._quantity = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"quantity",_loc2_,this._quantity));
         }
      }
      
      public function get level_id() : uint
      {
         return this._level_id;
      }
      
      public function set level_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._level_id != param1)
         {
            _loc2_ = this._level_id;
            this._level_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"level_id",_loc2_,this._level_id));
            dispatchEvent(PropertyChangeEvent.create(this,"level",null,this.level));
         }
      }
      
      public function get item_id() : uint
      {
         return this._item_id;
      }
      
      public function set item_id(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._item_id != param1)
         {
            _loc2_ = this._item_id;
            this._item_id = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"item_id",_loc2_,this._item_id));
            dispatchEvent(PropertyChangeEvent.create(this,"item",null,this.item));
         }
      }
   }
}
