package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.l10n.Asset;
   import com.edgebee.atlas.interfaces.IKbNavigatable;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.Button;
   import com.edgebee.atlas.ui.controls.TextArea;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   
   public class AlertWindow extends Window
   {
      
      public static var WarningIconPng:Class = AlertWindow_WarningIconPng;
      
      public static var ErrorIconPng:Class = AlertWindow_ErrorIconPng;
      
      public static const RESULT_YES:String = "ALERT_WINDOW_YES";
      
      public static const RESULT_NO:String = "ALERT_WINDOW_NO";
      
      public static const RESULT_OK:String = "ALERT_WINDOW_OK";
      
      public static const RESULT_CANCEL:String = "ALERT_WINDOW_CANCEL";
      
      public static const RESULT_CLOSE:String = "ALERT_WINDOW_CLOSE";
      
      public static const YES_BUTTON:int = 1;
      
      public static const NO_BUTTON:int = 2;
      
      public static const OK_BUTTON:int = 4;
      
      public static const CANCEL_BUTTON:int = 8;
       
      
      public var extraData;
      
      private var _listeners:Object;
      
      public var textArea:TextArea;
      
      public var btnFlags:int;
      
      public var okBtn:Button;
      
      public var yesBtn:Button;
      
      public var noBtn:Button;
      
      public var cancelBtn:Button;
      
      public var body;
      
      public var useHtml:Boolean = false;
      
      private var _contentLayout:Array;
      
      private var _statusLayout:Array;
      
      public function AlertWindow()
      {
         this._contentLayout = [{
            "CLASS":TextArea,
            "ID":"textArea",
            "minWidth":UIGlobals.relativize(250),
            "STYLES":{
               "FontSize":UIGlobals.getStyle("LargeFontSize",UIGlobals.relativize(20)),
               "Alignment":TextFormatAlign.CENTER
            }
         }];
         this._statusLayout = [{
            "CLASS":Button,
            "ID":"okBtn",
            "label":Asset.getInstanceByName("OK"),
            "STYLES":{"FontSize":UIGlobals.getStyle("MediumFontSize",UIGlobals.relativize(18))},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onOkClick"
            }]
         },{
            "CLASS":Button,
            "ID":"yesBtn",
            "label":Asset.getInstanceByName("YES"),
            "STYLES":{"FontSize":UIGlobals.getStyle("MediumFontSize",UIGlobals.relativize(18))},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onYesClick"
            }]
         },{
            "CLASS":Button,
            "ID":"noBtn",
            "label":Asset.getInstanceByName("NO"),
            "STYLES":{"FontSize":UIGlobals.getStyle("MediumFontSize",UIGlobals.relativize(18))},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onNoClick"
            }]
         },{
            "CLASS":Button,
            "ID":"cancelBtn",
            "label":Asset.getInstanceByName("CANCEL"),
            "STYLES":{"FontSize":UIGlobals.getStyle("MediumFontSize",UIGlobals.relativize(18))},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onCancelClick"
            }]
         }];
         super();
         centered = true;
      }
      
      public static function create(param1:*, param2:* = null, param3:Boolean = false, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Class = null) : AlertWindow
      {
         var _loc10_:AlertWindow = null;
         (_loc10_ = new AlertWindow()).title = param2;
         if(param9)
         {
            _loc10_.titleIcon = UIUtils.createBitmapIcon(param9,16,16);
         }
         else
         {
            _loc10_.titleIcon = UIUtils.createBitmapIcon(ErrorIconPng,16,16);
         }
         _loc10_.btnFlags = 0;
         _loc10_.body = param1;
         if(param4)
         {
            _loc10_.btnFlags |= OK_BUTTON;
         }
         if(param5)
         {
            _loc10_.btnFlags |= YES_BUTTON;
         }
         if(param6)
         {
            _loc10_.btnFlags |= NO_BUTTON;
         }
         if(param7)
         {
            _loc10_.btnFlags |= CANCEL_BUTTON;
         }
         _loc10_.showCloseButton = param3;
         _loc10_.useHtml = param8;
         return _loc10_;
      }
      
      public static function show(param1:*, param2:* = null, param3:DisplayObject = null, param4:Boolean = true, param5:Object = null, param6:Boolean = false, param7:Boolean = true, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Class = null) : AlertWindow
      {
         var _loc14_:String = null;
         var _loc13_:AlertWindow = create(param1,param2,param6,param7,param8,param9,param10,param11,param12);
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
         UIGlobals.popUpManager.centerPopUp(_loc13_,null,false);
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
      
      public function onYesClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(RESULT_YES));
         super.doClose();
      }
      
      public function onNoClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(RESULT_NO));
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
         var _loc1_:IKbNavigatable = null;
         var _loc2_:IKbNavigatable = null;
         super.createChildren();
         content.direction = Box.VERTICAL;
         content.horizontalAlign = Box.ALIGN_CENTER;
         content.maxWidth = 2 * UIGlobals.root.width / 3;
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
         this.okBtn.visible = Boolean(this.btnFlags & OK_BUTTON);
         this.yesBtn.visible = Boolean(this.btnFlags & YES_BUTTON);
         this.noBtn.visible = Boolean(this.btnFlags & NO_BUTTON);
         this.cancelBtn.visible = Boolean(this.btnFlags & CANCEL_BUTTON);
         if(Boolean(this.btnFlags & OK_BUTTON))
         {
            _loc1_ = this.okBtn;
            _loc2_ = this.okBtn;
         }
         if(Boolean(this.btnFlags & YES_BUTTON))
         {
            if(_loc2_)
            {
               _loc2_.kbLink(this.yesBtn,Keyboard.RIGHT);
               _loc2_ = this.yesBtn;
            }
            else
            {
               _loc1_ = this.yesBtn;
               _loc2_ = this.yesBtn;
            }
         }
         if(Boolean(this.btnFlags & NO_BUTTON))
         {
            if(_loc2_)
            {
               _loc2_.kbLink(this.noBtn,Keyboard.RIGHT);
               _loc2_ = this.noBtn;
            }
            else
            {
               _loc1_ = this.noBtn;
               _loc2_ = this.noBtn;
            }
         }
         if(Boolean(this.btnFlags & CANCEL_BUTTON))
         {
            if(_loc2_)
            {
               _loc2_.kbLink(this.cancelBtn,Keyboard.RIGHT);
               _loc2_ = this.cancelBtn;
            }
            else
            {
               _loc1_ = this.cancelBtn;
               _loc2_ = this.cancelBtn;
            }
         }
         if(_loc1_)
         {
            kbFirstNode = _loc1_;
            _loc1_.kbAnchor(this,Keyboard.LEFT);
            _loc2_.kbAnchor(this,Keyboard.RIGHT);
         }
      }
   }
}
