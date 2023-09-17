package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.MovieClipComponent;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.combat.Condition;
   import com.edgebee.breedr.data.combat.Damage;
   import com.edgebee.breedr.data.combat.Restoration;
   import com.edgebee.breedr.events.combat.DamageEvent;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.*;
   import flash.geom.ColorTransform;
   
   public class EffectDisplay extends Canvas
   {
      
      private static var ClawsMc:Class = EffectDisplay_ClawsMc;
      
      private static var BiteMc:Class = EffectDisplay_BiteMc;
      
      private static var CrushMc:Class = EffectDisplay_CrushMc;
      
      private static var SpearMc:Class = EffectDisplay_SpearMc;
      
      private static var ElementalMc:Class = EffectDisplay_ElementalMc;
      
      private static var HealMc:Class = EffectDisplay_HealMc;
      
      private static var DispelMc:Class = EffectDisplay_DispelMc;
      
      private static var BlockMc:Class = EffectDisplay_BlockMc;
      
      private static var FizzleMc:Class = EffectDisplay_FizzleMc;
      
      private static var ReduceMc:Class = EffectDisplay_ReduceMc;
      
      private static var BoostMc:Class = EffectDisplay_BoostMc;
      
      private static var ConditionMc:Class = EffectDisplay_ConditionMc;
      
      private static const BLEND:String = BlendMode.NORMAL;
       
      
      private var _effect:MovieClipComponent;
      
      public function EffectDisplay()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function setupDmgEffects(param1:DamageEvent) : void
      {
         var _loc2_:Damage = null;
         filters = [new GlowFilter(11184810,0.5,10,10,3)];
         if(param1.damages.length > 1)
         {
            _loc2_ = param1.damages[1];
            switch(_loc2_.type)
            {
               case Damage.DAMAGE_FIRE:
                  this._effect.transform.colorTransform = new ColorTransform(1,0.8,0.8);
                  filters = [new GlowFilter(11141120,0.5,10,10,3)];
                  break;
               case Damage.DAMAGE_ICE:
                  this._effect.transform.colorTransform = new ColorTransform(0.8,1,1);
                  filters = [new GlowFilter(7842474,0.5,10,10,3)];
                  break;
               case Damage.DAMAGE_THUNDER:
                  this._effect.transform.colorTransform = new ColorTransform(1,1,0.8);
                  filters = [new GlowFilter(11184640,0.5,10,10,3)];
                  break;
               case Damage.DAMAGE_EARTH:
                  this._effect.transform.colorTransform = new ColorTransform(0.8,1,0.8);
                  filters = [new GlowFilter(43520,0.5,10,10,3)];
            }
         }
      }
      
      public function showDamage(param1:DamageEvent) : void
      {
         var _loc2_:Class = null;
         var _loc4_:MovieClip = null;
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         this._effect.width = width;
         this._effect.height = height;
         this._effect.transform.colorTransform = new ColorTransform(1,1,1);
         var _loc3_:Damage = param1.damages[0];
         switch(_loc3_.type)
         {
            case Damage.DAMAGE_BITE:
               _loc2_ = BiteMc;
               this.setupDmgEffects(param1);
               break;
            case Damage.DAMAGE_SPEAR:
               _loc2_ = SpearMc;
               this.setupDmgEffects(param1);
               break;
            case Damage.DAMAGE_CLAW:
               _loc2_ = ClawsMc;
               this.setupDmgEffects(param1);
               break;
            case Damage.DAMAGE_CRUSH:
               _loc2_ = CrushMc;
               this.setupDmgEffects(param1);
               break;
            case Damage.DAMAGE_FIRE:
               _loc2_ = ElementalMc;
               this._effect.transform.colorTransform = new ColorTransform(1,0.8,0.8);
               filters = [new GlowFilter(11141120,0.5,10,10,3)];
               break;
            case Damage.DAMAGE_ICE:
               _loc2_ = ElementalMc;
               this._effect.transform.colorTransform = new ColorTransform(0.8,1,1);
               filters = [new GlowFilter(7842474,0.5,10,10,3)];
               break;
            case Damage.DAMAGE_THUNDER:
               _loc2_ = ElementalMc;
               this._effect.transform.colorTransform = new ColorTransform(1,1,0.8);
               filters = [new GlowFilter(11184640,0.5,10,10,3)];
               break;
            case Damage.DAMAGE_EARTH:
               _loc2_ = ElementalMc;
               this._effect.transform.colorTransform = new ColorTransform(0.8,1,0.8);
               filters = [new GlowFilter(43520,0.5,10,10,3)];
         }
         if(_loc2_)
         {
            (_loc4_ = new _loc2_() as MovieClip).blendMode = BLEND;
            _loc4_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            this._effect.movieclip = _loc4_;
            addChild(this._effect);
         }
         else
         {
            this._effect = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function showRestoration(param1:Restoration) : void
      {
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         if(param1.type == Restoration.HP)
         {
            this._effect.transform.colorTransform = new ColorTransform(0.95,1,0.95);
            filters = [new GlowFilter(5614165,0.5,10,10,3)];
         }
         else if(param1.type == Restoration.PP)
         {
            this._effect.transform.colorTransform = new ColorTransform(0.95,0.95,1);
            filters = [new GlowFilter(5592490,0.5,10,10,3)];
         }
         var _loc2_:MovieClip = new HealMc() as MovieClip;
         _loc2_.blendMode = BLEND;
         _loc2_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._effect.movieclip = _loc2_;
         addChild(this._effect);
      }
      
      public function showDispel() : void
      {
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         this._effect.transform.colorTransform = new ColorTransform(1,0.95,1);
         filters = [new GlowFilter(11184725,0.5,10,10,3)];
         var _loc1_:MovieClip = new DispelMc() as MovieClip;
         _loc1_.blendMode = BLEND;
         _loc1_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._effect.movieclip = _loc1_;
         addChild(this._effect);
      }
      
      public function showBlock() : void
      {
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         var _loc1_:MovieClip = new BlockMc() as MovieClip;
         _loc1_.blendMode = BLEND;
         _loc1_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         filters = [new GlowFilter(11184810,0.5,10,10,3)];
         this._effect.movieclip = _loc1_;
         addChild(this._effect);
      }
      
      public function showFizzle() : void
      {
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         var _loc1_:MovieClip = new FizzleMc() as MovieClip;
         _loc1_.blendMode = BLEND;
         _loc1_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         filters = [new GlowFilter(11184810,0.5,10,10,3)];
         this._effect.movieclip = _loc1_;
         addChild(this._effect);
      }
      
      public function showCondition(param1:Condition) : void
      {
         var _loc3_:Class = null;
         var _loc4_:MovieClip = null;
         this.cleanUpOldEffect();
         this._effect = new MovieClipComponent();
         filters = [new GlowFilter(11184810,0.5,10,10,3)];
         this._effect.transform.colorTransform = new ColorTransform(1,1,1);
         var _loc2_:Color = new Color();
         if(param1.type & Condition.TYPE_REDUCE)
         {
            _loc3_ = ReduceMc;
         }
         else if(param1.type & Condition.TYPE_BOOST)
         {
            _loc3_ = BoostMc;
         }
         else
         {
            _loc3_ = ConditionMc;
         }
         if(_loc3_)
         {
            (_loc4_ = new _loc3_() as MovieClip).blendMode = BLEND;
            _loc4_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            this._effect.framerate = 60 * this.client.combatSpeedMultiplier;
            this._effect.movieclip = _loc4_;
            addChild(this._effect);
         }
         else
         {
            this._effect = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function cleanUpOldEffect() : void
      {
         if(this._effect)
         {
            removeChild(this._effect);
            this._effect.stop();
            this._effect.removeEventListener(Event.COMPLETE,this.onEffectDone);
            this._effect.movieclip = null;
            this._effect = null;
            filters = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._effect.movieclip.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._effect.movieclip.scaleX = height / 128;
         this._effect.movieclip.scaleY = height / 128;
         this._effect.addEventListener(Event.COMPLETE,this.onEffectDone,false,0,true);
         this._effect.play();
      }
      
      private function onEffectDone(param1:Event) : void
      {
         this.cleanUpOldEffect();
      }
   }
}
