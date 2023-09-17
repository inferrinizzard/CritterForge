package com.edgebee.breedr.ui.creature
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.util.Color;
   import com.edgebee.atlas.util.ColorMatrix;
   import com.edgebee.atlas.util.ColorTransformProxy;
   import com.edgebee.atlas.util.GlowProxy;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.creature.Category;
   import com.edgebee.breedr.data.creature.CreatureInstance;
   import com.edgebee.breedr.data.creature.Element;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CreatureView extends Canvas
   {
      
      public static const Egg1Png:Class = CreatureView_Egg1Png;
      
      public static const Egg2Png:Class = CreatureView_Egg2Png;
      
      public static const Egg3Png:Class = CreatureView_Egg3Png;
      
      public static const Egg4Png:Class = CreatureView_Egg4Png;
      
      public static const Egg5Png:Class = CreatureView_Egg5Png;
      
      public static const SleepBubblePng:Class = CreatureView_SleepBubblePng;
      
      public static const MAX_CREATURE_SIZE:Number = 384;
      
      public static const SCALE_FACTOR:Number = 1.25;
      
      private static var _scaleAnim:Animation;
       
      
      private var _relativeProportions:Boolean = false;
      
      private var _disableElements:Boolean = false;
      
      private var _flipped:Boolean = false;
      
      private var _creature:WeakReference;
      
      private var _layers:Object;
      
      private var _layered:Boolean = true;
      
      private var _rendered:Bitmap;
      
      private var _sleepBubble:BitmapComponent;
      
      private var _sleepBubbleAnim:AnimationInstance;
      
      private var _listeningForLoadComplete:Boolean;
      
      private var _fgCvs:Canvas;
      
      private var _bgCvs:Canvas;
      
      private var _sleeping:Boolean = false;
      
      public function CreatureView()
      {
         var _loc1_:Track = null;
         this._creature = new WeakReference(null,CreatureInstance);
         this._layers = {};
         super();
         addEventListener(Component.RESIZE,this.onResized);
         if(!_scaleAnim)
         {
            _scaleAnim = new Animation();
            _loc1_ = new Track("scaleX");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.5,1.25));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _scaleAnim.addTrack(_loc1_);
            _loc1_ = new Track("scaleY");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.5,1.25));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _scaleAnim.addTrack(_loc1_);
            _scaleAnim.loop = true;
         }
      }
      
      public function get creature() : CreatureInstance
      {
         return this._creature.get() as CreatureInstance;
      }
      
      public function set creature(param1:CreatureInstance) : void
      {
         if(!this.creature || !this.creature.equals(param1))
         {
            if(this.creature)
            {
               this.creature.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
            }
            this._creature.reset(param1);
            if(this.creature)
            {
               this.creature.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCreatureChange);
               this.onCreatureChange(null);
            }
            else
            {
               this.removeAllChildren();
            }
            invalidateDisplayList();
         }
      }
      
      public function get relativeProportions() : Boolean
      {
         return this._relativeProportions;
      }
      
      public function set relativeProportions(param1:Boolean) : void
      {
         this._relativeProportions = param1;
      }
      
      public function get disableElements() : Boolean
      {
         return this._disableElements;
      }
      
      public function set disableElements(param1:Boolean) : void
      {
         this._disableElements = param1;
      }
      
      public function get layered() : Boolean
      {
         return this._layered;
      }
      
      public function set layered(param1:Boolean) : void
      {
         this._layered = param1;
      }
      
      public function get asBitmap() : Bitmap
      {
         return this._rendered;
      }
      
      public function get flipped() : Boolean
      {
         return this._flipped;
      }
      
      public function set flipped(param1:Boolean) : void
      {
         if(this._flipped != param1)
         {
            if(this.flipped)
            {
               this.undoFlip();
            }
            this._flipped = param1;
            if(this.flipped)
            {
               this.doFlip();
            }
         }
      }
      
      public function get bodyCenter() : Point
      {
         var _loc2_:BitmapComponent = null;
         var _loc1_:Point = new Point();
         if(this.layers.hasOwnProperty("body"))
         {
            _loc2_ = this.layers.body as BitmapComponent;
            _loc1_.x = _loc2_.bitmap.x + _loc2_.bitmap.width / 2;
            _loc1_.y = _loc2_.bitmap.y + _loc2_.bitmap.height / 2;
            _loc1_ = _loc2_.localToGlobal(_loc1_);
         }
         else
         {
            _loc1_.x = width / 2;
            _loc1_.y = height / 2;
            _loc1_ = localToGlobal(_loc1_);
         }
         return _loc1_;
      }
      
      public function get fgCvs() : Canvas
      {
         return this._fgCvs;
      }
      
      public function get layers() : Object
      {
         return this._layers;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sleepBubble = new BitmapComponent();
         this._sleepBubble.x = width / 2;
         this._sleepBubble.y = height / 3;
         this._sleepBubble.width = width / 4;
         this._sleepBubble.height = height / 4;
         this._sleepBubble.centered = true;
         this._sleepBubble.source = SleepBubblePng;
         this._sleepBubble.filters = UIGlobals.fontOutline;
         this._sleepBubble.visible = false;
         this._sleepBubbleAnim = this._sleepBubble.controller.addAnimation(_scaleAnim);
         addChild(this._sleepBubble);
         this._bgCvs = new Canvas();
         this._bgCvs.percentWidth = 1;
         this._bgCvs.percentHeight = 1;
         addChild(this._bgCvs);
         this._fgCvs = new Canvas();
         this._fgCvs.percentWidth = 1;
         this._fgCvs.percentHeight = 1;
         addChild(this._fgCvs);
         this.onCreatureChange(null);
      }
      
      override public function removeAllChildren() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Number = 0;
         this._fgCvs.removeAllChildren();
         this._bgCvs.removeAllChildren();
         while(numChildren - _loc1_ > 0)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ == border || _loc2_ == softBorder || _loc2_ == this._sleepBubble || _loc2_ == this._fgCvs || _loc2_ == this._bgCvs)
            {
               _loc1_++;
            }
            else
            {
               removeChildAt(_loc1_);
            }
         }
      }
      
      private function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      private function get sleeping() : Boolean
      {
         return this._sleeping;
      }
      
      private function set sleeping(param1:Boolean) : void
      {
         if(this._sleeping != param1)
         {
            this._sleeping = param1;
            this.update();
         }
      }
      
      private function undoFlip() : void
      {
         var _loc1_:Component = null;
         var _loc2_:Matrix = null;
         for each(_loc1_ in this._layers)
         {
            if(_loc1_ is BitmapComponent)
            {
               _loc2_ = _loc1_.transform.matrix;
               _loc2_.scale(-1,1);
               _loc2_.translate(0,0);
               _loc1_.transform.matrix = _loc2_;
            }
         }
      }
      
      private function doFlip() : void
      {
         var _loc1_:Component = null;
         var _loc2_:Matrix = null;
         for each(_loc1_ in this._layers)
         {
            if(_loc1_ is BitmapComponent)
            {
               _loc2_ = _loc1_.transform.matrix;
               _loc2_.scale(-1,1);
               _loc2_.translate(width,0);
               _loc1_.transform.matrix = _loc2_;
            }
         }
      }
      
      private function onCreatureChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:SWFLoader = null;
         var _loc3_:BitmapComponent = null;
         if(childrenCreated || childrenCreating)
         {
            if(this.creature && this.creature.copying && !(Boolean(param1) && param1.property == "copying" && param1.newValue == false))
            {
               return;
            }
            if(Boolean(param1) && param1.property == "stamina")
            {
               this.sleeping = Boolean(this.creature.stamina) && this.creature.stamina.index == 0;
            }
            else if(param1 == null || param1.property == "copying" || param1.property == "id" || param1.property == "horns" || param1.property == "mouth" || param1.property == "wings" || param1.property == "tail" || param1.property == "dorsal" || param1.property == "claws" || param1.property == "hue")
            {
               this.removeAllChildren();
               this._layers = {};
               if(this.creature == null || this.creature.id == 0 && this.creature.creature_id == 0)
               {
                  return;
               }
               if(this.creature.isEgg)
               {
                  _loc3_ = new BitmapComponent();
                  switch(this.creature.creature.category.type)
                  {
                     case Category.CATEGORY_COMMON:
                        _loc3_.source = Egg1Png;
                        break;
                     case Category.CATEGORY_UNCOMMON:
                        _loc3_.source = Egg2Png;
                        break;
                     case Category.CATEGORY_RARE:
                        _loc3_.source = Egg3Png;
                        break;
                     case Category.CATEGORY_LEGEND:
                        _loc3_.source = Egg4Png;
                        break;
                     case Category.CATEGORY_MYSTIC:
                        _loc3_.source = Egg5Png;
                  }
                  if(this.relativeProportions)
                  {
                     _loc3_.x = 0;
                     _loc3_.y = 0;
                     _loc3_.width = width;
                     _loc3_.height = height;
                  }
                  else
                  {
                     _loc3_.x = -(SCALE_FACTOR * width - width) / 2;
                     _loc3_.y = -(SCALE_FACTOR * height - height) / 2;
                     _loc3_.width = SCALE_FACTOR * width;
                     _loc3_.height = SCALE_FACTOR * height;
                  }
                  _loc3_.colorMatrix.hue = this.creature.hue;
                  this._rendered = _loc3_.bitmap;
                  this._layers = {"rendered":_loc3_};
                  addChild(_loc3_);
                  dispatchEvent(new Event(Event.COMPLETE));
                  this.sleeping = false;
                  return;
               }
               if(this.creature.creature_id == 0 || this.creature.creature.id == 0)
               {
                  return;
               }
               this.sleeping = Boolean(this.creature.stamina) && this.creature.stamina.index == 0;
               if(!this.client.creatureCache.hasOwnProperty(this.creature.swf_url))
               {
                  _loc2_ = new SWFLoader();
                  this.client.creatureCache[this.creature.swf_url] = _loc2_;
                  _loc2_.source = UIGlobals.getAssetPath(this.creature.swf_url);
                  _loc2_.addEventListener(Event.COMPLETE,this.onCreatureLoaded);
                  return;
               }
               _loc2_ = this.client.creatureCache[this.creature.swf_url] as SWFLoader;
               if(!_loc2_.loaded)
               {
                  if(!this._listeningForLoadComplete)
                  {
                     this._listeningForLoadComplete = true;
                     _loc2_.addEventListener(Event.COMPLETE,this.onCreatureLoaded);
                  }
               }
               else
               {
                  this.onCreatureLoaded();
               }
            }
         }
      }
      
      private function onResized(param1:Event) : void
      {
         var _loc2_:BitmapComponent = null;
         if(childrenCreated || childrenCreating)
         {
            if(!this.layered)
            {
               if(this.flipped)
               {
                  this.undoFlip();
               }
               if(this._layers.hasOwnProperty("rendered"))
               {
                  this._layers["rendered"].width = width;
                  this._layers["rendered"].height = height;
               }
               if(this.flipped)
               {
                  this.doFlip();
               }
            }
            else
            {
               for each(_loc2_ in this._layers)
               {
                  _loc2_.x = -(width * SCALE_FACTOR - width) / 2;
                  _loc2_.y = -(height * SCALE_FACTOR - height) / 2;
                  _loc2_.width = width * SCALE_FACTOR;
                  _loc2_.height = height * SCALE_FACTOR;
               }
            }
            this._sleepBubble.x = width / 2;
            this._sleepBubble.y = height / 3;
            this._sleepBubble.width = width / 4;
            this._sleepBubble.height = height / 4;
         }
      }
      
      private function update() : void
      {
         if(childrenCreated || childrenCreating)
         {
            if(this.sleeping)
            {
               if(this._layers.hasOwnProperty("sleep"))
               {
                  this._layers.sleep.visible = true;
               }
               removeChild(this._sleepBubble);
               addChild(this._sleepBubble);
               this._sleepBubble.visible = true;
               this._sleepBubbleAnim.gotoStartAndPlay();
            }
            else
            {
               if(this._layers.hasOwnProperty("sleep"))
               {
                  this._layers.sleep.visible = false;
               }
               this._sleepBubble.visible = false;
               this._sleepBubbleAnim.stop();
            }
         }
      }
      
      private function onCreatureLoaded(param1:Event = null) : void
      {
         var _loc4_:Bitmap = null;
         var _loc5_:Bitmap = null;
         var _loc6_:BitmapComponent = null;
         var _loc7_:uint = 0;
         var _loc9_:Element = null;
         var _loc10_:Color = null;
         var _loc11_:* = false;
         var _loc12_:Boolean = false;
         var _loc13_:ColorMatrix = null;
         var _loc15_:Matrix = null;
         var _loc16_:GlowProxy = null;
         var _loc17_:ColorTransformProxy = null;
         var _loc18_:Boolean = false;
         if(!this.creature)
         {
            (param1.target as SWFLoader).removeEventListener(Event.COMPLETE,this.onCreatureLoaded);
            return;
         }
         var _loc2_:SWFLoader = this.client.creatureCache[this.creature.swf_url] as SWFLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.onCreatureLoaded);
         this._listeningForLoadComplete = false;
         var _loc3_:DisplayObjectContainer = _loc2_.content as DisplayObjectContainer;
         var _loc8_:Array = _loc3_["layers_info"];
         this._rendered = new Bitmap(new BitmapData(width * SCALE_FACTOR,height * SCALE_FACTOR,true,0));
         this._rendered.pixelSnapping = PixelSnapping.ALWAYS;
         this._rendered.smoothing = true;
         var _loc14_:BitmapComponent;
         (_loc14_ = new BitmapComponent()).bitmap = this._rendered;
         if(this.relativeProportions)
         {
            _loc14_.width = width * (_loc2_.contentWidth / MAX_CREATURE_SIZE);
            _loc14_.height = height * (_loc2_.contentHeight / MAX_CREATURE_SIZE);
            _loc14_.x = (width - _loc14_.width) / 2;
            _loc14_.y = height - _loc14_.height;
         }
         else
         {
            _loc14_.x = 0;
            _loc14_.y = 0;
            _loc14_.width = width * SCALE_FACTOR;
            _loc14_.height = height * SCALE_FACTOR;
         }
         this._layers = {"rendered":_loc14_};
         if(!this.layered)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc8_.length)
            {
               _loc12_ = false;
               _loc11_ = true;
               if(Boolean(_loc8_[_loc7_].name.match(/^tail_normal.*/)) && !this.creature.tail_id)
               {
                  _loc12_ = true;
               }
               else if(Boolean(_loc8_[_loc7_].name.match(/^mouth_normal.*/)) && !this.creature.mouth_id)
               {
                  _loc12_ = true;
               }
               else if(Boolean(_loc8_[_loc7_].name.match(/^claw_normal.*/)) && !this.creature.claws_id)
               {
                  _loc12_ = true;
               }
               else if(Boolean(_loc8_[_loc7_].name.match(/^dorsal_normal.*/)) && !this.creature.dorsal_id)
               {
                  _loc12_ = true;
               }
               else if(Boolean(_loc8_[_loc7_].name.match(/^horn_normal.*/)) && !this.creature.horns_id)
               {
                  _loc12_ = true;
               }
               else if(Boolean(_loc8_[_loc7_].name.match(/^wing_normal.*/)) && !this.creature.wings_id)
               {
                  _loc12_ = true;
               }
               else if(_loc8_[_loc7_].name == "body" || _loc8_[_loc7_].name == "shadow" || this.creature.getAccessory(_loc8_[_loc7_].name) != null)
               {
                  _loc11_ = _loc8_[_loc7_].name != "shadow";
                  _loc12_ = true;
               }
               if(_loc12_)
               {
                  (_loc4_ = new _loc8_[_loc7_].bmp() as Bitmap).pixelSnapping = PixelSnapping.ALWAYS;
                  _loc4_.smoothing = true;
                  _loc4_.name = _loc8_[_loc7_].name;
                  _loc4_.x = _loc8_[_loc7_].x;
                  _loc4_.y = _loc8_[_loc7_].y;
                  if(_loc11_)
                  {
                     (_loc13_ = new ColorMatrix()).hue = this.creature.hue;
                     _loc4_.bitmapData.applyFilter(_loc4_.bitmapData,_loc4_.bitmapData.rect,new Point(0,0),_loc13_.filter);
                  }
                  if((Boolean(_loc9_ = this.creature.getAccessoryElement(_loc4_.name))) && !this.disableElements)
                  {
                     _loc10_ = _loc9_.color;
                     (_loc16_ = new GlowProxy()).color = _loc10_.hex;
                     _loc16_.alpha = 0.85;
                     _loc16_.strength = 2;
                     _loc16_.blurX = 10 * (_loc4_.width / 512);
                     _loc16_.blurY = 20 * (_loc4_.width / 512);
                     _loc4_.bitmapData.applyFilter(_loc4_.bitmapData,_loc4_.bitmapData.rect,new Point(0,0),_loc16_.filter);
                     (_loc17_ = new ColorTransformProxy()).redMultiplier = _loc10_.r;
                     _loc17_.greenMultiplier = _loc10_.g;
                     _loc17_.blueMultiplier = _loc10_.b;
                     _loc17_.redOffset = _loc10_.r * 50;
                     _loc17_.greenOffset = _loc10_.g * 50;
                     _loc17_.blueOffset = _loc10_.b * 50;
                     _loc4_.bitmapData.colorTransform(_loc4_.bitmapData.rect,_loc17_.transform);
                  }
                  (_loc15_ = new Matrix()).scale(width / _loc2_.contentWidth,height / _loc2_.contentHeight);
                  _loc15_.translate(_loc4_.x * width / _loc2_.contentWidth,_loc4_.y * height / _loc2_.contentHeight);
                  this._rendered.bitmapData.draw(_loc4_,_loc15_,null,null,null,false);
               }
               _loc7_++;
            }
            addChild(_loc14_);
         }
         else
         {
            _loc7_ = 0;
            for(; _loc7_ < _loc8_.length; _loc7_++)
            {
               _loc12_ = true;
               _loc11_ = true;
               _loc18_ = true;
               if(_loc8_[_loc7_].name == "body")
               {
                  _loc11_ = true;
               }
               else if(_loc8_[_loc7_].name == "sleep")
               {
                  _loc11_ = true;
                  _loc12_ = false;
               }
               else
               {
                  if(_loc8_[_loc7_].name == "lines")
                  {
                     continue;
                  }
                  if(_loc8_[_loc7_].name == "shadow")
                  {
                     _loc11_ = false;
                     _loc18_ = false;
                  }
                  else if(this.creature.getAccessory(_loc8_[_loc7_].name) == null)
                  {
                     if(Boolean(_loc8_[_loc7_].name.match(/^tail_normal.*/)) && !this.creature.tail_id)
                     {
                        _loc11_ = true;
                     }
                     else if(Boolean(_loc8_[_loc7_].name.match(/^mouth_normal.*/)) && !this.creature.mouth_id)
                     {
                        _loc11_ = true;
                     }
                     else if(Boolean(_loc8_[_loc7_].name.match(/^claw_normal.*/)) && !this.creature.claws_id)
                     {
                        _loc11_ = true;
                     }
                     else if(Boolean(_loc8_[_loc7_].name.match(/^dorsal_normal.*/)) && !this.creature.dorsal_id)
                     {
                        _loc11_ = true;
                     }
                     else if(Boolean(_loc8_[_loc7_].name.match(/^horn_normal.*/)) && !this.creature.horns_id)
                     {
                        _loc11_ = true;
                     }
                     else
                     {
                        if(!(Boolean(_loc8_[_loc7_].name.match(/^wing_normal.*/)) && !this.creature.wings_id))
                        {
                           continue;
                        }
                        _loc11_ = true;
                     }
                  }
               }
               (_loc4_ = new _loc8_[_loc7_].bmp() as Bitmap).pixelSnapping = PixelSnapping.ALWAYS;
               _loc4_.smoothing = true;
               _loc4_.name = _loc8_[_loc7_].name;
               _loc4_.x = _loc8_[_loc7_].x;
               _loc4_.y = _loc8_[_loc7_].y;
               (_loc6_ = new BitmapComponent()).name = _loc4_.name;
               _loc6_.visible = _loc12_;
               if(this.relativeProportions)
               {
                  _loc6_.width = width * (_loc2_.contentWidth / MAX_CREATURE_SIZE);
                  _loc6_.height = height * (_loc2_.contentHeight / MAX_CREATURE_SIZE);
                  _loc6_.x = (width - _loc6_.width) / 2;
                  _loc6_.y = height - _loc6_.height;
               }
               else
               {
                  _loc6_.x = -(SCALE_FACTOR * width - width) / 2;
                  _loc6_.y = -(SCALE_FACTOR * height - height) / 2;
                  _loc6_.width = SCALE_FACTOR * width;
                  _loc6_.height = SCALE_FACTOR * height;
               }
               _loc6_.bitmapRect = new Rectangle(_loc4_.x / _loc2_.contentWidth,_loc4_.y / _loc2_.contentHeight,_loc4_.width / _loc2_.contentWidth,_loc4_.height / _loc2_.contentHeight);
               _loc6_.bitmap = _loc4_;
               if((Boolean(_loc9_ = this.creature.getAccessoryElement(_loc4_.name))) && !this.disableElements)
               {
                  _loc10_ = _loc9_.color;
                  _loc6_.glowProxy.color = _loc10_.hex;
                  _loc6_.glowProxy.alpha = 0.65;
                  _loc6_.glowProxy.strength = 2;
                  _loc6_.glowProxy.blurX = 20 * (_loc6_.width / 512);
                  _loc6_.glowProxy.blurY = 40 * (_loc6_.width / 512);
                  _loc6_.colorTransformProxy.redMultiplier = 1;
                  _loc6_.colorTransformProxy.greenMultiplier = 1;
                  _loc6_.colorTransformProxy.blueMultiplier = 1;
                  _loc6_.colorTransformProxy.redOffset = _loc10_.r * 50;
                  _loc6_.colorTransformProxy.greenOffset = _loc10_.g * 50;
                  _loc6_.colorTransformProxy.blueOffset = _loc10_.b * 50;
               }
               if(_loc11_)
               {
                  (_loc13_ = new ColorMatrix()).hue = this.creature.hue;
                  _loc6_.bitmap.filters = [_loc13_.filter];
               }
               if(_loc12_)
               {
                  this._rendered.bitmapData.draw(_loc6_,null,null,null,null,false);
               }
               if(_loc18_)
               {
                  this._fgCvs.addChild(_loc6_);
               }
               else
               {
                  this._bgCvs.addChild(_loc6_);
               }
               this._layers[_loc4_.name] = _loc6_;
            }
         }
         if(this.flipped)
         {
            this.doFlip();
         }
         this.update();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
