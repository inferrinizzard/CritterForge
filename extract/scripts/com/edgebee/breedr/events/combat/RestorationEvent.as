package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.combat.Restoration;
   
   public class RestorationEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"RestorationEvent",
         "cls":RestorationEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var status:String;
      
      public var restorations:DataArray;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      public function RestorationEvent(param1:Object = null)
      {
         this.restorations = new DataArray(Restoration.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get totalHP() : int
      {
         var _loc2_:Restoration = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.restorations)
         {
            if(_loc2_.type == Restoration.HP)
            {
               _loc1_ += _loc2_.value;
            }
         }
         return _loc1_;
      }
      
      public function get totalPP() : int
      {
         var _loc2_:Restoration = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.restorations)
         {
            if(_loc2_.type == Restoration.PP)
            {
               _loc1_ += _loc2_.value;
            }
         }
         return _loc1_;
      }
      
      public function get total() : int
      {
         return Math.max(this.totalHP,this.totalPP);
      }
   }
}
