package com.edgebee.breedr.events.combat
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   
   public class ResistedConditionEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"ResistedConditionEvent",
         "cls":ResistedConditionEvent
      };
       
      
      public var creature_instance_id:uint;
      
      public var type:int;
      
      public var afflict_text_id:uint;
      
      public function ResistedConditionEvent(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get afflict_text() : Asset
      {
         return Asset.getInstanceById(this.afflict_text_id);
      }
   }
}
