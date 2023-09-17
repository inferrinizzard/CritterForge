package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.EffectPiece;
   import com.edgebee.breedr.data.skill.EffectPieceInstance;
   import com.edgebee.breedr.data.skill.Piece;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PieceView extends Canvas
   {
      
      public static const StarIconPng:Class = PieceView_StarIconPng;
      
      public static const CONNECTOR_RATIO:Number = 0.15;
      
      public static const PIECE_MOUSE_CLICK:String = "PIECE_MOUSE_CLICK";
      
      public static const PIECE_MOUSE_OVER:String = "PIECE_MOUSE_OVER";
      
      public static const PIECE_MOUSE_OUT:String = "PIECE_MOUSE_OUT";
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private static const connectorFuncs:Array = [drawCrossConnector,drawCircleConnector,drawSquareConnector,drawCloverConnector,drawTriangleConnector,drawKeyConnector,drawOctogonConnector,drawClipConnector];
       
      
      public var color:Color;
      
      public var parentEffectPiece:WeakReference;
      
      public var toolTipEnabled:Boolean = true;
      
      private var _piece:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _isGhost:Boolean;
      
      private var _locks:Object;
      
      private var _pieceMask:Sprite = null;
      
      public var bgBmp:BitmapComponent;
      
      public var iconBmp:BitmapComponent;
      
      public var iconBox:Box;
      
      public var starBmp:BitmapComponent;
      
      public var levelLbl:Label;
      
      private var _layout:Array;
      
      public function PieceView()
      {
         this.color = new Color();
         this._piece = new WeakReference(null,Piece);
         this._creature = new WeakReference(null,CreatureInstance);
         this._locks = {
            "top":null,
            "bottom":null,
            "right":null,
            "left":null
         };
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"bgBmp",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":Box,
            "ID":"iconBox",
            "direction":Box.VERTICAL,
            "percentWidth":1,
            "percentHeight":1,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{"Gap":UIGlobals.relativize(-1)},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"iconBmp",
               "percentWidth":CONNECTOR_RATIO * 3,
               "isSquare":true,
               "visible":false,
               "filters":UIGlobals.fontOutline
            }]
         },{
            "CLASS":BitmapComponent,
            "ID":"starBmp",
            "isSquare":true,
            "filters":UIGlobals.fontSmallOutline,
            "percentHeight":CONNECTOR_RATIO,
            "source":StarIconPng
         },{
            "CLASS":Label,
            "ID":"levelLbl",
            "filters":UIGlobals.fontSmallOutline,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         }];
         super();
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         UIGlobals.oneSecTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.parentEffectPiece = new WeakReference();
      }
      
      private static function drawCircleConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x,param4.y,param5);
         param1.endFill();
      }
      
      private static function drawCloverConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x,param4.y,param5 / 2);
         param1.endFill();
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x - param5 * 2 / 3,param4.y,param5 / 2);
         param1.endFill();
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x + param5 * 2 / 3,param4.y,param5 / 2);
         param1.endFill();
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x,param4.y - param5 * 2 / 3,param5 / 2);
         param1.endFill();
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawCircle(param4.x,param4.y + param5 * 2 / 3,param5 / 2);
         param1.endFill();
      }
      
      private static function drawSquareConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawRect(param4.x - param5,param4.y - param5,2 * param5,2 * param5);
         param1.endFill();
      }
      
      private static function drawCrossConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawRect(param4.x - param5,param4.y - param5 / 2,param5 * 2,param5);
         param1.endFill();
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawRect(param4.x - param5 / 2,param4.y - param5,param5,param5 * 2);
         param1.endFill();
      }
      
      private static function drawTriangleConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.lineStyle(0,0,0);
         param1.moveTo(param4.x - param5,param4.y);
         param1.lineTo(param4.x,param4.y + param5);
         param1.lineTo(param4.x + param5,param4.y);
         param1.lineTo(param4.x,param4.y - param5);
         param1.lineTo(param4.x - param5,param4.y);
         param1.endFill();
      }
      
      private static function drawKeyConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         if(param3 == "left" || param3 == "right")
         {
            param1.beginFill(param2 ? 0 : 16777215,1);
            param1.drawRect(param4.x - param5 / 2,param4.y - param5 / 4,param5,param5 / 2);
            param1.endFill();
            param1.beginFill(param2 ? 0 : 16777215,1);
            param1.drawCircle(param4.x - param5 * 2 / 3,param4.y,param5 * 2 / 3);
            param1.drawCircle(param4.x + param5 * 2 / 3,param4.y,param5 * 2 / 3);
            param1.endFill();
         }
         else
         {
            param1.beginFill(param2 ? 0 : 16777215,1);
            param1.drawRect(param4.x - param5 / 4,param4.y - param5 / 2,param5 / 2,param5);
            param1.endFill();
            param1.beginFill(param2 ? 0 : 16777215,1);
            param1.drawCircle(param4.x,param4.y - param5 * 2 / 3,param5 * 2 / 3);
            param1.drawCircle(param4.x,param4.y + param5 * 2 / 3,param5 * 2 / 3);
            param1.endFill();
         }
      }
      
      private static function drawOctogonConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.lineStyle(0,0,0);
         param1.moveTo(param4.x - param5,param4.y - param5 / 3);
         param1.lineTo(param4.x - param5 / 3,param4.y - param5);
         param1.lineTo(param4.x + param5 / 3,param4.y - param5);
         param1.lineTo(param4.x + param5,param4.y - param5 / 3);
         param1.lineTo(param4.x + param5,param4.y + param5 / 3);
         param1.lineTo(param4.x + param5 / 3,param4.y + param5);
         param1.lineTo(param4.x - param5 / 3,param4.y + param5);
         param1.lineTo(param4.x - param5,param4.y + param5 / 3);
         param1.lineTo(param4.x - param5,param4.y - param5 / 3);
         param1.endFill();
      }
      
      private static function drawClipConnector(param1:Graphics, param2:Boolean, param3:String, param4:Point, param5:Number) : void
      {
         param1.beginFill(param2 ? 0 : 16777215,1);
         param1.drawRect(param4.x - param5,param4.y - param5,2 * param5,2 * param5);
         param1.drawRect(param4.x - param5 / 3,param4.y - param5,param5 * 2 / 3,param5 / 3);
         param1.drawRect(param4.x - param5 / 3,param4.y + param5 * 2 / 3,param5 * 2 / 3,param5 / 3);
         param1.drawRect(param4.x - param5,param4.y - param5 / 3,param5 / 3,param5 * 2 / 3);
         param1.drawRect(param4.x + param5 * 2 / 3,param4.y - param5 / 3,param5 / 3,param5 * 2 / 3);
         param1.endFill();
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
            this._isGhost = false;
            this._pieceMask = null;
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
            this.update(true);
         }
      }
      
      public function get isGhost() : Boolean
      {
         return this._isGhost;
      }
      
      public function set isGhost(param1:Boolean) : void
      {
         if(this.isGhost != param1)
         {
            this._isGhost = param1;
            this._pieceMask = null;
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      public function lock(param1:String, param2:*) : void
      {
         this._locks[param1] = param2;
         if(param2 != null)
         {
            this._pieceMask = null;
            this.update();
         }
      }
      
      public function resetLocks() : void
      {
         this._locks = {
            "top":null,
            "bottom":null,
            "right":null,
            "left":null
         };
         this._pieceMask = null;
         this.update();
      }
      
      private function get pieceMask() : Sprite
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Function = null;
         var _loc3_:uint = 0;
         if(!this._pieceMask)
         {
            this._pieceMask = new Sprite();
            this._pieceMask.graphics.clear();
            this._pieceMask.graphics.beginFill(0,1);
            this._pieceMask.graphics.drawRect(0,0,width,height);
            this._pieceMask.graphics.endFill();
            _loc1_ = new Rectangle(width * CONNECTOR_RATIO,height * CONNECTOR_RATIO,width - width * CONNECTOR_RATIO * 2,height - height * CONNECTOR_RATIO * 2);
            this._pieceMask.graphics.beginFill(16777215,1);
            this._pieceMask.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
            this._pieceMask.graphics.endFill();
            if(!this.isGhost)
            {
               if(Boolean(this.piece.top) && this.piece.top.isValid)
               {
                  if(this._locks[TOP] != null)
                  {
                     _loc3_ = uint(this._locks[TOP]);
                  }
                  else
                  {
                     _loc3_ = uint(this.piece.top.types[UIGlobals.oneSecTimer.currentCount % this.piece.top.types.length]);
                  }
                  _loc2_ = connectorFuncs[_loc3_];
                  _loc2_(this._pieceMask.graphics,this.piece.top.isFemale,"top",new Point(width / 2,_loc1_.y),_loc1_.width * CONNECTOR_RATIO);
               }
               if(Boolean(this.piece.bottom) && this.piece.bottom.isValid)
               {
                  if(this._locks[BOTTOM] != null)
                  {
                     _loc3_ = uint(this._locks[BOTTOM]);
                  }
                  else
                  {
                     _loc3_ = uint(this.piece.bottom.types[UIGlobals.oneSecTimer.currentCount % this.piece.bottom.types.length]);
                  }
                  _loc2_ = connectorFuncs[_loc3_];
                  _loc2_(this._pieceMask.graphics,this.piece.bottom.isFemale,"bottom",new Point(width / 2,_loc1_.y + _loc1_.height),_loc1_.width * CONNECTOR_RATIO);
               }
               if(Boolean(this.piece.left) && this.piece.left.isValid)
               {
                  if(this._locks[LEFT] != null)
                  {
                     _loc3_ = uint(this._locks[LEFT]);
                  }
                  else
                  {
                     _loc3_ = uint(this.piece.left.types[UIGlobals.oneSecTimer.currentCount % this.piece.left.types.length]);
                  }
                  _loc2_ = connectorFuncs[_loc3_];
                  _loc2_(this._pieceMask.graphics,this.piece.left.isFemale,"left",new Point(_loc1_.x,height / 2),_loc1_.height * CONNECTOR_RATIO);
               }
               if(Boolean(this.piece.right) && this.piece.right.isValid)
               {
                  if(this._locks[RIGHT] != null)
                  {
                     _loc3_ = uint(this._locks[RIGHT]);
                  }
                  else
                  {
                     _loc3_ = uint(this.piece.right.types[UIGlobals.oneSecTimer.currentCount % this.piece.right.types.length]);
                  }
                  _loc2_ = connectorFuncs[_loc3_];
                  _loc2_(this._pieceMask.graphics,this.piece.right.isFemale,"right",new Point(_loc1_.x + _loc1_.width,height / 2),_loc1_.height * CONNECTOR_RATIO);
               }
            }
         }
         return this._pieceMask;
      }
      
      private function onPieceChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "level")
         {
            this.update(true);
         }
      }
      
      private function update(param1:Boolean = false) : void
      {
         var _loc2_:EffectPieceInstance = null;
         var _loc3_:EffectPiece = null;
         var _loc4_:Color = null;
         var _loc5_:Sprite = null;
         var _loc6_:Matrix = null;
         var _loc7_:Bitmap = null;
         if(childrenCreated || childrenCreating)
         {
            if(Boolean(this.piece) || this.isGhost)
            {
               visible = true;
               if(!param1)
               {
                  this.iconBmp.colorMatrix.saturation = -100;
                  this.iconBmp.alpha = 0.95;
                  if(this.piece)
                  {
                     _loc4_ = this.piece.color;
                  }
                  if(this.isGhost)
                  {
                     _loc4_ = new Color(3355443);
                  }
                  _loc5_ = new Sprite();
                  (_loc6_ = new Matrix()).createGradientBox(width,height,Math.PI / 2);
                  _loc5_.graphics.clear();
                  _loc5_.graphics.beginGradientFill(GradientType.LINEAR,[_loc4_.brighter(75).hex,_loc4_.hex],[1,1],[0,255],_loc6_);
                  _loc5_.graphics.drawRect(0,0,width,height);
                  _loc5_.graphics.endFill();
                  this.bgBmp.bitmap = new Bitmap(new BitmapData(width,height,true));
                  this.bgBmp.bitmap.bitmapData.draw(_loc5_);
                  if(this.piece is EffectPiece)
                  {
                     this.bgBmp.filters = [new GlowFilter(16777215,0.25,5,5,2,1,true),new GlowFilter(0,1,3,3,3),new GlowFilter(16777215,1,3,3,3)];
                  }
                  else if(this.piece)
                  {
                     this.bgBmp.filters = [new GlowFilter(16777215,0.25,5,5,2,1,true),new GlowFilter(0,1,3,3,3)];
                  }
                  else
                  {
                     this.bgBmp.filters = [];
                  }
                  (_loc7_ = new Bitmap(new BitmapData(width,height,true))).bitmapData.draw(this.pieceMask);
                  this.bgBmp.bitmap.bitmapData.copyChannel(_loc7_.bitmapData,_loc7_.bitmapData.rect,new Point(0,0),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
                  if(this.isGhost)
                  {
                     this.bgBmp.alpha = 0.35;
                  }
                  else
                  {
                     this.bgBmp.alpha = 1;
                  }
                  if(this.piece)
                  {
                     this.iconBmp.source = this.piece.icon;
                  }
                  else
                  {
                     this.iconBmp.source = null;
                  }
                  this.iconBmp.visible = this.iconBmp.bitmap != null;
               }
               _loc2_ = this.parentEffectPiece.get() as EffectPieceInstance;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.effect_piece;
               }
               else
               {
                  _loc3_ = null;
               }
               if(this.piece)
               {
                  toolTip = this.piece.getDescription(_loc3_,this.creature);
                  this.levelLbl.text = this.piece.modifiedLevel.toString();
                  if(Boolean(this.creature) && this.piece.canUpgrade(this.creature))
                  {
                     this.levelLbl.setStyle("FontColor",16777215);
                  }
                  else
                  {
                     this.levelLbl.setStyle("FontColor",16755200);
                  }
                  validateNow(true);
                  this.starBmp.x = width - width * CONNECTOR_RATIO - this.starBmp.width - 1;
                  this.starBmp.y = height * CONNECTOR_RATIO + 1;
                  this.levelLbl.x = width - width * CONNECTOR_RATIO - this.starBmp.width - this.levelLbl.width - 1;
                  this.levelLbl.y = height * CONNECTOR_RATIO - 5;
                  this.starBmp.visible = this.piece.modifiedLevel > 1;
                  this.levelLbl.visible = this.piece.modifiedLevel > 1;
               }
               else
               {
                  toolTip = null;
                  this.starBmp.visible = false;
                  this.levelLbl.visible = false;
               }
            }
            else
            {
               visible = false;
               toolTip = null;
            }
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(PIECE_MOUSE_CLICK,{
            "event":param1,
            "piece":this
         },true));
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(PIECE_MOUSE_OVER,{
            "event":param1,
            "piece":this
         },true));
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(PIECE_MOUSE_OUT,{
            "event":param1,
            "piece":this
         },true));
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         if((childrenCreated || childrenCreating) && Boolean(this.piece))
         {
            _loc2_ = false;
            if(this._locks[TOP] == null && this.piece.top && this.piece.top.types.length > 1)
            {
               _loc2_ = true;
            }
            if(this._locks[BOTTOM] == null && this.piece.bottom && this.piece.bottom.types.length > 1)
            {
               _loc2_ = true;
            }
            if(this._locks[LEFT] == null && this.piece.right && this.piece.right.types.length > 1)
            {
               _loc2_ = true;
            }
            if(this._locks[RIGHT] == null && this.piece.left && this.piece.left.types.length > 1)
            {
               _loc2_ = true;
            }
            if(_loc2_)
            {
               this._pieceMask = null;
               this.update();
            }
         }
      }
   }
}
