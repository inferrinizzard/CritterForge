package com.edgebee.breedr.ui.achievements
{
   import com.edgebee.atlas.data.FilteredArrayCollection;
   import com.edgebee.atlas.data.StaticData;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.TileList;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.PersonalAchievement;
   import com.edgebee.breedr.data.player.PersonalAchievementInstance;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.ControlBar;
   import flash.events.Event;
   
   public class AchievementsWindow extends Window
   {
       
      
      private var achievements:FilteredArrayCollection;
      
      public var achievementList:TileList;
      
      private var _contentLayout:Array;
      
      public function AchievementsWindow()
      {
         this._contentLayout = [{
            "CLASS":Box,
            "layoutInvisibleChildren":false,
            "spreadProportionality":false,
            "CHILDREN":[{
               "CLASS":TileList,
               "ID":"achievementList",
               "direction":TileList.VERTICAL,
               "widthInColumns":4,
               "heightInRows":3,
               "selectable":false,
               "highlightable":true,
               "showHighlight":false,
               "renderer":AchievementDisplay,
               "useMouseScreen":true,
               "STYLES":{
                  "BorderAlpha":1,
                  "BorderThickness":0,
                  "BorderColor":UIGlobals.getStyle("FontColor")
               },
               "EVENTS":[{
                  "TYPE":AchievementDisplay.INVALID_DATA,
                  "LISTENER":"onInvalidData"
               }]
            },{
               "CLASS":ScrollBar,
               "percentHeight":1,
               "scrollable":"{achievementList}"
            }]
         }];
         super();
         rememberPositionId = "AchievementWindow";
         super.visible = false;
         this.achievements = new FilteredArrayCollection();
         this.achievements.filter = this.filterAchievements;
         client.service.addEventListener("FetchAchievements",this.onFetchAchievements);
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
      }
      
      public function get player() : Player
      {
         return (client as Client).player;
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.setStyle("Gap",5);
         title = Asset.getInstanceByName("PERSONAL_ACHIEVEMENTS");
         titleIcon = UIUtils.createBitmapIcon(ControlBar.TrophyIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         this.achievementList.dataProvider = this.achievements;
         this.player.game_achievements.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onAchievementsChange);
         if(!this.player.achievementsFetched)
         {
            this.fetchAchievements();
         }
         else
         {
            this.update();
         }
      }
      
      private function fetchAchievements() : void
      {
         this.player.achievementsFetched = false;
         this.achievementList.busyOverlayed = true;
         client.service.FetchAchievements(client.createInput());
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "FetchAchievements")
         {
            this.achievementList.busyOverlayed = false;
         }
      }
      
      private function onFetchAchievements(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            (client as Client).actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "achievementsFetched" && this.player.achievementsFetched && Boolean(this.achievementList))
         {
            this.achievementList.busyOverlayed = false;
         }
      }
      
      private function update() : void
      {
         var _loc2_:PersonalAchievement = null;
         var _loc3_:PersonalAchievementInstance = null;
         var _loc4_:uint = 0;
         var _loc1_:Array = [];
         for each(_loc2_ in StaticData.getAllInstances("PersonalAchievement","id"))
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc3_ in this.player.game_achievements)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(_loc1_[_loc4_] is PersonalAchievement && _loc1_[_loc4_].id == _loc3_.static_id)
               {
                  _loc1_[_loc4_] = _loc3_;
               }
               _loc4_++;
            }
         }
         this.achievements.source = _loc1_;
      }
      
      private function onAchievementsChange(param1:CollectionEvent) : void
      {
         this.update();
      }
      
      private function filterAchievements(param1:Array) : Array
      {
         var _loc3_:PersonalAchievement = null;
         var _loc4_:PersonalAchievement = null;
         var _loc5_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc5_ in param1)
         {
            if(_loc5_ is PersonalAchievementInstance)
            {
               _loc2_.push(_loc5_);
            }
            else
            {
               _loc3_ = _loc5_ as PersonalAchievement;
               _loc4_ = _loc3_.parent;
               if(_loc3_.alwaysShow || _loc4_ && _loc4_.showChildren && this.player.game_achievements.findItemByProperty("static_id",_loc4_.id) != null)
               {
                  _loc2_.push(_loc5_);
               }
            }
         }
         return _loc2_;
      }
      
      public function onInvalidData(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         this.fetchAchievements();
      }
   }
}
