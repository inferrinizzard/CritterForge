package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.world.Dialog;
   
   public class HatchingEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"HatchingEvent",
         "cls":HatchingEvent
      };
       
      
      public var creature_instance:CreatureInstance;
      
      public var dialog_uid:String;
      
      public function HatchingEvent(param1:Object = null)
      {
         this.creature_instance = new CreatureInstance();
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get dialog() : Dialog
      {
         return Dialog.getInstanceByName(this.dialog_uid);
      }
   }
}
