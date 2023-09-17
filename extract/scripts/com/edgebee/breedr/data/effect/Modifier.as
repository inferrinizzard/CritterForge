package com.edgebee.breedr.data.effect
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.util.Utils;
   
   public class Modifier extends Data
   {
      
      public static const MAX_LEVEL:uint = 15;
      
      private static const _classinfo:Object = {
         "name":"Modifier",
         "cls":Modifier
      };
      
      public static const POSITIVE:Number = 5635925;
      
      public static const NEGATIVE:Number = 16724787;
       
      
      public var id:uint;
      
      public var modifies:String;
      
      public var add:Number;
      
      public var add_level:Number;
      
      public var mult:Number;
      
      public var mult_level:Number;
      
      public var min_level:uint;
      
      public var is_condition:Boolean;
      
      public var hidden:Boolean;
      
      public var is_ratio:Boolean;
      
      public function Modifier(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.modifies = this.modifies;
         param1.add = this.add;
         param1.add_level = this.add_level;
         param1.min_level = this.min_level;
         param1.is_condition = this.is_condition;
      }
      
      public function getDescription(param1:int = 0) : String
      {
         var _loc2_:* = null;
         if(param1 > 0)
         {
            param1 -= this.min_level;
         }
         var _loc3_:String = this.modifies;
         var _loc4_:String = String(this.modifies.split(".")[0]);
         var _loc5_:String = String(this.modifies.split(".")[1]);
         var _loc6_:Boolean = false;
         if(_loc5_ == "*")
         {
            _loc6_ = true;
            _loc3_ = _loc4_;
         }
         var _loc7_:Asset;
         if(_loc7_ = Asset.getInstanceByName(_loc3_,false))
         {
            _loc2_ = Utils.capitalizeFirst(_loc7_.value);
         }
         else
         {
            _loc2_ = _loc3_ + "ERROR";
         }
         if(this.is_condition)
         {
            _loc2_ += " (" + Asset.getInstanceByName("CONDITION_EFFECT").value + ")";
         }
         return _loc2_ + (" " + this.getStatsDescription(param1));
      }
      
      private function getStatsDescription(param1:uint) : String
      {
         var _loc2_:* = "";
         if(this.hasAdds && this.hasMults)
         {
            _loc2_ += this.getAddDescription(this.getAdds(param1)) + ", " + this.getMultDescription(this.getMults(param1));
         }
         else if(this.hasAdds)
         {
            _loc2_ += this.getAddDescription(this.getAdds(param1));
         }
         else if(this.hasMults)
         {
            _loc2_ += this.getMultDescription(this.getMults(param1));
         }
         if(this.add_level != 0 || this.mult_level != 0)
         {
            _loc2_ += "   " + Asset.getInstanceByName("NEXT_LEVEL").value + " ";
            if(param1 < MAX_LEVEL)
            {
               if(this.hasAdds && this.hasMults)
               {
                  _loc2_ += this.getAddDescription(this.getAdds(param1 + 1)) + ", " + this.getMultDescription(this.getMults(param1 + 1));
               }
               else if(this.hasAdds)
               {
                  _loc2_ += this.getAddDescription(this.getAdds(param1 + 1));
               }
               else if(this.hasMults)
               {
                  _loc2_ += this.getMultDescription(this.getMults(param1 + 1));
               }
            }
            else
            {
               _loc2_ += "-";
            }
         }
         return _loc2_;
      }
      
      private function get hasAdds() : Boolean
      {
         return this.add != 0 || this.add_level != 0;
      }
      
      private function get hasMults() : Boolean
      {
         return this.mult != 0 || this.mult_level != 0;
      }
      
      private function getAdds(param1:uint) : Number
      {
         if((this.modifies == "restoration.happiness" || this.modifies == "restoration.health") && !this.is_ratio)
         {
            return int((this.add + this.add_level * param1) * 100);
         }
         return this.add + this.add_level * param1;
      }
      
      private function getMults(param1:uint) : Number
      {
         return this.mult + this.mult_level * param1;
      }
      
      private function get isPercent() : Boolean
      {
         return this.modifies == "drain.pp" || this.is_ratio;
      }
      
      private function get isInverseNegative() : Boolean
      {
         return this.modifies == "misc.gestation" || this.modifies == "misc.jealousy" || this.modifies == "misc.food_per_stamina" || this.modifies.indexOf("vulnerability") != -1;
      }
      
      private function getAddDescription(param1:Number) : String
      {
         if(this.isPercent)
         {
            return this.getMultDescription(param1);
         }
         if(param1 > 0 && !this.isInverseNegative || param1 <= 0 && this.isInverseNegative)
         {
            return Utils.htmlWrap((!this.isInverseNegative ? "+" : "") + Utils.round(param1,4).toString(),null,POSITIVE,0,true);
         }
         return Utils.htmlWrap(Utils.round(param1,4).toString(),null,NEGATIVE,0,true);
      }
      
      private function getMultDescription(param1:Number) : String
      {
         var _loc2_:Number = NaN;
         if(param1 > 0 && !this.isInverseNegative || param1 <= 0 && this.isInverseNegative)
         {
            return Utils.htmlWrap((!this.isInverseNegative ? "+" : "") + Utils.toFixed(Utils.round(param1,4) * 100,1) + "%",null,POSITIVE,0,true);
         }
         _loc2_ = Utils.round(param1,4) * 100;
         return Utils.htmlWrap((_loc2_ > 0 ? "+" : "") + Utils.toFixed(_loc2_,1) + "%",null,NEGATIVE,0,true);
      }
   }
}
