package com.edgebee.atlas.data.messaging
{
   import com.edgebee.atlas.data.Data;
   
   public class Attachment extends Data
   {
      
      public static const STATE_EXECUTED:int = 1;
      
      private static const _classinfo:Object = {
         "name":"Attachment",
         "cls":Attachment
      };
       
      
      public var id:uint;
      
      public var type:int;
      
      public var state:int;
      
      public var token_cost:uint;
      
      public function Attachment(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get isExecuted() : Boolean
      {
         return this.state == STATE_EXECUTED;
      }
      
      public function get canDelete() : Boolean
      {
         return this.isExecuted || this.token_cost > 0;
      }
      
      public function execute() : void
      {
         this.state |= STATE_EXECUTED;
      }
      
      public function unexecute() : void
      {
         this.state &= ~STATE_EXECUTED;
      }
   }
}
