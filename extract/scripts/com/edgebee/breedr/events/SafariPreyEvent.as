package com.edgebee.breedr.events
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.DataReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   
   public class SafariPreyEvent extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"SafariPreyEvent",
         "cls":SafariPreyEvent
      };
       
      
      public var last_safari_prey:DataReference;
      
      public function SafariPreyEvent(param1:Object = null)
      {
         this.last_safari_prey = new DataReference(CreatureInstance.classinfo);
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
   }
}
