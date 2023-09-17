package idv.cjcat.stardust.twoD.actions
{
   import flash.events.Event;
   import idv.cjcat.stardust.common.emitters.Emitter;
   import idv.cjcat.stardust.common.particles.Particle;
   import idv.cjcat.stardust.twoD.particles.Particle2D;
   
   public class Snapshot extends Action2D
   {
       
      
      private var _snapshotTaken:Boolean = true;
      
      public function Snapshot()
      {
         super();
      }
      
      public function takeSnapshot(param1:Event = null) : void
      {
         this._snapshotTaken = false;
      }
      
      override public function update(param1:Emitter, param2:Particle, param3:Number) : void
      {
         var _loc4_:Particle2D = Particle2D(param2);
         if(this._snapshotTaken)
         {
            skipThisAction = true;
            return;
         }
         _loc4_.dictionary[Snapshot] = new SnapshotData(_loc4_);
      }
      
      override public function postUpdate(param1:Emitter, param2:Number) : void
      {
         if(!this._snapshotTaken)
         {
            this._snapshotTaken = true;
         }
      }
      
      override public function getXMLTagName() : String
      {
         return "Snapshot";
      }
   }
}
