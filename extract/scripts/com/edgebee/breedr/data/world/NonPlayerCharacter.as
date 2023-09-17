package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class NonPlayerCharacter extends StaticData
   {
      
      public static const EXPRESSION_NEUTRAL:Number = 1;
      
      public static const EXPRESSION_HAPPY:Number = 2;
      
      public static const EXPRESSION_SAD:Number = 4;
      
      public static const EXPRESSION_ANGRY:Number = 8;
      
      private static const _classinfo:Object = {
         "name":"NonPlayerCharacter",
         "cls":NonPlayerCharacter
      };
       
      
      public var id:uint;
      
      public var codename:String;
      
      public var expressions:Number;
      
      public var name_id:uint;
      
      public var is_female:Boolean;
      
      public var dialog_ids:Array;
      
      private var _dialogs:ArrayCollection;
      
      public function NonPlayerCharacter(param1:Object = null)
      {
         super(param1,null,["id","codename"]);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public static function getInstanceById(param1:uint) : NonPlayerCharacter
      {
         return StaticData.getInstance(param1,"id","NonPlayerCharacter");
      }
      
      public static function getInstanceByCodename(param1:String) : NonPlayerCharacter
      {
         return StaticData.getInstance(param1,"codename","NonPlayerCharacter");
      }
      
      override public function get classinfo() : Object
      {
         return NonPlayerCharacter.classinfo;
      }
      
      public function get name() : Asset
      {
         return Asset.getInstanceById(this.name_id);
      }
      
      public function get dialogs() : ArrayCollection
      {
         var _loc1_:uint = 0;
         if(!this._dialogs)
         {
            this._dialogs = new ArrayCollection();
            for each(_loc1_ in this.dialog_ids)
            {
               this._dialogs.addItem(Dialog.getInstanceById(_loc1_));
            }
         }
         return this._dialogs;
      }
   }
}
