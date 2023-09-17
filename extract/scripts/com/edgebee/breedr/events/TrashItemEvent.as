package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class TrashItemEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"TrashItemEvent",
         "cls":TrashItemEvent
      };
       
      
      public var id:uint;
      
      public function TrashItemEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
