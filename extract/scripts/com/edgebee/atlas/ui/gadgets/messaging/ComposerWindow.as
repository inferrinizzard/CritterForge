package com.edgebee.atlas.ui.gadgets.messaging
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Label;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.gadgets.AlertWindow;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   
   public class ComposerWindow extends Window
   {
       
      
      private var _recipients:String;
      
      private var _subject:String;
      
      private var _body:String;
      
      public var sendBtn:Button;
      
      public var recipientsTextInput:TextInput;
      
      public var subjectTextInput:TextInput;
      
      public var bodyTextInput:TextInput;
      
      public var charCount:Label;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function ComposerWindow()
      {
         this._statusBarLayout = [];
         this._contentLayout = [{
            "CLASS":Box,
            "percentWidth":1,
            "verticalAlign":Box.ALIGN_MIDDLE,
            "CHILDREN":[{
               "CLASS":Button,
               "ID":"sendBtn",
               "icon":UIUtils.createBitmapIcon(InboxWindow.ComposeIconPng,16,16),
               "label":Asset.getInstanceByName("SEND"),
               "toolTip":Asset.getInstanceByName("SEND"),
               "STYLES":{"FontSize":10},
               "EVENTS":[{
                  "TYPE":MouseEvent.CLICK,
                  "LISTENER":"onSendClick"
               }]
            }]
         },{
            "CLASS":Box,
            "percentWidth":1,
            "direction":Box.VERTICAL,
            "CHILDREN":[{
               "CLASS":Label,
               "text":Asset.getInstanceByName("RECIPIENTS")
            },{
               "CLASS":TextInput,
               "ID":"recipientsTextInput",
               "percentWidth":1,
               "multiline":true
            },{
               "CLASS":Spacer,
               "height":3
            },{
               "CLASS":Label,
               "text":Asset.getInstanceByName("SUBJECT")
            },{
               "CLASS":TextInput,
               "ID":"subjectTextInput",
               "percentWidth":1,
               "multiline":true
            },{
               "CLASS":Spacer,
               "height":5
            },{
               "CLASS":TextInput,
               "ID":"bodyTextInput",
               "maxChars":768,
               "percentWidth":1,
               "percentHeight":1,
               "multiline":true,
               "EVENTS":[{
                  "TYPE":Event.CHANGE,
                  "LISTENER":"onBodyChange"
               }]
            },{
               "CLASS":Spacer,
               "height":3
            },{
               "CLASS":Box,
               "percentWidth":1,
               "horizontalAlign":Box.ALIGN_RIGHT,
               "CHILDREN":[{
                  "CLASS":Label,
                  "ID":"charCount",
                  "STYLES":{"FontSize":10}
               }]
            }]
         }];
         super();
         filters = [new BlurFilter(0,0)];
         draggable = true;
         super.visible = false;
         client.service.addEventListener("SendMessage",this.onSendMessage);
      }
      
      public function set recipients(param1:String) : void
      {
         this._recipients = param1;
      }
      
      public function set subject(param1:String) : void
      {
         this._subject = param1;
      }
      
      public function set body(param1:String) : void
      {
         this._body = param1;
      }
      
      override public function doClose() : void
      {
         super.doClose();
         client.service.removeEventListener("SendMessage",this.onSendMessage);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.layoutInvisibleChildren = false;
         content.setStyle("Gap",5);
         title = Asset.getInstanceByName("COMPOSE");
         titleIcon = UIUtils.createBitmapIcon(InboxWindow.ComposeIconPng,16,16);
         UIUtils.performLayout(this,content,this._contentLayout);
         if(this._recipients)
         {
            this.recipientsTextInput.text = this._recipients;
         }
         if(this._subject)
         {
            this.subjectTextInput.text = this._subject;
         }
         if(this._body)
         {
            if(this._body.length > 1000)
            {
               this._body = this._body.slice(0,1000);
            }
            this.bodyTextInput.text = this._body;
         }
         this.onBodyChange(null);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      private function update() : void
      {
         invalidateDisplayList();
      }
      
      private function onSendMessage(param1:ServiceEvent) : void
      {
         var _loc2_:String = null;
         if(param1.data.success)
         {
            this.doClose();
         }
         else
         {
            _loc2_ = Asset.getInstanceByName("INVALID_MAIL_REICPIENT_TEXT").value;
            _loc2_ = Utils.formatString(_loc2_,{"invalids":param1.data.invalid_recipients.join(", ")});
            AlertWindow.show(_loc2_,Asset.getInstanceByName("INVALID_MAIL_REICPIENT_TITLE"),this,true,null,true,false);
         }
         enabled = true;
      }
      
      private function onExeption(param1:ExceptionEvent) : void
      {
         if(param1.method == "SendMessage" && param1.exception.cls == "CannotInteract")
         {
            client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onExeption);
            this.doClose();
            enabled = true;
         }
      }
      
      public function onSendClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = client.createInput();
         _loc2_.recipients = this.recipientsTextInput.text.split(/,/);
         _loc2_.subject = this.subjectTextInput.text;
         _loc2_.body = this.bodyTextInput.text;
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onExeption);
         client.service.SendMessage(_loc2_);
         enabled = false;
      }
      
      public function onBodyChange(param1:Event) : void
      {
         this.charCount.text = this.bodyTextInput.text.length.toString() + "/768";
      }
   }
}
