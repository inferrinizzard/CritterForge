package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.events.ExceptionEvent;
   import com.edgebee.atlas.events.ServiceEvent;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.LoggingBox;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import com.edgebee.atlas.util.Utils;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class CheatWindow extends Window
   {
       
      
      private var _alert:com.edgebee.atlas.ui.gadgets.AlertWindow;
      
      public var cmdTxt:TextInput;
      
      public var textArea:LoggingBox;
      
      public var submitBtn:Button;
      
      private var _lastCommands:Array;
      
      private var _commandIndex:int = -1;
      
      private var _statusBarLayout:Array;
      
      private var _contentLayout:Array;
      
      public function CheatWindow()
      {
         this._lastCommands = [];
         this._statusBarLayout = [{
            "CLASS":TextInput,
            "ID":"cmdTxt",
            "percentWidth":1,
            "multiline":false
         },{
            "CLASS":Button,
            "ID":"submitBtn",
            "label":Asset.getInstanceByName("SUBMIT"),
            "enabled":true,
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onSubmitClick"
            }]
         }];
         this._contentLayout = [{
            "CLASS":LoggingBox,
            "ID":"textArea",
            "percentWidth":1,
            "percentHeight":1,
            "STYLES":{
               "BackgroundColor":3355443,
               "BackgroundAlpha":1
            }
         }];
         super();
         rememberPositionId = "CheatWindow";
         visible = false;
         UIGlobals.root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         client.service.addEventListener("CheatCommand",this.onCommandComplete);
      }
      
      override protected function doSetVisible(param1:Boolean) : void
      {
         super.doSetVisible(param1);
         if(param1)
         {
            this.textArea.print(Utils.htmlWrap("Type <b>\"help\"</b> to see available commands.",null,11206570,0));
            this.textArea.flush();
         }
      }
      
      override public function doClose() : void
      {
         visible = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.horizontalAlign = Box.ALIGN_LEFT;
         content.layoutInvisibleChildren = false;
         title = Asset.getInstanceByName("CHEATS");
         UIUtils.performLayout(this,content,this._contentLayout);
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.setStyle("Gap",5);
         UIUtils.performLayout(this,statusBar,this._statusBarLayout);
      }
      
      public function dispose() : void
      {
         UIGlobals.root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         client.service.removeEventListener("CheatCommand",this.onCommandComplete);
      }
      
      private function update() : void
      {
         invalidateDisplayList();
      }
      
      private function doSubmit() : void
      {
         var _loc1_:String = this.cmdTxt.text;
         var _loc2_:Object = client.createInput();
         _loc2_.command = _loc1_;
         if(this._commandIndex == -1 || _loc1_ != this._lastCommands[this._commandIndex])
         {
            this._commandIndex = -1;
            this._lastCommands.push(_loc1_);
         }
         client.service.addEventListener(ExceptionEvent.EXCEPTION,this.onException);
         client.service.CheatCommand(_loc2_);
         this.cmdTxt.text = "";
         this.textArea.print(Utils.htmlWrap("Sent command \"<b>" + _loc1_ + "</b>\".",null,16777215));
         this.textArea.flush();
      }
      
      public function onSubmitClick(param1:Event) : void
      {
         if(this.cmdTxt.text.length > 0)
         {
            this.doSubmit();
         }
      }
      
      protected function onException(param1:ExceptionEvent) : void
      {
         param1.handled = true;
         client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
         this.textArea.print(Utils.htmlWrap(param1.exception.render,"courier new",16755370,10));
         this.textArea.flush();
      }
      
      public function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.target != this.cmdTxt.textField)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onSubmitClick(null);
         }
         else if(this._lastCommands.length > 0)
         {
            if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN)
            {
               if(param1.keyCode == Keyboard.UP)
               {
                  if(this._commandIndex < 0)
                  {
                     this._commandIndex = this._lastCommands.length - 1;
                  }
                  else if(this._commandIndex > 0)
                  {
                     --this._commandIndex;
                  }
               }
               else if(param1.keyCode == Keyboard.DOWN)
               {
                  if(this._commandIndex >= 0)
                  {
                     ++this._commandIndex;
                  }
                  if(this._commandIndex >= this._lastCommands.length)
                  {
                     this._commandIndex = -1;
                  }
               }
               if(this._commandIndex >= 0)
               {
                  this.cmdTxt.text = this._lastCommands[this._commandIndex];
                  this.cmdTxt.textField.setSelection(this.cmdTxt.text.length - 1,this.cmdTxt.text.length - 1);
               }
               else
               {
                  this.cmdTxt.text = "";
               }
            }
         }
      }
      
      protected function onCommandComplete(param1:ServiceEvent) : void
      {
         client.service.removeEventListener(ExceptionEvent.EXCEPTION,this.onException);
         if(param1.data.hasOwnProperty("events"))
         {
            client.handleGameEvents(param1.data.events);
         }
         if(param1.data.hasOwnProperty("text"))
         {
            if(param1.data.text is Array)
            {
               this.textArea.print(Utils.htmlWrap(param1.data.text.join("<br>"),null,11206570));
            }
            else
            {
               this.textArea.print(Utils.htmlWrap(param1.data.text,null,11206570));
            }
         }
         else
         {
            this.textArea.print(Utils.htmlWrap("Command complete.",null,11206570));
         }
         this.textArea.flush();
      }
   }
}
