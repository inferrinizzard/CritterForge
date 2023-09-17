package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.StaticData;
   
   public class Link extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Link",
         "cls":Link
      };
       
      
      public var id:uint;
      
      public var name_id:uint;
      
      public var description_id:uint;
      
      public var area_id:uint;
      
      public var destination_id:uint;
      
      public function Link(param1:Object = null)
      {
         super(param1,null,["id","destination_id"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Link
      {
         return StaticData.getInstance(param1,"id","Link");
      }
      
      public static function getInstanceByDestinationId(param1:uint) : Link
      {
         return StaticData.getInstance(param1,"destination_id","Link");
      }
      
      override public function get classinfo() : Object
      {
         return Link.classinfo;
      }
      
      public function get destination() : Area
      {
         return Area.getInstanceById(this.destination_id);
      }
      
      public function get priority() : int
      {
         return this.destination.type;
      }
   }
}
