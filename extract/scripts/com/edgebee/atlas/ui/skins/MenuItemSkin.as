package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.MenuItem;
   import com.edgebee.atlas.ui.controls.Spacer;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   
   public class MenuItemSkin extends Skin
   {
       
      
      protected var _layoutBox:Box;
      
      protected var _label:Label;
      
      protected var _icon:SubMenuIcon;
      
      public function MenuItemSkin(param1:Component)
      {
         super(param1);
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      protected function get menuItem() : MenuItem
      {
         return component as MenuItem;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._icon = new SubMenuIcon();
         this._layoutBox = new Box(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         this.createLabel();
         this._layoutBox.addChild(this._label);
         var _loc1_:Spacer = new Spacer();
         _loc1_.percentWidth = 1;
         this._layoutBox.addChild(_loc1_);
         this._layoutBox.addChild(this._icon);
         addChild(this._layoutBox);
         this._icon.visible = this.menuItem.subMenu != null;
         filters = [new DropShadowFilter(2,45,0,1,3,3,2)];
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = component.getStyle("PaddingLeft",0);
         var _loc2_:Number = component.getStyle("PaddingRight",0);
         var _loc3_:Number = component.getStyle("PaddingTop",0);
         var _loc4_:Number = component.getStyle("PaddingBottom",0);
         this._layoutBox.width = width;
         this._icon.width = this._label.height;
         this._icon.height = this._label.height;
         if(percentWidth == 0)
         {
            measuredWidth = this._label.width + this._label.height + _loc1_ + _loc2_;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._label.height + _loc3_ + _loc4_;
         }
         measuredWidth = Math.max(minWidth,measuredWidth);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:uint = getStyle("BackgroundColor",16777215);
         if(this.menuItem.highlighted && this.menuItem.enabled)
         {
            _loc4_ = 0.1;
            graphics.beginFill(_loc3_,_loc4_);
            graphics.lineStyle(1,_loc3_,Math.min(1,_loc4_ * 2),true);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         else if(this.menuItem.selected && this.menuItem.enabled)
         {
            _loc4_ = 0.2;
            graphics.beginFill(_loc3_,_loc4_);
            graphics.lineStyle(1,_loc3_,Math.min(1,_loc4_ * 2),true);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
      }
      
      private function createLabel() : void
      {
         this._label = new Label();
         this._label.alignment = TextFormatAlign.LEFT;
         this._label.text = this.menuItem.label;
         this._label.setStyle("FontColor",getStyle("FontColor"));
         this._label.setStyle("FontWeight",getStyle("FontWeight"));
         this._label.setStyle("FontSize",getStyle("FontSize"));
      }
   }
}

import com.edgebee.atlas.ui.Component;

class SubMenuIcon extends Component
{
    
   
   public function SubMenuIcon()
   {
      super();
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      graphics.lineStyle(1,(parent.parent as Object).getStyle("FontColor",0),1);
      graphics.beginFill((parent.parent as Object).getStyle("FontColor",0));
      graphics.moveTo(param1 / 3,param2 / 5);
      graphics.lineTo(2 * param1 / 3,param2 / 2);
      graphics.lineTo(param1 / 3,4 * param2 / 5);
      graphics.lineTo(param1 / 3,param2 / 5);
      graphics.endFill();
   }
}
