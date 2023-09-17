package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   
   public class SafariCard extends Data
   {
      
      public static const SLOT_REVEALED:Number = 1;
      
      public static const SLOT_CREATURE:Number = 2;
      
      public static const SLOT_BOSS:Number = 4;
      
      public static const SLOT_ITEM:Number = 8;
      
      public static const SLOT_STAMINA:Number = 16;
      
      public static const SLOT_HAPPINESS:Number = 32;
      
      public static const SLOT_HEALTH:Number = 64;
      
      public static const SLOT_CREDITS:Number = 128;
      
      public static const SLOT_QUEST:Number = 256;
      
      public static const SLOT_XP:Number = 512;
      
      private static const _classinfo:Object = {
         "name":"SafariCard",
         "cls":SafariCard
      };
       
      
      public var index:int;
      
      private var _flags:Number = 0;
      
      private var _data:Number = 0;
      
      public function SafariCard(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get flags() : Number
      {
         return this._flags;
      }
      
      public function set flags(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.flags != param1)
         {
            _loc2_ = this.flags;
            this._flags = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"flags",_loc2_,param1));
         }
      }
      
      public function get data() : Number
      {
         return this._data;
      }
      
      public function set data(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.data != param1)
         {
            _loc2_ = this.data;
            this._data = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"data",_loc2_,param1));
         }
      }
      
      public function get isRevealed() : Boolean
      {
         return Boolean(this.flags & SLOT_REVEALED);
      }
      
      public function get isItem() : Boolean
      {
         return Boolean(this.flags & SLOT_ITEM);
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.copying = true;
         param1.index = this.index;
         param1.flags = this.flags;
         param1.data = this.data;
         param1.copying = false;
      }
   }
}
