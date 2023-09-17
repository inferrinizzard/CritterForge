package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   
   public class LoginEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"LoginEvent",
         "cls":LoginEvent
      };
       
      
      public function LoginEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
