package com.edgebee.breedr.ui.skill
{
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.skill.EffectPieceInstance;
   import com.edgebee.breedr.data.skill.Piece;
   import com.edgebee.breedr.data.skill.SkillInstance;
   
   public class MiniSkillView extends Box
   {
      
      private static const views:Array = ["primary","secondary","tertiary"];
      
      private static const fx01Views:Array = ["fx01","fx01mod01","fx01mod02","fx01mod03","fx01mod04","fx01mod05"];
      
      private static const fx02Views:Array = ["fx02","fx02mod01","fx02mod02","fx02mod03","fx02mod04","fx02mod05"];
       
      
      private var _skill:WeakReference;
      
      private var _creature:WeakReference;
      
      private var _size:Number;
      
      public var primary:Box;
      
      public var secondary:Box;
      
      public var tertiary:Box;
      
      public var fx01:Canvas;
      
      public var fx01mod01:Canvas;
      
      public var fx01mod02:Canvas;
      
      public var fx01mod03:Canvas;
      
      public var fx01mod04:Canvas;
      
      public var fx01mod05:Canvas;
      
      public var fx02:Canvas;
      
      public var fx02mod01:Canvas;
      
      public var fx02mod02:Canvas;
      
      public var fx02mod03:Canvas;
      
      public var fx02mod04:Canvas;
      
      public var fx02mod05:Canvas;
      
      private var _layout:Array;
      
      public function MiniSkillView()
      {
         this._skill = new WeakReference(null,SkillInstance);
         this._creature = new WeakReference(null,CreatureInstance);
         this._layout = [{
            "CLASS":Box,
            "ID":"primary",
            "visible":false,
            "layoutInvisibleChildren":false,
            "STYLES":{"Gap":1},
            "CHILDREN":[{
               "CLASS":Canvas,
               "ID":"fx01",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx01mod01",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx01mod02",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx01mod03",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx01mod04",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx01mod05",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            }]
         },{
            "CLASS":Box,
            "ID":"secondary",
            "visible":false,
            "layoutInvisibleChildren":false,
            "STYLES":{"Gap":1},
            "CHILDREN":[{
               "CLASS":Canvas,
               "ID":"fx02",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx02mod01",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx02mod02",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx02mod03",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx02mod04",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            },{
               "CLASS":Canvas,
               "ID":"fx02mod05",
               "STYLES":{
                  "BackgroundAlpha":1,
                  "BackgroundDirection":Math.PI / 2
               },
               "CHILDREN":[{
                  "CLASS":BitmapComponent,
                  "percentWidth":1,
                  "isSquare":true,
                  "filters":UIGlobals.fontOutline
               }]
            }]
         }];
         super(Box.VERTICAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         glowProxy.alpha = 1;
         glowProxy.blur = 3;
         glowProxy.color = 0;
         glowProxy.strength = 3;
         dropShadowProxy.alpha = 1;
         layoutInvisibleChildren = false;
         setStyle("Gap",1);
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
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         for each(_loc1_ in fx01Views)
         {
            this[_loc1_].width = this[_loc1_].height = this.size;
         }
         for each(_loc1_ in fx02Views)
         {
            this[_loc1_].width = this[_loc1_].height = this.size;
         }
         this.update();
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
               for each(_loc2_ in fx01Views)
               {
                  this[_loc2_].width = this[_loc2_].height = param1;
               }
               for each(_loc2_ in fx02Views)
               {
                  this[_loc2_].width = this[_loc2_].height = param1;
               }
            }
         }
      }
      
      private function onSkillChange(param1:PropertyChangeEvent) : void
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
         var _loc2_:String = null;
         var _loc3_:EffectPieceInstance = null;
         var _loc4_:Piece = null;
         var _loc5_:int = 0;
         var _loc6_:Canvas = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.skill)
            {
               visible = true;
               if(this.skill.pieces.length > 0)
               {
                  this.primary.visible = true;
                  _loc3_ = this.skill.pieces[0] as EffectPieceInstance;
                  (_loc6_ = this[fx01Views[0]]).toolTip = _loc3_.getDescription(_loc3_.effect_piece,this.creature);
                  _loc6_.setStyle("BackgroundColor",[_loc3_.color.brighter(75).hex,_loc3_.color.hex]);
                  (_loc6_.getChildAt(0) as BitmapComponent).source = _loc3_.icon;
                  _loc5_ = 1;
                  while(_loc5_ < fx01Views.length)
                  {
                     _loc6_ = this[fx01Views[_loc5_]];
                     if(_loc5_ - 1 < _loc3_.pieces.length)
                     {
                        _loc4_ = _loc3_.pieces[_loc5_ - 1] as Piece;
                        _loc6_.visible = true;
                        _loc6_.toolTip = _loc4_.getDescription(_loc3_.effect_piece,this.creature);
                        _loc6_.setStyle("BackgroundColor",[_loc4_.color.brighter(75).hex,_loc4_.color.hex]);
                        (_loc6_.getChildAt(0) as BitmapComponent).source = _loc4_.icon;
                     }
                     else
                     {
                        _loc6_.visible = false;
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  this.primary.visible = false;
               }
               if(this.skill.pieces.length > 1)
               {
                  this.secondary.visible = true;
                  _loc3_ = this.skill.pieces[1] as EffectPieceInstance;
                  (_loc6_ = this[fx02Views[0]]).toolTip = _loc3_.getDescription(_loc3_.effect_piece,this.creature);
                  _loc6_.setStyle("BackgroundColor",[_loc3_.color.brighter(75).hex,_loc3_.color.hex]);
                  (_loc6_.getChildAt(0) as BitmapComponent).source = _loc3_.icon;
                  _loc5_ = 1;
                  while(_loc5_ < fx02Views.length)
                  {
                     _loc6_ = this[fx02Views[_loc5_]];
                     if(_loc5_ - 1 < _loc3_.pieces.length)
                     {
                        _loc4_ = _loc3_.pieces[_loc5_ - 1] as Piece;
                        _loc6_.visible = true;
                        _loc6_.toolTip = _loc4_.getDescription(_loc3_.effect_piece,this.creature);
                        _loc6_.setStyle("BackgroundColor",[_loc4_.color.brighter(75).hex,_loc4_.color.hex]);
                        (_loc6_.getChildAt(0) as BitmapComponent).source = _loc4_.icon;
                     }
                     else
                     {
                        _loc6_.visible = false;
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  this.secondary.visible = false;
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
