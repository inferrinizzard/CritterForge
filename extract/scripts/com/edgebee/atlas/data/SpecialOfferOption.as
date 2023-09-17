package com.edgebee.atlas.data
{
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class SpecialOfferOption extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SpecialOfferOption",
         "cls":SpecialOfferOption
      };
       
      
      public var id:uint;
      
      public var image:String;
      
      public var cost:uint;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public function SpecialOfferOption(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get description() : Asset
      {
         return Asset.getInstanceById(this.description_id);
      }
   }
}
