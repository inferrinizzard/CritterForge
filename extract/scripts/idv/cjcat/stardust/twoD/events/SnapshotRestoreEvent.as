package idv.cjcat.stardust.twoD.events
{
   import flash.events.Event;
   
   public class SnapshotRestoreEvent extends Event
   {
      
      public static const COMPLETE:String = "stardustSnapshotRestoreComplete";
       
      
      public function SnapshotRestoreEvent(param1:String)
      {
         super(param1);
      }
   }
}
