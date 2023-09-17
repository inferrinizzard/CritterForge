package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.util.WeakReference;
   import flash.geom.Matrix;
   
   public class Skin extends Canvas
   {
      
      private static var tempMatrix:Matrix = new Matrix();
       
      
      private var _component:WeakReference;
      
      public function Skin(param1:Component = null)
      {
         super();
         this._component = new WeakReference(param1,Component);
      }
      
      public function get component() : Component
      {
         var _loc1_:Component = this._component.get() as Component;
         return !!_loc1_ ? _loc1_ : parent as Component;
      }
      
      protected function rotatedGradientMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Matrix
      {
         tempMatrix.createGradientBox(param3,param4,param5 * Math.PI / 180,param1,param2);
         return tempMatrix;
      }
      
      protected function horizontalGradientMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix
      {
         return this.rotatedGradientMatrix(param1,param2,param3,param4,0);
      }
      
      protected function verticalGradientMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix
      {
         return this.rotatedGradientMatrix(param1,param2,param3,param4,90);
      }
   }
}
