package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   internal class SnapshotData
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var rotation:Number;
      
      public var scale:Number;
      
      public function SnapshotData(param1:Particle2D)
      {
         super();
         this.x = param1.x;
         this.y = param1.y;
         this.rotation = param1.rotation;
         this.scale = param1.scale;
      }
   }
}
