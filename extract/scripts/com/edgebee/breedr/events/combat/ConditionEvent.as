package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.breedr.data.combat.Condition;
   
   public class ConditionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ConditionEvent",
         "cls":ConditionEvent
      };
       
      
      public var inflictor_id:uint;
      
      public var afflicted_id:uint;
      
      public var resisted:Boolean;
      
      public var condition:Condition;
      
      public var duration:uint;
      
      public var afflict_text_id:uint;
      
      public var skill_id:uint;
      
      public var is_primary:Boolean;
      
      private var _type:int;
      
      public function ConditionEvent(param1:Object = null)
      {
         this.condition = new Condition();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get type() : int
      {
         if(this._type != 0)
         {
            return this._type;
         }
         return this.condition.type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get afflict_text() : Asset
      {
         if(this.afflict_text_id != 0)
         {
            return Asset.getInstanceById(this.afflict_text_id);
         }
         return this.condition.afflict_text;
      }
   }
}
