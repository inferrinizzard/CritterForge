package idv.cjcat.stardust.twoD.actions.triggers
{
   import idv.cjcat.stardust.common.actions.triggers.ActionTrigger;
   import idv.cjcat.stardust.twoD.actions.Action2DPriority;
   
   public class ActionTrigger2D extends ActionTrigger
   {
       
      
      public function ActionTrigger2D()
      {
         super();
         _supports3D = false;
         priority = Action2DPriority.getInstance().getPriority(Object(this).constructor as Class);
      }
      
      override public function getXMLTagName() : String
      {
         return "ActionTrigger2D";
      }
   }
}
