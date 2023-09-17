package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.breedr.data.combat.Block;
   
   public class BlockEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"BlockEvent",
         "cls":BlockEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var status:String;
      
      public var blocks:DataArray;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      public var chances:Number;
      
      public function BlockEvent(param1:Object = null)
      {
         this.blocks = new DataArray(Block.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get total() : int
      {
         var _loc2_:Block = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.blocks)
         {
            _loc1_ += _loc2_.value;
         }
         return _loc1_;
      }
   }
}
