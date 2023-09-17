package com.edgebee.atlas.ui.gadgets.messaging
{
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.messaging.Message;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.controls.BitmapComponent;
   import com.edgebee.atlas.ui.controls.GradientLabel;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.PlayerLabel;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.display.Bitmap;
   
   public class MessageDisplay extends Box implements Listable
   {
      
      public static var UnreadEmailPng:Class = MessageDisplay_UnreadEmailPng;
      
      public static var ReadEmailPng:Class = MessageDisplay_ReadEmailPng;
      
      public static var ArchivedEmailPng:Class = MessageDisplay_ArchivedEmailPng;
      
      public static var ReplayPng:Class = MessageDisplay_ReplayPng;
      
      public static var ArchivedReplayPng:Class = MessageDisplay_ArchivedReplayPng;
       
      
      private var _message:Message;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      public var readUnreadIcon:BitmapComponent;
      
      public var readIcon:Bitmap;
      
      public var readArchivedIcon:Bitmap;
      
      public var unreadIcon:Bitmap;
      
      public var readReplayIcon:Bitmap;
      
      public var readReplayArchivedIcon:Bitmap;
      
      public var unreadReplayIcon:Bitmap;
      
      public var subjectLabel:Label;
      
      public var senderLabel:PlayerLabel;
      
      public var nameLbl:GradientLabel;
      
      public var dateLabel:Label;
      
      private var _tmpPlayer:Player;
      
      private var _layout:Array;
      
      public function MessageDisplay()
      {
         this.readIcon = new UnreadEmailPng();
         this.readArchivedIcon = new ArchivedEmailPng();
         this.unreadIcon = new UnreadEmailPng();
         this.readReplayIcon = new ReplayPng();
         this.readReplayArchivedIcon = new ArchivedReplayPng();
         this.unreadReplayIcon = new ReplayPng();
         this._tmpPlayer = new Player();
         this._layout = [{
            "CLASS":BitmapComponent,
            "ID":"readUnreadIcon",
            "width":16,
            "height":16
         },{
            "CLASS":Label,
            "name":"subjectLabel",
            "ID":"subjectLabel",
            "percentWidth":0.4
         },{
            "CLASS":PlayerLabel,
            "ID":"senderLabel",
            "percentWidth":0.35
         },{
            "CLASS":GradientLabel,
            "ID":"nameLbl",
            "visible":false,
            "percentWidth":0.35
         },{
            "CLASS":Spacer,
            "percentWidth":0.25
         },{
            "CLASS":Label,
            "ID":"dateLabel"
         }];
         super(Box.HORIZONTAL,Box.ALIGN_LEFT,Box.ALIGN_MIDDLE);
         layoutInvisibleChildren = false;
         percentWidth = 1;
         setStyle("PaddingTop",2);
         setStyle("PaddingBottom",2);
         setStyle("PaddingRight",2);
         setStyle("PaddingLeft",2);
      }
      
      public function get listElement() : Object
      {
         return this.message;
      }
      
      public function set listElement(param1:Object) : void
      {
         this.message = param1 as Message;
      }
      
      public function get message() : Message
      {
         return this._message;
      }
      
      public function set message(param1:Message) : void
      {
         if(this._message != param1)
         {
            if(this._message)
            {
               this._message.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMessageChange);
            }
            this._message = param1;
            if(childrenCreated)
            {
               this.update();
            }
            if(this._message)
            {
               this._message.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onMessageChange);
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
         this.nameLbl.setStyle("FontSize",this.senderLabel.getStyle("FontSize"));
         this.nameLbl.setStyle("FontColor",this.senderLabel.getStyle("FontColor"));
         this.nameLbl.setStyle("FontWeight",this.senderLabel.getStyle("FontWeight"));
         visible = false;
         this.update();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      private function update(param1:String = null) : void
      {
         var _loc2_:String = null;
         if(this.message)
         {
            visible = true;
            if(!param1 || param1 == "is_read" || param1 == "is_archived")
            {
               this.readUnreadIcon.bitmap = this.message.is_read ? (this.message.is_archived ? this.readArchivedIcon : this.readIcon) : this.unreadIcon;
               if(!this.message.is_read)
               {
                  this.subjectLabel.setStyle("FontWeight","bold");
                  this.senderLabel.setStyle("FontWeight","bold");
                  this.dateLabel.setStyle("FontWeight","bold");
               }
               else
               {
                  this.subjectLabel.setStyle("FontWeight","normal");
                  this.senderLabel.setStyle("FontWeight","normal");
                  this.dateLabel.setStyle("FontWeight","normal");
               }
            }
            if(!param1 || param1 == "subject")
            {
               this.subjectLabel.text = this.message.subject;
            }
            if(!param1 || param1 == "sender")
            {
               if(this.message.npc_sender)
               {
                  this.nameLbl.text = this.message.npc_sender;
                  this.senderLabel.visible = false;
                  this.nameLbl.visible = true;
               }
               else if(this.message.sender.name)
               {
                  this._tmpPlayer.name = this.message.sender.name;
                  this._tmpPlayer.user_level = this.message.sender.user_level;
                  this._tmpPlayer.avatar_version = this.message.sender.avatar_version;
                  this._tmpPlayer.foreign_type = this.message.sender.foreign_type;
                  this._tmpPlayer.foreign_id = this.message.sender.foreign_id;
                  this.senderLabel.player = this._tmpPlayer;
                  this.nameLbl.visible = false;
                  this.senderLabel.visible = true;
               }
               else
               {
                  this.nameLbl.text = "";
                  this.senderLabel.visible = false;
                  this.nameLbl.visible = true;
               }
            }
            if(!param1 || param1 == "date")
            {
               this.dateLabel.text = Utils.getLocalDateTimeString(this.message.date);
            }
            if(this.message.npc_sender)
            {
               _loc2_ = this.message.npc_sender;
            }
            else
            {
               _loc2_ = this.message.sender.name;
            }
            toolTip = this.message.subject + "<br>" + _loc2_ + "<br>" + Utils.getLocalDateTimeString(this.message.date) + "<br>" + this.message.recipients;
         }
         else
         {
            visible = false;
            toolTip = "";
         }
      }
      
      private function onMessageChange(param1:PropertyChangeEvent) : void
      {
         this.update(param1.property);
      }
   }
}
