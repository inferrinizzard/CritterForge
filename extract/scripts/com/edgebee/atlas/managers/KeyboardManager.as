package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.interfaces.IKbNavigatable;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   
   public class KeyboardManager
   {
      
      public static const W:uint = 87;
      
      public static const A:uint = 65;
      
      public static const S:uint = 83;
      
      public static const D:uint = 68;
       
      
      private var _listeners:ArrayCollection;
      
      public function KeyboardManager()
      {
         this._listeners = new ArrayCollection();
         super();
      }
      
      public function initialize(param1:Stage) : void
      {
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.onDownEvent);
         param1.addEventListener(KeyboardEvent.KEY_UP,this.onUpEvent);
      }
      
      public function addListener(param1:Object, param2:Function, param3:Function) : void
      {
         if(param1 is IKbNavigatable)
         {
            this._listeners.addItem(new KeyboardNavigator(param1 as IKbNavigatable,param2,param3));
         }
         else
         {
            this._listeners.addItem(new KeyboardListener(param1,param2,param3));
         }
      }
      
      public function removeListener(param1:Object) : void
      {
         var _loc2_:KeyboardListener = this._listeners.findItemByProperty("owner",param1) as KeyboardListener;
         this._listeners.removeItem(_loc2_);
      }
      
      public function teleportFocusTo(param1:IKbNavigatable) : void
      {
         var _loc2_:KeyboardNavigator = this._listeners.last as KeyboardNavigator;
         if(_loc2_)
         {
            _loc2_.teleportFocusTo(param1);
         }
      }
      
      private function onDownEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyboardListener = this._listeners.last as KeyboardListener;
         if(Boolean(_loc2_) && _loc2_.downCallback != null)
         {
            _loc2_.downCallback(param1);
         }
      }
      
      private function onUpEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyboardListener = this._listeners.last as KeyboardListener;
         if(Boolean(_loc2_) && _loc2_.upCallback != null)
         {
            _loc2_.upCallback(param1);
         }
      }
   }
}

class KeyboardListener
{
    
   
   public var owner:Object;
   
   public var listener:Object;
   
   public var downCallback:Function;
   
   public var upCallback:Function;
   
   public function KeyboardListener(param1:Object, param2:Function, param3:Function)
   {
      super();
      this.owner = param1;
      this.listener = param1;
      this.downCallback = param2;
      this.upCallback = param3;
   }
}

import com.edgebee.atlas.interfaces.IKbNavigatable;
import com.edgebee.atlas.managers.KeyboardManager;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

class KeyboardNavigator extends KeyboardListener
{
    
   
   private var _parentNode:IKbNavigatable;
   
   private var _currentNode:IKbNavigatable;
   
   private var _nodeDownCallback:Function;
   
   private var _nodeUpCallback:Function;
   
   public function KeyboardNavigator(param1:IKbNavigatable, param2:Function, param3:Function)
   {
      super(this,this.onKeyDown,this.onKeyUp);
      owner = param1;
      this._parentNode = param1;
      this._nodeDownCallback = param2;
      this._nodeUpCallback = param3;
      this._currentNode = this._parentNode.kbFirstNode;
      this._currentNode.hasKbFocus = true;
   }
   
   public function teleportFocusTo(param1:IKbNavigatable) : void
   {
      this._currentNode.hasKbFocus = false;
      this._currentNode = param1;
      this._currentNode.hasKbFocus = true;
   }
   
   public function onKeyDown(param1:KeyboardEvent) : void
   {
      if(this._nodeDownCallback != null)
      {
         this._nodeDownCallback(param1);
      }
   }
   
   public function onKeyUp(param1:KeyboardEvent) : void
   {
      if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.NUMPAD_8 || param1.keyCode == KeyboardManager.W)
      {
         this._currentNode = this._currentNode.kbMove(Keyboard.UP);
      }
      else if(param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.NUMPAD_2 || param1.keyCode == KeyboardManager.S)
      {
         this._currentNode = this._currentNode.kbMove(Keyboard.DOWN);
      }
      else if(param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.NUMPAD_4 || param1.keyCode == KeyboardManager.A)
      {
         this._currentNode = this._currentNode.kbMove(Keyboard.LEFT);
      }
      else if(param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.NUMPAD_6 || param1.keyCode == KeyboardManager.D)
      {
         this._currentNode = this._currentNode.kbMove(Keyboard.RIGHT);
      }
      else if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.SPACE)
      {
         if(this._currentNode.enabled)
         {
            this._currentNode.kbActivate();
         }
      }
      if(this._nodeUpCallback != null)
      {
         this._nodeUpCallback(param1);
      }
   }
}
