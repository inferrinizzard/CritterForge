package com.edgebee.breedr.effects
{
   import com.edgebee.breedr.data.creature.Element;
   import flash.geom.ColorTransform;
   import idv.cjcat.stardust.common.actions.Age;
   import idv.cjcat.stardust.common.actions.ColorCurve;
   import idv.cjcat.stardust.common.actions.DeathLife;
   import idv.cjcat.stardust.common.actions.ScaleCurve;
   import idv.cjcat.stardust.common.clocks.SteadyClock;
   import idv.cjcat.stardust.common.initializers.Life;
   import idv.cjcat.stardust.common.math.UniformRandom;
   import idv.cjcat.stardust.twoD.actions.Damping;
   import idv.cjcat.stardust.twoD.actions.Gravity;
   import idv.cjcat.stardust.twoD.actions.Move;
   import idv.cjcat.stardust.twoD.actions.Spin;
   import idv.cjcat.stardust.twoD.emitters.Emitter2D;
   import idv.cjcat.stardust.twoD.fields.UniformField;
   import idv.cjcat.stardust.twoD.initializers.DisplayObjectClass;
   import idv.cjcat.stardust.twoD.initializers.Omega;
   import idv.cjcat.stardust.twoD.initializers.Position;
   import idv.cjcat.stardust.twoD.initializers.Velocity;
   import idv.cjcat.stardust.twoD.zones.RectZone;
   
   public class BreathEmitter extends Emitter2D
   {
       
      
      public var gravityField:UniformField;
      
      public var position:RectZone;
      
      public var velocity:RectZone;
      
      public var particle:DisplayObjectClass;
      
      public var cc:ColorCurve;
      
      public function BreathEmitter()
      {
         super(new SteadyClock(20));
         this.position = new RectZone(-5,-5,10,10);
         this.velocity = new RectZone(55,-5,50,10);
         this.particle = new DisplayObjectClass(FlameParticle);
         addInitializer(this.particle);
         addInitializer(new Position(this.position));
         addInitializer(new Velocity(this.velocity));
         addInitializer(new Omega(new UniformRandom(50,10)));
         addInitializer(new Life(new UniformRandom(10,2)));
         var _loc1_:Gravity = new Gravity();
         this.gravityField = new UniformField(0,-2);
         _loc1_.addField(this.gravityField);
         addAction(_loc1_);
         addAction(new Age());
         addAction(new DeathLife());
         addAction(new Move());
         addAction(new Spin());
         addAction(new Damping(0.15));
         addAction(new ScaleCurve(5,0));
         this.cc = new ColorCurve(2,6);
         this.cc.inColor = new ColorTransform(1,1,1,0,255,255,255);
         addAction(this.cc);
      }
      
      public function set element(param1:Element) : void
      {
         removeInitializer(this.particle);
         var _loc2_:int = !!param1 ? int(param1.type) : 0;
         switch(_loc2_)
         {
            case Element.TYPE_FIRE:
            default:
               this.particle = new DisplayObjectClass(FlameParticle);
               addInitializer(this.particle);
               this.cc.outColor = new ColorTransform(1,1,1,0,-255,-255,-255);
               this.gravityField.y = -2;
               break;
            case Element.TYPE_ICE:
               this.particle = new DisplayObjectClass(IceParticle);
               addInitializer(this.particle);
               this.cc.outColor = new ColorTransform();
               this.gravityField.y = -1;
               break;
            case Element.TYPE_THUNDER:
               this.particle = new DisplayObjectClass(ShockParticle);
               addInitializer(this.particle);
               this.cc.outColor = new ColorTransform();
               this.gravityField.y = -1;
               break;
            case Element.TYPE_EARTH:
               this.particle = new DisplayObjectClass(AcidParticle);
               addInitializer(this.particle);
               this.cc.outColor = new ColorTransform(1,1,1,0,-255,-255,-255);
               this.gravityField.y = -1;
         }
      }
   }
}

import flash.display.BlendMode;
import flash.display.Shape;

class FlameParticle extends Shape
{
   
   private static const COLOURS:Array = [16733440,16724736,16711680];
    
   
   public function FlameParticle()
   {
      super();
      var _loc1_:Number = Math.random() * 40;
      var _loc2_:Number = Math.random() * 40;
      graphics.beginFill(COLOURS[Math.floor(Math.random() * COLOURS.length)]);
      graphics.drawEllipse(-(40 + _loc1_) / 2,-(40 + _loc2_) / 2,40 + _loc1_,40 + _loc2_);
      graphics.endFill();
      blendMode = BlendMode.ADD;
   }
}

import flash.display.BlendMode;
import flash.display.Sprite;

class IceParticle extends Sprite
{
   
   private static const COLOURS:Array = [14540287,15658751,14013941,12632304];
    
   
   public function IceParticle()
   {
      super();
      var _loc1_:Number = Math.random() * 80;
      graphics.beginFill(COLOURS[Math.floor(Math.random() * COLOURS.length)]);
      graphics.drawEllipse(-_loc1_ / 2,-_loc1_ / 2,_loc1_,_loc1_);
      graphics.endFill();
      blendMode = BlendMode.ADD;
   }
}

import flash.display.BlendMode;
import flash.display.Sprite;

class ShockParticle extends Sprite
{
   
   private static const COLOURS:Array = [16776960,16777045,16755285];
    
   
   public function ShockParticle()
   {
      super();
      var _loc1_:Number = Math.random() * 60;
      var _loc2_:Number = Math.random() * 60;
      graphics.lineStyle(8,COLOURS[Math.floor(Math.random() * COLOURS.length)]);
      graphics.drawRect(-_loc1_ / 2,-_loc2_ / 2,_loc1_,_loc2_);
      blendMode = BlendMode.ADD;
   }
}

import flash.display.BlendMode;
import flash.display.Sprite;

class AcidParticle extends Sprite
{
   
   private static const COLOURS:Array = [4259648,655218,6619046,1507041,8518654];
    
   
   public function AcidParticle()
   {
      super();
      var _loc1_:Number = Math.random() * 60;
      var _loc2_:Number = Math.random() * 60;
      graphics.lineStyle(8,COLOURS[Math.floor(Math.random() * COLOURS.length)]);
      graphics.drawEllipse(-(40 + _loc1_) / 2,-(40 + _loc2_) / 2,40 + _loc1_,40 + _loc2_);
      blendMode = BlendMode.ADD;
   }
}
