package com.edgebee.atlas.data.l10n
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   
   public class Asset extends StaticData
   {
      
      private static const indices:Array = ["hid","id"];
      
      private static const _classinfo:Object = {
         "name":"Asset",
         "cls":Asset
      };
       
      
      private var _id:uint;
      
      private var _hid:String;
      
      private var _value:String;
      
      public function Asset(param1:Object = null)
      {
         super(param1,null,indices);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Asset
      {
         if(!param1)
         {
            return null;
         }
         return StaticData.getInstance(param1,"id","Asset");
      }
      
      public static function getInstanceByName(param1:String, param2:Boolean = true) : Asset
      {
         var _loc3_:String = null;
         _loc3_ = MD5.hash(param1);
         var _loc4_:Asset;
         if(!(_loc4_ = getInstanceByHid(_loc3_)) && param2)
         {
            (_loc4_ = new Asset({
               "__type__":"Asset",
               "hid":_loc3_
            })).toReplace = true;
            StaticData.getStore("Asset")["hid"][_loc3_] = _loc4_;
         }
         return _loc4_;
      }
      
      public static function getInstanceByHid(param1:String) : Asset
      {
         return StaticData.getInstance(param1,"hid","Asset");
      }
      
      override public function get classinfo() : Object
      {
         return Asset.classinfo;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         var _loc2_:uint = this._id;
         this._id = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"id",_loc2_,this.id));
      }
      
      public function get hid() : String
      {
         return this._hid;
      }
      
      public function set hid(param1:String) : void
      {
         var _loc2_:String = this._hid;
         this._hid = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"hid",_loc2_,this.hid));
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function set value(param1:String) : void
      {
         var _loc2_:String = this._value;
         this._value = param1;
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"value",_loc2_,this.value));
      }
      
      override public function copyTo(param1:*) : void
      {
         var _loc2_:Asset = param1 as Asset;
         _loc2_.id = this.id;
         _loc2_.hid = this.hid;
         _loc2_.value = this.value;
      }
   }
}
