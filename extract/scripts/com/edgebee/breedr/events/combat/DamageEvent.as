package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.combat.Damage;
   
   public class DamageEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"DamageEvent",
         "cls":DamageEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var status:String;
      
      public var blocked:Boolean;
      
      public var condition_id:uint;
      
      public var lucky:Boolean;
      
      public var damages:DataArray;
      
      public function DamageEvent(param1:Object = null)
      {
         this.damages = new DataArray(Damage.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get total() : int
      {
         var _loc2_:Damage = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.damages)
         {
            _loc1_ += _loc2_.value;
         }
         return _loc1_;
      }
   }
}
