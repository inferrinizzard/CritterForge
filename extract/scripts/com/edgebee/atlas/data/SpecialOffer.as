package com.edgebee.atlas.data
{
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class SpecialOffer extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SpecialOffer",
         "cls":SpecialOffer
      };
       
      
      public var id:uint;
      
      public var image:String;
      
      public var image_small:String;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var condition_description_id:uint;
      
      public var options:com.edgebee.atlas.data.DataArray;
      
      public function SpecialOffer(param1:Object = null)
      {
         this.options = new com.edgebee.atlas.data.DataArray(SpecialOfferOption.classinfo);
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
