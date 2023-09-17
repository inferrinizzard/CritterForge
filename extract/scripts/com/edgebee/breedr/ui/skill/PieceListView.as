package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.effect.Effect;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.Piece;
   import com.edgebee.breedr.managers.TutorialManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PieceListView extends Box implements Listable
   {
       
      
      private var _piece:WeakReference;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _mouseDown:Boolean = false;
      
      public var pieceView:com.edgebee.breedr.ui.skill.PieceView;
      
      private var _layout:Array;
      
      public function PieceListView()
      {
         this._piece = new WeakReference(null,Piece);
         this._layout = [{
            "CLASS":com.edgebee.breedr.ui.skill.PieceView,
            "ID":"pieceView",
            "width":"{width}",
            "height":"{height}"
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         width = UIGlobals.relativize(64);
         height = UIGlobals.relativize(64);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get listElement() : Object
      {
         return this.piece;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.piece = param1 as Piece;
      }
      
      public function get piece() : Piece
      {
         return this._piece.get() as Piece;
      }
      
      public function set piece(param1:Piece) : void
      {
         if(this.piece != param1)
         {
            if(this.piece)
            {
               this.piece.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPieceChange);
            }
            this._piece.reset(param1);
            if(this.piece)
            {
               this.piece.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPieceChange);
            }
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
         this.pieceView.dropShadowProxy.alpha = 1;
         visible = false;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function update() : void
      {
         var _loc1_:EffectPiece = null;
         if(this.piece)
         {
            visible = true;
            this.pieceView.piece = this.piece;
            if(this.client.tutorialManager.state == TutorialManager.STATE_HATCHING)
            {
               _loc1_ = this.piece as EffectPiece;
               if(Boolean(_loc1_) && _loc1_.effect.type == Effect.TYPE_ATTACK)
               {
                  name = "FirstAttackEffect";
                  dispatchEvent(new Event("SKILL_EDITOR_FIRST_ATTACK_EFFECT_LISTED",true));
               }
            }
         }
         else
         {
            visible = false;
            this.pieceView.piece = null;
         }
      }
      
      private function onPieceChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:com.edgebee.breedr.ui.skill.PieceView = null;
         var _loc3_:EffectPiece = null;
         if(this._mouseDown && this.piece && enabled)
         {
            if(this.client.tutorialManager.state == TutorialManager.STATE_HATCHING)
            {
               _loc3_ = this.piece as EffectPiece;
               if(Boolean(_loc3_) && _loc3_.effect.type != Effect.TYPE_ATTACK)
               {
                  return;
               }
            }
            _loc2_ = new com.edgebee.breedr.ui.skill.PieceView();
            _loc2_.width = this.pieceView.width;
            _loc2_.height = this.pieceView.height;
            _loc2_.toolTipEnabled = false;
            _loc2_.piece = this.piece;
            UIGlobals.dragManager.doDrag(this,{"piece":this.piece},_loc2_,param1,this.pieceView.width / 2 - mouseX);
         }
      }
   }
}
