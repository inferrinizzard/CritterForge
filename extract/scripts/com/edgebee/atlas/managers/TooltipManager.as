package com.edgebee.atlas.managers
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.IToolTip;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.skins.*;
   import com.edgebee.atlas.util.Timer;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class TooltipManager
   {
       
      
      private var _tooltipLayer:Component;
      
      private var _currentComponents:Array;
      
      private var _currentTooltip:Skin;
      
      private var _timer:Timer;
      
      public function TooltipManager(param1:Component)
      {
         this._currentComponents = [];
         super();
         this._tooltipLayer = param1;
         this._timer = new Timer(750,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         UIGlobals.root.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick,false,0,true);
      }
      
      public function addComponent(param1:Component) : void
      {
         param1.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      public function removeComponent(param1:Component) : void
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         if(this._currentComponents[this._currentComponents.length - 1] == param1)
         {
            this._currentComponents.pop();
            if(this._currentTooltip)
            {
               (this._currentTooltip as IToolTip).hide();
            }
            this._currentTooltip = null;
            this._timer.reset();
            if(this._currentComponents.length)
            {
               this._timer.start();
            }
         }
      }
      
      public function globalToLocal(param1:Point) : Point
      {
         return this._tooltipLayer.globalToLocal(param1);
      }
      
      private function displayTooltip() : void
      {
         var _loc1_:Component = this._currentComponents[this._currentComponents.length - 1] as Component;
         var _loc2_:Class = _loc1_.getStyle("TooltipSkin",DefaultTooltipSkin);
         this._currentTooltip = new _loc2_(_loc1_);
         (this._currentTooltip as IToolTip).show(this._tooltipLayer);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(!this._currentComponents.length)
         {
            this._timer.start();
         }
         this._currentComponents.push(param1.target);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(this._currentTooltip)
         {
            (this._currentTooltip as IToolTip).hide();
         }
         this._currentTooltip = null;
         this._currentComponents.pop();
         this._timer.reset();
         if(this._currentComponents.length)
         {
            this._timer.start();
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(this._currentTooltip)
         {
            this._tooltipLayer.removeChild(this._currentTooltip);
         }
         this._currentTooltip = null;
         this._timer.reset();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.displayTooltip();
         this._timer.reset();
      }
   }
}
