package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.filters.GlowFilter;
   
   public class ButtonSkin extends Skin
   {
       
      
      protected var _mainBox:Box;
      
      protected var _layoutBox:Box;
      
      protected var _label:Label;
      
      protected var _currentIcon:DisplayObject;
      
      public function ButtonSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
      }
      
      protected function get button() : Button
      {
         return component as Button;
      }
      
      protected function get currentIcon() : DisplayObject
      {
         return this._currentIcon;
      }
      
      protected function set currentIcon(param1:DisplayObject) : void
      {
         var _loc2_:String = null;
         if(this._currentIcon != param1)
         {
            if(this._currentIcon)
            {
               this._layoutBox.removeChild(this._currentIcon);
            }
            this._currentIcon = this.button.icon;
            if(this._currentIcon)
            {
               _loc2_ = component.getStyle("IconSide","left");
               switch(_loc2_)
               {
                  case "right":
                     this._layoutBox.direction = Box.HORIZONTAL;
                     this._layoutBox.addChild(this._currentIcon);
                     break;
                  case "left":
                     this._layoutBox.direction = Box.HORIZONTAL;
                     this._layoutBox.addChildAt(this._currentIcon,0);
                     break;
                  case "top":
                     this._layoutBox.direction = Box.VERTICAL;
                     this._layoutBox.addChild(this._currentIcon);
                     break;
                  case "bottom":
                     this._layoutBox.direction = Box.VERTICAL;
                     this._layoutBox.addChildAt(this._currentIcon,0);
               }
            }
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      protected function get label() : *
      {
         return this.button.label;
      }
      
      protected function set label(param1:*) : void
      {
         if(childrenCreated || childrenCreating)
         {
            this._label.text = param1;
            this._label.visible = !!param1;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._layoutBox = new Box(Box.HORIZONTAL,Box.ALIGN_CENTER,Box.ALIGN_MIDDLE);
         this._layoutBox.name = "_layoutBox";
         this._layoutBox.setStyle("Gap",UIGlobals.relativize(5));
         this._layoutBox.layoutInvisibleChildren = false;
         this._layoutBox.setStyle("PaddingLeft",component.getStyle("PaddingLeft",6));
         this._layoutBox.setStyle("PaddingRight",component.getStyle("PaddingRight",6));
         this._layoutBox.setStyle("PaddingTop",component.getStyle("PaddingTop",4));
         this._layoutBox.setStyle("PaddingBottom",component.getStyle("PaddingBottom",4));
         this.currentIcon = this.button.icon;
         this._label = new Label();
         this._label.setStyle("FontWeight","bold");
         this._label.setStyle("FontSize",component.getStyle("FontSize",12));
         this._label.useHtml = getStyle("HTMLButton",false);
         this.label = this.button.label;
         this._layoutBox.addChild(this._label);
         addChild(this._layoutBox);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(percentWidth == 0)
         {
            measuredWidth = this._layoutBox.width;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._layoutBox.height;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc14_:Number = NaN;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         super.updateDisplayList(param1,param2);
         this._layoutBox.x = component.width / 2 - this._layoutBox.width / 2;
         this._layoutBox.y = component.height / 2 - this._layoutBox.height / 2;
         _loc3_ = component.getStyle("BorderColor",11187123);
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
         _loc14_ = Math.max(0,_loc4_ - 2);
         filters = null;
         graphics.clear();
         switch(this.button.state)
         {
            case "disabled":
               this._label.setStyle("FontColor",getStyle("DisabledColor"));
               _loc15_ = [_loc6_[0],_loc6_[1]];
               _loc16_ = [Math.max(0,_loc5_[0] - 0.35),Math.max(0,_loc5_[1] - 0.35)];
               UIUtils.drawRoundRect(graphics,0,0,component.width,component.height,_loc12_,[_loc3_,_loc10_],0.5,verticalGradientMatrix(0,0,component.width,component.height),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":component.width - 2,
                  "h":component.height - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,component.height - 2,_loc13_,_loc15_,_loc16_,verticalGradientMatrix(1,1,component.width - 2,component.height - 2));
               break;
            case "up":
               this._label.setStyle("FontColor",getStyle("FontColor"));
               UIUtils.drawRoundRect(graphics,0,0,component.width,component.height,_loc12_,[_loc3_,_loc10_],1,verticalGradientMatrix(0,0,component.width,component.height),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":component.width - 2,
                  "h":component.height - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,component.height - 2,_loc13_,_loc6_,_loc5_,verticalGradientMatrix(1,1,component.width - 2,component.height - 2));
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,(component.height - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,component.width - 2,(component.height - 2) / 2));
               break;
            case "selected":
            case "down":
               this._label.setStyle("FontColor",getStyle("FontColor"));
               UIUtils.drawRoundRect(graphics,0,0,component.width,component.height,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,component.width,component.height));
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,component.height - 2,_loc13_,[_loc9_.fillColorPress2,_loc9_.fillColorPress1],1,verticalGradientMatrix(1,1,component.width - 2,component.height - 2));
               UIUtils.drawRoundRect(graphics,2,2,component.width - 4,(component.height - 4) / 2,{
                  "tl":_loc14_,
                  "tr":_loc14_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],[_loc7_[1],_loc7_[0]],verticalGradientMatrix(1,1,component.width - 2,(component.height - 2) / 2));
               break;
            case "over":
               this._label.setStyle("FontColor",getStyle("FontColor"));
               filters = [new GlowFilter(_loc8_,1)];
               UIUtils.drawRoundRect(graphics,0,0,component.width,component.height,_loc12_,[_loc8_,_loc11_],1,verticalGradientMatrix(0,0,component.width,component.height),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":component.width - 2,
                  "h":component.height - 2,
                  "r":_loc4_ - 1
               });
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,component.height - 2,_loc13_,_loc6_,_loc5_,verticalGradientMatrix(1,1,component.width - 2,component.height - 2));
               UIUtils.drawRoundRect(graphics,1,1,component.width - 2,(component.height - 2) / 2,{
                  "tl":_loc13_,
                  "tr":_loc13_,
                  "bl":0,
                  "br":0
               },[16777215,16777215],_loc7_,verticalGradientMatrix(1,1,component.width - 2,(component.height - 2) / 2));
         }
      }
      
      protected function onComponentChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            invalidateDisplayList();
         }
         else if(param1.property == "label")
         {
            this.label = param1.newValue;
         }
         else if(param1.property == "icon")
         {
            this.currentIcon = param1.newValue as DisplayObject;
         }
      }
   }
}
