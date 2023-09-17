package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class ItemUseEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ItemUseEvent",
         "cls":ItemUseEvent
      };
       
      
      public var id:uint;
      
      public var destroy:Boolean;
      
      public var breaks:Boolean;
      
      public var creature_id:uint;
      
      public var stamina:int;
      
      public var happiness:int;
      
      public var health:int;
      
      public var stall_id:uint;
      
      public var use_count:uint;
      
      public function ItemUseEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
