package com.edgebee.breedr.ui.news
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.news.News;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.ui.ControlBar;
   import flash.events.MouseEvent;
   
   public class NewsWindow extends Window
   {
      
      public static const LINK:String = "LINK";
       
      
      public var newsList:List;
      
      public var hideIfEmpty:Boolean = true;
      
      public var hideIfNothingNew:Boolean = true;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function NewsWindow()
      {
         this._statusBarLayout = [{
            "CLASS":Button,
            "label":Asset.getInstanceByName("REFRESH"),
            "STYLES":{"FontSize":10},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onRefreshClick"
            }]
         }];
         this._contentLayout = [{
            "CLASS":Box,
            "percentHeight":1,
            "percentWidth":1,
            "layoutInvisibleChildren":false,
            "CHILDREN":[{
               "CLASS":List,
               "ID":"newsList",
               "percentHeight":1,
               "percentWidth":1,
               "selectable":false,
               "animated":false,
               "dataProvider":"{news}",
               "renderer":NewsDisplay
            },{
               "CLASS":ScrollBar,
               "percentHeight":1,
               "scrollable":"{newsList}"
            }]
         }];
         super();
         rememberPositionId = "NewsWindow";
         super.visible = false;
         client.service.addEventListener("GetNews",this.onGetNews);
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
         content.layoutInvisibleChildren = false;
         title = Asset.getInstanceByName("NEWS");
         titleIcon = UIUtils.createBitmapIcon(ControlBar.NewsIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_RIGHT;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      public function fetchNews() : void
      {
         client.service.GetNews(client.createInput());
         this.newsList.busyOverlayed = true;
      }
      
      private function onGetNews(param1:ServiceEvent) : void
      {
         this.player.news.reset();
         if(param1.data.hasOwnProperty("news"))
         {
            this.player.news.update(param1.data.news);
         }
         this.update();
         this.newsList.busyOverlayed = false;
         this.player.new_news = false;
      }
      
      public function onRefreshClick(param1:MouseEvent) : void
      {
         this.fetchNews();
      }
      
      public function get news() : DataArray
      {
         return this.player.news;
      }
      
      private function update() : void
      {
         if(!(!this.news.length && this.hideIfEmpty || this.news.length && (this.news.first as News).id == client.userCookie.latestNewsId && this.hideIfNothingNew))
         {
            visible = true;
         }
         client.userCookie.latestNewsId = !!this.news.length ? (this.news.first as News).id : 0;
         client.saveCookie();
         this.hideIfEmpty = false;
         this.hideIfNothingNew = false;
         invalidateDisplayList();
      }
   }
}
