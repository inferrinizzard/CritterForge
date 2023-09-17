package com.edgebee.breedr.ui.item
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Controller;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.skins.DefaultTooltipSkin;
   import com.edgebee.atlas.ui.skins.PersistentTooltipSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.item.ItemInstance;
   import com.edgebee.breedr.ui.creature.CreatureView;
   import com.edgebee.breedr.ui.skill.PieceView;
   import com.edgebee.breedr.ui.world.areas.ranch.RanchView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ItemView extends Canvas
   {
       
      
      private var _tooltipEnabled:Boolean = true;
      
      private var _canModifyNote:Boolean = true;
      
      private var _item:WeakReference;
      
      private var _static_item:WeakReference;
      
      private var _pulseAnimation:Animation;
      
      private var _anim:AnimationInstance;
      
      public var image:SWFLoader;
      
      public var icon:BitmapComponent;
      
      private var _toolTipBox:Box;
      
      public var tooltipDescriptionLbl:Label;
      
      public var tooltipSnapshot:CreatureView;
      
      public var tooltipNoteLbl:Label;
      
      public var tooltipNoteTxt:TextInput;
      
      public var tooltipModifyNoteBtn:Button;
      
      public var star1Bmp:BitmapComponent;
      
      public var star2Bmp:BitmapComponent;
      
      public var star3Bmp:BitmapComponent;
      
      public var star4Bmp:BitmapComponent;
      
      public var chargesBox:Box;
      
      public var chargesLbl:Label;
      
      public var iconSwf:SWFLoader;
      
      private var _layout:Array;
      
      private var _seedTooltipLayout:Array;
      
      public function ItemView()
      {
         var _loc1_:Track = null;
         this._item = new WeakReference(null,ItemInstance);
         this._static_item = new WeakReference(null,Item);
         this._layout = [{
            "CLASS":SWFLoader,
            "ID":"image",
            "percentWidth":1,
            "percentHeight":1
         },{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":0.95,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_BOTTOM,
            "filters":UIGlobals.fontSmallOutline,
            "layoutInvisibleChildren":false,
            "STYLES":{"Gap":1},
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"star1Bmp",
               "isSquare":true,
               "percentWidth":0.2,
               "source":PieceView.StarIconPng,
               "visible":false
            },{
               "CLASS":BitmapComponent,
               "ID":"star2Bmp",
               "isSquare":true,
               "percentWidth":0.2,
               "source":PieceView.StarIconPng,
               "visible":false
            },{
               "CLASS":BitmapComponent,
               "ID":"star3Bmp",
               "isSquare":true,
               "percentWidth":0.2,
               "source":PieceView.StarIconPng,
               "visible":false
            },{
               "CLASS":BitmapComponent,
               "ID":"star4Bmp",
               "isSquare":true,
               "percentWidth":0.2,
               "source":PieceView.StarIconPng,
               "visible":false
            }]
         },{
            "CLASS":Box,
            "ID":"chargesBox",
            "percentWidth":1,
            "percentHeight":1,
            "layoutInvisibleChildren":false,
            "horizontalAlign":Box.ALIGN_RIGHT,
            "verticalAlign":Box.ALIGN_TOP,
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"icon",
               "width":UIGlobals.relativize(16),
               "percentWidth":0.2,
               "isSquare":true,
               "visible":false
            },{
               "CLASS":SWFLoader,
               "ID":"iconSwf",
               "percentWidth":0.35,
               "percentHeight":0.35,
               "visible":false
            },{
               "CLASS":Label,
               "ID":"chargesLbl",
               "visible":false,
               "filters":UIGlobals.fontSmallOutline,
               "STYLES":{
                  "FontSize":UIGlobals.relativize(12),
                  "FontColor":16777215,
                  "FontWeight":"bold"
               }
            }]
         }];
         this._seedTooltipLayout = [{
            "CLASS":Label,
            "ID":"tooltipDescriptionLbl",
            "useHtml":true
         },{
            "CLASS":CreatureView,
            "ID":"tooltipSnapshot",
            "layered":false,
            "width":UIGlobals.relativize(192),
            "height":UIGlobals.relativize(192)
         },{
            "CLASS":Label,
            "ID":"tooltipNoteLbl",
            "percentWidth":1,
            "wordWrap":true
         },{
            "CLASS":TextInput,
            "ID":"tooltipNoteTxt",
            "percentWidth":1,
            "maxChars":64,
            "visible":false
         },{
            "CLASS":Button,
            "ID":"tooltipModifyNoteBtn",
            "label":Asset.getInstanceByName("SEED_ITEM_NOTE_MODIFY"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onTooltipModifyNote"
            }]
         }];
         super();
         if(!this._pulseAnimation)
         {
            this._pulseAnimation = new Animation();
            _loc1_ = new Track("gradientGlowProxy.blur");
            _loc1_.addKeyframe(new Keyframe(0,8));
            _loc1_.addKeyframe(new Keyframe(1,10));
            _loc1_.addKeyframe(new Keyframe(2,8));
            this._pulseAnimation.addTrack(_loc1_);
            this._pulseAnimation.loop = true;
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
      }
      
      public function get tooltipEnabled() : Boolean
      {
         return this._tooltipEnabled;
      }
      
      public function set tooltipEnabled(param1:Boolean) : void
      {
         if(this._tooltipEnabled != param1)
         {
            this._tooltipEnabled = param1;
            this.update();
         }
      }
      
      public function get canModifyNote() : Boolean
      {
         return this._canModifyNote;
      }
      
      public function set canModifyNote(param1:Boolean) : void
      {
         if(this._canModifyNote != param1)
         {
            this._canModifyNote = param1;
            this.update();
         }
      }
      
      public function get item() : ItemInstance
      {
         return this._item.get() as ItemInstance;
      }
      
      public function set item(param1:ItemInstance) : void
      {
         if(this.item != param1)
         {
            if(this.item)
            {
               this.item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChange);
            }
            this._item.reset(param1);
            if(this.item)
            {
               this.item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChange);
            }
            this.update();
         }
      }
      
      public function get static_item() : Item
      {
         return this._static_item.get() as Item;
      }
      
      public function set static_item(param1:Item) : void
      {
         if(this.static_item != param1)
         {
            this._static_item.reset(param1);
            this.update();
         }
      }
      
      public function dispose(param1:* = null) : void
      {
         if(this._anim)
         {
            this._anim.stop();
            this._anim = null;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.update();
      }
      
      private function onItemChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:Item = null;
         if(childrenCreated || childrenCreating)
         {
            this.image.source = null;
            this.icon.source = null;
            this.icon.visible = false;
            this.image.colorMatrix.reset();
            this.image.gradientGlowProxy.reset();
            if(this._anim)
            {
               this._anim.stop();
               this._anim = null;
            }
            _loc1_ = !!this.item ? this.item.item : this.static_item;
            this.chargesLbl.text = "";
            if(_loc1_)
            {
               if(this.item)
               {
                  this.image.source = UIGlobals.getAssetPath(this.item.image_url);
                  if(this.item.item.type == Item.TYPE_BREED && this.item.creature.id > 0)
                  {
                     this.icon.visible = true;
                     this.icon.source = this.item.creature.is_male ? RanchView.MaleIconPng : RanchView.FemaleIconPng;
                     setStyle("TooltipSkin",PersistentTooltipSkin);
                     if(this.tooltipEnabled)
                     {
                        if(!this._toolTipBox)
                        {
                           this._toolTipBox = new Box(Box.VERTICAL);
                           this._toolTipBox.spreadProportionalityX = false;
                           this._toolTipBox.layoutInvisibleChildren = false;
                           UIUtils.performLayout(this,this._toolTipBox,this._seedTooltipLayout);
                        }
                        this.tooltipDescriptionLbl.text = toolTip = Utils.htmlWrap(Utils.capitalizeFirst(_loc1_.name.value),null,16777215,0,true);
                        this.tooltipSnapshot.creature = this.item.creature;
                        this.tooltipNoteLbl.text = this.item.note;
                        this.tooltipNoteLbl.visible = this.canModifyNote;
                        this.tooltipModifyNoteBtn.visible = this.canModifyNote;
                        toolTip = this._toolTipBox;
                     }
                     else
                     {
                        toolTip = "";
                     }
                  }
                  else
                  {
                     setStyle("TooltipSkin",DefaultTooltipSkin);
                     if(this.tooltipEnabled)
                     {
                        toolTip = _loc1_.description;
                     }
                     else
                     {
                        toolTip = "";
                     }
                  }
                  this.chargesLbl.text = this.item.charges.toString() + "/" + _loc1_.maxCharges.toString();
               }
               else
               {
                  this.image.source = UIGlobals.getAssetPath(_loc1_.image_url);
                  if(this.tooltipEnabled)
                  {
                     toolTip = _loc1_.description;
                  }
                  else
                  {
                     toolTip = "";
                  }
                  this.chargesLbl.text = _loc1_.maxCharges.toString() + "/" + _loc1_.maxCharges.toString();
               }
               if(_loc1_.hue != 0)
               {
                  this.image.colorMatrix.hue = _loc1_.hue;
               }
               if(_loc1_.saturation != 0)
               {
                  this.image.colorMatrix.saturation = _loc1_.saturation;
               }
               if(_loc1_.glow != 0)
               {
                  this.image.gradientGlowProxy.distance = 0;
                  this.image.gradientGlowProxy.colors = [_loc1_.glow,UIUtils.adjustBrightness2(_loc1_.glow,85),_loc1_.glow,_loc1_.glow];
                  this.image.gradientGlowProxy.alphas = [0,0.5];
                  this.image.gradientGlowProxy.ratios = [0,128];
                  this.image.controller.updateType = Controller.UPDATE_ON_50MS;
                  this._anim = this.image.controller.addAnimation(this._pulseAnimation);
                  this._anim.play();
               }
               if(_loc1_.trait_id)
               {
                  this.iconSwf.visible = true;
                  this.iconSwf.source = UIGlobals.getAssetPath(_loc1_.trait.image_url);
               }
               else
               {
                  this.iconSwf.visible = false;
               }
               this.star1Bmp.visible = _loc1_.quality > Item.QUALITY_POOR;
               this.star2Bmp.visible = _loc1_.quality > Item.QUALITY_NORMAL;
               this.star3Bmp.visible = _loc1_.quality > Item.QUALITY_GOOD;
               this.star4Bmp.visible = _loc1_.quality > Item.QUALITY_GREAT;
               this.chargesLbl.visible = _loc1_.maxCharges > 1;
            }
         }
      }
      
      public function onTooltipModifyNote(param1:MouseEvent) : void
      {
         var _loc2_:Client = null;
         var _loc3_:Object = null;
         if(this.tooltipNoteLbl.visible)
         {
            this.tooltipNoteTxt.text = this.tooltipNoteLbl.text;
            this.tooltipNoteLbl.visible = false;
            this.tooltipNoteTxt.visible = true;
            this.tooltipModifyNoteBtn.label = Asset.getInstanceByName("SAVE");
         }
         else
         {
            this.tooltipNoteLbl.text = this.tooltipNoteTxt.text;
            this.tooltipNoteTxt.visible = false;
            this.tooltipNoteLbl.visible = true;
            this.tooltipModifyNoteBtn.label = Asset.getInstanceByName("SEED_ITEM_NOTE_MODIFY");
            this.item.note = this.tooltipNoteLbl.text;
            _loc2_ = (UIGlobals.root as breedr_flash).client as Client;
            _loc3_ = _loc2_.createInput();
            _loc3_.item_instance_id = this.item.id;
            _loc3_.note = this.tooltipNoteLbl.text;
            _loc2_.service.AddItemNote(_loc3_);
         }
      }
   }
}
