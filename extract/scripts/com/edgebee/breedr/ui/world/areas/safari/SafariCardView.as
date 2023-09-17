package com.edgebee.breedr.ui.world.areas.safari
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Callback;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.events.AnimationEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Canvas;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.item.Item;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.SafariCard;
   import com.edgebee.breedr.managers.handlers.ItemUseHandler;
   import com.edgebee.breedr.managers.handlers.NewEggHandler;
   import com.edgebee.breedr.ui.item.ItemView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class SafariCardView extends Canvas
   {
      
      public static const CARD_CLICKED:String = "CARD_CLICKED";
      
      public static const NormalCardPng:Class = SafariCardView_NormalCardPng;
      
      public static const BossCardPng:Class = SafariCardView_BossCardPng;
      
      public static const QuestCardPng:Class = SafariCardView_QuestCardPng;
      
      public static const CreditsCardPng:Class = SafariCardView_CreditsCardPng;
      
      public static const HappyCardPng:Class = SafariCardView_HappyCardPng;
      
      public static const HealthCardPng:Class = SafariCardView_HealthCardPng;
      
      public static const XpCardPng:Class = SafariCardView_XpCardPng;
      
      public static const StaminaCardPng:Class = SafariCardView_StaminaCardPng;
      
      public static const FlipCardPng:Class = SafariCardView_FlipCardPng;
      
      public static const TopCardPng:Class = SafariCardView_TopCardPng;
      
      public static const SIZE:Number = UIGlobals.relativize(96);
      
      private static var _flipAnim:Animation;
       
      
      private var _index:int = -1;
      
      private var _card:WeakReference;
      
      public var waitingForServer:Boolean = false;
      
      public var willReveal:Boolean = false;
      
      public var animComplete:Boolean = false;
      
      private var _flipInstance:AnimationInstance;
      
      private var _flipIndex:int = 0;
      
      public var containerCvs:Canvas;
      
      public var cardTopBmp:BitmapComponent;
      
      public var cardFlipBmp:BitmapComponent;
      
      public var contentBmp:BitmapComponent;
      
      public var contentItem:ItemView;
      
      private var _layout:Array;
      
      public function SafariCardView()
      {
         var _loc1_:Track = null;
         this._card = new WeakReference(null,SafariCard);
         this._layout = [{
            "CLASS":Canvas,
            "ID":"containerCvs",
            "width":SIZE,
            "height":SIZE,
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"cardTopBmp",
               "width":SIZE,
               "isSquare":true,
               "source":TopCardPng
            },{
               "CLASS":BitmapComponent,
               "ID":"cardFlipBmp",
               "width":SIZE,
               "isSquare":true,
               "visible":false,
               "source":FlipCardPng
            },{
               "CLASS":BitmapComponent,
               "ID":"contentBmp",
               "filters":[new DropShadowFilter()],
               "x":SIZE / 6,
               "y":SIZE / 6,
               "width":2 * SIZE / 3,
               "isSquare":true,
               "visible":false
            },{
               "CLASS":ItemView,
               "ID":"contentItem",
               "canModifyNote":false,
               "filters":[new DropShadowFilter()],
               "x":SIZE / 6,
               "y":SIZE / 6,
               "width":2 * SIZE / 3,
               "height":2 * SIZE / 3,
               "visible":false
            }]
         }];
         super();
         useMouseScreen = true;
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         if(!_flipAnim)
         {
            _flipAnim = new Animation();
            _loc1_ = new Track("x");
            _loc1_.addKeyframe(new Keyframe(0,0));
            _loc1_.addKeyframe(new Keyframe(0.5,SIZE / 2));
            _loc1_.addCallback(new Callback(0.5,null));
            _loc1_.addKeyframe(new Keyframe(1,0));
            _flipAnim.addTrack(_loc1_);
            _loc1_ = new Track("scaleX");
            _loc1_.addKeyframe(new Keyframe(0,1));
            _loc1_.addKeyframe(new Keyframe(0.5,0));
            _loc1_.addKeyframe(new Keyframe(1,1));
            _flipAnim.addTrack(_loc1_);
            _flipAnim.loop = true;
         }
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         if(this._index != param1)
         {
            this._index = param1;
            this.card = this.player.safari_cards[this.index];
         }
      }
      
      public function get card() : SafariCard
      {
         return this._card.get() as SafariCard;
      }
      
      public function set card(param1:SafariCard) : void
      {
         if(this.card != param1)
         {
            if(this.card)
            {
               this.card.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCardChange);
            }
            this._card.reset(param1);
            if(this.card)
            {
               this.card.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onCardChange);
            }
            this.update();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this._flipInstance = this.containerCvs.controller.addAnimation(_flipAnim);
         this._flipInstance.addEventListener(AnimationEvent.CALLBACK,this.onFlipCallback);
         this._flipInstance.addEventListener(AnimationEvent.LOOP,this.onFlipLoop);
         this.update();
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "SafariTrack")
         {
            if(this.waitingForServer)
            {
               if(this._flipInstance.playing)
               {
                  this._flipInstance.gotoStartAndStop();
               }
               this.waitingForServer = false;
               this.willReveal = false;
               this.animComplete = false;
               this.update();
            }
         }
      }
      
      private function onFlipCallback(param1:AnimationEvent) : void
      {
         ++this._flipIndex;
         if(this._flipIndex % 2 == 0)
         {
            this.cardTopBmp.visible = true;
            this.cardFlipBmp.visible = false;
         }
         else
         {
            this.cardTopBmp.visible = false;
            this.cardFlipBmp.visible = true;
         }
      }
      
      private function onFlipLoop(param1:AnimationEvent) : void
      {
         this._flipInstance.speed *= 0.85;
         if(this._flipIndex >= 7)
         {
            this._flipInstance.stop();
            this.update();
            this.animComplete = true;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onCardChange(param1:PropertyChangeEvent) : void
      {
         if(!this.card.copying)
         {
            if(this.waitingForServer)
            {
               this.waitingForServer = false;
            }
            this.update();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(enabled && !this.card.isRevealed && this.client.criticalComms == 0)
         {
            this.waitingForServer = true;
            this.willReveal = true;
            dispatchEvent(new ExtendedEvent(CARD_CLICKED,this.index,true));
            this.animComplete = false;
            this._flipIndex = 0;
            this._flipInstance.speed = 10;
            this._flipInstance.play();
            this.onMouseOut(null);
            UIGlobals.playSound(ItemUseHandler.ItemPlayWav);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(enabled && !this.card.isRevealed && this.client.criticalComms == 0)
         {
            colorTransformProxy.offset += 25;
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         colorTransformProxy.offset = 0;
      }
      
      private function update() : void
      {
         var _loc1_:AnimationInstance = null;
         var _loc2_:AnimationInstance = null;
         if(childrenCreated || childrenCreating)
         {
            if(Boolean(this._flipInstance) && this._flipInstance.playing)
            {
               return;
            }
            if(this.waitingForServer)
            {
               return;
            }
            if(this.card)
            {
               if(this.card.isRevealed)
               {
                  buttonMode = false;
                  useHandCursor = false;
                  this.cardTopBmp.visible = false;
                  this.cardFlipBmp.visible = true;
                  if(this.card.isItem)
                  {
                     this.contentBmp.visible = false;
                     this.contentBmp.source = null;
                     this.contentItem.visible = true;
                     this.contentItem.static_item = Item.getInstanceById(this.card.data);
                     if(this.willReveal)
                     {
                        this.willReveal = false;
                        this.contentItem.alpha = 0;
                        _loc1_ = this.contentItem.controller.animateTo({"alpha":1},null,false);
                        _loc1_.speed = 3;
                        _loc1_.gotoStartAndPlay();
                        UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                     }
                  }
                  else
                  {
                     this.contentBmp.visible = true;
                     if(this.card.flags & SafariCard.SLOT_CREATURE)
                     {
                        this.contentBmp.source = NormalCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedFailureWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_BOSS)
                     {
                        this.contentBmp.source = BossCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedFailureWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_STAMINA)
                     {
                        this.contentBmp.source = StaminaCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_HAPPINESS)
                     {
                        this.contentBmp.source = HappyCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_HEALTH)
                     {
                        this.contentBmp.source = HealthCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_CREDITS)
                     {
                        this.contentBmp.source = CreditsCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_QUEST)
                     {
                        this.contentBmp.source = QuestCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedFailureWav);
                        }
                     }
                     else if(this.card.flags & SafariCard.SLOT_XP)
                     {
                        this.contentBmp.source = XpCardPng;
                        if(this.willReveal)
                        {
                           UIGlobals.playSound(NewEggHandler.BreedSuccessWav);
                        }
                     }
                     this.contentItem.visible = false;
                     this.contentItem.static_item = null;
                     if(this.willReveal)
                     {
                        this.willReveal = false;
                        this.contentBmp.alpha = 0;
                        _loc2_ = this.contentBmp.controller.animateTo({"alpha":1},null,false);
                        _loc2_.speed = 3;
                        _loc2_.gotoStartAndPlay();
                     }
                  }
               }
               else
               {
                  buttonMode = true;
                  useHandCursor = true;
                  this.cardTopBmp.visible = true;
                  this.cardFlipBmp.visible = false;
                  this.contentBmp.visible = false;
                  this.contentBmp.source = null;
                  this.contentItem.visible = false;
                  this.contentItem.static_item = null;
               }
            }
         }
      }
   }
}
