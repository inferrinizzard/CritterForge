package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFormatAlign;
   
   public class CheckBoxSkin extends Skin
   {
       
      
      private var _skinShape:Shape;
      
      private var _crossShape:Shape;
      
      private var _label:Label;
      
      protected var _paddingLeft:Number;
      
      protected var _paddingRight:Number;
      
      protected var _paddingTop:Number;
      
      protected var _paddingBottom:Number;
      
      public function CheckBoxSkin(param1:Component)
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
         this._crossShape.filters = [new DropShadowFilter(2)];
         this.createLabel();
         addChild(this._skinShape);
         addChild(this._crossShape);
         addChild(this._label);
      }
      
      override protected function measure() : void
      {
         var _loc1_:String = null;
         super.measure();
         this._paddingLeft = component.getStyle("PaddingLeft",6);
         this._paddingRight = component.getStyle("PaddingRight",6);
         this._paddingTop = component.getStyle("PaddingTop",4);
         this._paddingBottom = component.getStyle("PaddingBottom",4);
         if((component as Button).labelUseHtml)
         {
            this._label.useHtml = true;
            _loc1_ = "";
            if((component as Button).label is Asset)
            {
               _loc1_ = ((component as Button).label as Asset).value;
            }
            else
            {
               _loc1_ = (component as Button).label;
            }
            _loc1_ = Utils.htmlWrap(_loc1_,getStyle("FontFamily"),getStyle("FontColor",734012),getStyle("FontSize",14));
            this._label.text = _loc1_;
         }
         else
         {
            this._label.useHtml = false;
            this._label.text = (component as Button).label;
         }
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
         var _loc16_:Number = NaN;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
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
         var _loc15_:Number = param2 / 2;
         _loc16_ = param2 / 2;
         switch((component as Button).state)
         {
            case "disabled":
               _loc17_ = [_loc6_[0],_loc6_[1]];
               _loc18_ = [Math.max(0,_loc5_[0] - 0.35),Math.max(0,_loc5_[1] - 0.35)];
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,_loc15_,_loc16_,_loc12_,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,_loc16_,_loc16_),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":_loc16_ - 2,
                  "h":_loc16_ - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,_loc16_ - 2,_loc13_,_loc17_,_loc18_,verticalGradientMatrix(1,1,_loc16_ - 2,_loc16_ - 2));
               break;
            case "up":
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,_loc16_,_loc16_,_loc12_,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,_loc16_,_loc16_),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":_loc16_ - 2,
                  "h":_loc16_ - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,_loc16_ - 2,_loc13_,_loc6_,_loc5_,verticalGradientMatrix(1,1,_loc16_ - 2,_loc16_ - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,(_loc16_ - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,_loc16_ - 2,(_loc16_ - 2) / 2));
               break;
            case "selected":
            case "down":
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,_loc16_,_loc16_,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,_loc16_,_loc16_));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,_loc16_ - 2,_loc13_,[_loc9_.fillColorPress1,_loc9_.fillColorPress2],1,verticalGradientMatrix(1,1,_loc16_ - 2,_loc16_ - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,2,2,_loc16_ - 4,(_loc16_ - 4) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,_loc16_ - 2,(_loc16_ - 2) / 2));
               this._crossShape.graphics.lineStyle(2,_loc11_,1,true);
               this._crossShape.graphics.moveTo(_loc15_ - 2,4);
               this._crossShape.graphics.lineTo(_loc16_ / 3,_loc16_ - 2);
               this._crossShape.graphics.lineTo(2,(_loc16_ - 4) * 2 / 3);
               break;
            case "over":
               if(_loc6_.length > 2)
               {
                  _loc19_ = [_loc6_[2],_loc6_[3]];
               }
               else
               {
                  _loc19_ = [_loc6_[0],_loc6_[1]];
               }
               if(_loc5_.length > 2)
               {
                  _loc20_ = [_loc5_[2],_loc5_[3]];
               }
               else
               {
                  _loc20_ = [_loc5_[0],_loc5_[1]];
               }
               filters = [new GlowFilter(_loc8_)];
               this._skinShape.graphics.clear();
               UIUtils.drawRoundRect(this._skinShape.graphics,0,0,_loc16_,_loc16_,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,_loc16_,_loc16_),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":_loc16_ - 2,
                  "h":_loc16_ - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,_loc16_ - 2,_loc13_,_loc19_,_loc20_,verticalGradientMatrix(1,1,_loc16_ - 2,_loc16_ - 2));
               UIUtils.drawRoundRect(this._skinShape.graphics,1,1,_loc16_ - 2,(_loc16_ - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,_loc16_ - 2,(_loc16_ - 2) / 2));
         }
         this.positionIconAndLabel();
      }
      
      override public function get styleClassName() : String
      {
         return "CheckBoxSkin";
      }
      
      private function createLabel() : void
      {
         this._label = new Label();
         this._label.alignment = TextFormatAlign.LEFT;
         this._label.text = "";
         this._label.setStyle("FontColor",734012);
         this._label.setStyle("FontWeight","normal");
         this._label.setStyle("FontSize",getStyle("FontSize",14));
      }
      
      private function positionIconAndLabel() : void
      {
         this._skinShape.y = height / 2 - this._skinShape.height / 2;
         this._crossShape.y = height / 2 - this._skinShape.height / 2;
         this._label.x = this._skinShape.width;
         this._label.y = height / 2 - this._label.height / 2;
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
         else if(param1.property == "labelUseHtml")
         {
            invalidateSize();
            invalidateDisplayList();
         }
      }
   }
}
