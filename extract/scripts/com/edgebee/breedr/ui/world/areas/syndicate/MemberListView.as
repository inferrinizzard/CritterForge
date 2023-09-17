package com.edgebee.breedr.ui.world.areas.syndicate
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.controls.ToggleButton;
   import com.edgebee.atlas.ui.skins.CheckBoxSkin;
   import com.edgebee.atlas.ui.skins.LinkButtonSkin;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import com.edgebee.atlas.util.WeakReference;
   import com.edgebee.breedr.Client;
   import com.edgebee.breedr.data.player.Player;
   import flash.events.MouseEvent;
   
   public class MemberListView extends Box implements Listable
   {
      
      public static const KICK_CLICKED:String = "KICK_CLICKED";
      
      public static const DELEGATE_CLICKED:String = "DELEGATE_CLICKED";
      
      public static const TOGGLE_CAN_CHALLENGE:String = "TOGGLE_CAN_CHALLENGE";
       
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _member:WeakReference;
      
      private var _mouseDown:Boolean = false;
      
      public var playerLbl:PlayerLabel;
      
      public var kickBtn:Button;
      
      public var statusLbl:Label;
      
      public var delegateBtn:Button;
      
      public var lastActivityLbl:Label;
      
      public var levelLbl:Label;
      
      public var canChallengeBtn:ToggleButton;
      
      private var _layout:Array;
      
      public function MemberListView()
      {
         this._member = new WeakReference(null,Player);
         this._layout = [{
            "CLASS":PlayerLabel,
            "ID":"playerLbl",
            "percentWidth":0.3,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Label,
            "ID":"statusLbl",
            "percentWidth":0.1,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Label,
            "ID":"levelLbl",
            "percentWidth":0.1,
            "STYLES":{"FontSize":UIGlobals.relativizeFont(12)}
         },{
            "CLASS":Label,
            "ID":"lastActivityLbl",
            "percentWidth":0.2,
            "STYLES":{
               "FontSize":UIGlobals.relativizeFont(12),
               "FontStyle":"italic"
            }
         },{
            "CLASS":Box,
            "percentWidth":0.1,
            "horizontalAlign":Box.ALIGN_CENTER,
            "CHILDREN":[{
               "CLASS":ToggleButton,
               "ID":"canChallengeBtn",
               "label":" ",
               "STYLES":{
                  "Skin":CheckBoxSkin,
                  "FontSize":UIGlobals.relativizeFont(12),
                  "PaddingLeft":0,
                  "PaddingRight":0,
                  "PaddingTop":0,
                  "PaddingButtom":0
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onCanChallengeClick"
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":0.2,
            "horizontalAlign":Box.ALIGN_RIGHT,
            "CHILDREN":[{
               "CLASS":Button,
               "ID":"delegateBtn",
               "label":Asset.getInstanceByName("DELEGATE"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onDelegateClick"
               }]
            },{
               "CLASS":Button,
               "ID":"kickBtn",
               "label":Asset.getInstanceByName("KICK"),
               "STYLES":{
                  "Skin":LinkButtonSkin,
                  "FontColor":16777215,
                  "FontSize":UIGlobals.relativizeFont(12)
               },
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onKickClick"
               }]
            }]
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         visible = false;
         percentWidth = 1;
         layoutInvisibleChildren = false;
         filters = UIGlobals.fontOutline;
      }
      
      public function get client() : Client
      {
         return UIGlobals.root.client as Client;
      }
      
      public function get player() : Player
      {
         return this.client.player;
      }
      
      public function get listElement() : Object
      {
         return this.member;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.member = param1 as Player;
      }
      
      public function get member() : Player
      {
         return this._member.get() as Player;
      }
      
      public function set member(param1:Player) : void
      {
         if(this.member != param1)
         {
            if(this.member)
            {
               this.member.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMemberChange);
            }
            this._member.reset(param1);
            if(this.member)
            {
               this.member.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMemberChange);
            }
            if(childrenCreated)
            {
               this.update();
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
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function onMemberChange(param1:PropertyChangeEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         if(this.member)
         {
            visible = true;
            this.playerLbl.player = this.member;
            this.statusLbl.text = this.player.syndicate.leader_id == this.member.id ? Asset.getInstanceByName("LEADER").value.toLocaleUpperCase() : "";
            this.levelLbl.text = this.member.syndicate_level.level.toString();
            this.lastActivityLbl.text = Utils.dateToElapsed(this.member.last_activity);
            this.kickBtn.enabled = this.player.syndicate.leader_id == this.player.id && this.member.id != this.player.id;
            this.delegateBtn.enabled = this.player.syndicate.leader_id == this.player.id && this.member.id != this.player.id;
            this.canChallengeBtn.selected = this.member.canChallengeOtherSyndicates;
            this.canChallengeBtn.enabled = this.player.syndicate.leader_id == this.player.id && this.member.id != this.player.id;
         }
         else
         {
            visible = false;
         }
      }
      
      public function onDelegateClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(DELEGATE_CLICKED,this.member,true));
      }
      
      public function onKickClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(KICK_CLICKED,this.member,true));
      }
      
      public function onCanChallengeClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ExtendedEvent(TOGGLE_CAN_CHALLENGE,this.member,true));
      }
   }
}
