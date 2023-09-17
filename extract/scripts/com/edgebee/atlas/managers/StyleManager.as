package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.ui.skins.*;
   import com.edgebee.atlas.ui.utils.UIUtils;
   
   public class StyleManager
   {
       
      
      private var _styles:Object;
      
      private var _themedColorCache:Object;
      
      public function StyleManager()
      {
         this._themedColorCache = {};
         super();
         this._styles = defaultStyles;
      }
      
      public function getStyle(param1:String, param2:Object = null) : *
      {
         var _loc5_:String = null;
         var _loc3_:Array = param1.split(".");
         var _loc4_:Object = this._styles;
         for each(_loc5_ in _loc3_)
         {
            if(!_loc4_.hasOwnProperty(_loc5_))
            {
               _loc4_ = null;
               break;
            }
            _loc4_ = _loc4_[_loc5_];
         }
         if(_loc4_ == null)
         {
            if(_loc3_.length > 1)
            {
               return this.getStyle(_loc3_.slice(1).join("."),param2);
            }
            return param2;
         }
         return _loc4_;
      }
      
      public function overrideStyles(param1:Object) : void
      {
         this.overrideObject(this._styles,param1);
      }
      
      private function overrideObject(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            if(param1.hasOwnProperty(_loc3_))
            {
               if(param2[_loc3_] is int || param2[_loc3_] is uint || param2[_loc3_] is Number || param2[_loc3_] is String || param2[_loc3_] is Boolean || param2[_loc3_] is Class || param2[_loc3_] is Array)
               {
                  param1[_loc3_] = param2[_loc3_];
               }
               else
               {
                  this.overrideObject(param1[_loc3_],param2[_loc3_]);
               }
            }
            else
            {
               param1[_loc3_] = param2[_loc3_];
            }
         }
      }
      
      public function getThemedColors(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc4_:String = [param1,param2,param3].join(",");
         var _loc5_:Object;
         if(!(_loc5_ = this._themedColorCache[_loc4_]))
         {
            (_loc5_ = this._themedColorCache[_loc4_] = {}).themeColLgt = UIUtils.adjustBrightness(param1,100);
            _loc5_.themeColDrk1 = UIUtils.adjustBrightness(param1,-75);
            _loc5_.themeColDrk2 = UIUtils.adjustBrightness(param1,-25);
            _loc5_.fillColorBright1 = UIUtils.adjustBrightness2(param2,15);
            _loc5_.fillColorBright2 = UIUtils.adjustBrightness2(param3,15);
            _loc5_.fillColorPress1 = UIUtils.adjustBrightness2(param1,85);
            _loc5_.fillColorPress2 = UIUtils.adjustBrightness2(param1,60);
            _loc5_.bevelHighlight1 = UIUtils.adjustBrightness2(param2,40);
            _loc5_.bevelHighlight2 = UIUtils.adjustBrightness2(param3,40);
         }
         return _loc5_;
      }
   }
}

var defaultStyles:Object = {
   "ThemeColor":40447,
   "FontFamily":"Tahoma, Verdana, Arial",
   "FontSize":12,
   "HugeFontSize":24,
   "LargeFontSize":16,
   "SmallFontSize":9,
   "TinyFontSize":8,
   "FontColor":0,
   "FontWeight":"normal",
   "FontStyle":"normal",
   "DisabledColor":10066329,
   "ModalColor":0,
   "Tooltip":{
      "BorderColor":0,
      "BackgroundColor":16777185,
      "BackgroundAlpha":1,
      "Skin":DefaultTooltipSkin,
      "FontSize":12
   },
   "Window":{
      "CornerRadius":5,
      "BackgroundColor":10066329,
      "BackgroundAlpha":1,
      "PaddingLeft":10,
      "PaddingRight":10,
      "PaddingTop":10,
      "PaddingBottom":10,
      "WindowTitle":{
         "FontSize":14,
         "FontWeight":"bold",
         "FontColor":16777215
      },
      "CloseButton":{"Skin":CloseButtonSkin}
   },
   "Box":{
      "BackgroundColor":0,
      "BackgroundAlpha":0,
      "Gap":0
   },
   "TileList":{
      "BackgroundColor":0,
      "BackgroundAlpha":0,
      "OverState":{
         "Color":16777215,
         "Alpha":0.1,
         "Skin":DefaultListOverStateSkin
      },
      "SelectedState":{
         "Color":16777215,
         "Alpha":0.2,
         "Skin":DefaultListSelectedStateSkin
      }
   },
   "List":{
      "BackgroundColor":0,
      "BackgroundAlpha":0,
      "OverState":{
         "Color":16777215,
         "Alpha":0.1,
         "Skin":DefaultListOverStateSkin
      },
      "SelectedState":{
         "Color":16777215,
         "Alpha":0.2,
         "Skin":DefaultListSelectedStateSkin
      }
   },
   "Button":{"Skin":ButtonSkin},
   "RadioButton":{"Skin":RadioButtonSkin},
   "ToggleButton":{"Skin":ButtonSkin},
   "TextInput":{
      "BackgroundColor":16777215,
      "BackgroundAlpha":0.9,
      "BorderColor":0,
      "Skin":DefaultTextInputSkin
   },
   "TextArea":{"Skin":DefaultTextAreaSkin},
   "Swatches":{
      "Swatch":{
         "Width":200,
         "Height":100,
         "BorderSize":1,
         "BorderColor":0
      },
      "BackgroundColor":11184810,
      "BackgroundAlpha":1,
      "CornerRadius":4,
      "PaddingTop":4,
      "PaddingBottom":4,
      "PaddingLeft":4,
      "PaddingRight":4
   },
   "MenuItem":{
      "PaddingTop":1,
      "PaddingBottom":1,
      "PaddingLeft":1,
      "PaddingRight":1,
      "FontSize":11,
      "Skin":MenuItemSkin
   },
   "ValueStepper":{
      "DecreaseButtonSkin":DecreaseButtonSkin,
      "IncreaseButtonSkin":IncreaseButtonSkin
   }
};
