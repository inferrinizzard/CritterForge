package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.skins.borders.Border;
   import com.edgebee.atlas.ui.skins.borders.LineBorder;
   import com.edgebee.atlas.ui.skins.borders.ShadowBorder;
   import com.edgebee.atlas.ui.skins.borders.SoftBorder;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.ui.utils.types.CornerType;
   import flash.display.Bitmap;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class Canvas extends Component
   {
       
      
      private var _growWithChildren:Boolean = false;
      
      private var _childrenMaxHeight:Number = 0;
      
      private var _childrenMaxWidth:Number = 0;
      
      private var _cornerRadius:uint;
      
      private var _cornerType:uint;
      
      private var _backgroundColor;
      
      private var _backgroundAlpha;
      
      private var _backgroundOffsetX:Number;
      
      private var _backgroundOffsetY:Number;
      
      private var _backgroundRatios:Array;
      
      private var _backgroundDirection:Number;
      
      private var _backgroundRepeat:Boolean;
      
      private var _backgroundSpread:String;
      
      private var _backgroundScale:Number;
      
      private var _backgroundImage;
      
      private var _bgLoader:SWFLoader;
      
      private var _backgroundBitmap:Bitmap;
      
      public var border:LineBorder;
      
      protected var softBorder:SoftBorder;
      
      protected var shadowBorder:ShadowBorder;
      
      public function Canvas()
      {
         this._bgLoader = new SWFLoader();
         super();
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChanged);
      }
      
      public function get growWithChildren() : Boolean
      {
         return this._growWithChildren;
      }
      
      public function set growWithChildren(param1:Boolean) : void
      {
         this._growWithChildren = param1;
         this.invalidateSize();
      }
      
      override public function get styleClassName() : String
      {
         return "Canvas";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override public function get processedDescriptors() : Boolean
      {
         return this.allChildrenCreated();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!(this is Border) && getStyle("BorderThickness",0) != 0)
         {
            this.border = new LineBorder(this);
            this.border.includeInLayout = false;
         }
         if(!(this is Border) && getStyle("SoftBorderThickness",0) != 0)
         {
            this.softBorder = new SoftBorder(this);
            this.softBorder.includeInLayout = false;
         }
         if(!(this is Border) && getStyle("ShadowBorderEnabled",false))
         {
            this.shadowBorder = new ShadowBorder(this);
            this.shadowBorder.includeInLayout = false;
         }
         if(this.shadowBorder)
         {
            addChild(this.shadowBorder);
         }
         if(this.softBorder)
         {
            addChild(this.softBorder);
         }
         if(this.border)
         {
            addChild(this.border);
         }
         this._cornerRadius = getStyle("CornerRadius",0);
         this._cornerType = getStyle("CornerType",CornerType.ROUND);
         this._backgroundColor = getStyle("BackgroundColor",0);
         this._backgroundOffsetX = getStyle("BackgroundOffsetX",0);
         this._backgroundOffsetY = getStyle("BackgroundOffsetY",0);
         this._backgroundAlpha = getStyle("BackgroundAlpha",0);
         this._backgroundRatios = getStyle("BackgroundRatios",null);
         this._backgroundImage = getStyle("BackgroundImage",null);
         this._backgroundDirection = getStyle("BackgroundDirection",0);
         this._backgroundRepeat = getStyle("BackgroundRepeat",true);
         this._backgroundScale = getStyle("BackgroundScale",1);
         this._backgroundSpread = getStyle("BackgroundSpread",SpreadMethod.PAD);
         var _loc1_:Boolean = getStyle("BackgroundRepeat",true);
         this._bgLoader.addEventListener(Event.COMPLETE,this.onBgLoaded);
         processedDescriptors = this.allChildrenCreated();
      }
      
      protected function allChildrenCreated() : Boolean
      {
         var _loc2_:Component = null;
         var _loc1_:uint = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as Component;
            if(Boolean(_loc2_) && !_loc2_.initialized)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Matrix = null;
         var _loc6_:Matrix = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this._backgroundImage is String)
         {
            if(this._bgLoader.source != UIGlobals.getAssetPath(this._backgroundImage))
            {
               this._bgLoader.source = UIGlobals.getAssetPath(this._backgroundImage);
            }
         }
         if(this._backgroundAlpha)
         {
            _loc3_ = this._backgroundDirection;
            _loc4_ = this._backgroundScale;
            (_loc5_ = new Matrix()).createGradientBox(param1,param2,_loc3_,this._backgroundOffsetX,this._backgroundOffsetY);
            (_loc6_ = new Matrix()).scale(_loc4_,_loc4_);
            _loc6_.rotate(_loc3_);
            _loc6_.translate(this._backgroundOffsetX,this._backgroundOffsetY);
            if(this._backgroundImage is Class)
            {
               _loc7_ = new this._backgroundImage();
               graphics.beginBitmapFill(_loc7_.bitmapData,_loc6_,this._backgroundRepeat,true);
            }
            else if(this._backgroundImage is Bitmap)
            {
               _loc7_ = this._backgroundImage as Bitmap;
               graphics.beginBitmapFill(_loc7_.bitmapData,_loc6_,this._backgroundRepeat,true);
            }
            else if(this._backgroundImage is SWFLoader && (this._backgroundImage as SWFLoader).loaded)
            {
               _loc7_ = (this._backgroundImage as SWFLoader).content as Bitmap;
               graphics.beginBitmapFill(_loc7_.bitmapData,_loc6_,this._backgroundRepeat,true);
            }
            else if(this._backgroundImage is String && this._bgLoader.loaded)
            {
               _loc7_ = this._bgLoader.content as Bitmap;
               graphics.beginBitmapFill(_loc7_.bitmapData,_loc6_,this._backgroundRepeat,true);
            }
            else if(this._backgroundColor is Array)
            {
               if(this._backgroundColor.length < 2)
               {
                  throw new Error("Must specify at least two colors in BackgroundColor array.");
               }
               _loc8_ = this._backgroundRatios;
               if(this._backgroundAlpha is Array && this._backgroundAlpha.length == this._backgroundColor.length)
               {
                  _loc9_ = this._backgroundAlpha;
               }
               else
               {
                  _loc9_ = [];
                  _loc10_ = 0;
                  while(_loc10_ < this._backgroundColor.length)
                  {
                     _loc9_.push(this._backgroundAlpha);
                     _loc10_++;
                  }
               }
               if(!_loc8_)
               {
                  _loc8_ = [];
                  _loc11_ = 0;
                  while(_loc11_ < this._backgroundColor.length)
                  {
                     _loc8_.push(_loc11_ / (this._backgroundColor.length - 1) * 255);
                     _loc11_++;
                  }
               }
               graphics.beginGradientFill(GradientType.LINEAR,this._backgroundColor,_loc9_,_loc8_,_loc5_,this._backgroundSpread);
            }
            else
            {
               graphics.beginFill(this._backgroundColor,this._backgroundAlpha);
            }
            if(this._cornerType == CornerType.SQUARE)
            {
               UIUtils.drawCorneredRect(graphics,0,0,param1,param2,this._cornerRadius);
            }
            else
            {
               graphics.drawRoundRect(0,0,param1,param2,this._cornerRadius,this._cornerRadius);
            }
            graphics.endFill();
         }
      }
      
      override protected function validateChildren() : void
      {
         var _loc2_:Component = null;
         super.validateChildren();
         var _loc1_:uint = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as Component;
            if(Boolean(_loc2_) && (Boolean(_loc2_.percentWidth) || Boolean(_loc2_.percentHeight)))
            {
               _loc2_.invalidateSize();
            }
            _loc1_++;
         }
      }
      
      protected function onStyleChanged(param1:StyleChangedEvent) : void
      {
         switch(param1.style)
         {
            case "CornerRadius":
               this._cornerRadius = param1.newValue;
               if(this.border)
               {
                  this.border.invalidateDisplayList();
               }
               if(this.softBorder)
               {
                  this.softBorder.invalidateDisplayList();
               }
               break;
            case "CornerType":
               this._cornerType = param1.newValue;
               if(this.border)
               {
                  this.border.invalidateDisplayList();
               }
               if(this.softBorder)
               {
                  this.softBorder.invalidateDisplayList();
               }
               break;
            case "BackgroundImage":
               this._backgroundImage = param1.newValue;
               break;
            case "BackgroundColor":
               this._backgroundColor = param1.newValue;
               break;
            case "BackgroundOffsetX":
               this._backgroundOffsetX = param1.newValue;
               break;
            case "BackgroundOffsetY":
               this._backgroundOffsetY = param1.newValue;
               break;
            case "BackgroundAlpha":
               this._backgroundAlpha = param1.newValue;
               break;
            case "BackgroundRatios":
               this._backgroundRatios = param1.newValue;
               break;
            case "BackgroundDirection":
               this._backgroundDirection = param1.newValue;
               break;
            case "BackgroundRepeat":
               this._backgroundRepeat = param1.newValue;
               break;
            case "BackgroundSpread":
               this._backgroundSpread = param1.newValue;
               break;
            case "BorderColor":
            case "BorderThickness":
            case "BorderAlpha":
            case "BorderRatios":
            case "BorderOffset":
            case "BorderDirection":
               if(!(this is Border))
               {
                  if(this.border)
                  {
                     this.border.invalidateDisplayList();
                  }
                  else if(childrenCreated || childrenCreating)
                  {
                     if(param1.style == "BorderThickness" && param1.newValue != 0)
                     {
                        if(!this.border)
                        {
                           this.border = new LineBorder(this);
                           this.border.includeInLayout = false;
                        }
                        if(this.softBorder)
                        {
                           addChildAt(this.border,getChildIndex(this.softBorder) + 1);
                        }
                        else if(this.shadowBorder)
                        {
                           addChildAt(this.border,getChildIndex(this.shadowBorder) + 1);
                        }
                        else
                        {
                           addChildAt(this.border,0);
                        }
                        this.border.invalidateDisplayList();
                     }
                  }
               }
               break;
            case "SoftBorderColor":
            case "SoftBorderAlpha":
            case "SoftBorderThickness":
               if(!(this is Border))
               {
                  if(this.softBorder)
                  {
                     this.softBorder.invalidateDisplayList();
                  }
                  else if(childrenCreated || childrenCreating)
                  {
                     if(param1.style == "SoftBorderThickness" && param1.newValue != 0)
                     {
                        if(!this.softBorder)
                        {
                           this.softBorder = new SoftBorder(this);
                           this.softBorder.includeInLayout = false;
                        }
                        addChildAt(this.softBorder,0);
                        this.softBorder.invalidateDisplayList();
                     }
                  }
               }
               break;
            case "ShadowBorderEnabled":
            case "ShadowBorderAlpha":
            case "ShadowBorderColor":
            case "ShadowBorderRatios":
            case "ShadowBorderGradientSizeFactor":
               if(!(this is Border))
               {
                  if(this.shadowBorder)
                  {
                     this.shadowBorder.invalidateDisplayList();
                  }
                  else if(childrenCreated || childrenCreating)
                  {
                     if(param1.style == "ShadowBorderEnabled" && param1.newValue != false)
                     {
                        if(!this.shadowBorder)
                        {
                           this.shadowBorder = new ShadowBorder(this);
                           this.shadowBorder.includeInLayout = false;
                        }
                        addChildAt(this.shadowBorder,0);
                        this.shadowBorder.invalidateDisplayList();
                     }
                  }
               }
         }
         invalidateDisplayList();
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
         if(this.border)
         {
            this.border.invalidateSize();
         }
         if(this.softBorder)
         {
            this.softBorder.invalidateSize();
         }
         if(this.shadowBorder)
         {
            this.shadowBorder.invalidateSize();
         }
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         if(this.border)
         {
            this.border.invalidateDisplayList();
         }
         if(this.softBorder)
         {
            this.softBorder.invalidateDisplayList();
         }
         if(this.shadowBorder)
         {
            this.shadowBorder.invalidateDisplayList();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.growWithChildren)
         {
            if(!percentHeight)
            {
               measuredHeight = this._childrenMaxHeight;
            }
            if(!percentWidth)
            {
               measuredWidth = this._childrenMaxWidth;
            }
         }
      }
      
      override protected function childrenNotifyValidation(param1:Component) : void
      {
         super.childrenNotifyValidation(param1);
         if(name == "ShipInstanceView")
         {
         }
         var _loc2_:Number = param1.x + param1.width;
         if(_loc2_ > this._childrenMaxWidth)
         {
            this._childrenMaxWidth = _loc2_;
         }
         var _loc3_:Number = param1.y + param1.height;
         if(_loc3_ > this._childrenMaxHeight)
         {
            this._childrenMaxHeight = _loc3_;
         }
      }
      
      private function onBgLoaded(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
