package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.DisplayObject;
   
   public class LinkButtonSkin extends Skin
   {
       
      
      private var _layoutBox:Box;
      
      private var _label:Label;
      
      private var _iconHolderL:Box;
      
      private var _iconHolderR:Box;
      
      private var _currentIcon:DisplayObject;
      
      public function LinkButtonSkin(param1:Component)
      {
         super(param1);
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChange);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onComponentStyleChange);
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
               this._iconHolderL.removeAllChildren();
               this._iconHolderR.removeAllChildren();
               this._iconHolderR.visible = this._iconHolderL.visible = false;
            }
            this._currentIcon = this.button.icon;
            if(this._currentIcon)
            {
               _loc2_ = component.getStyle("IconSide","left");
               if(_loc2_ == "right")
               {
                  this._iconHolderR.addChild(this._currentIcon);
                  this._iconHolderR.visible = true;
               }
               else
               {
                  this._iconHolderL.addChild(this._currentIcon);
                  this._iconHolderL.visible = true;
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
      
      override public function get styleClassName() : String
      {
         return "LinkButtonSkin";
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
         this._layoutBox.setStyle("Gap",4);
         this._layoutBox.layoutInvisibleChildren = false;
         this._layoutBox.setStyle("PaddingLeft",component.getStyle("PaddingLeft",2));
         this._layoutBox.setStyle("PaddingRight",component.getStyle("PaddingRight",2));
         this._layoutBox.setStyle("PaddingTop",component.getStyle("PaddingTop",2));
         this._layoutBox.setStyle("PaddingBottom",component.getStyle("PaddingBottom",2));
         this._iconHolderL = new Box();
         this._iconHolderL.visible = false;
         this._iconHolderR = new Box();
         this._iconHolderR.visible = false;
         this.currentIcon = this.button.icon;
         this._label = new Label();
         this._label.text = this.button.label;
         this._label.setStyle("FontWeight","bold");
         this._label.setStyle("FontSize",component.getStyle("FontSize",10));
         this._label.setStyle("CapitalizeFirst",component.getStyle("CapitalizeFirst",true));
         this._label.setStyle("FontDecoration","underline");
         this._layoutBox.addChild(this._iconHolderL);
         this._layoutBox.addChild(this._label);
         this._layoutBox.addChild(this._iconHolderR);
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
         super.updateDisplayList(param1,param2);
         this._layoutBox.x = component.width / 2 - this._layoutBox.width / 2;
         this._layoutBox.y = component.height / 2 - this._layoutBox.height / 2;
         var _loc3_:uint = component.getStyle("ThemeColor");
         useHandCursor = true;
         graphics.clear();
         UIUtils.drawRoundRect(graphics,0,0,component.width,component.height,0,0,0);
         switch(this.button.state)
         {
            case "disabled":
               useHandCursor = false;
               this._label.setStyle("FontColor",getStyle("DisabledColor"));
               break;
            case "up":
               this._label.setStyle("FontColor",getStyle("FontColor"));
               break;
            case "selected":
            case "down":
               this._label.setStyle("FontColor",UIUtils.adjustBrightness2(_loc3_,-20));
               break;
            case "over":
               this._label.setStyle("FontColor",UIUtils.adjustBrightness2(_loc3_,30));
         }
      }
      
      private function onComponentChange(param1:PropertyChangeEvent) : void
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
      
      private function onComponentStyleChange(param1:StyleChangedEvent) : void
      {
         if(param1.style == "CapitalizeFirst")
         {
            if(this._label)
            {
               this._label.setStyle("CapitalizeFirst",param1.newValue);
            }
         }
      }
   }
}
