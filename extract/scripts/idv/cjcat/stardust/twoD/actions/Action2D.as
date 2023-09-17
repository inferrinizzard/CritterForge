package idv.cjcat.stardust.twoD.actions
{
   import idv.cjcat.stardust.common.actions.Action;
   
   public class Action2D extends Action
   {
       
      
      public function Action2D()
      {
         super();
         _supports3D = false;
         priority = Action2DPriority.getInstance().getPriority(Object(this).constructor as Class);
      }
      
      override public function getXMLTagName() : String
      {
         return "Action2D";
      }
   }
}
