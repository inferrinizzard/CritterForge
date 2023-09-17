package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.controls.RadioButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class RadioButtonGroup extends EventDispatcher
   {
       
      
      private var _buttons:Array;
      
      private var _selected:RadioButton;
      
      public function RadioButtonGroup()
      {
         this._buttons = [];
         super();
      }
      
      public function get selected() : RadioButton
      {
         return this._selected;
      }
      
      public function set selected(param1:RadioButton) : void
      {
         this.onButtonChange(new ExtendedEvent(Event.CHANGE,param1));
      }
      
      public function get selectedItem() : *
      {
         return this.selected.userData;
      }
      
      public function set selectedItem(param1:*) : void
      {
         var _loc2_:RadioButton = null;
         for each(_loc2_ in this._buttons)
         {
            if(_loc2_.userData == param1)
            {
               this.selected = _loc2_;
               break;
            }
         }
      }
      
      public function addButton(param1:RadioButton) : void
      {
         this._buttons.push(param1);
         param1.addEventListener(Event.CHANGE,this.onButtonChange);
      }
      
      public function getButton(param1:*) : RadioButton
      {
         var _loc2_:RadioButton = null;
         for each(_loc2_ in this._buttons)
         {
            if(_loc2_.userData == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function reset() : void
      {
         this.onButtonChange(new ExtendedEvent(Event.CHANGE,null));
      }
      
      public function removeAll() : void
      {
         this._buttons = [];
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function onButtonChange(param1:ExtendedEvent) : void
      {
         var _loc3_:RadioButton = null;
         this._selected = null;
         var _loc2_:Object = null;
         for each(_loc3_ in this._buttons)
         {
            _loc3_.silentUnselect();
            if(_loc3_ == param1.data)
            {
               _loc3_.silentSelect();
               this._selected = _loc3_;
               _loc2_ = this._selected.userData;
            }
         }
         dispatchEvent(new ExtendedEvent(Event.CHANGE,_loc2_));
      }
   }
}
