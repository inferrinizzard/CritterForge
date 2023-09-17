package com.edgebee.atlas.ui.skins
{
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.IToolTip;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.TextArea;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   
   public class DefaultTooltipSkin extends Skin implements IToolTip
   {
       
      
      protected var _fadeOutAnimInstance:AnimationInstance;
      
      protected var _layout:Box;
      
      protected var _label:TextArea;
      
      private var _paddingLeft:uint;
      
      private var _paddingRight:uint;
      
      private var _paddingTop:uint;
      
      private var _paddingBottom:uint;
      
      private var _anchorPoint:Point;
      
      private var _removing:Boolean = false;
      
      public function DefaultTooltipSkin(param1:Component)
      {
         super(param1);
         this._anchorPoint = new Point(param1.mouseX,param1.mouseY);
         this._anchorPoint = param1.localToGlobal(this._anchorPoint);
         this._anchorPoint = UIGlobals.tooltipLayer.globalToLocal(this._anchorPoint);
         x = this._anchorPoint.x + 10;
         y = this._anchorPoint.y + 10;
         filters = [new DropShadowFilter(4,45,0,0.75)];
      }
      
      public function show(param1:Component) : void
      {
         alpha = 0;
         param1.addChild(this);
         var _loc2_:AnimationInstance = controller.animateTo({"alpha":1},{"alpha":Interpolation.quadIn},false);
         _loc2_.speed = 5;
         _loc2_.play();
      }
      
      public function hide(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._removing = true;
            this._fadeOutAnimInstance.removeEventListener(AnimationEvent.STOP,this.onFadeComplete);
            this._fadeOutAnimInstance.stop();
            parent.removeChild(this);
         }
         else if(!this._removing)
         {
            this._fadeOutAnimInstance = controller.animateTo({"alpha":0},{"alpha":Interpolation.quadIn},false);
            this._fadeOutAnimInstance.speed = 3;
            this._fadeOutAnimInstance.addEventListener(AnimationEvent.STOP,this.onFadeComplete);
            this._fadeOutAnimInstance.play();
         }
      }
      
      protected function onFadeComplete(param1:AnimationEvent) : void
      {
         parent.removeChild(this);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         setStyle("BackgroundColor",getStyle("BackgroundColor",16777185));
         setStyle("BackgroundAlpha",getStyle("BackgroundAlpha",1));
         setStyle("BorderThickness",getStyle("BorderThickness",1));
         this.createUI();
      }
      
      override protected function measure() : void
      {
         super.measure();
         this._paddingLeft = getStyle("PaddingLeft",3);
         this._paddingRight = getStyle("PaddingRight",3);
         this._paddingTop = getStyle("PaddingTop",3);
         this._paddingBottom = getStyle("PaddingBottom",3);
         measuredWidth = this._layout.width + this._paddingLeft + this._paddingRight;
         measuredHeight = this._layout.height + this._paddingTop + this._paddingBottom;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this._layout.x = this._paddingLeft;
         this._layout.y = this._paddingTop;
         if(x + param1 > UIGlobals.root.width)
         {
            x -= x + param1 - UIGlobals.root.width + 1;
         }
         if(y + param2 > UIGlobals.root.height)
         {
            y -= param2 + 15;
         }
         if(x < 0)
         {
            x = 0;
         }
         if(y < 0)
         {
            y = 0;
         }
      }
      
      override public function get inheritStyles() : Boolean
      {
         return false;
      }
      
      override public function get styleClassName() : String
      {
         return "Tooltip";
      }
      
      private function get componentTooltip() : Object
      {
         return component.toolTip;
      }
      
      private function createUI() : void
      {
         this._layout = new Box();
         if(this.componentTooltip is Asset || this.componentTooltip is String)
         {
            this.createLabel();
         }
         else if(this.componentTooltip is Component)
         {
            this._layout.addChild(this.componentTooltip as Component);
         }
         addChild(this._layout);
      }
      
      private function createLabel() : void
      {
         this._label = new TextArea();
         this._label.alignment = TextFormatAlign.LEFT;
         this._label.selectable = false;
         this._label.wordWrap = false;
         this._label.useHtml = true;
         this._label.setStyle("FontSize",getStyle("FontSize",12,false));
         this._label.setStyle("FontColor",getStyle("FontColor"));
         if(this.componentTooltip is Asset)
         {
            this._label.text = this.componentTooltip as Asset;
         }
         else
         {
            this._label.text = this.componentTooltip as String;
         }
         this._layout.addChild(this._label);
      }
   }
}
