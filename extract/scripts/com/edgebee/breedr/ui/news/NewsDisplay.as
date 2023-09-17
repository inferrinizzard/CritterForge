package com.edgebee.breedr.ui.news
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.IToolTip;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.skins.PersistentTooltipSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.news.News;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   
   public class NewsDisplay extends Box implements Listable
   {
      
      public static var WorldIcon:Class = NewsDisplay_WorldIcon;
      
      public static var ZoneIcon:Class = NewsDisplay_ZoneIcon;
      
      public static var PlayerIcon:Class = NewsDisplay_PlayerIcon;
      
      public static var GuildIcon:Class = NewsDisplay_GuildIcon;
       
      
      private var _news:News;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      public var titleLabel:Label;
      
      public var dateLabel:Label;
      
      public var toolTipTextArea:TextArea;
      
      private var _layout:Array;
      
      public function NewsDisplay()
      {
         this._layout = [{
            "CLASS":Box,
            "direction":Box.HORIZONTAL,
            "percentHeight":1,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Label,
               "ID":"dateLabel",
               "percentWidth":0.3,
               "STYLES":{
                  "FontSize":UIGlobals.relativizeFont(12),
                  "FontColor":"0xCCCCCC",
                  "FontStyle":"italic"
               }
            },{
               "CLASS":Label,
               "ID":"titleLabel",
               "percentWidth":0.7,
               "useHtml":true
            }]
         }];
         super(Box.VERTICAL,Box.ALIGN_LEFT);
         percentWidth = 1;
         height = UIGlobals.relativizeY(32);
         filters = [new DropShadowFilter(2,45,0,1,4,4,2)];
         setStyle("TooltipSkin",PersistentTooltipSkin);
      }
      
      public function get listElement() : Object
      {
         return this.news;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.news = param1 as News;
      }
      
      public function get news() : News
      {
         return this._news;
      }
      
      public function set news(param1:News) : void
      {
         if(this._news != param1)
         {
            if(this._news)
            {
               this._news.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onNewsChange);
            }
            this._news = param1;
            if(childrenCreated)
            {
               this.update();
            }
            if(this._news)
            {
               this._news.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onNewsChange);
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.toolTipTextArea = new TextArea();
         this.toolTipTextArea.useHtml = true;
         this.toolTipTextArea.width = UIGlobals.relativizeX(400);
         this.toolTipTextArea.addEventListener(TextEvent.LINK,this.onLink);
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      private function onLink(param1:TextEvent) : void
      {
         var _loc4_:Client = null;
         var _loc5_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:Array = param1.text.split(/:/);
         dispatchEvent(new ExtendedEvent(NewsWindow.LINK,_loc2_,true));
         var _loc3_:Component = param1.currentTarget as Component;
         while(Boolean(_loc3_) && !(_loc3_ is IToolTip))
         {
            _loc3_ = _loc3_.parent as Component;
         }
         (_loc3_ as IToolTip).hide(true);
         var _loc6_:String;
         if((_loc6_ = String(_loc2_[0])) == "show_results")
         {
            _loc7_ = uint(_loc2_[1]);
            (_loc5_ = (_loc4_ = (UIGlobals.root as breedr_flash).rootView.client).createInput()).challenge_results_id = _loc7_;
            _loc4_.service.GetSyndicateChallengeResults(_loc5_);
         }
         else if(_loc6_ == "replay_id")
         {
            _loc8_ = uint(_loc2_[1]);
            _loc4_ = (UIGlobals.root as breedr_flash).rootView.client;
            _loc4_.criticalComms += 1;
            (_loc5_ = _loc4_.createInput()).replay_id = _loc8_;
            _loc4_.service.GetReplay(_loc5_);
         }
      }
      
      private function update(param1:String = null) : void
      {
         if(this.news)
         {
            visible = true;
            if(!param1 || param1 == "title")
            {
               this.titleLabel.text = Utils.htmlWrap(this.news.title.text,null,16777215);
            }
            if(!param1 || param1 == "date")
            {
               this.dateLabel.text = Utils.getLocalDateTimeString(this.news.date);
            }
            if(!param1 || param1 == "body")
            {
               this.toolTipTextArea.text = Utils.htmlWrap("<b>" + this.news.title.text + "</b><br><i>" + this.news.date.toLocaleString() + "</i><br><br>" + this.news.body.text,null,16777215,0);
            }
            toolTip = this.toolTipTextArea;
         }
         else
         {
            visible = false;
            toolTip = null;
         }
      }
      
      private function onNewsChange(param1:PropertyChangeEvent) : void
      {
         this.update(param1.property);
      }
   }
}
