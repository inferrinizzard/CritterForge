package com.edgebee.breedr.ui.achievements
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.ProgressBar;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.skins.DefaultTooltipSkin;
   import com.edgebee.atlas.ui.skins.PersistentTooltipSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.PersonalAchievement;
   import com.edgebee.breedr.data.player.PersonalAchievementInstance;
   import com.edgebee.breedr.data.player.PersonalAchievementReward;
   import com.edgebee.breedr.ui.world.areas.safari.SafariCardView;
   import flash.events.Event;
   
   public class AchievementDisplay extends Box implements Listable
   {
      
      public static var INVALID_DATA:String = "INVALID_DATA";
       
      
      private var _data:Object;
      
      private var _highlighted:Boolean = false;
      
      private var _progress:Number;
      
      private var _client:Client;
      
      public var loader:SWFLoader;
      
      public var progressBar:ProgressBar;
      
      public var achievementNameLabel:GradientLabel;
      
      private var _toolTipBox:Box;
      
      public var tooltipTextArea:TextArea;
      
      public var rewardLabel:Label;
      
      public var rewardImg:SWFLoader;
      
      private var _contentLayout:Array;
      
      private var _toolTipUI:Array;
      
      public function AchievementDisplay()
      {
         this._contentLayout = [{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "width":UIGlobals.relativize(128),
            "horizontalAlign":Box.ALIGN_CENTER,
            "spreadProportionality":false,
            "STYLES":{
               "Padding":3,
               "BackgroundColor":0,
               "BackgroundAlpha":0.25,
               "CornerRadius":5
            },
            "CHILDREN":[{
               "CLASS":SWFLoader,
               "ID":"loader",
               "width":UIGlobals.relativize(96),
               "height":UIGlobals.relativize(96)
            },{
               "CLASS":GradientLabel,
               "ID":"achievementNameLabel",
               "width":UIGlobals.relativize(124),
               "STYLES":{
                  "FontWeight":"bold",
                  "FontSize":UIGlobals.getStyle("SmallFontSize")
               }
            },{
               "CLASS":ProgressBar,
               "ID":"progressBar",
               "height":UIGlobals.relativize(14),
               "percentWidth":0.9,
               "STYLES":{
                  "ShowLabel":true,
                  "LabelType":"percentage",
                  "FontColor":16777215,
                  "FontSize":UIGlobals.styleManager.getStyle("MiniFontSize")
               }
            }]
         }];
         this._toolTipUI = [{
            "CLASS":TextArea,
            "ID":"tooltipTextArea",
            "selectable":false,
            "wordWrap":false,
            "useHtml":true,
            "STYLES":{
               "FontSize":getStyle("FontSize",12,false),
               "FontColor":getStyle("FontColor")
            }
         },{
            "CLASS":Spacer,
            "height":15
         },{
            "CLASS":Box,
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"rewardLabel",
               "text":Asset.getInstanceByName("ACHIEVEMENT_REWARD_SUBJECT"),
               "STYLES":{"FontSize":UIGlobals.getStyle("SmallFontSize")}
            },{
               "CLASS":SWFLoader,
               "ID":"rewardImg",
               "width":UIGlobals.relativize(64),
               "height":UIGlobals.relativize(64)
            }]
         }];
         super();
         spreadProportionality = false;
         direction = Box.VERTICAL;
      }
      
      public function get achievement() : PersonalAchievement
      {
         return this._data as PersonalAchievement;
      }
      
      public function get achievementInstance() : PersonalAchievementInstance
      {
         return this._data as PersonalAchievementInstance;
      }
      
      public function get listElement() : Object
      {
         return this._data;
      }
      
      public function set listElement(param1:Object) : void
      {
         this._data = param1;
         this.reset();
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
      
      public function set selected(param1:Boolean) : void
      {
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         if(this._highlighted != param1)
         {
            this._highlighted = param1;
            invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         setStyle("Padding",3);
         UIUtils.performLayout(this,this,this._contentLayout);
         this._toolTipBox = new Box(Box.VERTICAL);
         this._toolTipBox.horizontalAlign = Box.ALIGN_CENTER;
         this._toolTipBox.layoutInvisibleChildren = false;
         UIUtils.performLayout(this,this._toolTipBox,this._toolTipUI);
         this.reset();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.achievementInstance)
         {
            this.drawAchieved();
         }
         else
         {
            this.drawNotAchieved();
         }
      }
      
      private function drawAchieved() : void
      {
         this.loader.alpha = 1;
         this.loader.colorMatrix.reset();
         this.loader.blurProxy.reset();
         this.loader.bevelProxy.reset();
      }
      
      private function drawNotAchieved() : void
      {
         this.loader.alpha = 0.35;
         this.loader.colorMatrix.reset();
         this.loader.colorMatrix.saturation = -100;
         this.loader.colorMatrix.brightness = -15;
         this.loader.colorMatrix.contrast = -50;
         this.loader.blurProxy.blur = 5;
         this.loader.bevelProxy.highlightAlpha = 1;
         this.loader.bevelProxy.shadowAlpha = 1;
         this.loader.bevelProxy.angle = 225;
      }
      
      private function get toolTipText() : *
      {
         var _loc1_:PersonalAchievementReward = null;
         if(this.achievementInstance)
         {
            return this.achievementInstance.personalAchievement.getDescription();
         }
         if(this.achievement)
         {
            if(this.achievement.showReward && Boolean(this.achievement.reward.ref))
            {
               setStyle("TooltipSkin",PersistentTooltipSkin);
               if(this.achievement.showProgress)
               {
                  this.tooltipTextArea.text = Utils.formatString(this.achievement.getProgressDescription(),{
                     "amount":this._progress,
                     "limit":this.achievement.limit
                  });
               }
               else
               {
                  this.tooltipTextArea.text = this.achievement.getDescription();
               }
               _loc1_ = this.achievement.reward.ref as PersonalAchievementReward;
               if(_loc1_.is_item)
               {
                  this.rewardImg.source = UIGlobals.getAssetPath(_loc1_.item.image_url);
                  this.rewardImg.toolTip = _loc1_.item.description;
               }
               else if(_loc1_.is_credits)
               {
                  this.rewardImg.source = SafariCardView.CreditsCardPng;
                  this.rewardImg.toolTip = _loc1_.credits.toString();
               }
               return this._toolTipBox;
            }
            if(this.achievement.showProgress)
            {
               return Utils.formatString(this.achievement.getProgressDescription(),{
                  "amount":this._progress,
                  "limit":this.achievement.limit
               });
            }
            return this.achievement.getDescription();
         }
         return null;
      }
      
      private function reset() : void
      {
         var _loc1_:String = null;
         this.removeProgress();
         if(childrenCreated || childrenCreating)
         {
            setStyle("TooltipSkin",DefaultTooltipSkin);
            if(this.achievementInstance)
            {
               _loc1_ = this.achievementInstance.personalAchievement.image;
               this.achievementNameLabel.text = this.achievementInstance.personalAchievement.name;
               this.progressBar.visible = false;
            }
            else if(this.achievement)
            {
               _loc1_ = this.achievement.image;
               this.achievementNameLabel.text = this.achievement.name;
               if(this.achievement.showProgress)
               {
                  this._progress = this.getProgress();
                  if(this._progress >= this.achievement.limit)
                  {
                     dispatchEvent(new Event(INVALID_DATA,true));
                     return;
                  }
                  this.progressBar.visible = true;
                  this.progressBar.setValueAndMaximum(this._progress,this.achievement.limit);
               }
               else
               {
                  this.progressBar.visible = false;
               }
            }
            this.loader.source = UIGlobals.getAssetPath(_loc1_);
            invalidateDisplayList();
         }
         toolTip = this.toolTipText;
         visible = !!this.listElement;
      }
      
      private function getProgress() : Number
      {
         var _loc1_:uint = 0;
         var _loc2_:Boolean = false;
         if(this.achievement)
         {
            _loc2_ = false;
            _loc1_ = 2;
            while(_loc1_ < 12)
            {
               if(this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS[_loc1_])
               {
                  _loc2_ = true;
                  break;
               }
               _loc1_++;
            }
            if(_loc2_)
            {
               this.client.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
               return this.client.player.getSyndicateWins(_loc1_);
            }
         }
         return 0;
      }
      
      private function removeProgress() : void
      {
         this.client.player.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerPropertyChange);
      }
      
      private function get client() : Client
      {
         if(!this._client)
         {
            this._client = UIGlobals.root.client as Client;
         }
         return this._client;
      }
      
      private function onPlayerPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "syndicate_wins_l2" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L2)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l3" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L3)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l4" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L4)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l5" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L5)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l6" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L6)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l7" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L7)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l8" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L8)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l9" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L9)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l10" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L10)
         {
            this.reset();
         }
         else if(param1.property == "syndicate_wins_l11" && this.achievement.type == PersonalAchievement.TYPE_SYNDICATE_WINS_L11)
         {
            this.reset();
         }
      }
   }
}
