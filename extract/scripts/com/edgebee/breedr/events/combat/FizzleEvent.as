package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.combat.Fizzle;
   
   public class FizzleEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"FizzleEvent",
         "cls":FizzleEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var status:String;
      
      public var fizzles:DataArray;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      public function FizzleEvent(param1:Object = null)
      {
         this.fizzles = new DataArray(Fizzle.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get total() : int
      {
         var _loc2_:Fizzle = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.fizzles)
         {
            _loc1_ += _loc2_.value;
         }
         return _loc1_;
      }
   }
}
