package com.edgebee.breedr.data.combat
{
   import com.edgebee.atlas.data.*;
   import com.edgebee.atlas.data.l10n.*;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.data.creature.Element;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.ModifierPiece;
   
   public class Condition extends Data
   {
      
      public static const TYPE_PREVENT_MOVEMENT:Number = 1;
      
      public static const TYPE_PREVENT_THINKING:Number = 2;
      
      public static const TYPE_PREVENT_AI:Number = 4;
      
      public static const TYPE_DAMAGE_OVER_TIME:Number = 8;
      
      public static const TYPE_REDUCE_STRENGTH:Number = 16;
      
      public static const TYPE_REDUCE_SPEED:Number = 32;
      
      public static const TYPE_REDUCE_RESILIENCE:Number = 64;
      
      public static const TYPE_REDUCE_INTELLIGENCE:Number = 128;
      
      public static const TYPE_REDUCE:Number = 240;
      
      public static const TYPE_NEGATIVE_CONDITION_MASK:Number = 255;
      
      public static const TYPE_BOOST_STRENGTH:Number = 256;
      
      public static const TYPE_BOOST_SPEED:Number = 512;
      
      public static const TYPE_BOOST_RESILIENCE:Number = 1024;
      
      public static const TYPE_BOOST_INTELLIGENCE:Number = 2048;
      
      public static const TYPE_BOOST:Number = 3840;
      
      public static const TYPE_REGENERATION:Number = 4096;
      
      public static const TYPE_POSITIVE_CONDITION_MASK:Number = 7936;
      
      public static const TYPE_MASK:Number = 8191;
      
      private static const _classinfo:Object = {
         "name":"Condition",
         "cls":Condition
      };
       
      
      public var id:uint;
      
      public var type:Number;
      
      public var afflict_text_id:uint;
      
      public var element_type:uint;
      
      private var _duration:int;
      
      public function Condition(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get classinfo() : Object
      {
         return _classinfo;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function set duration(param1:int) : void
      {
         var _loc2_:uint = 0;
         if(this._duration != param1)
         {
            _loc2_ = uint(this._duration);
            this._duration = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"duration",_loc2_,this.duration));
         }
      }
      
      override public function copyTo(param1:*) : void
      {
         param1.id = this.id;
         param1.type = this.type;
         param1.afflict_text_id = this.afflict_text_id;
         param1.element_type = this.element_type;
         param1.duration = this.duration;
      }
      
      public function get afflict_text() : Asset
      {
         return Asset.getInstanceById(this.afflict_text_id);
      }
      
      public function get isPositive() : Boolean
      {
         return Boolean(this.type & TYPE_POSITIVE_CONDITION_MASK);
      }
      
      public function get description() : String
      {
         var _loc1_:Asset = null;
         if(this.type & TYPE_PREVENT_MOVEMENT)
         {
            _loc1_ = Asset.getInstanceByName("PREVENT_MOVEMENT_EFFECT_DESCRIPTION");
         }
         else if(this.type & TYPE_PREVENT_THINKING)
         {
            _loc1_ = Asset.getInstanceByName("PREVENT_THINKING_EFFECT_DESCRIPTION");
         }
         else if(this.type & TYPE_PREVENT_AI)
         {
            _loc1_ = Asset.getInstanceByName("PREVENT_AI_EFFECT_DESCRIPTION");
         }
         else if(this.type & TYPE_REDUCE_STRENGTH)
         {
            _loc1_ = Asset.getInstanceByName("REDUCE_STRENGTH_DESCRIPTION");
         }
         else if(this.type & TYPE_REDUCE_SPEED)
         {
            _loc1_ = Asset.getInstanceByName("REDUCE_SPEED_DESCRIPTION");
         }
         else if(this.type & TYPE_REDUCE_RESILIENCE)
         {
            _loc1_ = Asset.getInstanceByName("REDUCE_RESILIENCE_DESCRIPTION");
         }
         else if(this.type & TYPE_REDUCE_INTELLIGENCE)
         {
            _loc1_ = Asset.getInstanceByName("REDUCE_INTELLIGENCE_DESCRIPTION");
         }
         else if(this.type & TYPE_BOOST_STRENGTH)
         {
            _loc1_ = Asset.getInstanceByName("BOOST_STRENGTH_DESCRIPTION");
         }
         else if(this.type & TYPE_BOOST_SPEED)
         {
            _loc1_ = Asset.getInstanceByName("BOOST_SPEED_DESCRIPTION");
         }
         else if(this.type & TYPE_BOOST_RESILIENCE)
         {
            _loc1_ = Asset.getInstanceByName("BOOST_RESILIENCE_DESCRIPTION");
         }
         else if(this.type & TYPE_BOOST_INTELLIGENCE)
         {
            _loc1_ = Asset.getInstanceByName("BOOST_INTELLIGENCE_DESCRIPTION");
         }
         else if(this.type & TYPE_DAMAGE_OVER_TIME)
         {
            _loc1_ = Asset.getInstanceByName("DAMAGE_OVER_TIME_DESCRIPTION");
         }
         else if(this.type & TYPE_REGENERATION)
         {
            _loc1_ = Asset.getInstanceByName("REGENERATION_DESCRIPTION");
         }
         return Utils.capitalizeFirst(this.afflict_text.value) + "<br>" + _loc1_.value;
      }
      
      public function get icon() : Class
      {
         if(this.type & TYPE_PREVENT_MOVEMENT)
         {
            return EffectPiece.PreventMoveIconPng;
         }
         if(this.type & TYPE_PREVENT_THINKING)
         {
            return EffectPiece.PreventThinkIconPng;
         }
         if(this.type & TYPE_PREVENT_AI)
         {
            return EffectPiece.PreventAiIconPng;
         }
         if(this.type & TYPE_BOOST_STRENGTH)
         {
            return EffectPiece.BoostStrIconPng;
         }
         if(this.type & TYPE_BOOST_SPEED)
         {
            return EffectPiece.BoostAgiIconPng;
         }
         if(this.type & TYPE_BOOST_RESILIENCE)
         {
            return EffectPiece.BoostResIconPng;
         }
         if(this.type & TYPE_BOOST_INTELLIGENCE)
         {
            return EffectPiece.BoostIntIconPng;
         }
         if(this.type & TYPE_REDUCE_STRENGTH)
         {
            return EffectPiece.ReduceStrIconPng;
         }
         if(this.type & TYPE_REDUCE_SPEED)
         {
            return EffectPiece.ReduceAgiIconPng;
         }
         if(this.type & TYPE_REDUCE_RESILIENCE)
         {
            return EffectPiece.ReduceResIconPng;
         }
         if(this.type & TYPE_REDUCE_INTELLIGENCE)
         {
            return EffectPiece.ReduceIntIconPng;
         }
         if(this.type & TYPE_DAMAGE_OVER_TIME)
         {
            switch(this.element_type)
            {
               case Element.TYPE_FIRE:
                  return ModifierPiece.FireIconPng;
               case Element.TYPE_ICE:
                  return ModifierPiece.IceIconPng;
               case Element.TYPE_THUNDER:
                  return ModifierPiece.ThunderIconPng;
               case Element.TYPE_EARTH:
                  return ModifierPiece.EarthIconPng;
               default:
                  return ModifierPiece.DurationIconPng;
            }
         }
         else
         {
            return ModifierPiece.DurationIconPng;
         }
      }
   }
}
