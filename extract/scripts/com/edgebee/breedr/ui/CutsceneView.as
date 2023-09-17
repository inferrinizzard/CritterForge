package com.edgebee.breedr.ui
{
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BufferedSWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Dialog;
   import com.edgebee.breedr.ui.world.NpcView;
   
   public class CutsceneView extends Canvas
   {
       
      
      private var _dialog:WeakReference;
      
      public var content:Box;
      
      public var bgImg:BufferedSWFLoader;
      
      public var npcView:NpcView;
      
      public var fade:AnimationInstance;
      
      public var dialogView:com.edgebee.breedr.ui.DialogView;
      
      private var _layout:Array;
      
      public function CutsceneView()
      {
         this._dialog = new WeakReference(null,Dialog);
         this._layout = [{
            "CLASS":BufferedSWFLoader,
            "ID":"bgImg",
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "ShadowBorderEnabled":true,
               "ShadowBorderAlpha":[0,0.65],
               "ShadowBorderRatios":[150,255],
               "ShadowBorderGradientSizeFactor":{
                  "width":1.5,
                  "height":1.5
               }
            }
         },{
            "CLASS":Box,
            "ID":"content",
            "percentHeight":1,
            "percentWidth":1,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE
         },{
            "CLASS":NpcView,
            "ID":"npcView",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":com.edgebee.breedr.ui.DialogView,
            "ID":"dialogView",
            "visible":false,
            "x":UIGlobals.relativize(80),
            "width":UIGlobals.relativize(800),
            "y":UIGlobals.relativize(576),
            "height":UIGlobals.relativize(120)
         }];
         super();
         setStyle("BackgroundAlpha",1);
         this.fade = controller.addAnimation(UIGlobals.alphaFadeIn);
         this.fade.addEventListener(AnimationEvent.STOP,this.onFadeStop);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get dialog() : Dialog
      {
         return this._dialog.get() as Dialog;
      }
      
      public function set dialog(param1:Dialog) : void
      {
         if(this.dialog != param1)
         {
            this._dialog.reset(param1);
            this.update();
         }
      }
      
      public function forceVisible() : void
      {
         if(this.fade.playing)
         {
            this.fade.stop();
            this.reset();
            super.doSetVisible(true);
            alpha = 1;
         }
         else
         {
            visible = true;
         }
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         if(param1)
         {
            super.doSetVisible(param1);
            if(alpha != 1)
            {
               this.fade.speed = 3;
               this.fade.gotoStartAndPlay();
            }
         }
         else if(alpha != 0)
         {
            this.fade.speed = 1;
            this.fade.gotoEndAndPlayReversed();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.dialogView.npcView = this.npcView;
         this.bgImg.colorMatrix.saturation = -35;
      }
      
      public function reset() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.npcView.npc = null;
            this.bgImg.source = null;
            this.dialog = null;
            this.content.removeAllChildren();
         }
      }
      
      private function update() : void
      {
         if(this.dialog)
         {
            this.npcView.npc = this.dialog.npc;
            this.dialogView.dialog = this.dialog;
         }
         else
         {
            this.npcView.npc = null;
            this.dialogView.dialog = null;
         }
      }
      
      private function onFadeStop(param1:AnimationEvent) : void
      {
         if(alpha < 0.1)
         {
            super.doSetVisible(false);
            this.reset();
         }
      }
   }
}
