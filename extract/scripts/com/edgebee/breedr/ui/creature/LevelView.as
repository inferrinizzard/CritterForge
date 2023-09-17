package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Level;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class LevelView extends Box
   {
      
      public static const VALUE:String = "VALUE";
      
      public static const PROGRESS:String = "PROGRESS";
       
      
      private var _creature:WeakReference;
      
      private var _style:String;
      
      private var _property:String;
      
      private var _icon:Class;
      
      public var valueCvs:Canvas;
      
      public var valueLbl:Label;
      
      public var valueIconBg:BitmapComponent;
      
      public var valueIconFg:BitmapComponent;
      
      public var valueIconFgMask:Sprite;
      
      public var progressBox:Box;
      
      public var progressIcon01:BitmapComponent;
      
      public var progressIcon02:BitmapComponent;
      
      public var progressIcon03:BitmapComponent;
      
      public var progressIcon04:BitmapComponent;
      
      public var progressIcon05:BitmapComponent;
      
      public var progressIcon06:BitmapComponent;
      
      public var progressIcon07:BitmapComponent;
      
      public var progressIcon08:BitmapComponent;
      
      public var progressIcon09:BitmapComponent;
      
      public var progressIcon10:BitmapComponent;
      
      private var _layoutValue:Array;
      
      private var _layoutProgress:Array;
      
      public function LevelView()
      {
         this._creature = new WeakReference(null,CreatureInstance);
         this._layoutValue = [{
            "CLASS":Canvas,
            "ID":"valueCvs",
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"valueIconBg",
               "percentWidth":1,
               "percentHeight":1,
               "source":this.icon
            },{
               "CLASS":BitmapComponent,
               "ID":"valueIconFg",
               "percentWidth":1,
               "percentHeight":1,
               "source":this.icon,
               "filters":[new GlowFilter(0,0.35,2,2,3)]
            },{
               "CLASS":Label,
               "ID":"valueLbl",
               "STYLES":{"FontWeight":"bold"},
               "filters":UIGlobals.fontSmallOutline
            }]
         }];
         this._layoutProgress = [{
            "CLASS":Box,
            "ID":"progressBox",
            "layoutInvisibleChildren":false,
            "STYLES":{"Gap":-5},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"progressIcon01",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon02",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon03",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon04",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon05",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon06",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon07",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon08",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon09",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            },{
               "CLASS":BitmapComponent,
               "ID":"progressIcon10",
               "source":this.icon,
               "percentHeight":1,
               "isSquare":true
            }]
         }];
         super();
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(!this.creature || !this.creature.equals(param1))
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this.update();
         }
      }
      
      public function get style() : String
      {
         return this._style;
      }
      
      public function set style(param1:String) : void
      {
         if(this._style != param1)
         {
            this._style = param1;
            if(childrenCreated)
            {
               throw new Error("Cant switch LevelView style after initialization");
            }
         }
      }
      
      public function get property() : String
      {
         return this._property;
      }
      
      public function set property(param1:String) : void
      {
         if(this._property != param1)
         {
            this._property = param1;
         }
      }
      
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(param1:Class) : void
      {
         var _loc2_:BitmapComponent = null;
         var _loc3_:uint = 0;
         if(this._icon != param1)
         {
            this._icon = param1;
            if(childrenCreated)
            {
               if(this.style == VALUE)
               {
                  this.valueIconBg.source = this._icon;
                  this.valueIconFg.source = this._icon;
               }
               else
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.progressBox.numChildren)
                  {
                     _loc2_ = this.progressBox.getChildAt(_loc3_) as BitmapComponent;
                     _loc2_.source = this._icon;
                     _loc3_++;
                  }
               }
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:BitmapComponent = null;
         var _loc2_:uint = 0;
         super.createChildren();
         if(this.style == VALUE)
         {
            UIUtils.performLayout(this,this,this._layoutValue);
            this.valueLbl.setStyle("FontFamily",getStyle("FontFamily"));
            this.valueLbl.setStyle("FontSize",getStyle("FontSize"));
            this.valueLbl.setStyle("FontWeight",getStyle("FontWeight"));
            this.valueIconBg.colorMatrix.saturation = -100;
            this.valueIconBg.colorMatrix.brightness = 25;
            this.valueIconBg.colorMatrix.contrast = -50;
            this.valueIconFgMask = new Sprite();
            this.valueIconFg.mask = this.valueIconFgMask;
            this.valueCvs.addChild(this.valueIconFgMask);
            this.valueIconBg.source = this._icon;
            this.valueIconFg.source = this._icon;
         }
         else
         {
            UIUtils.performLayout(this,this,this._layoutProgress);
            _loc2_ = 0;
            while(_loc2_ < this.progressBox.numChildren)
            {
               _loc1_ = this.progressBox.getChildAt(_loc2_) as BitmapComponent;
               _loc1_.source = this._icon;
               _loc2_++;
            }
         }
         this.update();
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == this.property || param1.property == "max_" + this.property)
         {
            this.update();
         }
      }
      
      private function onStyleChange(param1:StyleChangedEvent) : void
      {
         if(childrenCreated)
         {
            if(param1.style == "FontSize")
            {
               this.valueLbl.setStyle("FontSize",param1.newValue);
            }
            if(param1.style == "FontWeight")
            {
               this.valueLbl.setStyle("FontWeight",param1.newValue);
            }
            if(param1.style == "FontFamily")
            {
               this.valueLbl.setStyle("FontFamily",param1.newValue);
            }
         }
      }
      
      private function get level() : Level
      {
         if(this.creature)
         {
            return this.creature[this.property] as Level;
         }
         return null;
      }
      
      private function update() : void
      {
         var _loc1_:BitmapComponent = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Level = null;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         if((childrenCreated || childrenCreating) && Boolean(this.creature))
         {
            if(this.creature[this.property] is Level)
            {
               _loc2_ = int(this.level.index);
               if(_loc5_ = this.level.getMaximum(this.creature))
               {
                  _loc3_ = int(_loc5_.index);
               }
               else
               {
                  _loc3_ = _loc2_;
               }
            }
            else
            {
               _loc2_ = int(this.creature[this.property]);
               _loc3_ = 100;
            }
            _loc4_ = _loc2_ / _loc3_;
            if(this.style == VALUE)
            {
               this.valueLbl.text = _loc2_.toString();
               validateNow(true);
               this.valueLbl.x = this.valueLbl.getStyle("FontSize") / 4 + (width - this.valueLbl.width);
               this.valueLbl.y = 3 * this.valueLbl.getStyle("FontSize") / 5 + (height - this.valueLbl.height);
               this.valueIconFgMask.graphics.clear();
               if(_loc4_ > 0)
               {
                  this.valueIconFgMask.graphics.beginFill(16777215,1);
                  this.valueIconFgMask.graphics.drawRect(0,(1 - _loc4_) * height,width,_loc4_ * height);
                  this.valueIconFgMask.graphics.endFill();
               }
               else
               {
                  this.valueIconFgMask.graphics.beginFill(16777215,1);
                  this.valueIconFgMask.graphics.drawRect(0,height - 1,width,1);
                  this.valueIconFgMask.graphics.endFill();
               }
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < this.progressBox.numChildren)
               {
                  _loc1_ = this.progressBox.getChildAt(_loc6_) as BitmapComponent;
                  _loc7_ = _loc6_;
                  if(!(this.creature[this.property] is Level))
                  {
                     _loc7_ = _loc6_ * 10;
                  }
                  if(_loc7_ >= _loc3_)
                  {
                     _loc1_.visible = false;
                  }
                  else if(_loc7_ >= _loc2_)
                  {
                     _loc1_.visible = true;
                     _loc1_.colorMatrix.saturation = -100;
                     _loc1_.colorMatrix.brightness = 25;
                     _loc1_.colorMatrix.contrast = -50;
                  }
                  else
                  {
                     _loc1_.visible = true;
                     _loc1_.colorMatrix.reset();
                  }
                  _loc6_++;
               }
            }
         }
      }
   }
}
