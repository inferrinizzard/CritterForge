package com.edgebee.breedr.data.skill
{
   import com.edgebee.atlas.util.Color;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import flash.events.IEventDispatcher;
   
   public interface Piece extends IEventDispatcher
   {
       
      
      function get editable() : Boolean;
      
      function get color() : Color;
      
      function getNumber(param1:EffectPiece) : String;
      
      function get level() : int;
      
      function set level(param1:int) : void;
      
      function get level_delta() : int;
      
      function set level_delta(param1:int) : void;
      
      function get modifiedLevel() : int;
      
      function get icon() : Class;
      
      function getDescription(param1:EffectPiece, param2:CreatureInstance = null) : String;
      
      function get top() : Connector;
      
      function get left() : Connector;
      
      function get right() : Connector;
      
      function get bottom() : Connector;
      
      function canUpgrade(param1:CreatureInstance) : Boolean;
      
      function get priority() : int;
   }
}
