package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   
   public class PropertyView extends Canvas
   {
       
      
      private var _target:WeakReference;
      
      private var _property:String;
      
      private var _handleNegative:Boolean;
      
      private var _icon:Class;
      
      private var _flipped:Boolean = false;
      
      public var valueCvs:Canvas;
      
      public var valueLbl:Label;
      
      public var iconBmp:BitmapComponent;
      
      private var _layout:Array;
      
      public function PropertyView()
      {
         this._target = new WeakReference(null,EventDispatcher);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":Label,
            "ID":"valueLbl",
            "STYLES":{"FontWeight":"bold"},
            "filters":UIGlobals.fontSmallOutline
         }];
         super();
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get target() : EventDispatcher
      {
         return this._target.get() as EventDispatcher;
      }
      
      public function set target(param1:EventDispatcher) : void
      {
         if(this.target != param1)
         {
            if(this.target)
            {
               this.target.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTargetChange);
            }
            this._target.reset(param1);
            if(this.target)
            {
               this.target.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTargetChange);
            }
            this.update();
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
      
      public function get handleNegative() : Boolean
      {
         return this._handleNegative;
      }
      
      public function set handleNegative(param1:Boolean) : void
      {
         if(this._handleNegative != param1)
         {
            this._handleNegative = param1;
         }
      }
      
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(param1:Class) : void
      {
         if(this._icon != param1)
         {
            this._icon = param1;
            if(this.iconBmp)
            {
               this.iconBmp.source = this.icon;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.iconBmp.source = this.icon;
         this.valueLbl.setStyle("FontFamily",getStyle("FontFamily"));
         this.valueLbl.setStyle("FontSize",getStyle("FontSize"));
         this.valueLbl.setStyle("FontWeight",getStyle("FontWeight"));
         this.update();
      }
      
      private function onTargetChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == this.property)
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
      
      private function get value() : Number
      {
         if(this.target)
         {
            return this.target[this.property] as Number;
         }
         return 0;
      }
      
      private function update() : void
      {
         var _loc1_:Matrix = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.target)
            {
               visible = true;
               this.valueLbl.text = this.value != 0 ? Utils.abreviateNumber(this.value,1) : "0";
               if(this.handleNegative)
               {
                  this.valueLbl.text = this.value != 0 ? Utils.abreviateNumber(Math.abs(this.value),1) : "-";
                  alpha = this.value == 0 ? 0.5 : 1;
                  this.iconBmp.colorTransformProxy.reset();
                  if(this.value < 0)
                  {
                     this.iconBmp.colorTransformProxy.redMultiplier = 1;
                     this.iconBmp.colorTransformProxy.blueMultiplier = 0;
                     this.iconBmp.colorTransformProxy.greenMultiplier = 0;
                     if(!this._flipped)
                     {
                        _loc1_ = new Matrix();
                        _loc1_.scale(1,-1);
                        _loc1_.translate(0,height);
                        this.iconBmp.transform.matrix = _loc1_;
                        this._flipped = true;
                     }
                  }
                  else if(this.value > 0)
                  {
                     this.iconBmp.colorTransformProxy.redMultiplier = 0;
                     this.iconBmp.colorTransformProxy.blueMultiplier = 0;
                     this.iconBmp.colorTransformProxy.greenMultiplier = 1;
                     if(this._flipped)
                     {
                        _loc1_ = new Matrix();
                        _loc1_.scale(1,1);
                        _loc1_.translate(0,0);
                        this.iconBmp.transform.matrix = _loc1_;
                        this._flipped = false;
                     }
                  }
               }
               else
               {
                  alpha = 1;
               }
               validateNow(true);
               this.valueLbl.x = this.valueLbl.getStyle("FontSize") / 4 + (width - this.valueLbl.width);
               this.valueLbl.y = 3 * this.valueLbl.getStyle("FontSize") / 5 + (height - this.valueLbl.height);
            }
            else
            {
               visible = false;
            }
         }
      }
   }
}
