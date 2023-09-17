package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.util.Color;
   
   public class Element extends StaticData
   {
      
      public static const TYPE_FIRE:Number = 0;
      
      public static const TYPE_ICE:Number = 1;
      
      public static const TYPE_THUNDER:Number = 2;
      
      public static const TYPE_EARTH:Number = 3;
      
      private static const _classinfo:Object = {
         "name":"Element",
         "cls":Element
      };
       
      
      public var id:uint;
      
      public var name:String;
      
      public var type:Number;
      
      public function Element(param1:Object = null)
      {
         super(param1,null,["id","type"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Element
      {
         return StaticData.getInstance(param1,"id","Element");
      }
      
      public static function getInstanceByType(param1:Number) : Element
      {
         return StaticData.getInstance(param1,"type","Element");
      }
      
      override public function get classinfo() : Object
      {
         return Element.classinfo;
      }
      
      public function get color() : Color
      {
         switch(this.type)
         {
            case TYPE_FIRE:
               return new Color(16711680);
            case TYPE_ICE:
               return new Color(43775);
            case TYPE_THUNDER:
               return new Color(16755200);
            case TYPE_EARTH:
               return new Color(65280);
            default:
               return new Color();
         }
      }
   }
}
