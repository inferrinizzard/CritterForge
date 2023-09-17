package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.skins.DialogBubbleSkin;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class DialogBubbleManager extends EventDispatcher
   {
      
      public static const START_DECAY:String = "START_DECAY";
      
      public static const DECAYED:String = "DECAYED";
      
      public static const BUBBLE_FLUSHED:String = "BUBBLE_FLUSHED";
      
      public static const TEXT_FLUSHED:String = "TEXT_FLUSHED";
      
      public static const TEXT_FINISHED:String = "TEXT_FINISHED";
      
      public static const NEW_NPC:String = "NEW_NPC";
      
      public static const TYPE_NORMAL:uint = 1;
      
      public static const TYPE_THINKING:uint = 2;
      
      public static const HALIGN_CENTER:uint = 0;
      
      public static const HALIGN_LEFT:uint = 1;
      
      public static const HALIGN_RIGHT:uint = 2;
      
      public static const VALIGN_MIDDLE:uint = 0;
      
      public static const VALIGN_TOP:uint = 1;
      
      public static const VALIGN_BOTTOM:uint = 2;
       
      
      private var _dialogBubbleLayer:Component;
      
      private var _params:Array;
      
      private var _anchorObject:Component;
      
      private var _anchorPoint:Point;
      
      private var _positionObject:Component;
      
      private var _positionPoint:Point;
      
      private var _clickArea:Component;
      
      private var _positionHAlign:uint = 0;
      
      private var _positionVAlign:uint = 0;
      
      private var _useHtml:Boolean = false;
      
      private var _bubbleMaxWidth:int = -1;
      
      private var _waitingBubbles:Array;
      
      private var _currentBubbles:ArrayCollection;
      
      private var _maxLivingBubbleCount:uint = 1;
      
      private var _decayingBubbles:ArrayCollection;
      
      private var _autoProcessNext:Boolean = true;
      
      public function DialogBubbleManager(param1:Component)
      {
         this._params = [];
         this._waitingBubbles = [];
         this._currentBubbles = new ArrayCollection();
         this._decayingBubbles = new ArrayCollection();
         super();
         this._dialogBubbleLayer = param1;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get anchorObject() : Component
      {
         return this._anchorObject;
      }
      
      public function set anchorObject(param1:Component) : void
      {
         if(this._anchorObject != param1)
         {
            this._anchorObject = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"anchorObject",null,this.anchorObject));
         }
      }
      
      public function get anchorPoint() : Point
      {
         return this._anchorPoint;
      }
      
      public function set anchorPoint(param1:Point) : void
      {
         if(this._anchorPoint != param1)
         {
            this._anchorPoint = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"anchorPoint",null,this.anchorPoint));
         }
      }
      
      public function get positionObject() : Component
      {
         return this._positionObject;
      }
      
      public function set positionObject(param1:Component) : void
      {
         if(this._positionObject != param1)
         {
            this._positionObject = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"positionObject",null,this.positionObject));
         }
      }
      
      public function get positionPoint() : Point
      {
         return this._positionPoint;
      }
      
      public function set positionPoint(param1:Point) : void
      {
         if(this._positionPoint != param1)
         {
            this._positionPoint = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"positionPoint",null,this.positionPoint));
         }
      }
      
      public function get positionHAlign() : uint
      {
         return this._positionHAlign;
      }
      
      public function set positionHAlign(param1:uint) : void
      {
         if(this._positionHAlign != param1)
         {
            this._positionHAlign = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"positionHAlign",null,this.positionHAlign));
         }
      }
      
      public function get positionVAlign() : uint
      {
         return this._positionVAlign;
      }
      
      public function set positionVAlign(param1:uint) : void
      {
         if(this._positionVAlign != param1)
         {
            this._positionVAlign = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"positionVAlign",null,this.positionVAlign));
         }
      }
      
      public function get bubbleMaxWidth() : int
      {
         return this._bubbleMaxWidth;
      }
      
      public function set bubbleMaxWidth(param1:int) : void
      {
         if(this._bubbleMaxWidth != param1)
         {
            this._bubbleMaxWidth = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"bubbleMaxWidth",null,this.bubbleMaxWidth));
         }
      }
      
      public function get maxLivingBubbleCount() : uint
      {
         return this._maxLivingBubbleCount;
      }
      
      public function set maxLivingBubbleCount(param1:uint) : void
      {
         this._maxLivingBubbleCount = param1;
      }
      
      public function get useHtml() : Boolean
      {
         return this._useHtml;
      }
      
      public function set useHtml(param1:Boolean) : void
      {
         this._useHtml = param1;
      }
      
      public function get clickArea() : Component
      {
         return this._clickArea;
      }
      
      public function set clickArea(param1:Component) : void
      {
         if(this._clickArea != param1)
         {
            this._clickArea = param1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,this,"clickArea",null,this.clickArea));
         }
      }
      
      public function pushParams() : void
      {
         this._params.push({
            "anchorObject":this.anchorObject,
            "anchorPoint":this.anchorPoint,
            "positionObject":this.positionObject,
            "useHtml":this.useHtml,
            "positionPoint":this.positionPoint,
            "positionHAlign":this.positionHAlign,
            "positionVAlign":this.positionVAlign,
            "maxLivingBubbleCount":this.maxLivingBubbleCount,
            "bubbleMaxWidth":this.bubbleMaxWidth
         });
      }
      
      public function popParams() : void
      {
         var _loc1_:Object = this._params.pop();
         this.anchorObject = _loc1_.anchorObject;
         this.anchorPoint = _loc1_.anchorPoint;
         this.positionObject = _loc1_.positionObject;
         this.positionPoint = _loc1_.positionPoint;
         this.positionHAlign = _loc1_.positionHAlign;
         this.positionVAlign = _loc1_.positionVAlign;
         this.maxLivingBubbleCount = _loc1_.maxLivingBubbleCount;
         this.bubbleMaxWidth = _loc1_.bubbleMaxWidth;
         this.useHtml = _loc1_.useHtml;
      }
      
      public function clear() : void
      {
         var _loc1_:DialogBubbleSkin = null;
         this._waitingBubbles = [];
         for each(_loc1_ in this._decayingBubbles)
         {
            this.removeBubble(_loc1_);
         }
         this._decayingBubbles = new ArrayCollection();
         for each(_loc1_ in this._currentBubbles)
         {
            this.removeBubble(_loc1_);
         }
         this._currentBubbles = new ArrayCollection();
      }
      
      public function flush() : void
      {
         while(this._waitingBubbles.length)
         {
            this.processNext(200);
         }
      }
      
      public function createBubbleStruct(param1:*, param2:Boolean, param3:uint = 0, param4:Boolean = false, param5:Component = null, param6:Boolean = true, param7:Boolean = true) : Object
      {
         if(param7)
         {
            return {
               "data":param1,
               "isFemale":param2,
               "lifetime":param3,
               "removable":param4,
               "extraData":param5,
               "textEnd":true,
               "showPointer":param6,
               "useHtml":this.useHtml,
               "anchorObject":this.anchorObject,
               "anchorPoint":this.anchorPoint,
               "positionObject":this.positionObject,
               "bubbleMaxWidth":this.bubbleMaxWidth,
               "positionPoint":this.positionPoint,
               "positionHAlign":this.positionHAlign,
               "positionVAlign":this.positionVAlign
            };
         }
         return {
            "data":param1,
            "isFemale":param2,
            "lifetime":param3,
            "removable":param4,
            "extraData":param5,
            "textEnd":true,
            "showPointer":param6
         };
      }
      
      public function popBubbleFromStruct(param1:Object, param2:Boolean = false) : void
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         if(param2)
         {
            this.flush();
         }
         var _loc3_:RegExp = /(\$[\w:]*;)/;
         var _loc4_:* = false;
         if(param1.data is String || param1.data is Asset)
         {
            if(!(_loc5_ = param1.data as String))
            {
               _loc5_ = (param1.data as Asset).value;
            }
            _loc4_ = _loc5_.search(_loc3_) != -1;
         }
         if(_loc4_)
         {
            _loc6_ = {};
            if(param1.hasOwnProperty("anchorObject"))
            {
               _loc6_.anchorObject = param1.anchorObject;
            }
            if(param1.hasOwnProperty("anchorPoint"))
            {
               _loc6_.anchorPoint = param1.anchorPoint;
            }
            if(param1.hasOwnProperty("positionObject"))
            {
               _loc6_.positionObject = param1.positionObject;
            }
            if(param1.hasOwnProperty("positionPoint"))
            {
               _loc6_.positionPoint = param1.positionPoint;
            }
            if(param1.hasOwnProperty("positionHAlign"))
            {
               _loc6_.positionHAlign = param1.positionHAlign;
            }
            if(param1.hasOwnProperty("positionVAlign"))
            {
               _loc6_.positionVAlign = param1.positionVAlign;
            }
            if(param1.hasOwnProperty("type"))
            {
               _loc6_.type = param1.type;
            }
            if(param1.hasOwnProperty("showPointer"))
            {
               _loc6_.showPointer = param1.showPointer;
            }
            if(param1.hasOwnProperty("bubbleColor"))
            {
               _loc6_.bubbleColor = param1.bubbleColor;
            }
            if(param1.hasOwnProperty("bubbleMaxWidth"))
            {
               _loc6_.bubbleMaxWidth = param1.bubbleMaxWidth;
            }
            _loc6_.removable = true;
            _loc7_ = this.doProcessText(_loc5_,_loc6_);
            for each(_loc8_ in _loc7_)
            {
               this._waitingBubbles.push(_loc8_);
            }
            (_loc9_ = this._waitingBubbles[this._waitingBubbles.length - 1]).textEnd = true;
            if(param1.hasOwnProperty("clickToFlush"))
            {
               _loc9_.clickToFlush = param1.clickToFlush;
            }
            else if(param1.hasOwnProperty("manualFlush"))
            {
               _loc9_.manualFlush = param1.manualFlush;
            }
            if(param1.hasOwnProperty("extraData"))
            {
               _loc9_.extraData = param1.extraData;
            }
            if(param1.hasOwnProperty("removable"))
            {
               _loc9_.removable = param1.removable;
            }
            if(param1.hasOwnProperty("lifetime"))
            {
               _loc9_.lifetime = param1.lifetime;
            }
            if(param1.hasOwnProperty("isFemale"))
            {
               _loc9_.isFemale = param1.isFemale;
            }
         }
         else
         {
            this._waitingBubbles.push(param1);
         }
         this.processNext();
      }
      
      public function processText(param1:String, param2:Boolean = false, param3:Component = null, param4:Point = null, param5:Number = NaN, param6:Number = NaN) : void
      {
         var _loc8_:Object = null;
         var _loc7_:Object = this.doProcessText(param1,{
            "isFemale":param2,
            "lifetime":0,
            "removable":true,
            "anchorObject":param3,
            "anchorPoint":param4,
            "bubbleColor":param5,
            "pointerLength":param6
         });
         for each(_loc8_ in _loc7_)
         {
            this._waitingBubbles.push(_loc8_);
         }
         this._waitingBubbles[this._waitingBubbles.length - 1].textEnd = true;
         this.processNext();
      }
      
      public function unpopCurrentBubble(param1:uint = 4000) : void
      {
         var _loc2_:DialogBubbleSkin = null;
         if(this._waitingBubbles.length)
         {
            this.processNext(param1);
         }
         else if(this._currentBubbles.length)
         {
            this._autoProcessNext = false;
            while(this._currentBubbles.length)
            {
               _loc2_ = this._currentBubbles.getItemAt(0) as DialogBubbleSkin;
               _loc2_.startDecay(param1);
            }
            this._autoProcessNext = true;
         }
      }
      
      private function cloneParams(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      private function doProcessText(param1:String, param2:Object) : Array
      {
         var _loc5_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc3_:RegExp = /(\$[\w\/\.:]*;)/;
         var _loc4_:Array = param1.split(_loc3_);
         var _loc6_:Array = [];
         var _loc7_:Object = this.cloneParams(param2);
         for each(_loc8_ in _loc4_)
         {
            if(_loc8_)
            {
               if(_loc9_ = _loc8_.match(/\$([\w\/\.:]*);/))
               {
                  if((_loc8_ = _loc8_.substr(1,_loc8_.length - 2)).indexOf(":") >= 0)
                  {
                     _loc8_ = (_loc9_ = _loc8_.split(":"))[0] as String;
                     if(_loc9_[1] == "false")
                     {
                        _loc5_ = false;
                     }
                     else if(_loc9_[1] == "true")
                     {
                        _loc5_ = true;
                     }
                     else
                     {
                        _loc5_ = _loc9_[1];
                     }
                  }
                  switch(_loc8_)
                  {
                     case "normal":
                        _loc7_.type = DialogBubbleManager.TYPE_NORMAL;
                        break;
                     case "thinking":
                        _loc7_.type = DialogBubbleManager.TYPE_THINKING;
                        break;
                     case "lifetime":
                        _loc7_.lifetime = int(_loc5_);
                        break;
                     case "removable":
                        _loc7_.removable = _loc5_;
                        break;
                     case "color":
                        _loc7_.bubbleColor = int(_loc5_);
                        break;
                     case "clickToFlush":
                        _loc7_.clickToFlush = _loc5_;
                        break;
                     case "manualFlush":
                        _loc7_.manualFlush = _loc5_;
                        break;
                     case "npc":
                        _loc7_.npc = _loc5_;
                        break;
                     default:
                        throw new Error("Invalid dialog bubble option: " + _loc8_);
                  }
               }
               else
               {
                  _loc7_.data = _loc8_;
                  _loc6_.push(_loc7_);
                  _loc7_ = this.cloneParams(param2);
               }
            }
         }
         return _loc6_;
      }
      
      private function processNext(param1:uint = 4000) : void
      {
         var _loc2_:DialogBubbleSkin = null;
         var _loc4_:DialogBubbleSkin = null;
         var _loc5_:int = 0;
         if(!this._waitingBubbles.length)
         {
            return;
         }
         if(this._currentBubbles.length == this._maxLivingBubbleCount)
         {
            this._autoProcessNext = false;
            _loc2_ = this._currentBubbles.getItemAt(0) as DialogBubbleSkin;
            _loc2_.startDecay(param1);
            this._autoProcessNext = true;
         }
         var _loc3_:Object = this._waitingBubbles.shift();
         _loc2_ = new DialogBubbleSkin(this,_loc3_);
         if(_loc3_.hasOwnProperty("textEnd") && Boolean(_loc3_.textEnd))
         {
            _loc2_.addEventListener(BUBBLE_FLUSHED,this.onTextLastBubbleFlushed);
         }
         if(_loc3_.hasOwnProperty("npc"))
         {
            dispatchEvent(new ExtendedEvent(NEW_NPC,_loc3_.npc));
         }
         this.addNewBubble(_loc2_);
         for each(_loc4_ in this._decayingBubbles)
         {
            _loc4_.move(0,-_loc2_.height);
         }
         _loc5_ = 0;
         while(_loc5_ < this._currentBubbles.length - 1)
         {
            (_loc4_ = this._currentBubbles.getItemAt(_loc5_) as DialogBubbleSkin).move(0,-_loc2_.height);
            _loc5_++;
         }
      }
      
      private function onBubbleDecayed(param1:Event) : void
      {
         var _loc3_:DialogBubbleSkin = null;
         var _loc2_:DialogBubbleSkin = param1.currentTarget as DialogBubbleSkin;
         for each(_loc3_ in this._currentBubbles)
         {
            if(_loc3_ == _loc2_)
            {
               this._currentBubbles.removeItem(_loc3_);
               this.removeBubble(_loc3_);
               return;
            }
         }
         for each(_loc3_ in this._decayingBubbles)
         {
            if(_loc3_ == _loc2_)
            {
               this._decayingBubbles.removeItem(_loc3_);
               this.removeBubble(_loc3_);
               return;
            }
         }
      }
      
      private function onBubbleStartDecay(param1:Event) : void
      {
         var _loc3_:DialogBubbleSkin = null;
         var _loc4_:Boolean = false;
         var _loc2_:DialogBubbleSkin = param1.currentTarget as DialogBubbleSkin;
         for each(_loc3_ in this._currentBubbles)
         {
            if(_loc3_ == _loc2_)
            {
               this._currentBubbles.removeItem(_loc3_);
               this._decayingBubbles.addItem(_loc3_);
               _loc4_ = _loc3_.textEnd;
               if(this._autoProcessNext)
               {
                  this.processNext();
               }
               if(_loc4_)
               {
                  dispatchEvent(new Event(TEXT_FINISHED));
               }
               return;
            }
         }
      }
      
      private function onTextLastBubbleFlushed(param1:Event) : void
      {
         var _loc2_:DialogBubbleSkin = param1.currentTarget as DialogBubbleSkin;
         dispatchEvent(new Event(TEXT_FLUSHED));
      }
      
      private function onTextLastBubbleStartDecay(param1:Event) : void
      {
         var _loc2_:DialogBubbleSkin = param1.currentTarget as DialogBubbleSkin;
         dispatchEvent(new Event(TEXT_FINISHED));
      }
      
      private function addNewBubble(param1:DialogBubbleSkin) : void
      {
         param1.addEventListener(DECAYED,this.onBubbleDecayed);
         param1.addEventListener(START_DECAY,this.onBubbleStartDecay);
         this._dialogBubbleLayer.addChild(param1);
         this._currentBubbles.addItem(param1);
         param1.validateNow(false);
      }
      
      private function removeBubble(param1:DialogBubbleSkin) : void
      {
         param1.removeEventListener(DECAYED,this.onBubbleDecayed);
         param1.removeEventListener(START_DECAY,this.onBubbleStartDecay);
         param1.removeEventListener(BUBBLE_FLUSHED,this.onTextLastBubbleFlushed);
         this._dialogBubbleLayer.removeChild(param1);
      }
   }
}
