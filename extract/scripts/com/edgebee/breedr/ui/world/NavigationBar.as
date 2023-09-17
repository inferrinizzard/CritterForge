package com.edgebee.breedr.ui.world
{
   import com.edgebee.atlas.animation.Animation;
   import com.edgebee.atlas.animation.AnimationInstance;
   import com.edgebee.atlas.animation.Interpolation;
   import com.edgebee.atlas.animation.Keyframe;
   import com.edgebee.atlas.animation.Track;
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.data.Data;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.SWFLoader;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import com.edgebee.breedr.data.world.Area;
   import com.edgebee.breedr.data.world.Link;
   import com.edgebee.breedr.ui.world.areas.ranch.StallView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NavigationBar extends Box
   {
      
      public static const ExitPng:Class = NavigationBar_ExitPng;
      
      private static var _openAnimation:Animation;
       
      
      private var _areaTypeFilter:Array;
      
      public var button1:Button;
      
      public var button2:Button;
      
      public var button3:Button;
      
      public var button4:Button;
      
      public var button5:Button;
      
      public var button6:Button;
      
      public var button7:Button;
      
      public var button8:Button;
      
      public var pullOutBmp:BitmapComponent;
      
      private var buttons:Array;
      
      private var _openAnimInstance:AnimationInstance;
      
      private var _layout:Array;
      
      public function NavigationBar()
      {
         var _loc1_:Track = null;
         this._layout = [{
            "CLASS":Button,
            "ID":"button1",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button2",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button3",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button4",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button5",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button6",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button7",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Button,
            "ID":"button8",
            "width":UIGlobals.relativize(100),
            "height":UIGlobals.relativize(100),
            "visible":true,
            "STYLES":{
               "IconSide":"bottom",
               "FontColor":16777215,
               "FontSize":UIGlobals.relativizeFont(12)
            }
         },{
            "CLASS":Box,
            "name":"NavigationBarPulloutBtn",
            "width":UIGlobals.relativize(80),
            "height":UIGlobals.relativize(100),
            "direction":Box.VERTICAL,
            "horizontalAlign":Box.ALIGN_CENTER,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{
               "BackgroundAlpha":0.25,
               "CornerRadius":10
            },
            "CHILDREN":[{
               "CLASS":BitmapComponent,
               "ID":"pullOutBmp",
               "percentWidth":0.5,
               "filters":UIGlobals.fontOutline,
               "isSquare":true,
               "source":StallView.ArrowPng
            },{
               "CLASS":Label,
               "text":Asset.getInstanceByName("GOTO"),
               "filters":UIGlobals.fontOutline,
               "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
            }]
         }];
         super(Box.HORIZONTAL);
         name = "NavigationBar";
         useMouseScreen = true;
         setStyle("Gap",UIGlobals.relativize(7));
         setStyle("PaddingLeft",UIGlobals.relativize(7));
         setStyle("PaddingRight",UIGlobals.relativize(7));
         setStyle("PaddingTop",UIGlobals.relativize(7));
         setStyle("PaddingBottom",UIGlobals.relativize(7));
         setStyle("CornerRadius",5);
         setStyle("BackgroundAlpha",0.35);
         this.client.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onClientChange);
         this.client.player.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onPlayerChange);
         this.client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this.client.player.addEventListener(Data.UPDATED,this.onPlayerUpdated);
         this.client.service.addEventListener("TravelTo",this.onTravelTo);
         this.client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         if(!_openAnimation)
         {
            _openAnimation = new Animation();
            _loc1_ = new Track("x");
            _loc1_.addKeyframe(new Keyframe(0,UIGlobals.relativize(-864)));
            _loc1_.addKeyframe(new Keyframe(1,UIGlobals.relativize(5)));
            _loc1_.addTransitionByKeyframeTime(0,Interpolation.cubicOut);
            _openAnimation.addTrack(_loc1_);
         }
         this._openAnimInstance = controller.addAnimation(_openAnimation);
         this._openAnimInstance.speed = 2;
      }
      
      private static function sortLinks(param1:Link, param2:Link) : int
      {
         if(param1.priority < param2.priority)
         {
            return -1;
         }
         if(param1.priority > param2.priority)
         {
            return 1;
         }
         return 0;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,this,this._layout);
         this.buttons = [this.button1,this.button2,this.button3,this.button4,this.button5,this.button6,this.button7,this.button8];
         this.onPlayerChange(null);
      }
      
      public function get areaTypeFilter() : Array
      {
         return this._areaTypeFilter;
      }
      
      public function set areaTypeFilter(param1:Array) : void
      {
         this._areaTypeFilter = param1;
         this.onPlayerChange(null);
      }
      
      public function onNavButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:Button = param1.target as Button;
         var _loc3_:Link = _loc2_.userData as Link;
         var _loc4_:Object;
         (_loc4_ = this.client.createInput())["destination_id"] = _loc3_.destination_id;
         this.client.service.TravelTo(_loc4_);
         enabled = false;
         this._openAnimInstance.gotoEndAndPlayReversed();
         ++this.client.criticalComms;
      }
      
      private function onException(param1:ExceptionEvent) : void
      {
         if(param1.method == "TravelTo")
         {
            --this.client.criticalComms;
         }
      }
      
      private function onTravelTo(param1:ServiceEvent) : void
      {
         if(param1.data.hasOwnProperty("events"))
         {
            this.client.actionDispatcher.actions = param1.data.events;
         }
      }
      
      private function onClientChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "criticalComms")
         {
            enabled = this.client.criticalComms == 0;
         }
      }
      
      private function onPlayerUpdated(param1:Event) : void
      {
         this.onPlayerChange(null);
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "state")
         {
            this.onPlayerChange(null);
         }
      }
      
      private function onPlayerChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Button = null;
         var _loc3_:SWFLoader = null;
         var _loc4_:Link = null;
         var _loc5_:Area = null;
         var _loc6_:ArrayCollection = null;
         var _loc7_:int = 0;
         if(param1 == null || param1.property == "area")
         {
            if((Boolean(_loc5_ = this.client.player.area)) && _loc5_.type == Area.TYPE_SAFARI)
            {
               return;
            }
            _loc6_ = new ArrayCollection();
            if(_loc5_)
            {
               for each(_loc4_ in _loc5_.links)
               {
                  _loc6_.addItem(_loc4_);
               }
               _loc6_.addItem(Link.getInstanceByDestinationId(_loc5_.id));
               _loc6_.sort(sortLinks);
            }
            _loc7_ = 0;
            while(_loc7_ < 8)
            {
               _loc2_ = this.buttons[_loc7_];
               if(Boolean(_loc5_) && _loc7_ < _loc6_.length)
               {
                  _loc4_ = _loc6_[_loc7_];
                  _loc2_.label = _loc4_.destination.name;
                  _loc3_ = new SWFLoader();
                  _loc3_.width = UIGlobals.relativize(64);
                  _loc3_.height = UIGlobals.relativize(48);
                  _loc3_.source = UIGlobals.getAssetPath(_loc4_.destination.getImageForPlayer(this.player));
                  _loc3_.filters = UIGlobals.fontOutline;
                  _loc2_.icon = _loc3_;
                  _loc2_.visible = true;
                  _loc2_.userData = _loc4_;
                  if(Boolean(this.areaTypeFilter) && this.areaTypeFilter.indexOf(_loc4_.destination.type) < 0)
                  {
                     _loc2_.enabled = false;
                  }
                  else if(_loc4_.destination.type == _loc5_.type)
                  {
                     _loc2_.enabled = false;
                  }
                  else
                  {
                     _loc2_.enabled = true;
                  }
                  if(!this.client.user.registered)
                  {
                     if(_loc4_.destination.type == Area.TYPE_AUCTION)
                     {
                        _loc2_.enabled = false;
                     }
                     if(_loc4_.destination.type == Area.TYPE_SYNDICATE)
                     {
                        _loc2_.enabled = false;
                     }
                  }
                  _loc2_.addEventListener(MouseEvent.CLICK,this.onNavButtonClick);
               }
               else
               {
                  _loc2_.removeEventListener(MouseEvent.CLICK,this.onNavButtonClick);
               }
               _loc7_++;
            }
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(enabled)
         {
            if(this._openAnimInstance.playing)
            {
               if(this._openAnimInstance.reversed)
               {
                  this._openAnimInstance.reverse();
                  this._openAnimInstance.play();
               }
            }
            else
            {
               this._openAnimInstance.gotoStartAndPlay();
            }
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(enabled)
         {
            if(this._openAnimInstance.playing)
            {
               if(!this._openAnimInstance.reversed)
               {
                  this._openAnimInstance.reverse();
                  this._openAnimInstance.play();
               }
            }
            else
            {
               this._openAnimInstance.gotoEndAndPlayReversed();
            }
         }
      }
   }
}
