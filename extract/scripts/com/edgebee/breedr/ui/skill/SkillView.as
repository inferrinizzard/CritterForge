package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.SkillInstance;
   
   public class SkillView extends Box
   {
      
      private static const views:Array = ["primary","secondary"];
       
      
      private var _skill:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _size:Number;
      
      public var primary:com.edgebee.breedr.ui.skill.EffectView;
      
      public var secondary:com.edgebee.breedr.ui.skill.EffectView;
      
      private var _layout:Array;
      
      public function SkillView()
      {
         this._skill = new WeakReference(null,SkillInstance);
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.skill.EffectView,
            "ID":"primary",
            "size":this.size
         },{
            "CLASS":com.edgebee.breedr.ui.skill.EffectView,
            "ID":"secondary",
            "size":this.size
         }];
         super(Box.VERTICAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         layoutInvisibleChildren = false;
         dropShadowProxy.alpha = 1;
      }
      
      public function get skill() : SkillInstance
      {
         return this._skill.get() as SkillInstance;
      }
      
      public function set skill(param1:SkillInstance) : void
      {
         if(this.skill != param1)
         {
            if(this.skill)
            {
               this.skill.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
            }
            this._skill.reset(param1);
            if(this.skill)
            {
               this.skill.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSkillChange);
            }
            if(childrenCreated || childrenCreating)
            {
               this.primary.resetLocks();
               this.secondary.resetLocks();
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
         if(param1 != this.creature)
         {
            this._creature.reset(param1);
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.primary.size = this.size;
         this.secondary.size = this.size;
         setStyle("Gap",-PieceView.CONNECTOR_RATIO * this.size * 2 + 1);
         this.update();
      }
      
      public function get size() : Number
      {
         return this._size;
      }
      
      public function set size(param1:Number) : void
      {
         if(this.size != param1)
         {
            this._size = param1;
            height = 2 * this.size;
            if(childrenCreated || childrenCreating)
            {
               setStyle("Gap",-PieceView.CONNECTOR_RATIO * this.size * 2 + 1);
               this.primary.size = this.size;
               this.secondary.size = this.size;
            }
         }
      }
      
      public function resetLocks() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.primary.resetLocks();
            this.secondary.resetLocks();
         }
      }
      
      private function onSkillChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:com.edgebee.breedr.ui.skill.EffectView = null;
         var _loc2_:com.edgebee.breedr.ui.skill.EffectView = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         if(childrenCreated || childrenCreating)
         {
            if(this.skill)
            {
               visible = true;
               _loc3_ = 0;
               while(_loc3_ < views.length)
               {
                  _loc1_ = this[views[_loc3_]] as com.edgebee.breedr.ui.skill.EffectView;
                  if(_loc3_ < this.skill.pieces.length)
                  {
                     _loc1_.effect = this.skill.pieces[_loc3_];
                     _loc1_.creature = this.creature;
                     _loc1_.visible = true;
                  }
                  else
                  {
                     _loc1_.effect = null;
                     _loc1_.creature = null;
                     _loc1_.visible = false;
                  }
                  _loc3_++;
               }
               if(this.skill.pieces.length > 1)
               {
                  _loc1_ = this[views[0]] as com.edgebee.breedr.ui.skill.EffectView;
                  _loc2_ = this[views[1]] as com.edgebee.breedr.ui.skill.EffectView;
                  _loc4_ = _loc1_.effect.bottom.connectToWithType(_loc2_.effect.top);
                  _loc1_.fxView.lock(PieceView.BOTTOM,_loc4_);
                  _loc2_.fxView.lock(PieceView.TOP,_loc4_);
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
