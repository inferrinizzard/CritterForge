package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.skins.ProgressBarSkin;
   import com.edgebee.atlas.ui.skins.Skin;
   
   public class ProgressBar extends Canvas
   {
      
      public static const HORIZONTAL:String = "HORIZONTAL";
      
      public static const VERTICAL:String = "VERTICAL";
      
      public static const LEFT:String = "LEFT";
      
      public static const RIGHT:String = "RIGHT";
      
      public static const UP:String = "UP";
      
      public static const DOWN:String = "DOWN";
       
      
      private var _value:Number = 0;
      
      private var _maximum:Number = 100;
      
      private var _orientation:String = "HORIZONTAL";
      
      private var _direction:String = "RIGHT";
      
      private var _skin:Skin;
      
      public function ProgressBar()
      {
         super();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this._value != param1)
         {
            _loc2_ = this._value;
            this._value = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"value",_loc2_,param1));
         }
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this._maximum != param1)
         {
            _loc2_ = this._maximum;
            this._maximum = param1;
            dispatchEvent(PropertyChangeEvent.create(this,"maximum",_loc2_,param1));
         }
      }
      
      public function get orientation() : String
      {
         return this._orientation;
      }
      
      public function set orientation(param1:String) : void
      {
         if(this._orientation != param1)
         {
            this._orientation = param1;
            if(this._orientation == HORIZONTAL && (this._direction != LEFT || this._direction != RIGHT))
            {
               this._direction = RIGHT;
            }
            if(this._orientation == VERTICAL && (this._direction != UP || this._direction != DOWN))
            {
               this._direction = UP;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"orientation",null,param1));
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction != param1)
         {
            this._direction = param1;
            if(this._direction == LEFT || this._direction == RIGHT)
            {
               this._orientation = HORIZONTAL;
            }
            if(this._direction == UP || this._direction == DOWN)
            {
               this._orientation = VERTICAL;
            }
            dispatchEvent(PropertyChangeEvent.create(this,"direction",null,param1));
         }
      }
      
      override public function get styleClassName() : String
      {
         return "ProgressBar";
      }
      
      public function setValueAndMaximum(param1:Number, param2:Number) : void
      {
         if(param1 != this._value || param2 != this._maximum)
         {
            this.value = param1;
            this.maximum = param2;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:Class = getStyle("Skin",ProgressBarSkin) as Class;
         this._skin = new _loc1_(this);
         addChild(this._skin);
      }
      
      override protected function validateChildren() : void
      {
         super.validateChildren();
         this._skin.invalidateSize();
         this._skin.invalidateDisplayList();
      }
   }
}
