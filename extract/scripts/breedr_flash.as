package
{
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Application;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.skins.MenuItemSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.ui.RootView;
   import com.edgebee.breedr.ui.skins.*;
   import flash.display.GradientType;
   import flash.display.Loader;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class breedr_flash extends Application
   {
      
      public static var StaticDataTxt:Class = breedr_flash_StaticDataTxt;
      
      public static var ButtonWav:Class = breedr_flash_ButtonWav;
      
      public static var CheckWav:Class = breedr_flash_CheckWav;
      
      public static var DialogHighWav:Class = breedr_flash_DialogHighWav;
      
      public static var DialogLowWav:Class = breedr_flash_DialogLowWav;
      
      public static var LinkWav:Class = breedr_flash_LinkWav;
      
      public static var OpenWindowWav:Class = breedr_flash_OpenWindowWav;
      
      public static var CloseWindowWav:Class = breedr_flash_CloseWindowWav;
       
      
      public var rootView:RootView;
      
      public var drawBackground:Boolean = false;
      
      public var creatureCache:Object;
      
      public var npcCache:SWFLoader;
      
      public function breedr_flash(param1:Object = null)
      {
         this.creatureCache = {};
         super("breedr",StageQuality.MEDIUM);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         this.preloadedAssets = param1;
      }
      
      override public function get buildVersion() : String
      {
         return "7790";
      }
      
      override public function get buildMode() : String
      {
         return "production";
      }
      
      override protected function positionDebugInfo() : void
      {
         if(debugInfo)
         {
            debugInfo.x = 10;
            debugInfo.y = 40;
         }
      }
      
      override protected function positionNetworkStatus() : void
      {
         if(networkStatus)
         {
            networkStatus.x = 10;
            networkStatus.y = 40;
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Object = {
            "FontFamily":"Trebuchet MS,Lucida Sans,Arial",
            "FontColor":16777215,
            "LinkFontColor":16776960,
            "FontSize":UIGlobals.relativizeFont(16),
            "ThemeColor":4701439,
            "ThemeColor2":16765530,
            "UIHighlightColor":16711680,
            "HPColor":16733782,
            "PPColor":5474559,
            "XPColor":6160221,
            "DamageColor":16711680,
            "BlockColor":65280,
            "PPDamageColor":16711935,
            "SkillPointColor":16733525,
            "HugeFontSize":UIGlobals.relativizeFont(24),
            "LargeFontSize":UIGlobals.relativizeFont(20),
            "SmallFontSize":UIGlobals.relativizeFont(14),
            "TinyFontSize":UIGlobals.relativizeFont(12),
            "MiniFontSize":UIGlobals.relativizeFont(11),
            "LogNameColor":14548957,
            "Button":{
               "FontColor":0,
               "CornerRadius":UIGlobals.relativize(17),
               "Skin":BreedrButtonSkin,
               "ClickSound":breedr_flash.ButtonWav
            },
            "LinkButtonSkin":{
               "FontColor":16777215,
               "ClickSound":breedr_flash.ButtonWav
            },
            "RadioButtonSkin":{"ClickSound":breedr_flash.CheckWav},
            "CheckBoxSkin":{"ClickSound":breedr_flash.CheckWav},
            "ToggleButton":{
               "FontColor":0,
               "CornerRadius":UIGlobals.relativize(17),
               "Skin":BreedrButtonSkin,
               "ClickSound":breedr_flash.CheckWav,
               "ShowBorder":false,
               "Padding":UIGlobals.relativize(6)
            },
            "TextInput":{
               "FontColor":16777215,
               "CornerRadius":5,
               "Skin":BreedrTextInputSkin
            },
            "Menu":{
               "BackgroundColor":[UIUtils.adjustBrightness2(4241919,15),UIUtils.adjustBrightness2(4241919,-50),UIUtils.adjustBrightness2(4241919,-50),UIUtils.adjustBrightness2(4241919,15)],
               "BackgroundAlpha":[0.9,0.9,0.9,0.9],
               "BackgroundRatio":[0,50,205,255],
               "BackgroundDirection":Math.PI / 2,
               "CornerRadius":3,
               "BorderThickness":1,
               "BorderColor":UIUtils.adjustBrightness2(4241919,75)
            },
            "MenuItem":{
               "PaddingTop":1,
               "PaddingBottom":1,
               "PaddingLeft":4,
               "PaddingRight":1,
               "FontSize":UIGlobals.relativize(16),
               "BackgroundColor":UIUtils.adjustBrightness2(4241919,-35),
               "BackgroundAlpha":0.85,
               "Skin":MenuItemSkin,
               "ClickSound":breedr_flash.CheckWav
            },
            "Tooltip":{
               "FontSize":UIGlobals.relativize(17),
               "FontColor":16777215,
               "BackgroundColor":UIUtils.adjustBrightness2(4241919,-50),
               "BackgroundAlpha":0.85,
               "BorderColor":[UIUtils.adjustBrightness2(4241919,35),UIUtils.adjustBrightness2(4241919,-35)],
               "BorderThickness":2,
               "BorderAlpha":[1,1],
               "BorderRatios":[0,255],
               "BorderDirection":Math.PI / 2,
               "ShadowBorderEnabled":true,
               "ShadowBorderAlpha":0.25,
               "ShadowBorderRatios":[150,255]
            },
            "ProgressBar":{
               "CornerRadius":3,
               "BarOffset":2,
               "Skin":BreedrProgressBarSkin
            },
            "Scrollbar":{
               "TrackSkin":BreedrScrollBarTrackSkin,
               "ThumbSkin":BreedrScrollBarThumbSkin,
               "UpButtonSkin":BreedrTopArrowButtonSkin,
               "DownButtonSkin":BreedrBottomArrowButtonSkin
            },
            "Window":{
               "FontColor":16777215,
               "Skin":BreedrWindowSkin,
               "BackgroundAlpha":0,
               "CloseSound":breedr_flash.CloseWindowWav,
               "WindowTitle":{
                  "FontSize":UIGlobals.relativizeFont(18),
                  "FontWeight":"bold",
                  "FontColor":16777215
               },
               "WindowContent":{
                  "PaddingLeft":UIGlobals.relativize(6),
                  "PaddingRight":UIGlobals.relativize(6),
                  "PaddingTop":UIGlobals.relativize(6),
                  "PaddingBottom":UIGlobals.relativize(6)
               },
               "CloseButton":{"Skin":BreedrCloseButtonSkin}
            },
            "ChatWindow":{
               "FontColor":16777215,
               "Skin":BreedrChatWindowSkin,
               "BackgroundAlpha":0,
               "CloseSound":breedr_flash.CloseWindowWav,
               "PaddingLeft":UIGlobals.relativize(12),
               "PaddingRight":UIGlobals.relativize(12),
               "PaddingTop":UIGlobals.relativize(12),
               "PaddingBottom":UIGlobals.relativize(12),
               "WindowTitle":{
                  "FontSize":UIGlobals.relativizeFont(18),
                  "FontWeight":"bold",
                  "FontColor":16777215
               },
               "CloseButton":{"Skin":BreedrCloseButtonSkin}
            }
         };
         client = new Client();
         UIGlobals.styleManager.overrideStyles(_loc1_);
         client.addEventListener(Event.INIT,this.onClientInitialized);
         startProgressIndicator();
         client.initialize();
         super.createChildren();
         setStyle("BackgroundAlpha",1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Matrix = null;
         if(this.drawBackground)
         {
            super.updateDisplayList(param1,param2);
            _loc3_ = new Matrix();
            _loc3_.createGradientBox(param1,param2,Math.PI / 2);
            graphics.beginGradientFill(GradientType.LINEAR,[UIUtils.adjustBrightness2(4241919,-90),UIUtils.adjustBrightness2(4241919,-75),UIUtils.adjustBrightness2(41215,-90)],[1,1,1],[0,128,255],_loc3_);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
      }
      
      private function onClientInitialized(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Loader = null;
         var _loc4_:String = null;
         if(preloadedAssets)
         {
            for(_loc2_ in preloadedAssets)
            {
               if(_loc2_.indexOf("breedr/npc/npcs") >= 0)
               {
                  this.npcCache = new SWFLoader(preloadedAssets[_loc2_]);
               }
               else
               {
                  _loc3_ = preloadedAssets[_loc2_];
                  _loc4_ = _loc2_.slice(_loc2_.indexOf("breedr"));
                  this.creatureCache[_loc4_] = new SWFLoader(preloadedAssets[_loc2_]);
               }
            }
         }
         this.rootView = new RootView(client as Client);
         this.rootView.width = stage.stageWidth;
         this.rootView.height = stage.stageHeight;
         addChild(this.rootView);
         stopProgressIndicator();
      }
      
      private function onTilingBgLoaded(param1:Event) : void
      {
         invalidateDisplayList();
      }
   }
}
