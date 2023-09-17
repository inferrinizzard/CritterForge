package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.containers.Window;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PopUpManager
   {
       
      
      private var _popUpLayer:Component;
      
      private var _modalCount:uint = 0;
      
      public function PopUpManager(param1:Component)
      {
         super();
         this._popUpLayer = param1;
      }
      
      public function addPopUp(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false) : void
      {
         if(param3)
         {
            ++this._modalCount;
         }
         var _loc4_:PopUpWrapper;
         (_loc4_ = new PopUpWrapper(param1,param2,this._popUpLayer,param3)).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
      }
      
      public function centerPopUp(param1:DisplayObject, param2:Point = null, param3:Boolean = true) : void
      {
         var _loc4_:PopUpWrapper;
         if(_loc4_ = param1.parent as PopUpWrapper)
         {
            _loc4_.validateNow(false);
            _loc4_.center(param3,param2);
            if(param1 is Window)
            {
               (param1 as Window).centered = true;
            }
         }
      }
      
      public function positionPopUp(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         var _loc4_:PopUpWrapper;
         if(_loc4_ = param1.parent as PopUpWrapper)
         {
            param1.x = param2;
            param1.y = param3;
         }
      }
      
      public function movePopUp(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         var _loc4_:PopUpWrapper;
         if(_loc4_ = param1.parent as PopUpWrapper)
         {
            param1.x += param2;
            param1.y += param3;
         }
      }
      
      public function removePopUp(param1:DisplayObject) : void
      {
         var _loc2_:PopUpWrapper = param1.parent as PopUpWrapper;
         if(_loc2_)
         {
            if(_loc2_.isModal)
            {
               --this._modalCount;
            }
            _loc2_.remove();
         }
      }
      
      public function bringToFront(param1:DisplayObject) : void
      {
         var _loc2_:PopUpWrapper = param1.parent as PopUpWrapper;
         _loc2_.bringToFront();
      }
      
      public function isPopUp(param1:DisplayObject) : Boolean
      {
         return !!(param1.parent as PopUpWrapper);
      }
      
      public function get isInModalState() : Boolean
      {
         return this._modalCount > 0;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:PopUpWrapper = null;
         if(Boolean(_loc2_) && this._modalCount == 0)
         {
            _loc2_ = param1.currentTarget as PopUpWrapper;
            this._popUpLayer.removeChild(_loc2_);
            this._popUpLayer.addChild(_loc2_);
         }
      }
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.UIGlobals;
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.filters.BlurFilter;
import flash.geom.Point;

class PopUpWrapper extends Component
{
    
   
   public var popUpWin:DisplayObject;
   
   public var isModal:Boolean;
   
   private var _popUpParent:DisplayObject;
   
   private var _popUpLayer:Component;
   
   private var _modalScreen:ModalScreen;
   
   public function PopUpWrapper(param1:DisplayObject, param2:DisplayObject, param3:Component, param4:Boolean)
   {
      var _loc5_:BlurFilter = null;
      var _loc6_:uint = 0;
      var _loc7_:DisplayObject = null;
      this.name = "PopUpWrapper";
      super();
      this.popUpWin = param1;
      this.isModal = param4;
      this._popUpParent = param2;
      this._popUpLayer = param3;
      if(param4)
      {
         this._modalScreen = new ModalScreen(this,param2.stage);
         this._popUpLayer.addChild(this._modalScreen);
         _loc5_ = new BlurFilter(getStyle("ModalBlurX",5),getStyle("ModalBlurY",5));
         _loc6_ = 0;
         while(_loc6_ < UIGlobals.root.numChildren)
         {
            if((_loc7_ = UIGlobals.root.getChildAt(_loc6_) as DisplayObject) != this._popUpLayer)
            {
               _loc7_.filters = _loc7_.filters.concat([_loc5_]);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < this._popUpLayer.numChildren)
         {
            if((_loc7_ = this._popUpLayer.getChildAt(_loc6_) as DisplayObject) != this)
            {
               _loc7_.filters = _loc7_.filters.concat([_loc5_]);
            }
            _loc6_++;
         }
      }
      this._popUpLayer.addChild(this);
      addChild(param1);
   }
   
   public function center(param1:Boolean, param2:Point = null) : void
   {
      var _loc3_:DisplayObject = null;
      var _loc5_:Number = NaN;
      var _loc6_:Number = NaN;
      if(param1)
      {
         _loc3_ = this._popUpParent;
      }
      else
      {
         _loc3_ = stage;
      }
      var _loc4_:Point = _loc3_.localToGlobal(new Point(0,0));
      if(_loc3_ is Stage)
      {
         _loc5_ = (_loc3_ as Stage).stageWidth;
         _loc6_ = (_loc3_ as Stage).stageHeight;
      }
      else
      {
         _loc5_ = _loc3_.width;
         _loc6_ = _loc3_.height;
      }
      _loc4_.x += _loc5_ / 2;
      _loc4_.y += _loc6_ / 2;
      if(!param2)
      {
         param2 = new Point();
      }
      this.popUpWin.x = _loc4_.x - (this.popUpWin as Component).width / 2 + param2.x;
      this.popUpWin.y = _loc4_.y - (this.popUpWin as Component).height / 2 + param2.y;
   }
   
   public function remove() : void
   {
      var _loc1_:uint = 0;
      var _loc2_:DisplayObject = null;
      this._popUpLayer.removeChild(this);
      removeAllChildren();
      if(this._modalScreen)
      {
         this._popUpLayer.removeChild(this._modalScreen);
         _loc1_ = 0;
         while(_loc1_ < UIGlobals.root.numChildren)
         {
            _loc2_ = UIGlobals.root.getChildAt(_loc1_) as DisplayObject;
            if(_loc2_ != this._popUpLayer)
            {
               _loc2_.filters = _loc2_.filters.slice(0,-1);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._popUpLayer.numChildren)
         {
            _loc2_ = this._popUpLayer.getChildAt(_loc1_) as DisplayObject;
            if(_loc2_ != this)
            {
               _loc2_.filters = _loc2_.filters.slice(0,-1);
            }
            _loc1_++;
         }
      }
   }
   
   public function bringToFront() : void
   {
      this._popUpLayer.removeChild(this);
      this._popUpLayer.addChild(this);
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.utils.UIUtils;
import flash.display.Stage;

class ModalScreen extends Component
{
    
   
   private var _wrapper:PopUpWrapper;
   
   public function ModalScreen(param1:PopUpWrapper, param2:Stage)
   {
      super();
      this._wrapper = param1;
      width = param2.stageWidth;
      height = param2.stageHeight;
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      graphics.clear();
      var _loc3_:uint = UIUtils.adjustBrightness2(getStyle("ThemeColor",3355443),-50);
      graphics.beginFill(getStyle("ModalColor",_loc3_),getStyle("ModalAlpha",0.5));
      graphics.drawRect(0,0,param1,param2);
      graphics.endFill();
   }
}
