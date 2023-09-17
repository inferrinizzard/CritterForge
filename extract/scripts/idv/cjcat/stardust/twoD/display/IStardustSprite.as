package idv.cjcat.stardust.twoD.display
{
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   
   public interface IStardustSprite
   {
       
      
      function init(param1:Particle) : void;
      
      function update(param1:Emitter, param2:Particle, param3:Number) : void;
      
      function disable() : void;
   }
}
