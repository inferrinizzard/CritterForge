package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.managers.DialogBubbleManager;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.TricklingTextArea;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DialogBubbleSkin extends Skin
   {
      
      public static var MousePng:Class = DialogBubbleSkin_MousePng;
      
      public static var MouseClickPng:Class = DialogBubbleSkin_MouseClickPng;
       
      
      public var manager:DialogBubbleManager;
      
      public var textEnd:Boolean = false;
      
      private var _initParams:Object;
      
      private var _data;
      
      private var _type:uint = 1;
      
      private var _lifetime:uint;
      
      private var _isFemale:Boolean = false;
      
      private var _removable:Boolean;
      
      private var _extraData:Component;
      
      private var _anchorObject:Component;
      
      private var _anchorPoint:Point;
      
      private var _positionObject:Component;
      
      private var _positionPoint:Point;
      
      private var _positionHAlign:uint;
      
      private var _positionVAlign:uint;
      
      private var _listeningList:Array;
      
      private var _offset:Point;
      
      private var _moveAnimation:AnimationInstance;
      
      private var _bubbleParams:Object;
      
      private var _showPointer:Boolean = true;
      
      private var _pointerLength:uint;
      
      private var _cornerRadius:Number;
      
      private var _bubbleMaxWidth:int = -1;
      
      private var _isDecaying:Boolean = false;
      
      private var _decayAnim:AnimationInstance;
      
      private var _clickToFlush:Boolean = false;
      
      private var _manualFlush:Boolean = false;
      
      private var _flushWaitingForClick:Boolean = false;
      
      private var _aging:Boolean = false;
      
      private var _agingTimer:Timer;
      
      private var _highlighted:Boolean = false;
      
      private var _layoutBox:Box;
      
      private var _textArea:TricklingTextArea;
      
      private var _useHtml:Boolean = false;
      
      private var _color:uint;
      
      private var _borderColor:uint;
      
      private var _showClickHint:Boolean = false;
      
      private var _clickTimer:Timer;
      
      private var _clickBitmap:BitmapComponent;
      
      private var _mouseClickBitmap:Boolean = false;
      
      private var _clickArea:Component;
      
      public function DialogBubbleSkin(param1:DialogBubbleManager, param2:Object)
      {
         this._listeningList = [];
         this._offset = new Point(0,0);
         this._clickTimer = new Timer(800);
         super(null);
         filters = [new BlurFilter(0,0),new DropShadowFilter(4,45,0,0.75)];
         this._pointerLength = getStyle("pointerLength",60);
         this._cornerRadius = getStyle("CornerRadius",20);
         this.manager = param1;
         this.initParams = param2;
         alpha = 0;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         this._clickTimer.addEventListener(TimerEvent.TIMER,this.onClickTimer);
      }
      
      override public function get styleClassName() : String
      {
         return "DialogBubbleSkin";
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      override public function get inheritStyles() : Boolean
      {
         return false;
      }
      
      public function get initParams() : Object
      {
         return this._initParams;
      }
      
      public function set initParams(param1:Object) : void
      {
         this._initParams = param1;
         if(this._initParams.hasOwnProperty("anchorObject"))
         {
            this._anchorObject = this._initParams.anchorObject;
         }
         if(this._initParams.hasOwnProperty("anchorPoint"))
         {
            this._anchorPoint = this._initParams.anchorPoint;
         }
         if(!this._anchorObject)
         {
            this._anchorObject = this.manager.anchorObject;
         }
         if(!this._anchorPoint)
         {
            this._anchorPoint = this.manager.anchorPoint;
         }
         if(this._initParams.hasOwnProperty("positionObject"))
         {
            this._positionObject = this._initParams.positionObject;
         }
         else
         {
            this._positionObject = this.manager.positionObject;
         }
         if(this._initParams.hasOwnProperty("positionPoint"))
         {
            this._positionPoint = this._initParams.positionPoint;
         }
         else
         {
            this._positionPoint = this.manager.positionPoint;
         }
         if(this._initParams.hasOwnProperty("positionVAlign"))
         {
            this._positionVAlign = this._initParams.positionVAlign;
         }
         else
         {
            this._positionVAlign = this.manager.positionVAlign;
         }
         if(this._initParams.hasOwnProperty("positionHAlign"))
         {
            this._positionHAlign = this._initParams.positionHAlign;
         }
         else
         {
            this._positionHAlign = this.manager.positionHAlign;
         }
         if(this._initParams.hasOwnProperty("data"))
         {
            this._data = this._initParams.data;
         }
         if(this._initParams.hasOwnProperty("type"))
         {
            this._type = this._initParams.type;
         }
         if(this._initParams.hasOwnProperty("lifetime"))
         {
            this._lifetime = this._initParams.lifetime;
            this._agingTimer = new Timer(this._lifetime,1);
            this._agingTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAgingTimerComplete);
         }
         if(this._initParams.hasOwnProperty("removable"))
         {
            this._removable = this._initParams.removable;
         }
         if(this._initParams.hasOwnProperty("extraData"))
         {
            this._extraData = this._initParams.extraData;
         }
         if(this._initParams.hasOwnProperty("showPointer"))
         {
            this._showPointer = this._initParams.showPointer;
         }
         if(this._initParams.hasOwnProperty("clickToFlush"))
         {
            this._clickToFlush = this._initParams.clickToFlush;
         }
         else if(this._initParams.hasOwnProperty("manualFlush"))
         {
            this._manualFlush = this._initParams.manualFlush;
         }
         if(this._initParams.hasOwnProperty("textEnd"))
         {
            this.textEnd = this._initParams.textEnd;
         }
         else
         {
            this.textEnd = false;
         }
         if(this._initParams.hasOwnProperty("useHtml"))
         {
            this._useHtml = this._initParams.useHtml;
         }
         if(this._initParams.hasOwnProperty("bubbleColor") && !isNaN(this._initParams.bubbleColor))
         {
            this._borderColor = this._initParams.bubbleColor;
         }
         else
         {
            this._borderColor = getStyle("BorderColor",16777215);
         }
         if(this._initParams.hasOwnProperty("bubbleMaxWidth"))
         {
            this._bubbleMaxWidth = this._initParams.bubbleMaxWidth;
         }
         else
         {
            this._bubbleMaxWidth = this.manager.bubbleMaxWidth;
         }
         if(this._initParams.hasOwnProperty("pointerLength") && !isNaN(this._initParams.pointerLength))
         {
            this._pointerLength = this._initParams.pointerLength;
         }
         if(this._initParams.hasOwnProperty("clickArea"))
         {
            this._clickArea = this._initParams.clickArea;
         }
         else
         {
            this._clickArea = this.manager.clickArea;
         }
         if(this._initParams.hasOwnProperty("isFemale"))
         {
            this._isFemale = this._initParams.isFemale;
         }
         else
         {
            this._isFemale = false;
         }
         this.listenTo(this._anchorObject);
      }
      
      public function get dataDisplay() : DisplayObject
      {
         return this._data as DisplayObject;
      }
      
      public function get dataString() : String
      {
         var _loc2_:Asset = null;
         var _loc1_:String = "";
         if(this._data is Asset)
         {
            _loc2_ = this._data as Asset;
            if(!_loc2_.value)
            {
               _loc2_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onAssetChange);
               visible = false;
            }
            else
            {
               visible = true;
            }
            _loc1_ = _loc2_.value;
         }
         else
         {
            _loc1_ = this._data as String;
         }
         return _loc1_;
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         var _loc2_:AnimationInstance = null;
         super.doSetVisible(param1);
         if(param1)
         {
            _loc2_ = controller.addAnimation(UIGlobals.alphaFadeIn);
            _loc2_.play();
         }
      }
      
      public function startDecay(param1:uint = 1000) : void
      {
         enabled = false;
         this.listenTo(null);
         this._isDecaying = true;
         this.highlighted = false;
         this.showClickHint = false;
         var _loc2_:Animation = new Animation();
         var _loc3_:Track = new Track("alpha");
         _loc3_.addKeyframe(new Keyframe(0,1));
         _loc3_.addKeyframe(new Keyframe(param1 / 1000,0));
         _loc3_.addTransitionByKeyframeTime(0,Interpolation.quadInAndOut);
         _loc2_.addTrack(_loc3_);
         this._decayAnim = controller.addAnimation(_loc2_);
         this._decayAnim.addEventListener(AnimationEvent.STOP,this.onDecayAnimStop);
         this._decayAnim.gotoStartAndPlay();
         invalidateDisplayList();
         dispatchEvent(new Event(DialogBubbleManager.START_DECAY));
         if(Boolean(this._textArea) && this._textArea.trickling)
         {
            this._textArea.flush();
         }
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this._offset.x += param1;
         this._offset.y += param2;
         this.reposition(true);
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Box = null;
         super.createChildren();
         this._layoutBox = new Box(Box.VERTICAL,Box.ALIGN_CENTER);
         this._layoutBox.name = "DialogBubbleSkin:_layoutBox";
         this._layoutBox.autoSizeChildren = true;
         this._layoutBox.setStyle("PaddingLeft",getStyle("PaddingLeft",3));
         this._layoutBox.setStyle("PaddingRight",getStyle("PaddingRight",3));
         this._layoutBox.setStyle("PaddingTop",getStyle("PaddingTop",3));
         this._layoutBox.setStyle("PaddingBottom",getStyle("PaddingBottom",3));
         addChild(this._layoutBox);
         if(this.dataDisplay)
         {
            this._layoutBox.addChild(this.dataDisplay);
            this._layoutBox.invalidateSize();
            this.startAging();
            dispatchEvent(new Event(DialogBubbleManager.BUBBLE_FLUSHED));
         }
         else
         {
            this._textArea = new TricklingTextArea();
            this._textArea.name = "DialogBubbleSkin:_textArea";
            this._textArea.setStyle("FontSize",getStyle("FontSize"));
            this._textArea.setStyle("FontColor",getStyle("FontColor"));
            this._textArea.setStyle("FontWeight","bold");
            this._textArea.useHtml = this._useHtml;
            this._textArea.selectable = false;
            this._textArea.text = this.dataString;
            if(this._isFemale)
            {
               this._textArea.sound = getStyle("TrickleSoundFemale");
            }
            else
            {
               this._textArea.sound = getStyle("TrickleSoundMale");
            }
            this._textArea.addEventListener(TricklingTextArea.FINISHED,this.onTextAreaFinished);
            this._textArea.filters = [new GlowFilter(0,1,2,2,5)];
            if(this._bubbleMaxWidth > -1)
            {
               this._textArea.preferedWidth = this._bubbleMaxWidth;
            }
            this._layoutBox.addChild(this._textArea);
            this._layoutBox.invalidateSize();
         }
         if(this._extraData)
         {
            this._extraData.minWidth = 0;
            this._layoutBox.addChild(this._extraData);
            this._layoutBox.invalidateSize();
         }
         if(this._removable || this._clickToFlush)
         {
            this._clickBitmap = new BitmapComponent();
            this._clickBitmap.width = this._clickBitmap.height = 16;
            this._clickBitmap.source = MousePng;
            _loc1_ = new Box(Box.HORIZONTAL,Box.ALIGN_RIGHT);
            _loc1_.addChild(this._clickBitmap);
            this._layoutBox.addChild(_loc1_);
            this.showClickHint = true;
         }
         invalidateSize();
         invalidateDisplayList();
         if(this._clickArea)
         {
            this._clickArea.addEventListener(MouseEvent.CLICK,this.onClickAreaClick);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredHeight = this._layoutBox.height;
         measuredWidth = this._layoutBox.width;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(!stage || !parent)
         {
            return;
         }
         switch(this._type)
         {
            case DialogBubbleManager.TYPE_NORMAL:
               this.drawNormal(param1,param2);
               break;
            case DialogBubbleManager.TYPE_THINKING:
               this.drawThinking(param1,param2);
               break;
            default:
               throw new Error("Invalid DialogBubble type: " + this._type);
         }
      }
      
      override protected function sizeChanged() : void
      {
         super.sizeChanged();
         this.reposition();
      }
      
      private function get showClickHint() : Boolean
      {
         return this._showClickHint;
      }
      
      private function set showClickHint(param1:Boolean) : void
      {
         if(this._showClickHint != param1)
         {
            this._showClickHint = param1;
            if(this.showClickHint)
            {
               if(this._clickBitmap)
               {
                  this._clickBitmap.visible = true;
                  this._clickTimer.start();
               }
            }
            else if(this._clickBitmap)
            {
               this._clickBitmap.visible = false;
               this._clickTimer.stop();
            }
         }
      }
      
      private function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      private function set highlighted(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         if(this._highlighted != param1)
         {
            this._highlighted = param1;
            if(this.highlighted)
            {
               _loc2_ = filters;
               _loc2_.unshift(new GlowFilter(getStyle("ThemeColor"),0.2));
               filters = _loc2_;
            }
            else
            {
               _loc2_ = filters;
               _loc2_.shift();
               filters = _loc2_;
            }
         }
      }
      
      private function startAging() : void
      {
         if(this._lifetime)
         {
            this._aging = true;
            this._agingTimer.start();
         }
      }
      
      private function listenTo(param1:Component) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in this._listeningList)
         {
            _loc2_.removeEventListener(Component.X_CHANGED,this.onAnchorMoved);
            _loc2_.removeEventListener(Component.Y_CHANGED,this.onAnchorMoved);
         }
         this._listeningList = [];
         while(param1)
         {
            param1.addEventListener(Component.X_CHANGED,this.onAnchorMoved);
            param1.addEventListener(Component.Y_CHANGED,this.onAnchorMoved);
            this._listeningList.push(param1);
            param1 = param1.parent as Component;
         }
      }
      
      private function onAnchorMoved(param1:Event) : void
      {
         this.reposition(false);
         invalidateDisplayList();
      }
      
      private function onDecayAnimStop(param1:AnimationEvent) : void
      {
         if(this._moveAnimation)
         {
            controller.removeAnimation(this._moveAnimation);
            this._moveAnimation = null;
         }
         controller.removeAnimation(this._decayAnim);
         this._decayAnim = null;
         this._isDecaying = false;
         visible = false;
         dispatchEvent(new Event(DialogBubbleManager.DECAYED));
         if(this._clickArea)
         {
            this._clickArea.removeEventListener(MouseEvent.CLICK,this.onClickAreaClick);
         }
      }
      
      private function onMoveAnimStop(param1:AnimationEvent) : void
      {
         controller.removeAnimation(this._moveAnimation);
         this._moveAnimation = null;
         this.repositionParams();
         invalidateDisplayList();
      }
      
      private function onAssetChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "value")
         {
            this._textArea.text = this.dataString;
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(Boolean(this._textArea) && this._textArea.trickling)
         {
            this._textArea.flush();
         }
         else if(this._flushWaitingForClick)
         {
            this._flushWaitingForClick = false;
            this.startAging();
            if(!this._removable)
            {
               this.showClickHint = false;
            }
            dispatchEvent(new Event(DialogBubbleManager.BUBBLE_FLUSHED));
         }
         else if(this._isDecaying)
         {
            this._decayAnim.gotoEndAndStop();
         }
         else if(this._removable)
         {
            this.startDecay();
         }
      }
      
      private function onClickAreaClick(param1:MouseEvent) : void
      {
         if(Boolean(this._textArea) && this._textArea.trickling)
         {
            this._textArea.flush();
         }
         else if(this._flushWaitingForClick)
         {
            this._flushWaitingForClick = false;
            this.startAging();
            if(!this._removable)
            {
               this.showClickHint = false;
            }
            dispatchEvent(new Event(DialogBubbleManager.BUBBLE_FLUSHED));
         }
         else if(!this._isDecaying)
         {
            if(this._removable)
            {
               this.startDecay();
            }
         }
      }
      
      private function onMouseRollOver(param1:MouseEvent) : void
      {
         if(this._removable && !this._isDecaying)
         {
            this.highlighted = true;
         }
         if(this._aging)
         {
            this._agingTimer.stop();
         }
      }
      
      private function onMouseRollOut(param1:MouseEvent) : void
      {
         this.highlighted = false;
         if(this._aging && !this._isDecaying)
         {
            this._agingTimer.reset();
            this._agingTimer.start();
         }
      }
      
      private function onTextAreaFinished(param1:Event) : void
      {
         if(this._clickToFlush)
         {
            this._flushWaitingForClick = true;
         }
         else if(!this._manualFlush)
         {
            this.startAging();
            dispatchEvent(new Event(DialogBubbleManager.BUBBLE_FLUSHED));
         }
      }
      
      private function onClickTimer(param1:TimerEvent) : void
      {
         if(this._mouseClickBitmap)
         {
            this._clickBitmap.source = MousePng;
         }
         else
         {
            this._clickBitmap.source = MouseClickPng;
         }
         this._mouseClickBitmap = !this._mouseClickBitmap;
      }
      
      private function onAgingTimerComplete(param1:TimerEvent) : void
      {
         this._aging = false;
         if(!this._isDecaying)
         {
            this.startDecay();
         }
      }
      
      protected function moveAnimate(param1:Number, param2:Number) : void
      {
         if(this._moveAnimation)
         {
            this._moveAnimation.gotoEndAndStop();
         }
         var _loc3_:Animation = new Animation();
         var _loc4_:Track;
         (_loc4_ = new Track("x")).addKeyframe(new Keyframe(0,x));
         _loc4_.addKeyframe(new Keyframe(0.5,param1));
         _loc4_.addTransitionByKeyframeTime(0,Interpolation.elasticInAndOut);
         _loc3_.addTrack(_loc4_);
         var _loc5_:Track;
         (_loc5_ = new Track("y")).addKeyframe(new Keyframe(0,y));
         _loc5_.addKeyframe(new Keyframe(0.5,param2));
         _loc5_.addTransitionByKeyframeTime(0,Interpolation.elasticInAndOut);
         _loc3_.addTrack(_loc5_);
         this._moveAnimation = controller.addAnimation(_loc3_);
         this._moveAnimation.addEventListener(AnimationEvent.STOP,this.onMoveAnimStop);
         this._moveAnimation.gotoStartAndPlay();
      }
      
      protected function repositionParams() : void
      {
         this._bubbleParams.pointerStart = globalToLocal(this._bubbleParams.pointerStart);
         this._bubbleParams.pointerEnd = globalToLocal(this._bubbleParams.pointerEnd);
         this._bubbleParams.insidePointerStart = globalToLocal(this._bubbleParams.insidePointerStart);
         this._bubbleParams.insidePointerEnd = globalToLocal(this._bubbleParams.insidePointerEnd);
         this._bubbleParams.pointerAnchor = globalToLocal(this._bubbleParams.pointerAnchor);
         this._bubbleParams.anchorPoint = globalToLocal(this._anchorObject.localToGlobal(this._anchorPoint));
      }
      
      protected function reposition(param1:Boolean = false) : void
      {
         if(!stage || !parent)
         {
            return;
         }
         var _loc2_:Number = Math.min(this._pointerLength,height / 4);
         this._bubbleParams = this.getOrigin(this._pointerLength,10,_loc2_);
         if(param1)
         {
            this.moveAnimate(this._bubbleParams.origin.x,this._bubbleParams.origin.y);
         }
         else
         {
            x = this._bubbleParams.origin.x;
            y = this._bubbleParams.origin.y;
            this.repositionParams();
         }
      }
      
      protected function getOrigin(param1:uint, param2:uint, param3:uint) : Object
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc10_:Number = NaN;
         _loc4_ = parent.globalToLocal(this._anchorObject.localToGlobal(this._anchorPoint));
         _loc5_ = parent.globalToLocal(this._positionObject.localToGlobal(this._positionPoint));
         _loc5_.x += this._offset.x;
         _loc5_.y += this._offset.y;
         var _loc6_:Point = new Point();
         if(this._positionHAlign == DialogBubbleManager.HALIGN_LEFT)
         {
            _loc6_.x = _loc5_.x;
         }
         else if(this._positionHAlign == DialogBubbleManager.HALIGN_RIGHT)
         {
            _loc6_.x = _loc5_.x - width;
         }
         else
         {
            _loc6_.x = _loc5_.x - width / 2;
         }
         if(this._positionVAlign == DialogBubbleManager.VALIGN_TOP)
         {
            _loc6_.y = _loc5_.y;
         }
         else if(this._positionVAlign == DialogBubbleManager.VALIGN_BOTTOM)
         {
            _loc6_.y = _loc5_.y - height;
         }
         else
         {
            _loc6_.y = _loc5_.y - height / 2;
         }
         var _loc7_:Point = new Point(_loc6_.x + width / 2,_loc6_.y + height / 2);
         var _loc8_:Rectangle = new Rectangle(_loc6_.x,_loc6_.y,width,height);
         var _loc9_:Point;
         if((_loc9_ = new Point(_loc4_.x - _loc7_.x,_loc4_.y - _loc7_.y)).x == 0)
         {
            _loc10_ = Number.POSITIVE_INFINITY;
         }
         else
         {
            _loc10_ = _loc9_.y / _loc9_.x;
         }
         var _loc11_:Number = (_loc8_.top - _loc7_.y) / (_loc8_.left - _loc7_.x);
         var _loc12_:Number = (_loc8_.top - _loc7_.y) / (_loc8_.right - _loc7_.x);
         var _loc13_:Number = (_loc8_.bottom - _loc7_.y) / (_loc8_.right - _loc7_.x);
         var _loc14_:Number = (_loc8_.bottom - _loc7_.y) / (_loc8_.left - _loc7_.x);
         if(_loc10_ < _loc11_ && _loc10_ > _loc12_)
         {
            return this.initForHorizontalPointer(_loc8_,_loc4_,param2,param3,param1);
         }
         return this.initForVerticalPointer(_loc8_,_loc4_,param2,param3,param1);
      }
      
      private function initForHorizontalPointer(param1:Rectangle, param2:Point, param3:uint, param4:uint, param5:uint) : Object
      {
         var _loc6_:Point = new Point();
         var _loc7_:Point = new Point();
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         var _loc10_:Point = new Point(param1.x + param1.width / 2,param1.y + param1.height / 2);
         if(param2.x < _loc10_.x)
         {
            _loc7_.x = _loc6_.x = param1.left;
            _loc9_.x = _loc8_.x = param1.left + 1;
         }
         else
         {
            _loc7_.x = _loc6_.x = param1.right;
            _loc9_.x = _loc8_.x = param1.right - 1;
         }
         if(param2.y < _loc10_.y)
         {
            _loc6_.y = Math.max(param1.top + 2 * param4,param2.y);
            _loc7_.y = _loc6_.y + param3;
         }
         else
         {
            _loc7_.y = Math.min(param1.bottom - 2 * param4,param2.y);
            _loc6_.y = _loc7_.y + param3;
         }
         _loc8_.y = _loc6_.y + 1;
         _loc9_.y = _loc7_.y - 1;
         var _loc11_:Number = Math.min(1,param5 / Point.distance(_loc6_,param2));
         var _loc12_:Point = Point.interpolate(param2,_loc6_,_loc11_);
         return {
            "origin":param1.topLeft,
            "pointerStart":_loc6_,
            "pointerEnd":_loc7_,
            "insidePointerStart":_loc8_,
            "insidePointerEnd":_loc9_,
            "pointerAnchor":_loc12_
         };
      }
      
      private function initForVerticalPointer(param1:Rectangle, param2:Point, param3:uint, param4:uint, param5:uint) : Object
      {
         var _loc6_:Point = new Point();
         var _loc7_:Point = new Point();
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         var _loc10_:Point = new Point(param1.x + param1.width / 2,param1.y + param1.height / 2);
         if(param2.y < _loc10_.y)
         {
            _loc7_.y = _loc6_.y = param1.top;
            _loc9_.y = _loc8_.y = param1.top + 1;
         }
         else
         {
            _loc7_.y = _loc6_.y = param1.bottom;
            _loc9_.y = _loc8_.y = param1.bottom - 1;
         }
         if(param2.x < _loc10_.x)
         {
            _loc6_.x = Math.max(param1.left + 2 * param4,param2.x);
            _loc7_.x = _loc6_.x + param3;
         }
         else
         {
            _loc7_.x = Math.min(param1.right - 2 * param4,param2.x);
            _loc6_.x = _loc7_.x + param3;
         }
         _loc8_.x = _loc6_.x + 1;
         _loc9_.x = _loc7_.x - 1;
         var _loc11_:Number = Math.min(1,param5 / Point.distance(_loc6_,param2));
         var _loc12_:Point = Point.interpolate(param2,_loc6_,_loc11_);
         return {
            "origin":param1.topLeft,
            "pointerStart":_loc6_,
            "pointerEnd":_loc7_,
            "insidePointerStart":_loc8_,
            "insidePointerEnd":_loc9_,
            "pointerAnchor":_loc12_
         };
      }
      
      private function drawNormal(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getStyle("BackgroundColor",0);
         var _loc4_:uint = UIUtils.adjustBrightness2(_loc3_,-30);
         var _loc5_:uint = this._borderColor;
         var _loc6_:Number = UIUtils.adjustBrightness2(_loc5_,-60);
         var _loc7_:Number = getStyle("DialogBackgroundAlpha",1);
         var _loc8_:uint = getStyle("pointerLength",20);
         var _loc9_:Number;
         var _loc10_:Number = (_loc9_ = Math.min(getStyle("CornerRadius",20),param2 / 4)) - 1;
         var _loc11_:Matrix;
         (_loc11_ = new Matrix()).createGradientBox(param1,param2,Math.PI / 2);
         if(!this._bubbleParams)
         {
            return;
         }
         var _loc12_:Point = this._bubbleParams.anchorPoint;
         var _loc13_:Point = this._bubbleParams.pointerAnchor;
         var _loc14_:Point = parent.globalToLocal(this._bubbleParams.pointerStart);
         var _loc15_:Point = parent.globalToLocal(this._bubbleParams.pointerEnd);
         var _loc16_:Point = parent.globalToLocal(this._bubbleParams.insidePointerStart);
         var _loc17_:Point = parent.globalToLocal(this._bubbleParams.insidePointerEnd);
         graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc4_],[_loc7_,_loc7_],[0,255],_loc11_);
         graphics.drawRoundRect(0,0,param1,param2,_loc10_);
         graphics.endFill();
         graphics.lineStyle(1,_loc5_,1,true);
         graphics.drawRoundRect(2,2,param1 - 4,param2 - 4,_loc10_);
         graphics.beginFill(_loc5_,1);
         if(!this._isDecaying && this._showPointer)
         {
            graphics.moveTo(_loc16_.x,_loc16_.y);
            if(_loc16_.x == _loc17_.x)
            {
               graphics.lineTo(_loc13_.x - 1,_loc13_.y);
            }
            else
            {
               graphics.lineTo(_loc13_.x,_loc13_.y - 1);
            }
            graphics.lineTo(_loc17_.x,_loc17_.y);
         }
         graphics.endFill();
      }
      
      private function drawThinking(param1:Number, param2:Number) : void
      {
         var _loc14_:Point = null;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         var _loc17_:Point = null;
         var _loc18_:Array = null;
         var _loc19_:Object = null;
         var _loc3_:uint = getStyle("BackgroundColor",0);
         var _loc4_:uint = UIUtils.adjustBrightness2(_loc3_,-30);
         var _loc5_:uint = this._borderColor;
         var _loc6_:Number = UIUtils.adjustBrightness2(_loc5_,-60);
         var _loc7_:Number = getStyle("DialogBackgroundAlpha",1);
         var _loc8_:uint = getStyle("pointerLength",20);
         var _loc9_:Number;
         var _loc10_:Number = (_loc9_ = Math.min(getStyle("CornerRadius",20),param2 / 4)) - 1;
         var _loc11_:Matrix;
         (_loc11_ = new Matrix()).createGradientBox(param1,param2,Math.PI / 2);
         var _loc12_:Point = this._bubbleParams.anchorPoint;
         var _loc13_:Point = this._bubbleParams.pointerAnchor;
         graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc4_],[_loc7_,_loc7_],[0,255],_loc11_);
         graphics.drawRoundRect(0,0,param1,param2,_loc10_);
         graphics.endFill();
         graphics.lineStyle(1,_loc5_,1,true);
         graphics.drawRoundRect(2,2,param1 - 4,param2 - 4,_loc10_);
         if(!this._isDecaying && this._showPointer)
         {
            _loc14_ = parent.globalToLocal(this._bubbleParams.pointerStart);
            _loc15_ = parent.globalToLocal(this._bubbleParams.pointerEnd);
            _loc16_ = parent.globalToLocal(this._bubbleParams.insidePointerStart);
            _loc17_ = parent.globalToLocal(this._bubbleParams.insidePointerEnd);
            if(_loc14_.x == _loc12_.x || _loc14_.y == _loc12_.y)
            {
               _loc18_ = this.getCircles(_loc15_,_loc13_);
            }
            else
            {
               _loc18_ = this.getCircles(_loc14_,_loc13_);
            }
            for each(_loc19_ in _loc18_)
            {
               graphics.beginFill(_loc5_,1);
               graphics.drawCircle(_loc19_.center.x,_loc19_.center.y,_loc19_.radius);
               graphics.endFill();
               graphics.beginFill(_loc5_,1);
               graphics.drawCircle(_loc19_.center.x,_loc19_.center.y,_loc19_.radius - 1);
               graphics.endFill();
            }
         }
      }
      
      private function quad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param4 + param2 * param4 * param4 + param3;
      }
      
      private function getCircles(param1:Point, param2:Point) : Array
      {
         var _loc13_:Object = null;
         var _loc14_:Number = NaN;
         var _loc3_:uint = 3;
         var _loc4_:Number = Point.distance(param1,param2);
         var _loc5_:Number = -1;
         var _loc6_:Number = 1;
         var _loc7_:Number = 1;
         var _loc8_:Number = this.quad(_loc5_,_loc6_,_loc7_,_loc3_);
         var _loc9_:Number = _loc4_ / (_loc8_ * 2);
         var _loc10_:Array = [];
         var _loc11_:Number = 0;
         var _loc12_:uint = 1;
         while(_loc12_ <= _loc3_)
         {
            _loc13_ = new Object();
            _loc14_ = this.quad(_loc5_,_loc6_,_loc7_,_loc12_) * _loc9_ - _loc11_;
            _loc13_.radius = _loc14_;
            _loc13_.center = Point.interpolate(param1,param2,(_loc11_ * 2 + _loc14_) / _loc4_);
            _loc11_ += _loc14_;
            _loc10_.push(_loc13_);
            _loc12_++;
         }
         return _loc10_;
      }
   }
}
