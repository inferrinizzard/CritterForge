package idv.cjcat.stardust.common.particles
{
   public interface InfoRecycler
   {
       
      
      function recycleInfo(param1:Particle) : void;
      
      function needsRecycle() : Boolean;
   }
}
