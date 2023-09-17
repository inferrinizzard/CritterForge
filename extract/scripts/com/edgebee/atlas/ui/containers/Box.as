package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.ui.Component;
   
   public class Box extends Canvas
   {
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL:String = "vertical";
      
      public static const ALIGN_LEFT:String = "left";
      
      public static const ALIGN_CENTER:String = "center";
      
      public static const ALIGN_RIGHT:String = "right";
      
      public static const ALIGN_TOP:String = "top";
      
      public static const ALIGN_MIDDLE:String = "middle";
      
      public static const ALIGN_BOTTOM:String = "bottom";
       
      
      private var _direction:String;
      
      private var _horizontalAlign:String;
      
      private var _verticalAlign:String;
      
      private var _spreadProportionalityX:Boolean = true;
      
      private var _spreadProportionalityY:Boolean = true;
      
      private var _layoutFreezedCount:uint = 0;
      
      protected var _aligner:Aligner;
      
      private var _autoSizeChildren:Boolean;
      
      private var _layoutInvisibleChildren:Boolean = true;
      
      private var _unreservedWidth:Number = 0;
      
      private var _unreservedHeight:Number = 0;
      
      private var _layoutInReverse:Boolean = false;
      
      public function Box(param1:String = "horizontal", param2:String = "left", param3:String = "top")
      {
         super();
         this.direction = param1;
         this.horizontalAlign = param2;
         this.verticalAlign = param3;
      }
      
      public function get autoSizeChildren() : Boolean
      {
         return this._autoSizeChildren;
      }
      
      public function set autoSizeChildren(param1:Boolean) : void
      {
         if(this._autoSizeChildren != param1)
         {
            this._autoSizeChildren = param1;
            invalidateSize();
         }
      }
      
      override public function get layoutInvisibleChildren() : Boolean
      {
         return this._layoutInvisibleChildren;
      }
      
      public function set layoutInvisibleChildren(param1:Boolean) : void
      {
         if(this._layoutInvisibleChildren != param1)
         {
            this._layoutInvisibleChildren = param1;
            invalidateSize();
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
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get layoutInReverse() : Boolean
      {
         return this._layoutInReverse;
      }
      
      public function set layoutInReverse(param1:Boolean) : void
      {
         if(this._layoutInReverse != param1)
         {
            this._layoutInReverse = param1;
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign != param1)
         {
            this._horizontalAlign = param1;
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign != param1)
         {
            this._verticalAlign = param1;
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function set spreadProportionality(param1:Boolean) : void
      {
         this.spreadProportionalityX = param1;
         this.spreadProportionalityY = param1;
      }
      
      public function get spreadProportionalityX() : Boolean
      {
         return this._spreadProportionalityX;
      }
      
      public function set spreadProportionalityX(param1:Boolean) : void
      {
         if(this._spreadProportionalityX != param1)
         {
            this._spreadProportionalityX = param1;
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get spreadProportionalityY() : Boolean
      {
         return this._spreadProportionalityY;
      }
      
      public function set spreadProportionalityY(param1:Boolean) : void
      {
         if(this._spreadProportionalityY != param1)
         {
            this._spreadProportionalityY = param1;
            this.resetAligner();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get layoutFreezed() : Boolean
      {
         return this._layoutFreezedCount != 0;
      }
      
      public function freezeLayout() : void
      {
         ++this._layoutFreezedCount;
      }
      
      public function unfreezeLayout() : uint
      {
         if(this._layoutFreezedCount)
         {
            --this._layoutFreezedCount;
            if(this._layoutFreezedCount == 0)
            {
               invalidateSize();
            }
         }
         return this._layoutFreezedCount;
      }
      
      public function forceRealignNow() : void
      {
         this._aligner.align(width,height);
      }
      
      override public function get styleClassName() : String
      {
         return "Box";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override public function get unreservedWidth() : Number
      {
         return this._unreservedWidth;
      }
      
      override public function set unreservedWidth(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Component = null;
         if(this._unreservedWidth != param1)
         {
            this._unreservedWidth = Math.max(0,param1);
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_) as Component;
               if(Boolean(_loc3_) && Boolean(_loc3_.percentWidth))
               {
                  _loc3_.invalidateSize();
               }
               _loc2_++;
            }
         }
      }
      
      override public function get unreservedHeight() : Number
      {
         return this._unreservedHeight;
      }
      
      override public function set unreservedHeight(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Component = null;
         if(this._unreservedHeight != param1)
         {
            this._unreservedHeight = Math.max(0,param1);
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_) as Component;
               if(Boolean(_loc3_) && Boolean(_loc3_.percentHeight))
               {
                  _loc3_.invalidateSize();
               }
               _loc2_++;
            }
         }
      }
      
      override protected function measure() : void
      {
         if(this.layoutFreezed)
         {
            return;
         }
         super.measure();
         this._aligner.measure();
         var _loc1_:Component = parent as Component;
         if(percentWidth == 0)
         {
            measuredWidth = this._aligner.maxWidth;
         }
         else if(_loc1_)
         {
            measuredWidth = _loc1_.unreservedWidth * percentWidth;
         }
         if(percentHeight == 0)
         {
            measuredHeight = this._aligner.maxHeight;
         }
         else if(_loc1_)
         {
            measuredHeight = _loc1_.unreservedHeight * percentHeight;
         }
         if(this.direction == Box.VERTICAL)
         {
            this.unreservedWidth = Math.min(maxWidth,Math.max(minWidth,getExplicitOrMeasuredWidth())) - (this._aligner._PaddingLeft + this._aligner._PaddingRight);
            this.unreservedHeight = Math.min(maxHeight,Math.max(minHeight,getExplicitOrMeasuredHeight())) - this._aligner.maxHeight;
         }
         else
         {
            this.unreservedWidth = Math.min(maxWidth,Math.max(minWidth,getExplicitOrMeasuredWidth())) - this._aligner.maxWidth;
            this.unreservedHeight = Math.min(maxHeight,Math.max(minHeight,getExplicitOrMeasuredHeight())) - (this._aligner._PaddingBottom + this._aligner._PaddingTop);
         }
      }
      
      override protected function validateChildren() : void
      {
         if(this.layoutFreezed)
         {
            return;
         }
         super.validateChildren();
         this._aligner.align(width,height);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function resetAligner() : void
      {
         if(this._direction == VERTICAL)
         {
            this._aligner = new VerticalAligner(this,this._horizontalAlign,this._verticalAlign);
         }
         else
         {
            if(this._direction != HORIZONTAL)
            {
               throw new Error("Unhandled direction \'" + this._direction + "\'");
            }
            this._aligner = new HorizontalAligner(this,this._horizontalAlign,this._verticalAlign);
         }
      }
   }
}

import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.util.WeakReference;

class Aligner
{
    
   
   private var _box:WeakReference;
   
   protected var _horizontalAlign:String;
   
   protected var _verticalAlign:String;
   
   protected var _currentX:Number;
   
   protected var _currentY:Number;
   
   protected var _gap:Number;
   
   public var _PaddingLeft:Number;
   
   public var _PaddingRight:Number;
   
   public var _PaddingTop:Number;
   
   public var _PaddingBottom:Number;
   
   public function Aligner(param1:Box, param2:String, param3:String)
   {
      super();
      this._box = new WeakReference(param1,Box);
      this._horizontalAlign = param2;
      this._verticalAlign = param3;
   }
   
   public function get box() : Box
   {
      return this._box.get() as Box;
   }
   
   public function measure() : void
   {
      this._gap = this.box.getStyle("Gap",0);
      this._PaddingLeft = this.box.getStyle("PaddingLeft",this.box.getStyle("Padding",0));
      this._PaddingRight = this.box.getStyle("PaddingRight",this.box.getStyle("Padding",0));
      this._PaddingTop = this.box.getStyle("PaddingTop",this.box.getStyle("Padding",0));
      this._PaddingBottom = this.box.getStyle("PaddingBottom",this.box.getStyle("Padding",0));
   }
   
   public function align(param1:Number, param2:Number) : void
   {
   }
   
   public function get maxWidth() : Number
   {
      return 0;
   }
   
   public function get maxHeight() : Number
   {
      return 0;
   }
   
   public function get containerWidth() : Number
   {
      return this.box.width - (this._PaddingLeft + this._PaddingRight);
   }
   
   public function get containerHeight() : Number
   {
      return this.box.height - (this._PaddingTop + this._PaddingBottom);
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.containers.Box;
import flash.display.DisplayObject;

class VerticalAligner extends Aligner
{
    
   
   private var _totalHeight:Number;
   
   private var _maxWidth:Number;
   
   private var _totalHeightPercent:Number;
   
   private var _maxWidthPercent:Number;
   
   public var getX:Function;
   
   public function VerticalAligner(param1:Box, param2:String, param3:String)
   {
      super(param1,param2,param3);
   }
   
   override public function measure() : void
   {
      var _loc4_:Component = null;
      super.measure();
      this._totalHeight = _PaddingBottom + _PaddingTop;
      this._totalHeightPercent = 0;
      this._maxWidth = 0;
      this._maxWidthPercent = 0;
      var _loc1_:uint = uint(box.numChildren);
      var _loc2_:uint = _loc1_;
      var _loc3_:uint = 0;
      while(_loc3_ < _loc1_)
      {
         if(!(_loc4_ = box.getChildAt(_loc3_) as Component) || !_loc4_.includeInLayout)
         {
            _loc2_--;
         }
         else if(_loc4_.visible || Boolean(box.layoutInvisibleChildren))
         {
            if(_loc4_.percentHeight == 0)
            {
               this._totalHeight += _loc4_.height;
            }
            else
            {
               this._totalHeightPercent += _loc4_.percentHeight;
            }
            if(_loc4_.percentWidth == 0)
            {
               if(box.autoSizeChildren)
               {
                  this._maxWidth = Math.max(this._maxWidth,_loc4_.unlimitedWidth);
               }
               else
               {
                  this._maxWidth = Math.max(this._maxWidth,_loc4_.width);
               }
            }
            else
            {
               this._maxWidthPercent = Math.max(this._maxWidthPercent,_loc4_.percentWidth);
            }
         }
         else
         {
            _loc2_--;
         }
         _loc3_++;
      }
      if(this._totalHeightPercent > 1)
      {
         throw new Error("Sum of percentHeight properties must be <= 1.0");
      }
      if(this._maxWidthPercent > 1)
      {
         throw new Error("Sum of percentWidth properties must be <= 1.0");
      }
      this._maxWidth += _PaddingLeft + _PaddingRight;
      this._totalHeight += (_loc2_ - 1) * _gap;
      if(isNaN(box.explicitHeight) && !box.percentHeight && this._totalHeightPercent && Boolean(box.spreadProportionalityY))
      {
         box.percentHeight = 1;
      }
      if(isNaN(box.explicitWidth) && !box.percentWidth && this._maxWidthPercent && Boolean(box.spreadProportionalityX))
      {
         box.percentWidth = 1;
      }
   }
   
   public function reset(param1:Number, param2:Number) : void
   {
      this._totalHeight += (param2 - this._totalHeight) * this._totalHeightPercent;
      this._maxWidth = Math.max(this._maxWidth,param1 * this._maxWidthPercent);
      this._maxWidth = Math.max(this._maxWidth,box.width);
      var _loc3_:Number = _PaddingTop + _PaddingBottom;
      var _loc4_:Number = _PaddingLeft + _PaddingRight;
      switch(_verticalAlign)
      {
         case Box.ALIGN_TOP:
            _currentY = _PaddingTop;
            break;
         case Box.ALIGN_MIDDLE:
            _currentY = (box.height - _loc3_) / 2 + _PaddingTop - (this._totalHeight - _loc3_) / 2;
            break;
         case Box.ALIGN_BOTTOM:
            _currentY = box.height - (this._totalHeight + _PaddingBottom);
            break;
         default:
            throw new Error("Unhandled algnment \'" + _verticalAlign + "\'");
      }
      switch(_horizontalAlign)
      {
         case Box.ALIGN_LEFT:
            _currentX = _PaddingLeft;
            this.getX = this.getLeftX;
            break;
         case Box.ALIGN_CENTER:
            _currentX = (box.width - _loc4_) / 2 + _PaddingLeft;
            this.getX = this.getCenterX;
            break;
         case Box.ALIGN_RIGHT:
            _currentX = box.width - _PaddingRight;
            this.getX = this.getRightX;
            break;
         default:
            throw new Error("Unhandled algnment \'" + _horizontalAlign + "\'");
      }
   }
   
   override public function align(param1:Number, param2:Number) : void
   {
      var _loc5_:Component = null;
      super.align(param1,param2);
      this.reset(param1,param2);
      var _loc3_:Array = [];
      var _loc4_:uint = 0;
      while(_loc4_ < box.numChildren)
      {
         _loc3_.push(box.getChildAt(_loc4_) as Component);
         _loc4_++;
      }
      if(box.layoutInReverse)
      {
         _loc3_ = _loc3_.reverse();
      }
      for each(_loc5_ in _loc3_)
      {
         if(_loc5_ && _loc5_.includeInLayout && (Boolean(box.layoutInvisibleChildren) || _loc5_.visible))
         {
            (_loc5_ as DisplayObject).x = this.getX(_loc5_.width);
            (_loc5_ as DisplayObject).y = this.getY(_loc5_.height);
            if(box.autoSizeChildren)
            {
               _loc5_.minWidth = this._maxWidth - (_PaddingLeft + _PaddingRight);
            }
         }
      }
   }
   
   override public function get maxWidth() : Number
   {
      return this._maxWidth;
   }
   
   override public function get maxHeight() : Number
   {
      return this._totalHeight;
   }
   
   public function getLeftX(param1:Number) : Number
   {
      return _currentX;
   }
   
   public function getCenterX(param1:Number) : Number
   {
      return _currentX - param1 / 2;
   }
   
   public function getRightX(param1:Number) : Number
   {
      return _currentX - param1;
   }
   
   public function getY(param1:Number) : Number
   {
      var _loc2_:Number = Number(_currentY);
      _currentY += param1 + _gap;
      return _loc2_;
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.containers.Box;
import flash.display.DisplayObject;

class HorizontalAligner extends Aligner
{
    
   
   private var _totalWidth:Number;
   
   private var _maxHeight:Number;
   
   private var _totalWidthPercent:Number;
   
   private var _maxHeightPercent:Number;
   
   public var getY:Function;
   
   public function HorizontalAligner(param1:Box, param2:String, param3:String)
   {
      super(param1,param2,param3);
   }
   
   override public function measure() : void
   {
      var _loc4_:Component = null;
      super.measure();
      this._totalWidth = _PaddingLeft + _PaddingRight;
      this._totalWidthPercent = 0;
      this._maxHeight = 0;
      this._maxHeightPercent = 0;
      var _loc1_:uint = uint(box.numChildren);
      var _loc2_:uint = _loc1_;
      var _loc3_:uint = 0;
      while(_loc3_ < _loc1_)
      {
         if(!(_loc4_ = box.getChildAt(_loc3_) as Component) || !_loc4_.includeInLayout)
         {
            _loc2_--;
         }
         else if(_loc4_.visible || Boolean(box.layoutInvisibleChildren))
         {
            if(_loc4_.percentWidth == 0)
            {
               this._totalWidth += _loc4_.width;
            }
            else
            {
               this._totalWidthPercent += _loc4_.percentWidth;
            }
            if(_loc4_.percentHeight == 0)
            {
               if(box.autoSizeChildren)
               {
                  this._maxHeight = Math.max(this._maxHeight,_loc4_.unlimitedHeight);
               }
               else
               {
                  this._maxHeight = Math.max(this._maxHeight,_loc4_.height);
               }
            }
            else
            {
               this._maxHeightPercent = Math.max(this._maxHeightPercent,_loc4_.percentHeight);
            }
         }
         else
         {
            _loc2_--;
         }
         _loc3_++;
      }
      if(this._maxHeightPercent > 1)
      {
         throw new Error("Sum of percentHeight properties must be <= 1.0");
      }
      if(this._totalWidthPercent > 1)
      {
         throw new Error("Sum of percentWidth properties must be <= 1.0");
      }
      this._maxHeight += _PaddingBottom + _PaddingTop;
      this._totalWidth += (_loc2_ - 1) * _gap;
      if(isNaN(box.explicitWidth) && !box.percentWidth && this._totalWidthPercent && Boolean(box.spreadProportionalityX))
      {
         box.percentWidth = 1;
      }
      if(isNaN(box.explicitHeight) && !box.percentHeight && this._maxHeightPercent && Boolean(box.spreadProportionalityY))
      {
         box.percentHeight = 1;
      }
   }
   
   public function reset(param1:Number, param2:Number) : void
   {
      this._totalWidth += (param1 - this._totalWidth) * this._totalWidthPercent;
      this._maxHeight = Math.max(this._maxHeight,param2 * this._maxHeightPercent);
      this._maxHeight = Math.max(this._maxHeight,box.height);
      var _loc3_:Number = _PaddingTop + _PaddingBottom;
      var _loc4_:Number = _PaddingLeft + _PaddingRight;
      switch(_verticalAlign)
      {
         case Box.ALIGN_TOP:
            _currentY = _PaddingTop;
            this.getY = this.getTopY;
            break;
         case Box.ALIGN_MIDDLE:
            _currentY = (box.height - _loc3_) / 2 + _PaddingTop;
            this.getY = this.getMiddleY;
            break;
         case Box.ALIGN_BOTTOM:
            _currentY = box.height - _PaddingBottom;
            this.getY = this.getBottomX;
            break;
         default:
            throw new Error("Unhandled algnment \'" + _verticalAlign + "\'");
      }
      switch(_horizontalAlign)
      {
         case Box.ALIGN_LEFT:
            _currentX = _PaddingLeft;
            break;
         case Box.ALIGN_CENTER:
            _currentX = (box.width - _loc4_) / 2 - (this._totalWidth - _loc4_) / 2 + _PaddingLeft;
            break;
         case Box.ALIGN_RIGHT:
            _currentX = box.width - (this._totalWidth + _PaddingRight);
            break;
         default:
            throw new Error("Unhandled algnment \'" + _horizontalAlign + "\'");
      }
   }
   
   override public function align(param1:Number, param2:Number) : void
   {
      var _loc5_:Component = null;
      super.align(param1,param2);
      this.reset(param1,param2);
      var _loc3_:Array = [];
      var _loc4_:uint = 0;
      while(_loc4_ < box.numChildren)
      {
         _loc3_.push(box.getChildAt(_loc4_) as Component);
         _loc4_++;
      }
      if(box.layoutInReverse)
      {
         _loc3_ = _loc3_.reverse();
      }
      for each(_loc5_ in _loc3_)
      {
         if(_loc5_ && _loc5_.includeInLayout && (Boolean(box.layoutInvisibleChildren) || _loc5_.visible))
         {
            (_loc5_ as DisplayObject).x = this.getX(_loc5_.width);
            (_loc5_ as DisplayObject).y = this.getY(_loc5_.height);
            if(box.autoSizeChildren)
            {
               _loc5_.minHeight = this._maxHeight - (_PaddingTop + _PaddingBottom);
            }
         }
      }
   }
   
   override public function get maxWidth() : Number
   {
      return this._totalWidth;
   }
   
   override public function get maxHeight() : Number
   {
      return this._maxHeight;
   }
   
   public function getTopY(param1:Number) : Number
   {
      return _currentY;
   }
   
   public function getMiddleY(param1:Number) : Number
   {
      return _currentY - param1 / 2;
   }
   
   public function getBottomX(param1:Number) : Number
   {
      return _currentY - param1;
   }
   
   public function getX(param1:Number) : Number
   {
      var _loc2_:Number = Number(_currentX);
      _currentX += param1 + _gap;
      return _loc2_;
   }
}
