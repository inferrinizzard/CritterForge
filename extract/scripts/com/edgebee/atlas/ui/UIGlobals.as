package com.edgebee.atlas.ui
{
   import com.edgebee.atlas.Client;
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.managers.ControlLayoutManager;
   import com.edgebee.atlas.managers.DialogBubbleManager;
   import com.edgebee.atlas.managers.DragManager;
   import com.edgebee.atlas.managers.KeyboardManager;
   import com.edgebee.atlas.managers.LocalizationManager;
   import com.edgebee.atlas.managers.PopUpManager;
   import com.edgebee.atlas.managers.StyleManager;
   import com.edgebee.atlas.managers.TooltipManager;
   import com.edgebee.atlas.ui.containers.Application;
   import com.edgebee.atlas.ui.gadgets.UIDebugWin;
   import com.edgebee.atlas.util.NamedObjectDictionary;
   import com.edgebee.atlas.util.Timer;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   
   public class UIGlobals
   {
      
      public static var layoutManager:ControlLayoutManager;
      
      public static var popUpManager:PopUpManager;
      
      public static var dragManager:DragManager;
      
      public static var styleManager:StyleManager;
      
      public static var l10nManager:LocalizationManager;
      
      public static var toolTipManager:TooltipManager;
      
      public static var dialogBubbleManager:DialogBubbleManager;
      
      public static var keyboardManager:KeyboardManager;
      
      public static var root:Application;
      
      public static var dragLayer:com.edgebee.atlas.ui.Component;
      
      public static var popUpLayer:com.edgebee.atlas.ui.Component;
      
      public static var tooltipLayer:com.edgebee.atlas.ui.Component;
      
      public static var dialogBubbleLayer:com.edgebee.atlas.ui.Component;
      
      public static var namedObjects:NamedObjectDictionary = new NamedObjectDictionary();
      
      public static var twentyfiveMsTimer:Timer = new Timer(25);
      
      public static var fiftyMsTimer:Timer = new Timer(50);
      
      public static var hundredMsTimer:Timer = new Timer(100);
      
      public static var oneSecTimer:Timer = new Timer(1000);
      
      public static var fiveSecTimer:Timer = new Timer(5000);
      
      public static var blinkAnimation:Animation = new Animation();
      
      public static var alphaFadeIn:Animation = new Animation();
      
      public static var pulseOnce:Animation = new Animation();
      
      public static var debugKeyDow:Boolean = false;
      
      public static var uiDebugWin:UIDebugWin;
       
      
      public function UIGlobals()
      {
         super();
      }
      
      public static function Init(param1:Application) : void
      {
         root = param1;
         root.stage.addEventListener(Event.RESIZE,onStageResized,false,0,true);
         InitLayoutManager();
         InitDialogBubbles();
         InitPopUpManager();
         InitDragManager();
         InitStyleManager();
         InitL10nManager();
         InitToolTipManager();
         InitGlobalAnimations();
         InitKeyboardManager();
         twentyfiveMsTimer.start();
         fiftyMsTimer.start();
         hundredMsTimer.start();
         oneSecTimer.start();
         fiveSecTimer.start();
      }
      
      public static function initDebug() : void
      {
         if(inUIDebugMode)
         {
            root.stage.addEventListener(KeyboardEvent.KEY_DOWN,onDebugKeyDown,false,1,true);
            root.stage.addEventListener(KeyboardEvent.KEY_UP,onDebugKeyUp,false,1,true);
            root.stage.addEventListener(MouseEvent.CLICK,onDebugMouseClick,false,1,true);
         }
      }
      
      public static function getAssetPath(param1:String, param2:Boolean = false, param3:String = null) : String
      {
         return root.client.GetAssetPath(param1,param2,param3);
      }
      
      public static function getStyle(param1:String, param2:Object = null) : *
      {
         return UIGlobals.styleManager.getStyle(param1,param2);
      }
      
      public static function relativize(param1:Number) : Number
      {
         return relativizeX(param1);
      }
      
      public static function relativizeFont(param1:int) : int
      {
         var _loc2_:int = int(Math.round(param1 * root.width / root.defaultWidth));
         return _loc2_ > 7 ? _loc2_ : 7;
      }
      
      public static function relativizeX(param1:Number) : Number
      {
         return param1 * root.width / root.defaultWidth;
      }
      
      public static function relativizeY(param1:Number) : Number
      {
         return param1 * root.height / root.defaultHeight;
      }
      
      public static function get inUIDebugMode() : Boolean
      {
         if(Boolean(root) && Boolean(root.client))
         {
            return root.client.mode == Client.DEVELOPER;
         }
         return false;
      }
      
      public static function playSound(param1:*) : SoundChannel
      {
         if(param1)
         {
            if(param1 is String)
            {
               return root.client.sndManager.play(getAssetPath(param1));
            }
            return root.client.sndManager.play(param1);
         }
         return null;
      }
      
      public static function get fontOutline() : Array
      {
         return [new GlowFilter(0,1,3,3,4),new DropShadowFilter(2,45,0,0.35,2,2)];
      }
      
      public static function get fontSmallOutline() : Array
      {
         return [new GlowFilter(0,1,3,3,4)];
      }
      
      private static function InitLayoutManager() : void
      {
         layoutManager = new ControlLayoutManager(root);
      }
      
      private static function InitDragManager() : void
      {
         dragLayer = new com.edgebee.atlas.ui.Component();
         dragLayer.name = "dragLayer";
         dragLayer.width = root.stage.stageWidth;
         dragLayer.height = root.stage.stageHeight;
         dragLayer.processedDescriptors = true;
         root.addLayer(dragLayer);
         dragLayer.initialize();
         dragManager = new DragManager(root,dragLayer);
      }
      
      private static function InitPopUpManager() : void
      {
         popUpLayer = new com.edgebee.atlas.ui.Component();
         popUpLayer.name = "popUpLayer";
         popUpLayer.width = root.stage.stageWidth;
         popUpLayer.height = root.stage.stageHeight;
         popUpLayer.processedDescriptors = true;
         root.addLayer(popUpLayer);
         popUpLayer.initialize();
         popUpManager = new PopUpManager(popUpLayer);
      }
      
      private static function InitStyleManager() : void
      {
         styleManager = new StyleManager();
      }
      
      private static function InitL10nManager() : void
      {
         l10nManager = new LocalizationManager();
      }
      
      private static function InitToolTipManager() : void
      {
         tooltipLayer = new com.edgebee.atlas.ui.Component();
         tooltipLayer.name = "tooltipLayer";
         tooltipLayer.width = root.stage.stageWidth;
         tooltipLayer.height = root.stage.stageHeight;
         tooltipLayer.processedDescriptors = true;
         root.addLayer(tooltipLayer);
         tooltipLayer.initialize();
         toolTipManager = new TooltipManager(tooltipLayer);
      }
      
      private static function InitKeyboardManager() : void
      {
         keyboardManager = new KeyboardManager();
         keyboardManager.initialize(root.stage);
      }
      
      private static function InitGlobalAnimations() : void
      {
         var _loc1_:Track = new Track("alpha");
         _loc1_.addKeyframe(new Keyframe(0,0));
         _loc1_.addKeyframe(new Keyframe(0.5,1));
         _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicInAndOut);
         alphaFadeIn.addTrack(_loc1_);
         blinkAnimation = new Animation();
         _loc1_ = new Track("colorTransformProxy.offset");
         _loc1_.addKeyframe(new Keyframe(0,0));
         _loc1_.addKeyframe(new Keyframe(1,100));
         _loc1_.addKeyframe(new Keyframe(2,0));
         _loc1_.addTransitionByKeyframeTime(0,Interpolation.quintIn);
         _loc1_.addTransitionByKeyframeTime(1,Interpolation.quintOut);
         blinkAnimation.addTrack(_loc1_);
         blinkAnimation.loop = true;
         pulseOnce = new Animation();
         _loc1_ = new Track("colorTransformProxy.offset");
         _loc1_.addKeyframe(new Keyframe(0,0));
         _loc1_.addKeyframe(new Keyframe(0.1,100));
         _loc1_.addKeyframe(new Keyframe(0.5,0));
         pulseOnce.addTrack(_loc1_);
      }
      
      private static function InitDialogBubbles() : void
      {
         dialogBubbleLayer = new com.edgebee.atlas.ui.Component();
         dialogBubbleLayer.name = "dialogBubbleLayer";
         dialogBubbleLayer.width = root.stage.stageWidth;
         dialogBubbleLayer.height = root.stage.stageHeight;
         dialogBubbleLayer.processedDescriptors = true;
         root.addLayer(dialogBubbleLayer);
         dialogBubbleLayer.initialize();
         dialogBubbleManager = new DialogBubbleManager(dialogBubbleLayer);
         dialogBubbleManager.anchorObject = dialogBubbleLayer;
         dialogBubbleManager.anchorPoint = new Point(dialogBubbleLayer.width / 2,5 * dialogBubbleLayer.height / 6);
         dialogBubbleManager.positionObject = dialogBubbleLayer;
         dialogBubbleManager.positionPoint = new Point(dialogBubbleLayer.width / 2,dialogBubbleLayer.height / 2);
      }
      
      private static function onStageResized(param1:Event) : void
      {
         dragLayer.width = root.stage.stageWidth;
         dragLayer.height = root.stage.stageHeight;
         tooltipLayer.width = root.stage.stageWidth;
         tooltipLayer.height = root.stage.stageHeight;
         dialogBubbleLayer.width = root.stage.stageWidth;
         dialogBubbleLayer.height = root.stage.stageHeight;
         popUpLayer.width = root.stage.stageWidth;
         popUpLayer.height = root.stage.stageHeight;
      }
      
      private static function onDebugKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.shiftKey && param1.ctrlKey)
         {
            if(!debugKeyDow)
            {
               if(!uiDebugWin)
               {
                  uiDebugWin = new UIDebugWin();
               }
               uiDebugWin.reset();
               debugKeyDow = true;
            }
         }
      }
      
      private static function onDebugKeyUp(param1:KeyboardEvent) : void
      {
         debugKeyDow = false;
      }
      
      private static function onDebugMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Array = null;
         var _loc4_:DisplayObject = null;
         if(debugKeyDow)
         {
            _loc2_ = new Point(root.stage.mouseX,root.stage.mouseY);
            _loc3_ = root.stage.getObjectsUnderPoint(_loc2_);
            for each(_loc4_ in _loc3_)
            {
               uiDebugWin.addMember({
                  "name":_loc4_.name,
                  "value":_loc4_.toString(),
                  "obj":_loc4_
               });
               popUpManager.addPopUp(UIGlobals.uiDebugWin,UIGlobals.root);
            }
         }
      }
   }
}
