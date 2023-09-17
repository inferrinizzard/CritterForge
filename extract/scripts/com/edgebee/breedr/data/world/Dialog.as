package com.edgebee.breedr.data.world
{
   import com.adobe.crypto.MD5;
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.StaticData;
   
   public class Dialog extends StaticData
   {
      
      private static const _classinfo:Object = {
         "name":"Dialog",
         "cls":Dialog
      };
       
      
      public var id:uint;
      
      public var uid:String;
      
      public var npc_id:uint;
      
      public var lines:DataArray;
      
      public function Dialog(param1:Object = null)
      {
         this.lines = new DataArray(DialogLine.classinfo);
         super(param1,null,["id","uid"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : Dialog
      {
         return StaticData.getInstance(param1,"id","Dialog");
      }
      
      public static function getInstanceByUid(param1:String) : Dialog
      {
         return StaticData.getInstance(param1,"uid","Dialog");
      }
      
      public static function getInstanceByName(param1:String) : Dialog
      {
         return getInstanceByUid(MD5.hash("Dialog:" + param1));
      }
      
      override public function get classinfo() : Object
      {
         return Dialog.classinfo;
      }
      
      public function get npc() : NonPlayerCharacter
      {
         return NonPlayerCharacter.getInstanceById(this.npc_id);
      }
   }
}
