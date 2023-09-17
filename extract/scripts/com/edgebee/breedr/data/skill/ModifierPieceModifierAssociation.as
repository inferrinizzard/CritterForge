package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.effect.Effect;
   import com.edgebee.breedr.data.effect.Modifier;
   
   public class ModifierPieceModifierAssociation extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ModifierPieceModifierAssociation",
         "cls":ModifierPieceModifierAssociation
      };
       
      
      public var effect:int;
      
      public var condition:int;
      
      public var modifier:Modifier;
      
      public function ModifierPieceModifierAssociation(param1:Object = null)
      {
         this.modifier = new Modifier();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function get classinfo() : Object
      {
         return ModifierPieceModifierAssociation.classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.effect = this.effect;
         param1.condition = this.condition;
         this.modifier.copyTo(param1.modifier);
      }
      
      public function getDescription(param1:uint, param2:Boolean, param3:Boolean) : String
      {
         var _loc4_:* = "";
         if(param3)
         {
            _loc4_ = Asset.getInstanceByName("WITH_EFFECT_PIECE").value + " " + Utils.htmlWrap(Utils.capitalizeFirst(Asset.getInstanceByName(Effect.TYPE_NAMES[this.effect.toString()]).value),null,null,0,true,true) + "<br>";
         }
         if(param2)
         {
            _loc4_ += Utils.getIndent(1);
         }
         return _loc4_ + (this.modifier.getDescription(param1) + "<br>");
      }
   }
}
