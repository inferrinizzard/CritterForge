package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFormatAlign;
   
   public class ProgressBarSkin extends Skin
   {
       
      
      private var _track:Sprite;
      
      private var _bar:Shape;
      
      private var _label:Label;
      
      private var _bgColor:uint;
      
      private var _bgAlpha:Number;
      
      private var _fgColor:uint;
      
      private var _fgAlpha:Number;
      
      private var _offset:Number;
      
      private var _showLabel:Boolean;
      
      private var _labelType:String;
      
      public function ProgressBarSkin(param1:Component)
      {
         super(param1);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onComponentStyleChanged);
         param1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onComponentChanged);
         this._bgColor = getStyle("BackgroundColor",0);
         this._bgAlpha = getStyle("BackgroundAlpha",1);
         this._fgColor = getStyle("ForegroundColor",16777215);
         this._fgAlpha = getStyle("ForegroundAlpha",1);
         this._offset = getStyle("BarOffset",2);
         this._showLabel = getStyle("ShowLabel",false);
         this._labelType = getStyle("LabelType","fraction");
      }
      
      protected function get progressBar() : ProgressBar
      {
         return component as ProgressBar;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._track = new Sprite();
         addChild(this._track);
         this._bar = new Shape();
         this._track.addChild(this._bar);
         this._label = new Label();
         if(this._showLabel)
         {
            addChild(this._label);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Rectangle = new Rectangle();
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Number = this._offset;
         if(this.progressBar.orientation == ProgressBar.HORIZONTAL)
         {
            _loc3_.width = this.progressBar.width;
            _loc3_.height = this.progressBar.height;
            if(this.progressBar.maximum > 0)
            {
               _loc4_.width = Math.max(0,this.progressBar.value / this.progressBar.maximum * (_loc3_.width - 2 * _loc5_));
            }
            else
            {
               _loc4_.width = 0;
            }
            _loc4_.height = Math.max(0,_loc3_.height - 2 * _loc5_);
            if(this.progressBar.direction == ProgressBar.RIGHT)
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_;
            }
            else
            {
               _loc4_.x = _loc5_ + (_loc3_.width - 2 * _loc5_ - _loc4_.width);
               _loc4_.y = _loc5_;
            }
            if(this._showLabel)
            {
               this._label.visible = true;
               _loc6_ = UIUtils.adjustBrightness2(getStyle("FontColor"),-85);
               if(this._labelType == "fraction")
               {
                  this._label.text = Utils.formatString("{v} / {m}",{
                     "v":Utils.abreviateNumber(this.progressBar.value,0),
                     "m":Utils.abreviateNumber(this.progressBar.maximum,0)
                  });
               }
               else if(this._labelType == "percentage")
               {
                  _loc7_ = 0;
                  if(this.progressBar.maximum > 0)
                  {
                     _loc7_ = 100 * (this.progressBar.value / this.progressBar.maximum);
                  }
                  this._label.text = int(_loc7_).toString() + "%";
               }
               this._label.alignment = TextFormatAlign.CENTER;
               this._label.x = this.progressBar.width / 2 - this._label.width / 2;
               this._label.y = this.progressBar.height / 2 - this._label.height / 2;
               this._label.setStyle("FontColor",getStyle("FontColor"));
               this._label.setStyle("FontSize",getStyle("FontSize"));
               this._label.filters = [new GlowFilter(_loc6_,1,2,2,8,1)];
            }
            else
            {
               this._label.visible = false;
               this._label.filters = null;
            }
         }
         else
         {
            _loc3_.width = this.progressBar.width;
            _loc3_.height = this.progressBar.height;
            _loc4_.width = Math.max(0,_loc3_.width - 2 * _loc5_);
            if(this.progressBar.maximum > 0)
            {
               _loc4_.height = Math.max(0,this.progressBar.value / this.progressBar.maximum * (_loc3_.height - 2 * _loc5_));
            }
            else
            {
               _loc4_.height = 0;
            }
            if(this.progressBar.direction == ProgressBar.UP)
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_ + (_loc3_.height - 2 * _loc5_ - _loc4_.height);
            }
            else
            {
               _loc4_.x = _loc5_;
               _loc4_.y = _loc5_;
            }
         }
         this._track.graphics.clear();
         this._track.graphics.beginFill(this._bgColor,this._bgAlpha);
         this._track.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         this._track.graphics.endFill();
         this._bar.graphics.clear();
         this._bar.graphics.beginFill(this._fgColor,this._fgAlpha);
         this._bar.graphics.drawRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height);
         this._bar.graphics.endFill();
      }
      
      private function onComponentChanged(param1:PropertyChangeEvent) : void
      {
         invalidateDisplayList();
      }
      
      private function onComponentStyleChanged(param1:StyleChangedEvent) : void
      {
         switch(param1.style)
         {
            case "BackgroundColor":
               this._bgColor = param1.newValue;
               break;
            case "BackgroundAlpha":
               this._bgAlpha = param1.newValue;
               break;
            case "ForegroundColor":
               this._fgColor = param1.newValue;
               break;
            case "ForegroundAlpha":
               this._fgAlpha = param1.newValue;
               break;
            case "BarOffset":
               this._offset = param1.newValue;
               break;
            case "LabelType":
               this._labelType = param1.newValue;
               break;
            case "ShowLabel":
               this._showLabel = param1.newValue;
               if(this._showLabel && !getChildIndex(this._label))
               {
                  addChild(this._label);
               }
               if(!this._showLabel && Boolean(getChildIndex(this._label)))
               {
                  removeChild(this._label);
               }
         }
      }
   }
}
