package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   
   public class CustomizableButtonSkin extends Skin
   {
       
      
      private var _skinShape:Shape;
      
      protected var _customShape:Shape;
      
      public function CustomizableButtonSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
      }
      
      protected function get button() : Button
      {
         return component as Button;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._skinShape = new Shape();
         this._customShape = new Shape();
         addChild(this._skinShape);
         addChild(this._customShape);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = component.width;
         measuredHeight = component.height;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         super.updateDisplayList(param1,param2);
         param1 = component.width;
         param2 = component.height;
         var _loc3_:uint = component.getStyle("BorderColor",11187123);
         var _loc4_:Number = component.getStyle("CornerRadius",4);
         _loc5_ = component.getStyle("FillAlphas",[0.9,0.75]);
         _loc6_ = component.getStyle("FillColors",[15134446,16777215]);
         var _loc7_:Array = component.getStyle("HighlightAlphas",[0.3,0]);
         var _loc8_:uint = component.getStyle("ThemeColor");
         var _loc9_:Object = UIGlobals.styleManager.getThemedColors(_loc8_,_loc6_[0],_loc6_[1]);
         var _loc10_:Number = UIUtils.adjustBrightness2(_loc3_,-50);
         var _loc11_:Number = UIUtils.adjustBrightness2(_loc8_,-25);
         var _loc12_:Number = Math.max(0,_loc4_);
         var _loc13_:Number = Math.max(0,_loc4_ - 1);
         var _loc14_:Number = Math.max(0,_loc4_ - 2);
         this._skinShape.filters = null;
         this._skinShape.graphics.clear();
         switch((component as Button).state)
         {
            case "disabled":
               _loc15_ = [_loc6_[0],_loc6_[1]];
               _loc16_ = [Math.max(0,_loc5_[0] - 0.35),Math.max(0,_loc5_[1] - 0.35)];
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,param1,param2,_loc12_,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,param2 - 2,_loc13_,_loc15_,_loc16_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               break;
            case "up":
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,param1,param2,_loc12_,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,param2 - 2,_loc13_,_loc6_,_loc5_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "down":
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,param1,param2,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,param2 - 2,_loc13_,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],1,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,2,2,param1 - 4,(param2 - 4) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
               break;
            case "over":
               this._skinShape.filters = [new GlowFilter(_loc8_,1)];
               if(_loc6_.length > 2)
               {
                  _loc17_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc17_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc18_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc18_ = [_loc5_[0],_loc5_[1]];
               }
               this._skinShape.graphics.clear();
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,param1,param2,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,param1,param2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":param1 - 2,
                  "h":param2 - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,param2 - 2,_loc13_,_loc17_,_loc18_,verticalGradientMatrix(1,1,param1 - 2,param2 - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,param1 - 2,(param2 - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,param1 - 2,(param2 - 2) / 2));
         }
         this.drawContent();
      }
      
      protected function drawContent() : void
      {
      }
      
      private function onComponentChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            invalidateDisplayList();
         }
      }
   }
}
