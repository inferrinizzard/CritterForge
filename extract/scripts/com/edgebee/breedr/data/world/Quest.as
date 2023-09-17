package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.item.Item;
   
   public class Quest extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Quest",
         "cls":Quest
      };
       
      
      public var id:uint;
      
      public var reward:Number;
      
      public var item_id:uint;
      
      public var area_id:uint;
      
      public var snapshot:CreatureInstance;
      
      private var _delta_abandon_at:Date;
      
      private var _delta_abandon:Number;
      
      public function Quest(param1:Object = null)
      {
         this.snapshot = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get delta_abandon() : Number
      {
         return this._delta_abandon;
      }
      
      public function set delta_abandon(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Date = null;
         if(this.delta_abandon != param1)
         {
            _loc2_ = this._delta_abandon;
            this._delta_abandon = param1;
            _loc3_ = new Date();
            this._delta_abandon_at = new Date(_loc3_.time + Math.max(0,this._delta_abandon) * 1000);
            dispatchEvent(PropertyChangeEvent.create(this,"delta_abandon",_loc2_,param1));
         }
      }
      
      public function get canAbandon() : Boolean
      {
         return this._delta_abandon_at.time < new Date().time;
      }
      
      public function get area() : Area
      {
         return Area.getInstanceById(this.area_id);
      }
      
      public function get item() : Item
      {
         return Item.getInstanceById(this.item_id);
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.copying = true;
         param1.id = this.id;
         param1.item_id = this.item_id;
         param1.area_id = this.area_id;
         param1.reward = this.reward;
         param1.delta_abandon = this.delta_abandon;
         this.snapshot.copyTo(param1.snapshot);
         param1.copying = false;
      }
   }
}
