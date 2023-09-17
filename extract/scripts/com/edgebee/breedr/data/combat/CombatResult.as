package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class CombatResult extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"CombatResult",
         "cls":CombatResult
      };
       
      
      public var challenger:DataReference;
      
      public var defender:DataReference;
      
      public var winner:int;
      
      public var replay_id:uint;
      
      public var events:Array;
      
      private var _resultVisible:Boolean;
      
      public function CombatResult(param1:Object = null)
      {
         this.challenger = new DataReference(CreatureInstance.classinfo);
         this.defender = new DataReference(CreatureInstance.classinfo);
         this.events = [];
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override protected function finalize() : void
      {
         super.finalize();
         this._resultVisible = false;
      }
      
      public function get resultVisible() : Boolean
      {
         return this._resultVisible;
      }
      
      public function set resultVisible(param1:Boolean) : void
      {
         if(param1 != this._resultVisible)
         {
            this._resultVisible = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"resultVisible",!this.resultVisible,this.resultVisible));
         }
      }
   }
}
