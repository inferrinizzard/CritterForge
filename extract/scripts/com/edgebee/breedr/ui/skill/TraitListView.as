package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.TraitInstance;
   import flash.events.MouseEvent;
   
   public class TraitListView extends Canvas implements Listable
   {
      
      public static const TRAIT_CLICKED:String = "TRAIT_CLICKED";
       
      
      public var traitViewSize:Number;
      
      public var traitViewSizeHalf:Number;
      
      private var _trait:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      public var traitView:com.edgebee.breedr.ui.skill.TraitView;
      
      private var _layout:Array;
      
      public function TraitListView()
      {
         this._trait = new WeakReference(null,TraitInstance);
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.skill.TraitView,
            "ID":"traitView",
            "x":"{traitViewSizeHalf}",
            "y":"{traitViewSizeHalf}",
            "width":"{traitViewSize}",
            "height":"{traitViewSize}"
         }];
         super();
         width = UIGlobals.relativize(90);
         height = UIGlobals.relativize(90);
         this.traitViewSize = height - UIGlobals.relativize(5);
         this.traitViewSizeHalf = (width - this.traitViewSize) / 2;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function get listElement() : Object
      {
         return this.trait;
      }
      
      public function set listElement(param1:Object) : void
      {
         if(param1)
         {
            this.trait = param1.trait;
            this.creature = param1.creature;
         }
         else
         {
            this.trait = null;
            this.creature = null;
         }
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
            if(childrenCreated)
            {
               this.update();
            }
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
            this._creature.reset(param1);
            if(childrenCreated)
            {
               this.update();
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         visible = false;
         this.update();
      }
      
      private function update() : void
      {
         if(this.trait)
         {
            visible = true;
            this.traitView.trait = this.trait;
            this.traitView.creature = this.creature;
         }
         else
         {
            visible = false;
            this.traitView.trait = null;
            this.traitView.creature = this.creature;
         }
      }
      
      private function onTraitChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(TRAIT_CLICKED,this.trait,true));
      }
   }
}
