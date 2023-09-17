package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.containers.RadioButtonGroup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RadioButton extends ToggleButton
   {
       
      
      private var _group:RadioButtonGroup;
      
      public function RadioButton()
      {
         super();
      }
      
      override public function get selected() : Boolean
      {
         return _selected;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         if(_selected != param1)
         {
            _selected = param1;
            updateState();
            dispatchEvent(new ExtendedEvent(Event.CHANGE,this));
         }
      }
      
      public function get group() : RadioButtonGroup
      {
         return this._group;
      }
      
      public function set group(param1:RadioButtonGroup) : void
      {
         if(this._group != param1)
         {
            param1.addButton(this);
            this._group = param1;
         }
      }
      
      override public function get styleClassName() : String
      {
         return "RadioButton";
      }
      
      public function silentSelect() : void
      {
         _selected = true;
         updateState();
      }
      
      public function silentUnselect() : void
      {
         _selected = false;
         updateState();
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(enabled)
         {
            if(!this.selected)
            {
               playClickSound();
               dispatchEvent(new ExtendedEvent(Event.CHANGE,this));
            }
         }
      }
   }
}
