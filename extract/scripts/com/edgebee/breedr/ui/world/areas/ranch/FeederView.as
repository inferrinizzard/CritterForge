package com.edgebee.breedr.ui.world.areas.ranch
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.StyleChangedEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.world.Feeder;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class FeederView extends Box
   {
       
      
      private var _feeder:WeakReference;
      
      public var valueCvs:Canvas;
      
      public var valueLbl:Label;
      
      public var valueIconBg:SWFLoader;
      
      public var valueIconFg:SWFLoader;
      
      public var valueIconFgMask:Sprite;
      
      private var _layout:Array;
      
      public function FeederView()
      {
         this._feeder = new WeakReference(null,Feeder);
         this._layout = [{
            "CLASS":Canvas,
            "ID":"valueCvs",
            "percentWidth":1,
            "percentHeight":1,
            "CHILDREN":[{
               "CLASS":SWFLoader,
               "ID":"valueIconBg",
               "percentWidth":1,
               "percentHeight":1
            },{
               "CLASS":SWFLoader,
               "ID":"valueIconFg",
               "percentWidth":1,
               "percentHeight":1,
               "filters":[new GlowFilter(0,0.35,2,2,3)]
            },{
               "CLASS":Label,
               "ID":"valueLbl",
               "STYLES":{
                  "FontColor":16777215,
                  "FontWeight":"bold"
               },
               "filters":UIGlobals.fontOutline
            }]
         }];
         super();
         layoutInvisibleChildren = false;
         addEventListener(StyleChangedEvent.STYLE_CHANGED,this.onStyleChange);
      }
      
      public function get feeder() : Feeder
      {
         return this._feeder.get() as Feeder;
      }
      
      public function set feeder(param1:Feeder) : void
      {
         if(this.feeder != param1)
         {
            if(this.feeder)
            {
               this.feeder.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onFeederChange);
            }
            this._feeder.reset(param1);
            if(this.feeder)
            {
               this.feeder.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onFeederChange);
            }
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.valueLbl.setStyle("FontFamily",getStyle("FontFamily"));
         this.valueLbl.setStyle("FontSize",getStyle("FontSize"));
         this.valueLbl.setStyle("FontWeight",getStyle("FontWeight"));
         this.valueIconBg.colorMatrix.saturation = -100;
         this.valueIconBg.colorMatrix.brightness = 25;
         this.valueIconBg.colorMatrix.contrast = -50;
         this.valueIconFgMask = new Sprite();
         this.valueIconFg.mask = this.valueIconFgMask;
         this.valueCvs.addChild(this.valueIconFgMask);
         this.update();
      }
      
      private function onFeederChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onStyleChange(param1:StyleChangedEvent) : void
      {
         if(childrenCreated)
         {
            if(param1.style == "FontSize")
            {
               this.valueLbl.setStyle("FontSize",param1.newValue);
            }
            if(param1.style == "FontWeight")
            {
               this.valueLbl.setStyle("FontWeight",param1.newValue);
            }
            if(param1.style == "FontFamily")
            {
               this.valueLbl.setStyle("FontFamily",param1.newValue);
            }
         }
      }
      
      private function update() : void
      {
         var _loc1_:Number = NaN;
         if(childrenCreated || childrenCreating)
         {
            if(this.feeder)
            {
               visible = true;
               this.valueLbl.text = this.feeder.quantity.toString();
               validateNow(true);
               this.valueLbl.x = this.valueLbl.getStyle("FontSize") / 4 + (width - this.valueLbl.width);
               this.valueLbl.y = 2 * this.valueLbl.getStyle("FontSize") / 5 + (height - this.valueLbl.height);
               this.valueIconFgMask.graphics.clear();
               this.valueIconFgMask.graphics.beginFill(16777215,1);
               _loc1_ = this.feeder.quantity / this.feeder.level.capacity;
               this.valueIconFgMask.graphics.drawRect(0,(1 - _loc1_) * height,width,_loc1_ * height);
               this.valueIconFgMask.graphics.endFill();
               if(this.feeder.item_id > 0 && this.feeder.quantity > 0)
               {
                  this.valueIconBg.visible = true;
                  this.valueIconFg.visible = true;
                  this.valueIconBg.source = UIGlobals.getAssetPath(this.feeder.item.image_url);
                  this.valueIconFg.source = UIGlobals.getAssetPath(this.feeder.item.image_url);
                  toolTip = Utils.formatString(Asset.getInstanceByName("FEEDER_TOOLTIP").value,{
                     "level":this.feeder.level.level.toString(),
                     "capacity":this.feeder.level.capacity.toString(),
                     "amount":this.feeder.quantity.toString(),
                     "item":this.feeder.item.name.value
                  });
               }
               else
               {
                  this.valueIconBg.visible = false;
                  this.valueIconFg.visible = false;
                  this.valueLbl.text = Asset.getInstanceByName("EMPTY");
                  validateNow(true);
                  this.valueLbl.x = width - this.valueLbl.width;
                  this.valueLbl.y = 0;
                  toolTip = Utils.formatString(Asset.getInstanceByName("FEEDER_TOOLTIP").value,{
                     "level":this.feeder.level.level.toString(),
                     "capacity":this.feeder.level.capacity.toString(),
                     "amount":this.feeder.quantity.toString(),
                     "item":Asset.getInstanceByName("NOTHING").value
                  });
               }
            }
            else
            {
               visible = false;
            }
         }
      }
   }
}
