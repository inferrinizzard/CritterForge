package com.edgebee.atlas.ui.gadgets
{
   import com.adobe.utils.StringUtil;
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.Spacer;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.controls.TextInput;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class InputWindow extends Window
   {
      
      public static const RESULT_OK:String = "ALERT_WINDOW_OK";
      
      public static const RESULT_CANCEL:String = "ALERT_WINDOW_CANCEL";
      
      public static const RESULT_CLOSE:String = "ALERT_WINDOW_CLOSE";
       
      
      public var extraData;
      
      private var _listeners:Object;
      
      private var _defaultText:String = "";
      
      private var _restrict:String = null;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _multiline:Boolean = false;
      
      private var _trim:Boolean = false;
      
      private var _minChars:int = 0;
      
      private var _maxChars:int = 0;
      
      private var _textInputWidth:Number = 100;
      
      public var textArea:TextArea;
      
      public var textInput:TextInput;
      
      public var okBtn:Button;
      
      public var cancelBtn:Button;
      
      public var body;
      
      public var useHtml:Boolean = false;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function InputWindow()
      {
         this._contentLayout = [{
            "CLASS":TextArea,
            "ID":"textArea",
            "minWidth":200
         },{
            "CLASS":Spacer,
            "height":UIGlobals.relativize(10)
         },{
            "CLASS":TextInput,
            "ID":"textInput"
         },{
            "CLASS":Spacer,
            "height":UIGlobals.relativize(10)
         }];
         this._statusLayout = [{
            "CLASS":Button,
            "ID":"okBtn",
            "label":Asset.getInstanceByName("OK"),
            "enabled":false,
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onOkClick"
            }]
         },{
            "CLASS":Button,
            "ID":"cancelBtn",
            "label":Asset.getInstanceByName("CANCEL"),
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onCancelClick"
            }]
         }];
         super();
         centered = true;
      }
      
      public static function create(param1:*, param2:* = null, param3:Boolean = false, param4:Boolean = false, param5:Class = null) : InputWindow
      {
         var _loc6_:InputWindow = null;
         (_loc6_ = new InputWindow()).title = param2;
         if(param5)
         {
            _loc6_.titleIcon = UIUtils.createBitmapIcon(param5,16,16);
         }
         else
         {
            _loc6_.titleIcon = UIUtils.createBitmapIcon(AlertWindow.ErrorIconPng,16,16);
         }
         _loc6_.body = param1;
         _loc6_.showCloseButton = param3;
         _loc6_.useHtml = param4;
         return _loc6_;
      }
      
      public static function show(param1:*, param2:* = null, param3:DisplayObject = null, param4:Boolean = true, param5:Object = null, param6:Boolean = false, param7:Boolean = false, param8:String = null, param9:uint = 0, param10:uint = 0, param11:Boolean = false, param12:Class = null) : InputWindow
      {
         var _loc14_:String = null;
         var _loc13_:InputWindow;
         (_loc13_ = create(param1,param2,param6,param7,param12)).defaultText = param8 == null ? "" : param8;
         _loc13_.minChars = param9;
         _loc13_.maxChars = param10;
         _loc13_.trim = param11;
         if(param5 != null)
         {
            _loc13_._listeners = param5;
            for(_loc14_ in param5)
            {
               _loc13_.addEventListener(_loc14_,param5[_loc14_]);
            }
         }
         if(param3 == null)
         {
            param3 = UIGlobals.root;
         }
         UIGlobals.popUpManager.addPopUp(_loc13_,param3,param4);
         return _loc13_;
      }
      
      override public function doClose() : void
      {
         if(Boolean(this._listeners) && this._listeners.hasOwnProperty(RESULT_CLOSE))
         {
            dispatchEvent(new Event(RESULT_CLOSE));
         }
         else
         {
            this.doParentClose();
         }
      }
      
      public function doParentClose() : void
      {
         super.doClose();
      }
      
      public function onOkClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(RESULT_OK));
         super.doClose();
      }
      
      public function onCancelClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(RESULT_CANCEL));
         super.doClose();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         content.direction = Box.VERTICAL;
         content.horizontalAlign = Box.ALIGN_CENTER;
         content.setStyle("PaddingLeft",5);
         content.setStyle("PaddingRight",5);
         content.setStyle("PaddingTop",5);
         content.setStyle("PaddingBottom",5);
         UIUtils.performLayout(this,this.content,this._contentLayout);
         if(this.body is String || this.body is Asset)
         {
            this.textArea.useHtml = this.useHtml;
            this.textArea.text = this.body;
         }
         else if(this.body is Component)
         {
            this.textArea.visible = false;
            content.addChild(this.body);
         }
         statusBar.horizontalAlign = Box.ALIGN_CENTER;
         statusBar.layoutInvisibleChildren = false;
         statusBar.setStyle("Gap",20);
         UIUtils.performLayout(this,statusBar,this._statusLayout);
         this.okBtn.visible = true;
         this.cancelBtn.visible = showCloseButton;
         this.textInput.width = this.textInputWidth;
         this.textInput.text = this.defaultText;
         this.textInput.restrict = this.restrict;
         this.textInput.displayAsPassword = this.displayAsPassword;
         this.textInput.multiline = this.multiline;
         this.textInput.maxChars = this.maxChars;
         this.textInput.setStyle("FontSize",getStyle("FontSize"));
         this.onTextInputChange(null);
         this.textInput.addEventListener(Event.CHANGE,this.onTextInputChange);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      public function get textInputWidth() : Number
      {
         return this._textInputWidth;
      }
      
      public function set textInputWidth(param1:Number) : void
      {
         this._textInputWidth = param1;
         if(this.textInput)
         {
            this.textInput.width = this.textInputWidth;
         }
      }
      
      public function get defaultText() : String
      {
         return this._defaultText;
      }
      
      public function set defaultText(param1:String) : void
      {
         this._defaultText = param1;
         if(this.textInput)
         {
            this.textInput.text = this._defaultText;
         }
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         this._restrict = param1;
         if(this.textInput)
         {
            this.textInput.restrict = this._restrict;
         }
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         this._displayAsPassword = param1;
         if(this.textInput)
         {
            this.textInput.displayAsPassword = param1;
         }
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._multiline = param1;
         if(this.textInput)
         {
            this.textInput.multiline = param1;
         }
      }
      
      public function get trim() : Boolean
      {
         return this._trim;
      }
      
      public function set trim(param1:Boolean) : void
      {
         this._trim = param1;
      }
      
      public function get minChars() : int
      {
         return this._minChars;
      }
      
      public function set minChars(param1:int) : void
      {
         this._minChars = param1;
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         this._maxChars = param1;
         if(this.textInput)
         {
            this.textInput.maxChars = param1;
         }
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onOkClick(null);
         }
      }
      
      private function onTextInputChange(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.trim)
         {
            _loc2_ = StringUtil.trim(this.textInput.text);
         }
         else
         {
            _loc2_ = this.textInput.text;
         }
         this.okBtn.enabled = _loc2_.length >= this.minChars;
      }
   }
}
