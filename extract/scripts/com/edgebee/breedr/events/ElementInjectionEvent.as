package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class ElementInjectionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ElementInjectionEvent",
         "cls":ElementInjectionEvent
      };
       
      
      public var creature_id:uint;
      
      public var accessory_name:String;
      
      public var element_id:uint;
      
      public function ElementInjectionEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
