package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.Component;
   
   public class Spacer extends Component
   {
       
      
      public function Spacer()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:Number = getStyle("BackgroundAlpha");
         if(_loc3_)
         {
            _loc4_ = getStyle("CornerRadius");
            graphics.beginFill(getStyle("BackgroundColor"),_loc3_);
            graphics.drawRoundRect(0,0,param1,param2,_loc4_,_loc4_);
            graphics.endFill();
         }
      }
   }
}
