package com.edgebee.atlas.data.l10n
{
   public class StringPart extends FormattedAssetPart
   {
      
      private static const _classinfo:Object = {
         "name":"StringPart",
         "cls":StringPart
      };
       
      
      public var value:String;
      
      public function StringPart(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function get text() : String
      {
         return this.value;
      }
   }
}
