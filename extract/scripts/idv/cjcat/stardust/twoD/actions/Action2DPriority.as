package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.actions.ActionPriority;
   import idv.cjcat.stardust.twoD.actions.triggers.DeflectorTrigger;
   import idv.cjcat.stardust.twoD.actions.triggers.ZoneTrigger;
   
   public class Action2DPriority extends ActionPriority
   {
      
      private static var _instance:idv.cjcat.stardust.twoD.actions.Action2DPriority;
       
      
      public function Action2DPriority()
      {
         super();
      }
      
      public static function getInstance() : idv.cjcat.stardust.twoD.actions.Action2DPriority
      {
         if(!_instance)
         {
            _instance = new idv.cjcat.stardust.twoD.actions.Action2DPriority();
         }
         return _instance;
      }
      
      final override protected function populatePriorities() : void
      {
         priorities[Damping] = -1;
         priorities[DeathZone] = -1;
         priorities[VelocityField] = -2;
         priorities[Gravity] = -3;
         priorities[MutualGravity] = -3;
         priorities[Move] = -4;
         priorities[Spin] = -4;
         priorities[Deflect] = -5;
         priorities[Collide] = -6;
         priorities[DeathZone] = -6;
         priorities[Oriented] = -6;
         priorities[ZoneTrigger] = -6;
         priorities[DeflectorTrigger] = -6;
         priorities[SnapshotRestore] = -7;
      }
   }
}
