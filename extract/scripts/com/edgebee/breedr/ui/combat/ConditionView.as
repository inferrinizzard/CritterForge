package com.edgebee.breedr.ui.combat
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.combat.Condition;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   
   public class ConditionView extends Canvas
   {
      
      public static const CONDITION_MOUSE_CLICK:String = "CONDITION_MOUSE_CLICK";
      
      public static const CONDITION_MOUSE_OVER:String = "CONDITION_MOUSE_OVER";
      
      public static const CONDITION_MOUSE_OUT:String = "CONDITION_MOUSE_OUT";
      
      private static const POSITIVE_COLOR:Color = new Color(3407667);
      
      private static const NEGATIVE_COLOR:Color = new Color(16724787);
       
      
      private var _condition:WeakReference;
      
      public var iconBmp:BitmapComponent;
      
      public var durationLbl:Label;
      
      private var _layout:Array;
      
      public function ConditionView()
      {
         this._condition = new WeakReference(null,Condition);
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"iconBmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":Label,
            "ID":"durationLbl",
            "x":1,
            "y":UIGlobals.relativize(-5),
            "percentWidth":1,
            "alpha":0.85,
            "alignment":TextFormatAlign.RIGHT,
            "filters":UIGlobals.fontSmallOutline,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(12),
               "FontColor":16777215,
               "FontWeight":"bold"
            }
         }];
         super();
         setStyle("CornerRadius",5);
         setStyle("BorderAlpha",1);
         setStyle("BorderThickness",1);
         setStyle("BorderColor",16777215);
         setStyle("BackgroundAlpha",0.1);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function get condition() : Condition
      {
         return this._condition.get() as Condition;
      }
      
      public function set condition(param1:Condition) : void
      {
         if(this.condition)
         {
            this.condition.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onConditionChange);
         }
         this._condition.reset(param1);
         if(this.condition)
         {
            this.condition.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onConditionChange);
         }
         if(childrenCreated || childrenCreating)
         {
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.iconBmp.glowProxy.blur = 3;
         this.iconBmp.glowProxy.alpha = 0.75;
         border.glowProxy.blur = 3;
         border.glowProxy.alpha = 0.75;
         this.update();
      }
      
      private function onConditionChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.condition)
            {
               visible = true;
               if(this.condition.isPositive)
               {
                  this.iconBmp.glowProxy.color = POSITIVE_COLOR.hex;
                  this.iconBmp.colorTransformProxy.greenOffset = 100;
                  border.glowProxy.color = POSITIVE_COLOR.hex;
                  border.colorTransformProxy.greenOffset = 100;
               }
               else
               {
                  this.iconBmp.glowProxy.color = NEGATIVE_COLOR.hex;
                  this.iconBmp.colorTransformProxy.redOffset = 100;
                  border.glowProxy.color = NEGATIVE_COLOR.hex;
                  border.colorTransformProxy.redOffset = 100;
               }
               this.iconBmp.source = this.condition.icon;
               this.durationLbl.text = this.condition.duration.toString();
               toolTip = this.condition.description;
            }
            else
            {
               visible = false;
            }
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(CONDITION_MOUSE_CLICK,{
            "event":param1,
            "condition":this.condition
         },true));
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(CONDITION_MOUSE_OVER,{
            "event":param1,
            "condition":this.condition
         },true));
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(CONDITION_MOUSE_OUT,{
            "event":param1,
            "condition":this.condition
         },true));
      }
   }
}
