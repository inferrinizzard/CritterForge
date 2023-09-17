package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.filters.BevelFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFormatAlign;
   
   public class RadioButtonSkin extends Skin
   {
       
      
      private var _skinShape:Shape;
      
      private var _crossShape:Shape;
      
      private var _label:Label;
      
      protected var _paddingLeft:Number;
      
      protected var _paddingRight:Number;
      
      protected var _paddingTop:Number;
      
      protected var _paddingBottom:Number;
      
      public function RadioButtonSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._skinShape = new Shape();
         this._crossShape = new Shape();
         this._crossShape.filters = [new BevelFilter(2,45,16777215,0.5,0,0.35)];
         this.createLabel();
         addChild(this._skinShape);
         addChild(this._crossShape);
         addChild(this._label);
      }
      
      override protected function measure() : void
      {
         super.measure();
         this._paddingLeft = component.getStyle("PaddingLeft",6);
         this._paddingRight = component.getStyle("PaddingRight",6);
         this._paddingTop = component.getStyle("PaddingTop",4);
         this._paddingBottom = component.getStyle("PaddingBottom",4);
         this._label.text = (component as Button).label;
         if(percentWidth == 0)
         {
            measuredWidth = height + this._label.width + this._paddingLeft + this._paddingRight;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._label.height + this._paddingTop + this._paddingBottom;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc8_:uint = 0;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = component.getStyle("BorderColor",11187123);
         var _loc4_:Number = component.getStyle("CornerRadius",4);
         _loc5_ = component.getStyle("FillAlphas",[0.9,0.75]);
         _loc6_ = component.getStyle("FillColors",[15134446,16777215]);
         var _loc7_:Array = component.getStyle("HighlightAlphas",[0.3,0]);
         _loc8_ = component.getStyle("ThemeColor");
         var _loc9_:Object = UIGlobals.styleManager.getThemedColors(_loc8_,_loc6_[0],_loc6_[1]);
         var _loc10_:Number = UIUtils.adjustBrightness2(_loc3_,-50);
         var _loc11_:Number = UIUtils.adjustBrightness2(_loc8_,-25);
         var _loc12_:Number = Math.max(0,_loc4_);
         var _loc13_:Number = Math.max(0,_loc4_ - 1);
         var _loc14_:Number = Math.max(0,_loc4_ - 2);
         switch((component as Button).state)
         {
            case "disabled":
               this._label.setStyle("FontColor",getStyle("DisabledColor"));
               break;
            default:
               this._label.setStyle("FontColor",getStyle("FontColor"));
         }
         filters = null;
         this._skinShape.graphics.clear();
         this._crossShape.graphics.clear();
         var _loc15_:Number = param2 * 0.75;
         switch((component as Button).state)
         {
            case "disabled":
               _loc16_ = [_loc6_[0],_loc6_[1]];
               _loc17_ = [Math.max(0,_loc5_[0] - 0.5),Math.max(0,_loc5_[1] - 0.5)];
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc10_],[1,1],[0,255],verticalGradientMatrix(0,0,_loc15_,_loc15_));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,_loc16_,_loc17_,[0,255],verticalGradientMatrix(1,1,_loc15_ - 2,_loc15_ - 2));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 1);
               this._skinShape.graphics.endFill();
               break;
            case "up":
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc10_],[1,1],[0,255],verticalGradientMatrix(0,0,_loc15_,_loc15_));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,_loc6_,_loc5_,[0,255],verticalGradientMatrix(1,1,_loc15_ - 2,_loc15_ - 2));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 1);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[16777215,16777215],_loc7_,[0,255],verticalGradientMatrix(2,2,_loc15_ - 4,_loc15_ - 4));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 2);
               this._skinShape.graphics.endFill();
               break;
            case "selected":
            case "down":
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[_loc8_,_loc11_],[1,1],[0,255],verticalGradientMatrix(0,0,_loc15_,_loc15_));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],[1,1],[0,255],verticalGradientMatrix(1,1,_loc15_ - 2,_loc15_ - 2));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 1);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[16777215,16777215],_loc7_,[0,255],verticalGradientMatrix(2,2,_loc15_ - 4,_loc15_ - 4));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 2);
               this._skinShape.graphics.endFill();
               this._crossShape.graphics.beginFill(_loc11_,1);
               this._crossShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 4);
               this._crossShape.graphics.endFill();
               break;
            case "over":
               if(_loc6_.length > 2)
               {
                  _loc18_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc18_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc19_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc19_ = [_loc5_[0],_loc5_[1]];
               }
               filters = [new GlowFilter(_loc8_)];
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[_loc8_,_loc11_],[1,1],[0,255],verticalGradientMatrix(0,0,_loc15_,_loc15_));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,_loc18_,_loc19_,[0,255],verticalGradientMatrix(1,1,_loc15_ - 2,_loc15_ - 2));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 1);
               this._skinShape.graphics.endFill();
               this._skinShape.graphics.beginGradientFill(GradientType.LINEAR,[16777215,16777215],_loc7_,[0,255],verticalGradientMatrix(2,2,_loc15_ - 4,_loc15_ - 4));
               this._skinShape.graphics.drawCircle(_loc15_ / 2,_loc15_ / 2,_loc15_ / 2 - 2);
               this._skinShape.graphics.endFill();
         }
         this.positionIconAndLabel();
      }
      
      override public function get styleClassName() : String
      {
         return "RadioButtonSkin";
      }
      
      private function createLabel() : void
      {
         this._label = new Label();
         this._label.alignment = TextFormatAlign.LEFT;
         this._label.text = "";
         this._label.setStyle("FontColor",getStyle("FontColor",734012));
         this._label.setStyle("FontWeight",getStyle("FontWeight","normal"));
         this._label.setStyle("FontSize",getStyle("FontSize",14));
      }
      
      private function positionIconAndLabel() : void
      {
         this._label.x = this._skinShape.width;
         this._label.y = this._skinShape.height / 2 - this._label.height / 2;
      }
      
      private function onComponentChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            invalidateDisplayList();
         }
         else if(param1.property == "label")
         {
            invalidateSize();
            invalidateDisplayList();
         }
      }
   }
}
