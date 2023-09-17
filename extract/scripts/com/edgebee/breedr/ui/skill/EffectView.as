package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.Connector;
   import com.edgebee.breedr.data.skill.EffectPieceInstance;
   
   public class EffectView extends Box
   {
      
      private static const views:Array = ["modView1","modView2","modView3","modView4","modView5"];
       
      
      private var _effect:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _size:Number;
      
      public var fxView:com.edgebee.breedr.ui.skill.PieceView;
      
      public var modView1:com.edgebee.breedr.ui.skill.PieceView;
      
      public var modView2:com.edgebee.breedr.ui.skill.PieceView;
      
      public var modView3:com.edgebee.breedr.ui.skill.PieceView;
      
      public var modView4:com.edgebee.breedr.ui.skill.PieceView;
      
      public var modView5:com.edgebee.breedr.ui.skill.PieceView;
      
      private var _layout:Array;
      
      public function EffectView()
      {
         this._effect = new WeakReference(null,EffectPieceInstance);
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"modView5",
            "visible":false
         },{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"modView4",
            "visible":false
         },{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"modView3",
            "visible":false
         },{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"modView2",
            "visible":false
         },{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"modView1",
            "visible":false
         },{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"fxView"
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         layoutInvisibleChildren = false;
         layoutInReverse = true;
      }
      
      public function get effect() : EffectPieceInstance
      {
         return this._effect.get() as EffectPieceInstance;
      }
      
      public function set effect(param1:EffectPieceInstance) : void
      {
         if(this.effect != param1)
         {
            if(this.effect)
            {
               this.effect.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onEffectChange);
            }
            this._effect.reset(param1);
            if(this.effect)
            {
               this.effect.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onEffectChange);
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
      
      public function get size() : Number
      {
         return this._size;
      }
      
      public function set size(param1:Number) : void
      {
         var _loc2_:String = null;
         if(this.size != param1)
         {
            this._size = param1;
            if(childrenCreated || childrenCreating)
            {
               setStyle("Gap",-com.edgebee.breedr.ui.skill.PieceView.CONNECTOR_RATIO * this.size * 2 + 1);
               this.fxView.width = this.fxView.height = this.size;
               for each(_loc2_ in views)
               {
                  (this[_loc2_] as com.edgebee.breedr.ui.skill.PieceView).width = (this[_loc2_] as com.edgebee.breedr.ui.skill.PieceView).height = this.size;
               }
            }
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         setStyle("Gap",-com.edgebee.breedr.ui.skill.PieceView.CONNECTOR_RATIO * this.size * 2 + 1);
         this.fxView.width = this.fxView.height = this.size;
         for each(_loc1_ in views)
         {
            (this[_loc1_] as com.edgebee.breedr.ui.skill.PieceView).width = (this[_loc1_] as com.edgebee.breedr.ui.skill.PieceView).height = this.size;
         }
         this.update();
      }
      
      public function resetLocks() : void
      {
         if(childrenCreated || childrenCreating)
         {
            this.fxView.resetLocks();
            this.modView1.resetLocks();
            this.modView2.resetLocks();
            this.modView3.resetLocks();
            this.modView4.resetLocks();
            this.modView5.resetLocks();
         }
      }
      
      private function onEffectChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:com.edgebee.breedr.ui.skill.PieceView = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Connector = null;
         var _loc5_:com.edgebee.breedr.ui.skill.PieceView = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.effect)
            {
               visible = true;
               this.fxView.piece = this.effect;
               this.fxView.creature = this.creature;
               _loc3_ = 0;
               if(this.effect is EffectPieceInstance)
               {
                  _loc3_ = (this.effect as EffectPieceInstance).slot_count;
               }
               _loc2_ = 0;
               while(_loc2_ < views.length)
               {
                  _loc1_ = this[views[_loc2_]];
                  if(_loc2_ < this.effect.pieces.length)
                  {
                     _loc1_.visible = true;
                     _loc1_.parentEffectPiece.reset(this.effect);
                     _loc1_.piece = this.effect.pieces[_loc2_];
                     _loc1_.creature = this.creature;
                  }
                  else if(_loc2_ < _loc3_)
                  {
                     _loc1_.visible = true;
                     _loc1_.piece = null;
                     _loc1_.parentEffectPiece.reset(null);
                     _loc1_.isGhost = true;
                     _loc1_.creature = null;
                  }
                  else
                  {
                     _loc1_.visible = false;
                     _loc1_.parentEffectPiece.reset(null);
                     _loc1_.piece = null;
                     _loc1_.isGhost = false;
                     _loc1_.creature = null;
                  }
                  _loc2_++;
               }
               if(this.effect.pieces.length > 0)
               {
                  this.fxView.lock(com.edgebee.breedr.ui.skill.PieceView.RIGHT,this.effect.right.connectToWithType(this.effect.pieces[0].left));
               }
               _loc4_ = this.effect.right;
               _loc2_ = 0;
               while(_loc2_ < views.length)
               {
                  _loc1_ = this[views[_loc2_]];
                  if(_loc2_ < this.effect.pieces.length)
                  {
                     _loc1_.lock(com.edgebee.breedr.ui.skill.PieceView.LEFT,_loc4_.connectToWithType(_loc1_.piece.left));
                     if(_loc2_ < this.effect.pieces.length - 1)
                     {
                        _loc5_ = this[views[_loc2_ + 1]];
                        _loc1_.lock(com.edgebee.breedr.ui.skill.PieceView.RIGHT,_loc1_.piece.right.connectToWithType(_loc5_.piece.left));
                     }
                     else
                     {
                        _loc1_.lock(com.edgebee.breedr.ui.skill.PieceView.RIGHT,_loc4_.connectToWithType(_loc1_.piece.left));
                     }
                     _loc4_ = _loc1_.piece.right;
                  }
                  _loc2_++;
               }
            }
            else
            {
               visible = false;
               this.fxView.piece = null;
            }
         }
      }
   }
}
