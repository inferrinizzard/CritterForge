package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.TraitInstance;
   
   public class TraitView extends Canvas
   {
      
      public static const HiddenPng:Class = TraitView_HiddenPng;
       
      
      private var _trait:WeakReference;
      
      private var _creature:WeakReference;
      
      public var iconImg:SWFLoader;
      
      public var starBmp:BitmapComponent;
      
      public var levelLbl:Label;
      
      private var _layout:Array;
      
      public function TraitView()
      {
         this._trait = new WeakReference(null,TraitInstance);
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":SWFLoader,
            "ID":"iconImg",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":BitmapComponent,
            "ID":"starBmp",
            "filters":UIGlobals.fontOutline,
            "isSquare":true,
            "percentWidth":0.2,
            "source":PieceView.StarIconPng
         },{
            "CLASS":Label,
            "ID":"levelLbl",
            "filters":UIGlobals.fontOutline,
            "STYLES":{
               "FontWeight":"bold",
               "FontSize":UIGlobals.relativizeFont(16)
            }
         }];
         super();
         mouseChildren = false;
      }
      
      public function get trait() : TraitInstance
      {
         return this._trait.get() as TraitInstance;
      }
      
      public function set trait(param1:TraitInstance) : void
      {
         if(this.trait != param1)
         {
            if(this.trait)
            {
               this.trait.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTraitChange);
            }
            this._trait.reset(param1);
            if(this.trait)
            {
               this.trait.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTraitChange);
            }
            this.update();
         }
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(this.creature != param1)
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      private function onTraitChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "level")
         {
            this.update();
         }
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.trait)
            {
               visible = true;
               toolTip = this.trait.getDescription(this.creature);
               this.iconImg.source = UIGlobals.getAssetPath(this.trait.trait.image_url);
               this.levelLbl.text = this.trait.modifiedLevel.toString();
               if(Boolean(this.creature) && this.trait.canUpgrade(this.creature))
               {
                  this.levelLbl.setStyle("FontColor",16777215);
               }
               else
               {
                  this.levelLbl.setStyle("FontColor",16755200);
               }
               validateNow(true);
               this.starBmp.x = width - this.starBmp.width - 1;
               this.starBmp.y = 1;
               this.levelLbl.x = width - this.starBmp.width - this.levelLbl.width - 2;
               this.levelLbl.y = -3;
               this.starBmp.visible = this.trait.modifiedLevel > 1;
               this.levelLbl.visible = this.trait.modifiedLevel > 1;
            }
            else
            {
               visible = false;
            }
         }
      }
   }
}
