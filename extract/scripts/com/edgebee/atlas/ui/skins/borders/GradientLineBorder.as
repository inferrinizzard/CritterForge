package com.edgebee.atlas.ui.skins.borders
{
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   
   public class GradientLineBorder extends Border
   {
      
      private static var _borderAnim:Timer = new Timer(50);
       
      
      private var _borderAnimCount:Number = 0;
      
      private var _borderMat0:Matrix;
      
      private var _borderMat1:Matrix;
      
      private var _borderMat2:Matrix;
      
      private var _borderMat3:Matrix;
      
      private var _borderThickness:Number;
      
      private var _borderColor:uint;
      
      private var _borderAlpha:Number;
      
      private var _gradientLength:Number;
      
      private var _spreadMethodLength:String;
      
      private var _animSpeed:Number;
      
      public function GradientLineBorder(param1:Component)
      {
         this._borderMat0 = new Matrix();
         this._borderMat1 = new Matrix();
         this._borderMat2 = new Matrix();
         this._borderMat3 = new Matrix();
         super(param1);
         param1.addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChanged);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._borderThickness = getStyle("BorderThickness",1);
         this._borderColor = getStyle("BorderColor",0);
         this._borderAlpha = getStyle("BorderAlpha",1);
         this._gradientLength = getStyle("GradientLength",20);
         this._spreadMethodLength = getStyle("SpreadMethod",SpreadMethod.REFLECT);
         this._animSpeed = getStyle("AnimationSpeed",1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.lineStyle(this._borderThickness,this._borderColor,this._borderAlpha,true);
         var _loc3_:uint = this._gradientLength;
         var _loc4_:uint = this._borderColor;
         var _loc5_:String = this._spreadMethodLength;
         if(this._borderAnimCount >= _loc3_)
         {
            this._borderAnimCount = 0;
         }
         this._borderMat0.createGradientBox(1,_loc3_ / 2,Math.PI / 2,0,-this._borderAnimCount);
         this._borderMat1.createGradientBox(1,_loc3_ / 2,3 * Math.PI / 2,0,this._borderAnimCount);
         this._borderMat2.createGradientBox(_loc3_ / 2,1,Math.PI,this._borderAnimCount,0);
         this._borderMat3.createGradientBox(_loc3_ / 2,1,0,-this._borderAnimCount,0);
         var _loc6_:uint = UIUtils.adjustBrightness2(_loc4_,95);
         var _loc7_:uint = UIUtils.adjustBrightness2(_loc4_,10);
         filters = [new GlowFilter(_loc4_)];
         graphics.moveTo(0,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc6_,_loc7_],[1,1],[0,255],this._borderMat0,_loc5_);
         graphics.lineTo(0,component.height);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc6_,_loc7_],[1,1],[0,255],this._borderMat1,_loc5_);
         graphics.moveTo(component.width,component.height);
         graphics.lineTo(component.width,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc6_,_loc7_],[1,1],[0,255],this._borderMat2,_loc5_);
         graphics.moveTo(component.width,0);
         graphics.lineTo(0,0);
         graphics.lineGradientStyle(GradientType.LINEAR,[_loc6_,_loc7_],[1,1],[0,255],this._borderMat3,_loc5_);
         graphics.moveTo(0,component.height);
         graphics.lineTo(component.width,component.height);
      }
      
      private function onBorderAnimTimer(param1:TimerEvent) : void
      {
         this._borderAnimCount += this._animSpeed;
         if(visible)
         {
            invalidateDisplayList();
         }
      }
      
      override protected function onStyleChanged(param1:StyleChangedEvent) : void
      {
         super.onStyleChanged(param1);
         switch(param1.style)
         {
            case "BorderThickness":
               this._borderThickness = param1.newValue;
               break;
            case "BorderColor":
               this._borderColor = param1.newValue;
               break;
            case "BorderAlpha":
               this._borderAlpha = param1.newValue;
               break;
            case "GradientLength":
               this._gradientLength = param1.newValue;
               break;
            case "SpreadMethodLength":
               this._spreadMethodLength = param1.newValue;
               break;
            case "AnimationSpeed":
               this._animSpeed = param1.newValue;
         }
         invalidateDisplayList();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         UIGlobals.fiftyMsTimer.addEventListener(TimerEvent.TIMER,this.onBorderAnimTimer);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         UIGlobals.fiftyMsTimer.removeEventListener(TimerEvent.TIMER,this.onBorderAnimTimer);
      }
   }
}
