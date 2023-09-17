package com.edgebee.atlas.ui.gadgets.messaging
{
   import com.edgebee.atlas.data.DataArray;
   import com.edgebee.atlas.data.Player;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.data.messaging.Message;
   import com.edgebee.atlas.events.CollectionEvent;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.events.PropertyChangeEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.ScrollableBox;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Timer;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   
   public class InboxWindow extends Window
   {
      
      public static var MailIconPng:Class = InboxWindow_MailIconPng;
      
      public static var RefreshIconPng:Class = InboxWindow_RefreshIconPng;
      
      public static var ComposeIconPng:Class = InboxWindow_ComposeIconPng;
      
      public static var ReplyIconPng:Class = InboxWindow_ReplyIconPng;
      
      public static var ReplyAllIconPng:Class = InboxWindow_ReplyAllIconPng;
      
      public static var ForwardIconPng:Class = InboxWindow_ForwardIconPng;
      
      public static var DeleteIconPng:Class = InboxWindow_DeleteIconPng;
      
      public static var ArchiveIconPng:Class = InboxWindow_ArchiveIconPng;
      
      public static var UnarchiveIconPng:Class = InboxWindow_UnarchiveIconPng;
      
      public static var DeleteAllIconPng:Class = InboxWindow_DeleteAllIconPng;
      
      public static const LINK:String = "LINK";
       
      
      private var _timer:Timer;
      
      private var _selectedMsg:Message;
      
      public var refreshBtn:Button;
      
      public var composeBtn:Button;
      
      public var replyBtn:Button;
      
      public var replyAllBtn:Button;
      
      public var forwardBtn:Button;
      
      public var deleteBtn:Button;
      
      public var archiveBtn:Button;
      
      public var unarchiveBtn:Button;
      
      public var deleteAllBtn:Button;
      
      public var markAllReadBtn:Button;
      
      public var messages:DataArray;
      
      public var messageList:List;
      
      public var bodyTextArea:TextArea;
      
      public var scrollableBox:ScrollableBox;
      
      public var attachmentList:List;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function InboxWindow()
      {
         this._timer = new Timer(3000);
         this._statusBarLayout = [];
         this._contentLayout = [{
            "CLASS":Box,
            "percentWidth":1,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "STYLES":{"Gap":UIGlobals.relativize(5)},
            "CHILDREN":[{
               "CLASS":Button,
               "ID":"refreshBtn",
               "icon":UIUtils.createBitmapIcon(RefreshIconPng,16,16),
               "toolTip":Asset.getInstanceByName("REFRESH"),
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onRefreshClick"
               }]
            },{
               "CLASS":Button,
               "ID":"composeBtn",
               "icon":UIUtils.createBitmapIcon(ComposeIconPng,16,16),
               "toolTip":Asset.getInstanceByName("COMPOSE"),
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onComposeClick"
               }]
            },{
               "CLASS":Button,
               "ID":"replyBtn",
               "icon":UIUtils.createBitmapIcon(ReplyIconPng,16,16),
               "toolTip":Asset.getInstanceByName("REPLY"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onReplyClick"
               }]
            },{
               "CLASS":Button,
               "ID":"replyAllBtn",
               "icon":UIUtils.createBitmapIcon(ReplyAllIconPng,16,16),
               "toolTip":Asset.getInstanceByName("REPLYALL"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onReplyAllClick"
               }]
            },{
               "CLASS":Button,
               "ID":"forwardBtn",
               "icon":UIUtils.createBitmapIcon(ForwardIconPng,16,16),
               "toolTip":Asset.getInstanceByName("FORWARD"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onForwardClick"
               }]
            },{
               "CLASS":Button,
               "ID":"deleteBtn",
               "icon":UIUtils.createBitmapIcon(DeleteIconPng,16,16),
               "toolTip":Asset.getInstanceByName("DELETE"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onDeleteClick"
               }]
            },{
               "CLASS":Button,
               "ID":"deleteAllBtn",
               "icon":UIUtils.createBitmapIcon(DeleteAllIconPng,16,16),
               "toolTip":Asset.getInstanceByName("DELETE_ALL"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onDeleteAllClick"
               }]
            },{
               "CLASS":Button,
               "ID":"markAllReadBtn",
               "icon":UIUtils.createBitmapIcon(MessageDisplay.ReadEmailPng,16,16),
               "toolTip":Asset.getInstanceByName("MARK_ALL_AS_READ"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onMarkAllReadClick"
               }]
            },{
               "CLASS":Button,
               "ID":"archiveBtn",
               "icon":UIUtils.createBitmapIcon(ArchiveIconPng,16,16),
               "toolTip":Asset.getInstanceByName("ARCHIVE"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onArchiveClick"
               }]
            },{
               "CLASS":Button,
               "ID":"unarchiveBtn",
               "icon":UIUtils.createBitmapIcon(UnarchiveIconPng,16,16),
               "toolTip":Asset.getInstanceByName("UNARCHIVE"),
               "enabled":false,
               "STYLES":{"Shape":"circle"},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onUnarchiveClick"
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "spreadProportionality":false,
            "layoutInvisibleChildren":false,
            "STYLES":{
               "BackgroundAlpha":0.5,
               "BorderThickness":1,
               "BorderAlpha":0.5,
               "BorderColor":UIGlobals.getStyle("FontColor")
            },
            "CHILDREN":[{
               "CLASS":List,
               "ID":"messageList",
               "percentWidth":1,
               "heightInRows":6,
               "animated":false,
               "sortFunc":sortByDateMostRecent,
               "dataProvider":"{messages}",
               "renderer":MessageDisplay,
               "selectable":true,
               "EVENTS":[{
                  "TYPE":Event.CHANGE,
                  "LISTENER":"onMessageListSelect"
               }]
            },{
               "CLASS":ScrollBar,
               "name":"InboxWindow:ScrollBar",
               "percentHeight":1,
               "scrollable":"{messageList}"
            }]
         },{
            "CLASS":ScrollableBox,
            "ID":"scrollableBox",
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "BackgroundAlpha":0.5,
               "BorderThickness":1,
               "Padding":5,
               "BorderAlpha":0.5,
               "BorderColor":UIGlobals.getStyle("FontColor")
            }
         }];
         super();
         rememberPositionId = "InboxWindow";
         super.visible = false;
         this.messages = this.player.messages;
         this.messages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onMessagesChange);
         client.service.addEventListener("GetMessages",this.onGetMessages);
         client.service.addEventListener("ArchiveMessage",this.onArchiveMessage);
         client.service.addEventListener("UnarchiveMessage",this.onUnarchiveMessage);
         client.user.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onUserChange);
         this._timer.addEventListener(TimerEvent.TIMER,this.onMessageReadTimer);
      }
      
      private static function createComposer() : ComposerWindow
      {
         var _loc1_:ComposerWindow = null;
         _loc1_ = new ComposerWindow();
         _loc1_.width = 500;
         _loc1_.height = 400;
         return _loc1_;
      }
      
      public static function composeTo(param1:Player) : void
      {
         var _loc2_:ComposerWindow = createComposer();
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root.stage);
         UIGlobals.popUpManager.centerPopUp(_loc2_);
         if(param1)
         {
            _loc2_.recipientsTextInput.text = param1.name;
         }
         _loc2_.visible = true;
      }
      
      public static function sortByDateMostRecent(param1:*, param2:*) : int
      {
         var _loc3_:Message = param1 as Message;
         var _loc4_:Message = param2 as Message;
         if(_loc3_.date.time > _loc4_.date.time)
         {
            return -1;
         }
         if(_loc3_.date.time < _loc4_.date.time)
         {
            return 1;
         }
         return 0;
      }
      
      public function get player() : Player
      {
         return client.basePlayer;
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.layoutInvisibleChildren = false;
         content.setStyle("Gap",5);
         title = Asset.getInstanceByName("INBOX");
         titleIcon = UIUtils.createBitmapIcon(MailIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
         this.scrollableBox.content.direction = Box.VERTICAL;
         this.bodyTextArea = new TextArea();
         this.bodyTextArea.useHtml = true;
         this.bodyTextArea.percentWidth = 1;
         this.bodyTextArea.addEventListener(TextEvent.LINK,this.onMessageLink);
         this.scrollableBox.content.addChild(this.bodyTextArea);
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 5;
         this.scrollableBox.content.addChild(_loc1_);
         this.attachmentList = new List();
         this.attachmentList.percentWidth = 1;
         this.attachmentList.selectable = false;
         this.attachmentList.highlightable = false;
         this.attachmentList.renderer = AttachmentDisplay;
         this.attachmentList.addEventListener(AttachmentDisplay.START_EXECUTE_ATTACHMENT,this.onStartExecuteAttachment);
         this.attachmentList.addEventListener(AttachmentDisplay.STOP_EXECUTE_ATTACHMENT,this.onStopExecuteAttachment);
         this.scrollableBox.content.addChild(this.attachmentList);
         this.onUserChange(null);
         this.fetchMessages();
      }
      
      public function fetchMessages() : void
      {
         if(client.session)
         {
            client.service.GetMessages(client.createInput());
            this.refreshBtn.enabled = false;
            this.messageList.busyOverlayed = true;
         }
      }
      
      private function onUserChange(param1:PropertyChangeEvent) : void
      {
         if((!param1 || param1.property == "state") && Boolean(this.composeBtn))
         {
            this.composeBtn.enabled = client.user.registered;
            this.composeBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : Asset.getInstanceByName("COMPOSE");
            this.replyBtn.enabled = client.user.registered;
            this.replyBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : Asset.getInstanceByName("REPLY");
            this.replyAllBtn.enabled = client.user.registered;
            this.replyAllBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : Asset.getInstanceByName("REPLYALL");
            this.forwardBtn.enabled = client.user.registered;
            this.forwardBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : Asset.getInstanceByName("FORWARD");
            this.archiveBtn.enabled = client.user.registered;
            this.archiveBtn.toolTip = !client.user.registered ? Asset.getInstanceByName("MUST_BE_REGISTERED") : Asset.getInstanceByName("ARCHIVE");
         }
      }
      
      private function onStartExecuteAttachment(param1:Event) : void
      {
         ++client.criticalComms;
         enabled = false;
         this.messageList.busyOverlayed = true;
      }
      
      private function onStopExecuteAttachment(param1:Event) : void
      {
         --client.criticalComms;
         this.messageList.busyOverlayed = false;
         enabled = true;
      }
      
      private function update() : void
      {
         invalidateDisplayList();
      }
      
      private function onGetMessages(param1:ServiceEvent) : void
      {
         this.messages.reset();
         if(param1.data.hasOwnProperty("messages"))
         {
            this.messages.update(param1.data.messages);
         }
         this.messageButtons = false;
         this.refreshBtn.enabled = true;
         this.messageList.busyOverlayed = false;
         this.player.new_messages = false;
      }
      
      private function onArchiveMessage(param1:ServiceEvent) : void
      {
         if(param1.data.success)
         {
            this._selectedMsg.is_archived = true;
         }
         else
         {
            AlertWindow.show(Asset.getInstanceByName("ARCHIVE_FULL_TEXT"),Asset.getInstanceByName("ARCHIVE_FULL_TITLE"),this,true,null,true,false);
         }
         this.messageList.busyOverlayed = false;
         enabled = true;
      }
      
      private function onUnarchiveMessage(param1:ServiceEvent) : void
      {
         if(param1.data.success)
         {
            this._selectedMsg.is_archived = false;
         }
         this.messageList.busyOverlayed = false;
         enabled = true;
      }
      
      private function onMessagesChange(param1:CollectionEvent) : void
      {
         var _loc2_:Message = null;
         if(this._selectedMsg)
         {
            for each(_loc2_ in this.messages)
            {
               if(_loc2_.id == this._selectedMsg.id)
               {
                  return;
               }
            }
            this.setEmptyMessage();
         }
         this.deleteAllBtn.enabled = this.messages.length > 0;
         this.markAllReadBtn.enabled = this.messages.length > 0;
      }
      
      public function setEmptyMessage() : void
      {
         this._selectedMsg = null;
         this._timer.stop();
         this.bodyTextArea.text = "";
         this.attachmentList.dataProvider.removeAll();
         this.messageButtons = false;
      }
      
      private function set messageButtons(param1:Boolean) : void
      {
         this.replyBtn.enabled = param1 && this._selectedMsg && !this._selectedMsg.npc_sender && client.user.registered;
         this.replyAllBtn.enabled = param1 && this._selectedMsg && !this._selectedMsg.npc_sender && client.user.registered;
         this.forwardBtn.enabled = param1 && client.user.registered;
         this.deleteBtn.enabled = param1;
         this.archiveBtn.enabled = param1 && !this._selectedMsg.is_archived && client.user.registered;
         this.unarchiveBtn.enabled = param1 && this._selectedMsg.is_archived;
      }
      
      public function onMessageListSelect(param1:ExtendedEvent) : void
      {
         if(this.messageList.selectedItem)
         {
            this._selectedMsg = this.messageList.selectedItem as Message;
            this.bodyTextArea.text = Utils.htmlWrap(this._selectedMsg.body,UIGlobals.getStyle("FontFamily"),UIGlobals.getStyle("FontColor"),UIGlobals.getStyle("FontSize"));
            this.messageButtons = true;
            this.attachmentList.dataProvider = this._selectedMsg.attachments;
            this.attachmentList.heightInRows = this._selectedMsg.attachments.length;
            if(!this._selectedMsg.is_read)
            {
               this._timer.reset();
               this._timer.start();
            }
            else
            {
               this._timer.stop();
            }
         }
      }
      
      private function onMessageReadTimer(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         this._timer.stop();
         if(Boolean(this._selectedMsg) && !this._selectedMsg.is_read)
         {
            this._selectedMsg.is_read = true;
            _loc2_ = client.createInput();
            _loc2_.id = [this._selectedMsg.id];
            client.service.ReadMessage(_loc2_);
         }
      }
      
      public function onRefreshClick(param1:MouseEvent) : void
      {
         this.fetchMessages();
      }
      
      public function onComposeClick(param1:MouseEvent) : void
      {
         composeTo(null);
      }
      
      public function onReplyClick(param1:MouseEvent) : void
      {
         var _loc2_:ComposerWindow = createComposer();
         var _loc3_:Message = this.messageList.selectedItem as Message;
         _loc2_.recipients = _loc3_.sender.name;
         _loc2_.subject = "Re: " + _loc3_.subject;
         _loc2_.body = "=================================================\n" + _loc3_.body;
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root.stage);
         UIGlobals.popUpManager.centerPopUp(_loc2_);
         _loc2_.visible = true;
      }
      
      public function onReplyAllClick(param1:MouseEvent) : void
      {
         var _loc2_:ComposerWindow = createComposer();
         var _loc3_:Message = this.messageList.selectedItem as Message;
         var _loc4_:Array = _loc3_.recipients.split(",");
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc4_[_loc5_] = Utils.trim(_loc4_[_loc5_] as String);
            _loc5_++;
         }
         _loc4_.splice(_loc4_.indexOf(this.player.name),1);
         _loc4_.push(_loc3_.sender.name);
         _loc2_.recipients = _loc4_.join(", ");
         _loc2_.subject = "Re: " + _loc3_.subject;
         _loc2_.body = "=================================================\n" + _loc3_.body;
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root.stage);
         UIGlobals.popUpManager.centerPopUp(_loc2_);
         _loc2_.visible = true;
      }
      
      public function onForwardClick(param1:MouseEvent) : void
      {
         var _loc2_:ComposerWindow = createComposer();
         var _loc3_:Message = this.messageList.selectedItem as Message;
         _loc2_.subject = "Fw: " + _loc3_.subject;
         _loc2_.body = "=================================================\n" + _loc3_.body;
         UIGlobals.popUpManager.addPopUp(_loc2_,UIGlobals.root.stage);
         UIGlobals.popUpManager.centerPopUp(_loc2_);
         _loc2_.visible = true;
      }
      
      public function onDeleteClick(param1:MouseEvent) : void
      {
         var _loc2_:Message = null;
         var _loc3_:Object = null;
         if(this.messageList.selectedItem)
         {
            _loc2_ = this.messageList.selectedItem as Message;
            if(!_loc2_.canDelete)
            {
               return;
            }
            _loc3_ = client.createInput();
            _loc3_.id = [_loc2_.id];
            client.service.DeleteMessage(_loc3_);
            this.messages.removeItem(_loc2_);
         }
      }
      
      public function onMarkAllReadClick(param1:MouseEvent) : void
      {
         var _loc2_:Message = null;
         var _loc3_:Object = null;
         if(this.messages.length > 0)
         {
            _loc3_ = client.createInput();
            _loc3_.id = new Array();
            for each(_loc2_ in this.messages)
            {
               if(!_loc2_.is_read)
               {
                  _loc3_.id.push(_loc2_.id);
                  _loc2_.is_read = true;
               }
            }
            client.service.ReadMessage(_loc3_);
         }
      }
      
      public function onDeleteAllClick(param1:MouseEvent) : void
      {
         AlertWindow.show(Asset.getInstanceByName("DELETE_ALL_CONFIRMATION"),Asset.getInstanceByName("CONFIRMATION_REQUIRED"),this,true,{
            "ALERT_WINDOW_YES":this.onDeleteAllConfirmed,
            "ALERT_WINDOW_NO":this.onDeleteAllCancelled
         },false,false,true,true);
      }
      
      public function onDeleteAllConfirmed(param1:Event) : void
      {
         var _loc2_:Message = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(this.messages.length > 0)
         {
            _loc3_ = client.createInput();
            _loc3_.id = [];
            _loc4_ = [];
            for each(_loc2_ in this.messages)
            {
               if(!_loc2_.is_archived)
               {
                  _loc3_.id.push(_loc2_.id);
                  _loc4_.push(_loc2_);
               }
            }
            client.service.DeleteMessage(_loc3_);
            for each(_loc2_ in _loc4_)
            {
               this.messages.removeItem(_loc2_);
            }
            (param1.target as AlertWindow).doClose();
         }
      }
      
      public function onDeleteAllCancelled(param1:Event) : void
      {
         (param1.target as AlertWindow).doClose();
      }
      
      public function onArchiveClick(param1:MouseEvent) : void
      {
         var _loc2_:Message = null;
         var _loc3_:Object = null;
         if(this.messageList.selectedItem)
         {
            _loc2_ = this.messageList.selectedItem as Message;
            _loc3_ = client.createInput();
            _loc3_.id = _loc2_.id;
            client.service.ArchiveMessage(_loc3_);
            this.messageList.busyOverlayed = true;
            enabled = false;
         }
      }
      
      public function onUnarchiveClick(param1:MouseEvent) : void
      {
         var _loc2_:Message = null;
         var _loc3_:Object = null;
         if(this.messageList.selectedItem)
         {
            _loc2_ = this.messageList.selectedItem as Message;
            _loc3_ = client.createInput();
            _loc3_.id = _loc2_.id;
            client.service.UnarchiveMessage(_loc3_);
            this.messageList.busyOverlayed = true;
            enabled = false;
         }
      }
      
      public function onScrollBack(param1:Event) : void
      {
         --this.messageList.startIndex;
      }
      
      public function onScrollForward(param1:Event) : void
      {
         ++this.messageList.startIndex;
      }
      
      private function onMessageLink(param1:TextEvent) : void
      {
         var _loc2_:Array = param1.text.split(/:/);
         _loc2_.unshift(this.messageList.selectedItem as Message);
         dispatchEvent(new ExtendedEvent(LINK,_loc2_));
      }
   }
}
