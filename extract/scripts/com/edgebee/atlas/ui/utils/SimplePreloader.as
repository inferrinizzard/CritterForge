package com.edgebee.atlas.ui.utils
{
   import com.edgebee.atlas.util.ColorMatrix;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class SimplePreloader extends Preloader
   {
       
      
      private var imageCls:Class;
      
      private var percentTxt:TextField;
      
      private var bg:Bitmap;
      
      private var fg:Bitmap;
      
      private var cm:ColorMatrix;
      
      public function SimplePreloader(param1:Class, param2:String)
      {
         super(param2);
         body.mouseChildren = false;
         this.imageCls = param1;
      }
      
      override protected function setup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.setup();
         this.bg = new this.imageCls();
         this.bg.width = 512;
         this.bg.height = 256;
         this.bg.smoothing = true;
         _loc1_ = int("800");
         _loc2_ = int("600");
         this.bg.x = _loc1_ / 2 - this.bg.width / 2;
         this.bg.y = _loc2_ / 2 - this.bg.height / 2;
         this.cm = new ColorMatrix();
         this.cm.contrast = -50;
         this.cm.saturation = -100;
         this.bg.alpha = 0.5;
         this.bg.filters = [new ColorMatrixFilter(this.cm.valueOf())];
         body.addChild(this.bg);
         this.fg = new this.imageCls();
         this.fg.width = 512;
         this.fg.height = 256;
         this.fg.smoothing = true;
         this.fg.x = _loc1_ / 2 - this.fg.width / 2;
         this.fg.y = _loc2_ / 2 - this.fg.height / 2;
         this.fg.mask = new Sprite();
         body.addChild(this.fg.mask);
         body.addChild(this.fg);
         this.percentTxt = new TextField();
         this.percentTxt.selectable = false;
         this.percentTxt.filters = [new GlowFilter(8952319,0.75,3,3,2,2)];
         this.percentTxt.x = _loc1_ / 2 - 300 / 2;
         this.percentTxt.y = _loc2_ - 100;
         this.percentTxt.width = 300;
         var _loc3_:TextFormat = new TextFormat("tahoma",24,16777215,true,null,null,null,null,TextFormatAlign.CENTER);
         this.percentTxt.defaultTextFormat = _loc3_;
         body.addChild(this.percentTxt);
      }
      
      override protected function terminate() : void
      {
         body.removeChild(this.bg);
         body.removeChild(this.fg.mask);
         this.fg.mask = null;
         body.removeChild(this.fg);
         body.removeChild(this.percentTxt);
      }
      
      override protected function update(param1:Number) : void
      {
         body.graphics.clear();
         body.graphics.beginFill(0,0);
         body.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         body.graphics.endFill();
         if(param1 < 1)
         {
            this.percentTxt.text = (param1 * 100).toFixed(0) + " %";
         }
         else
         {
            body.buttonMode = true;
            this.percentTxt.text = "CLICK TO START";
         }
         var _loc2_:Sprite = this.fg.mask as Sprite;
         _loc2_.graphics.clear();
         _loc2_.graphics.beginFill(16777215,1);
         _loc2_.graphics.drawRect(this.fg.x,this.fg.y,param1 * this.fg.width,this.fg.height);
         _loc2_.graphics.endFill();
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         this.percentTxt.visible = false;
         super.onClick(param1);
      }
   }
}
