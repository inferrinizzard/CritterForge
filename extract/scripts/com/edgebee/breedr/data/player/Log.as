package com.edgebee.breedr.data.player
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   
   public class Log extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Log",
         "cls":Log
      };
       
      
      public var id:uint;
      
      public var text:FormattedAsset;
      
      public var date:Date;
      
      public function Log(param1:Object = null)
      {
         this.text = new FormattedAsset();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.text = this.text;
         param1.date = this.date;
      }
   }
}
