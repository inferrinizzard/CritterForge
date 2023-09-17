package com.edgebee.atlas.ui.controls
{
   import flash.events.MouseEvent;
   
   public class ToggleButton extends Button
   {
       
      
      protected var _selected:Boolean;
      
      public function ToggleButton()
      {
         super();
         this.selected = false;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            this.updateState();
         }
      }
      
      override public function get styleClassName() : String
      {
         return "ToggleButton";
      }
      
      override protected function updateState() : void
      {
         if(!enabled)
         {
            state = "disabled";
         }
         else if(this.selected)
         {
            state = "selected";
         }
         else if(_mouseIsDown)
         {
            state = "down";
         }
         else if(_mouseIsOver)
         {
            state = "over";
         }
         else
         {
            state = "up";
         }
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(enabled)
         {
            this.selected = !this.selected;
            playClickSound();
            dispatchEvent(param1);
         }
      }
   }
}
