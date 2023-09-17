package idv.cjcat.stardust.threeD.particles
{
   import idv.cjcat.stardust.common.particles.Particle;
   
   public class Particle3D extends Particle
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var screenX:Number;
      
      public var screenY:Number;
      
      public var vx:Number;
      
      public var vy:Number;
      
      public var vz:Number;
      
      public var screenVX:Number;
      
      public var screenVY:Number;
      
      public var rotationX:Number;
      
      public var rotationY:Number;
      
      public var rotationZ:Number;
      
      public var omegaX:Number;
      
      public var omegaY:Number;
      
      public var omegaZ:Number;
      
      public function Particle3D()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.x = 0;
         this.y = 0;
         this.z = 0;
         this.screenX = 0;
         this.screenY = 0;
         this.vx = 0;
         this.vy = 0;
         this.vz = 0;
         this.screenVX = 0;
         this.screenVY = 0;
         this.rotationX = 0;
         this.rotationY = 0;
         this.rotationZ = 0;
         this.omegaX = 0;
         this.omegaY = 0;
         this.omegaZ = 0;
      }
   }
}
