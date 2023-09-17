package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class Stall extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Stall",
         "cls":Stall
      };
       
      
      public var id:uint;
      
      public var index:uint;
      
      public var feeder:com.edgebee.breedr.data.world.Feeder;
      
      private var _creature:CreatureInstance;
      
      private var _locked:Boolean;
      
      public function Stall(param1:Object = null)
      {
         this.feeder = new com.edgebee.breedr.data.world.Feeder();
         this.creature = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get creature_id() : uint
      {
         return this.creature.id;
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(this.creature != param1)
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature = param1;
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
         }
      }
      
      public function get empty() : Boolean
      {
         return this.creature.id == 0;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._locked != param1)
         {
            _loc2_ = this._locked;
            this._locked = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"locked",_loc2_,this._locked));
         }
      }
      
      override public function equals(param1:Data) : Boolean
      {
         var _loc2_:Stall = param1 as Stall;
         if(_loc2_)
         {
            return this.id == _loc2_.id && this.index == _loc2_.index && this.feeder.id == _loc2_.feeder.id && this.creature.id == _loc2_.creature.id && this.locked == _loc2_.locked;
         }
         return false;
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(!this.creature.copying)
         {
            dispatchEvent(PropertyChangeEvent.create(this,"creature",null,null));
         }
      }
   }
}
