package com.edgebee.breedr.data.creature
{
   import com.edgebee.atlas.data.StaticData;
   
   public class Accessory extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Accessory",
         "cls":Accessory
      };
       
      
      public var id:uint;
      
      public var name:String;
      
      private var _nameRx:RegExp;
      
      public function Accessory(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Accessory
      {
         return StaticData.getInstance(param1,"id","Accessory");
      }
      
      override public function get classinfo() : Object
      {
         return Accessory.classinfo;
      }
      
      public function matches(param1:String) : Boolean
      {
         return param1.match(this.nameRx) != null;
      }
      
      private function get nameRx() : RegExp
      {
         if(!this._nameRx)
         {
            this._nameRx = new RegExp("^" + this.name + ".*");
         }
         return this._nameRx;
      }
   }
}
