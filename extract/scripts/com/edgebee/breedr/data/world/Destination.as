package com.edgebee.breedr.data.world
{
   import com.edgebee.atlas.data.Data;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.player.Player;
   
   public class Destination extends Data
   {
      
      private static const _classinfo:Object = {
         "name":"Destination",
         "cls":Destination
      };
       
      
      public var id:uint;
      
      public var destination_id:uint;
      
      public var credits:int;
      
      public var tokens:int;
      
      public function Destination(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      override public function get classinfo() : Object
      {
         return Destination.classinfo;
      }
      
      public function get destination() : Area
      {
         return Area.getInstanceById(this.destination_id);
      }
      
      public function accessibleForPlayer(param1:Player) : Boolean
      {
         if(this.destination.type == Area.TYPE_SAFARI)
         {
            switch(this.destination.safari_type)
            {
               case Area.TYPE_SAFARI_MAGICAL:
                  return Boolean(param1.event_flags & Player.EV_MAGICAL_ACCESS);
            }
         }
         return true;
      }
      
      public function creditsCostForCreature(param1:CreatureInstance) : int
      {
         return this.credits * param1.level;
      }
   }
}
