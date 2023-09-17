package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class Level extends StaticData
   {
       
      
      public var id:uint;
      
      public var name_id:uint;
      
      public var index:uint;
      
      public function Level(param1:Object = null)
      {
         super(param1,null,["id","index"]);
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function getMaximum(param1:* = null) : Level
      {
         return null;
      }
   }
}
