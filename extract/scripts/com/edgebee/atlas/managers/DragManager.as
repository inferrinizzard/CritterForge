package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.events.DragEvent;
   import com.edgebee.atlas.ui.Component;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DragManager
   {
       
      
      private var _root:Component;
      
      private var _popUpLayer:Component;
      
      private var _mouseDown:Boolean = false;
      
      private var _isDragging:Boolean = false;
      
      private var _mouseScreen:MouseScreen;
      
      private var _dragProxy:DragProxy;
      
      private var _dragInitiator:Component;
      
      private var _dropTarget:Component;
      
      private var _dragInfo:Object;
      
      private var _dragImage:Component;
      
      public function DragManager(param1:Component, param2:Component)
      {
         this._mouseScreen = new MouseScreen();
         super();
         this._root = param1;
         this._popUpLayer = param2;
         this._root.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this._root.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
      }
      
      public function get isDragging() : Boolean
      {
         return this._isDragging;
      }
      
      public function set isDragging(param1:Boolean) : void
      {
         this._isDragging = param1;
      }
      
      public function get dragProxy() : Component
      {
         if(this.isDragging)
         {
            return this._dragProxy.component;
         }
         return null;
      }
      
      public function snapTo(param1:Component, param2:Point, param3:uint = 0) : void
      {
         if(!this.isDragging)
         {
            return;
         }
         this._dragProxy.snapTo(param1,param2,param3);
      }
      
      public function unSnap() : void
      {
         if(!this.isDragging)
         {
            return;
         }
         this._dragProxy.unSnap();
      }
      
      public function get dragInitiator() : Component
      {
         return this._dragInitiator;
      }
      
      public function doDrag(param1:Component, param2:Object, param3:Component, param4:MouseEvent, param5:Number = 0, param6:Number = 0) : Boolean
      {
         if(this._isDragging)
         {
            return false;
         }
         if(!this._mouseDown && !param4.buttonDown)
         {
            return false;
         }
         this._isDragging = true;
         this._dragInitiator = param1;
         this._dragInfo = param2;
         this._dragImage = param3;
         this._dragProxy = new DragProxy(this._dragImage);
         this._popUpLayer.addChild(this._mouseScreen);
         this._popUpLayer.addChild(this._dragProxy);
         this._dragImage.x = 0;
         this._dragImage.y = 0;
         var _loc7_:Point = new Point(param4.localX,param4.localY);
         _loc7_ = DisplayObject(param4.target).localToGlobal(_loc7_);
         var _loc8_:Number = (_loc7_ = param1.stage.globalToLocal(_loc7_)).x;
         var _loc9_:Number = _loc7_.y;
         var _loc10_:Point = DisplayObject(param4.target).localToGlobal(new Point(param4.localX,param4.localY));
         _loc10_ = DisplayObject(param1).globalToLocal(_loc10_);
         this._dragProxy.xOffset = _loc10_.x + param5;
         this._dragProxy.yOffset = _loc10_.y + param6;
         this._dragProxy.x = _loc8_ - this._dragProxy.xOffset;
         this._dragProxy.y = _loc9_ - this._dragProxy.yOffset;
         this._dragProxy.initialize();
         return true;
      }
      
      public function acceptDragDrop(param1:Component) : void
      {
         if(!this.isDragging)
         {
            throw new Error("Drag must be initiated before being accepted");
         }
         this._dragProxy.target = param1;
      }
      
      public function moveOver(param1:MouseEvent) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Boolean = false;
         var _loc7_:Component = null;
         var _loc2_:Array = DisplayObjectContainer(this._root.stage).getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
         var _loc3_:DisplayObject = null;
         var _loc4_:int = int(_loc2_.length - 1);
         while(_loc4_ >= 0)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_ != this._mouseScreen && _loc3_ != this._dragProxy && !this._dragProxy.contains(_loc3_))
            {
               break;
            }
            _loc4_--;
         }
         if(this._dragProxy.target)
         {
            _loc6_ = false;
            _loc7_ = this._dragProxy.target;
            _loc5_ = _loc3_;
            while(_loc5_)
            {
               if(_loc5_ == this._dragProxy.target)
               {
                  this.dispatchDragEvent(DragEvent.DRAG_OVER,_loc5_);
                  _loc6_ = true;
                  break;
               }
               this.dispatchDragEvent(DragEvent.DRAG_ENTER,_loc5_);
               if(this._dragProxy.target == _loc5_)
               {
                  _loc6_ = false;
                  break;
               }
               _loc5_ = _loc5_.parent;
            }
            if(!_loc6_)
            {
               this.dispatchDragEvent(DragEvent.DRAG_EXIT,_loc7_);
               if(this._dragProxy.target == _loc7_)
               {
                  this._dragProxy.target = null;
               }
            }
         }
         if(!this._dragProxy.target)
         {
            _loc5_ = _loc3_;
            while(_loc5_)
            {
               if(_loc5_ != this._dragProxy)
               {
                  this.dispatchDragEvent(DragEvent.DRAG_ENTER,_loc5_);
                  if(this._dragProxy.target)
                  {
                     break;
                  }
               }
               _loc5_ = _loc5_.parent;
            }
         }
      }
      
      public function endDrag() : void
      {
         if(this._dragProxy.target)
         {
            this.dispatchDragEvent(DragEvent.DRAG_DROP,this._dragProxy.target);
         }
         this.dispatchDragEvent(DragEvent.DRAG_COMPLETE,this._dragInitiator);
         this._dragProxy.parent.removeChild(this._dragProxy);
         this._popUpLayer.removeChild(this._mouseScreen);
         this._dragInitiator = null;
         this._dragImage = null;
         this._dragProxy = null;
         this._dropTarget = null;
         this._dragInfo = null;
         this._isDragging = false;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
         if(this.isDragging)
         {
            this._dragProxy.endDrag();
         }
      }
      
      private function dispatchDragEvent(param1:String, param2:Object) : void
      {
         var _loc3_:DragEvent = new DragEvent(param1,this._dragInitiator,this._dragInfo,this._dragProxy);
         param2.dispatchEvent(_loc3_);
      }
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.UIGlobals;
import com.edgebee.atlas.ui.containers.Box;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

class DragProxy extends Box
{
    
   
   public var target:Component;
   
   public var xOffset:Number = 0;
   
   public var yOffset:Number = 0;
   
   public var component:Component;
   
   public var snapped:Boolean;
   
   public var unSnappedParent:Component;
   
   public function DragProxy(param1:Component)
   {
      super();
      this.component = param1;
      param1.name = "DragProxyComponent";
      name = "DragProxy";
   }
   
   public function snapTo(param1:Component, param2:Point, param3:uint) : void
   {
      this.snapped = true;
      x = param2.x;
      y = param2.y;
      param1.addChildAt(this,param3);
   }
   
   public function unSnap() : void
   {
      this.snapped = false;
      x = this.unSnappedParent.mouseX - this.xOffset;
      y = this.unSnappedParent.mouseY - this.yOffset;
      this.unSnappedParent.addChild(this);
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true,0,true);
      stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler,false,0,true);
      addChild(this.component);
      this.unSnappedParent = parent as Component;
   }
   
   public function endDrag() : void
   {
      removeAllChildren();
      stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
      stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
      UIGlobals.dragManager.endDrag();
   }
   
   private function mouseMoveHandler(param1:MouseEvent) : void
   {
      var _loc2_:Point = null;
      var _loc3_:Number = NaN;
      var _loc4_:Number = NaN;
      if(!this.snapped)
      {
         _loc2_ = new Point(param1.localX,param1.localY);
         _loc2_ = DisplayObject(param1.target).localToGlobal(_loc2_);
         _loc2_ = parent.globalToLocal(_loc2_);
         _loc3_ = _loc2_.x;
         _loc4_ = _loc2_.y;
         x = _loc3_ - this.xOffset;
         y = _loc4_ - this.yOffset;
      }
      UIGlobals.dragManager.moveOver(param1);
   }
   
   private function mouseUpHandler(param1:MouseEvent) : void
   {
      this.endDrag();
   }
   
   private function mouseLeaveHandler(param1:Event) : void
   {
      this.endDrag();
   }
}

import com.edgebee.atlas.ui.Component;

class MouseScreen extends Component
{
    
   
   public function MouseScreen()
   {
      super();
   }
   
   override protected function measure() : void
   {
      super.measure();
      if(stage)
      {
         measuredWidth = width = stage.width;
         measuredHeight = height = stage.height;
      }
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      graphics.beginFill(0,0);
      graphics.drawRect(0,0,param1,param2);
      graphics.endFill();
   }
}
