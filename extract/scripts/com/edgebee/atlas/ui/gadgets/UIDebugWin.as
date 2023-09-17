package com.edgebee.atlas.ui.gadgets
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.ui.containers.Box;
   import com.edgebee.atlas.ui.containers.List;
   import com.edgebee.atlas.ui.containers.Window;
   import com.edgebee.atlas.ui.controls.ScrollBar;
   import com.edgebee.atlas.ui.utils.UIUtils;
   import flash.utils.describeType;
   
   public class UIDebugWin extends Window
   {
       
      
      private var _currentTitle:String = "UI Debug Window";
      
      private var _currentObj:Object;
      
      private var _stack:Array;
      
      private var _titleStack:Array;
      
      private var _objStack:Array;
      
      private var _members:ArrayCollection;
      
      public var memberList:List;
      
      private var _contentLayout:Array;
      
      public function UIDebugWin()
      {
         this._stack = [];
         this._titleStack = [];
         this._objStack = [];
         this._members = new ArrayCollection();
         this._contentLayout = [{
            "CLASS":Box,
            "percentWidth":1,
            "percentHeight":1,
            "layoutInvisibleChildren":false,
            "CHILDREN":[{
               "CLASS":List,
               "ID":"memberList",
               "percentWidth":1,
               "percentHeight":1,
               "renderer":MemberDisplay,
               "selectable":false,
               "EVENTS":[{
                  "TYPE":MemberDisplay.SELECTED,
                  "LISTENER":"onMemberSelected"
               },{
                  "TYPE":"MODIFIY_ENTRY",
                  "LISTENER":"onModifyEntry"
               }]
            },{
               "CLASS":ScrollBar,
               "width":16,
               "percentHeight":1,
               "scrollable":"{memberList}"
            }]
         }];
         super();
         width = 300;
         height = 400;
         draggable = true;
         setStyle("BackgroundAlpha",0.4);
         setStyle("Skin",DebugWinSkin);
      }
      
      public function reset() : void
      {
         this._stack = [];
         this._titleStack = [];
         this._members.source = [];
         this._currentTitle = "UI Debug Window";
      }
      
      public function addMember(param1:Object) : void
      {
         this._members.addItem(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         UIUtils.performLayout(this,content,this._contentLayout);
         this.memberList.dataProvider = this._members;
         title = this._currentTitle;
      }
      
      private function push() : void
      {
         this._stack.push(this._members.source);
         this._titleStack.push(this._currentTitle);
         this._objStack.push(this._currentObj);
         this._members.source = [];
         this._currentObj = null;
         this.addMember({
            "name":"..",
            "value":"..",
            "obj":null
         });
      }
      
      private function pop() : void
      {
         this._members.source = this._stack.pop();
         this._currentTitle = this._titleStack.pop();
         this._currentObj = this._objStack.pop();
         title = this._currentTitle;
      }
      
      public function onMemberSelected(param1:ExtendedEvent) : void
      {
         var _loc4_:XML = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         param1.stopImmediatePropagation();
         if(param1.data.name == "..")
         {
            this.pop();
            return;
         }
         var _loc2_:XML = describeType(param1.data.obj);
         var _loc3_:XMLList = _loc2_.accessor;
         if(!_loc3_.length())
         {
            return;
         }
         this.push();
         this._currentObj = param1.data.obj;
         var _loc5_:String = _loc2_.@name;
         var _loc6_:String = _loc2_.@base;
         if(param1.data.hasOwnProperty("base"))
         {
            _loc5_ = String(param1.data.base);
            _loc11_ = 0;
            for each(_loc4_ in _loc2_.extendsClass)
            {
               _loc11_++;
               if(_loc4_.@type == _loc5_)
               {
                  break;
               }
            }
            if(_loc11_ < _loc2_.extendsClass.length())
            {
               _loc6_ = _loc2_.extendsClass[_loc11_].@type;
            }
            else
            {
               _loc6_ = "";
            }
         }
         var _loc7_:Array = _loc5_.split("::");
         title = this._currentTitle = _loc7_[_loc7_.length - 1];
         if(_loc6_)
         {
            this.addMember({
               "name":"Base Class",
               "value":_loc6_,
               "obj":param1.data.obj,
               "base":_loc6_
            });
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.@declaredBy == _loc5_)
            {
               if(_loc4_.@access != "writeonly")
               {
                  _loc8_ = _loc4_.@name;
                  if(_loc10_ = param1.data.obj[_loc8_])
                  {
                     _loc9_ = String(_loc10_.toString());
                  }
                  else
                  {
                     _loc9_ = "null";
                  }
                  this.addMember({
                     "name":_loc8_,
                     "value":_loc9_,
                     "obj":_loc10_,
                     "access":_loc4_.@access,
                     "type":_loc4_.@type
                  });
               }
            }
         }
      }
      
      public function onModifyEntry(param1:ExtendedEvent) : void
      {
         var _loc2_:String = String(param1.data.member.name);
         var _loc3_:String = String(param1.data.member.type);
         var _loc4_:String;
         var _loc5_:* = _loc4_ = String(param1.data.newValue);
         if(_loc3_ == "Number")
         {
            _loc5_ = Number(_loc4_);
         }
         else if(_loc3_ == "Boolean")
         {
            _loc5_ = Boolean(_loc4_);
         }
         this._currentObj[_loc2_] = _loc5_;
      }
   }
}

import com.edgebee.atlas.events.ExtendedEvent;
import com.edgebee.atlas.ui.Listable;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.TextInput;
import com.edgebee.atlas.ui.utils.UIUtils;
import com.edgebee.atlas.util.Utils;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

class MemberDisplay extends Box implements Listable
{
   
   public static const SELECTED:String = "SELECTED";
    
   
   private var _member:Object;
   
   public var nameLabel:Label;
   
   public var valueLabel:Label;
   
   public var valueInput:TextInput;
   
   private var _contentLayout:Array;
   
   public function MemberDisplay()
   {
      this._contentLayout = [{
         "CLASS":Label,
         "ID":"nameLabel",
         "percentWidth":0.5,
         "useHtml":true
      },{
         "CLASS":Label,
         "ID":"valueLabel",
         "percentWidth":0.5,
         "visible":false,
         "useHtml":true
      }];
      super();
      useMouseScreen = true;
      layoutInvisibleChildren = false;
      addEventListener(MouseEvent.CLICK,this.onMouseClick);
      visible = false;
      height = 20;
   }
   
   public function get member() : Object
   {
      return this._member;
   }
   
   public function set member(param1:Object) : void
   {
      var _loc2_:String = null;
      var _loc3_:String = null;
      this._member = param1;
      if(this._member)
      {
         _loc2_ = String(this._member.name);
         _loc3_ = String(this._member.value);
         if(this._member.hasOwnProperty("base"))
         {
            _loc2_ = Utils.htmlWrap(_loc2_,null,16777215,10,false,true);
            _loc3_ = Utils.htmlWrap(_loc3_,null,16777215,8,false,true);
         }
         else
         {
            _loc2_ = Utils.htmlWrap(_loc2_,null,16777215,10);
            _loc3_ = Utils.htmlWrap(_loc3_,null,16777215,8);
         }
         this.nameLabel.text = _loc2_;
         if(Boolean(this._member.hasOwnProperty("access")) && this._member.access == "readwrite" && (this._member.type == "Number" || this._member.type == "String" || this._member.type == "Boolean"))
         {
            this.valueInput.visible = true;
            this.valueLabel.visible = false;
            this.valueInput.htmlText = _loc3_;
         }
         else
         {
            this.valueLabel.visible = true;
            this.valueInput.visible = false;
            this.valueLabel.text = _loc3_;
         }
         visible = true;
      }
      else
      {
         visible = false;
      }
   }
   
   public function get listElement() : Object
   {
      return this.member;
   }
   
   public function set listElement(param1:Object) : void
   {
      this.member = param1;
   }
   
   public function get selected() : Boolean
   {
      return false;
   }
   
   public function set selected(param1:Boolean) : void
   {
   }
   
   public function get highlighted() : Boolean
   {
      return false;
   }
   
   public function set highlighted(param1:Boolean) : void
   {
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      UIUtils.performLayout(this,this,this._contentLayout);
      this.valueInput = new TextInput();
      this.valueInput.setStyle("Skin",TextInputSkin);
      this.valueInput.percentWidth = 0.5;
      this.valueInput.height = 20;
      this.valueInput.visible = false;
      this.valueInput.addEventListener(KeyboardEvent.KEY_UP,this.onKeyDown);
      addChild(this.valueInput);
   }
   
   private function onMouseClick(param1:MouseEvent) : void
   {
      dispatchEvent(new ExtendedEvent(SELECTED,this.member,true));
   }
   
   private function onKeyDown(param1:KeyboardEvent) : void
   {
      if(param1.keyCode == 13)
      {
         dispatchEvent(new ExtendedEvent("MODIFIY_ENTRY",{
            "member":this._member,
            "newValue":this.valueInput.text
         },true));
      }
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.containers.Box;
import com.edgebee.atlas.ui.controls.BitmapComponent;
import com.edgebee.atlas.ui.controls.Button;
import com.edgebee.atlas.ui.controls.Label;
import com.edgebee.atlas.ui.controls.SWFLoader;
import com.edgebee.atlas.ui.controls.Spacer;
import com.edgebee.atlas.ui.skins.CloseButtonSkin;
import com.edgebee.atlas.ui.skins.WindowSkinBase;
import com.edgebee.atlas.ui.utils.UIUtils;
import flash.display.Bitmap;
import flash.events.MouseEvent;

class DebugWinSkin extends WindowSkinBase
{
    
   
   private var _titleBar:Box;
   
   public var titleIcon:BitmapComponent;
   
   public var titleIconSWF:SWFLoader;
   
   public var titleLbl:Label;
   
   public var closeBtn:Button;
   
   private var _titleBarLayout:Array;
   
   public function DebugWinSkin(param1:Component)
   {
      this._titleBarLayout = [{
         "CLASS":Box,
         "verticalAlign":Box.ALIGN_MIDDLE,
         "layoutInvisibleChildren":false,
         "useMouseScreen":true,
         "CHILDREN":[{
            "CLASS":BitmapComponent,
            "ID":"titleIcon",
            "width":25,
            "height":25,
            "visible":false
         },{
            "CLASS":SWFLoader,
            "ID":"titleIconSWF",
            "width":25,
            "height":25,
            "visible":false
         },{
            "CLASS":Label,
            "ID":"titleLbl"
         },{
            "CLASS":Spacer,
            "percentWidth":1
         },{
            "CLASS":Button,
            "width":20,
            "height":20,
            "ID":"closeBtn",
            "STYLES":{"Skin":CloseButtonSkin},
            "EVENTS":[{
               "TYPE":MouseEvent.CLICK,
               "LISTENER":"onCloseButtonClick"
            }]
         }]
      }];
      super(param1);
   }
   
   override public function get styleClassName() : String
   {
      return "DebugWinSkin";
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      this._titleBar = new Box();
      this._titleBar.name = "WindowSkin._titleBar";
      this._titleBar.spreadProportionality = false;
      UIUtils.performLayout(this,this._titleBar,this._titleBarLayout);
      this.titleLbl.setStyle("FontColor",getStyle("WindowTitle.FontColor"));
      this.titleLbl.setStyle("FontWeight",getStyle("WindowTitle.FontWeight"));
      this.titleLbl.setStyle("FontSize",getStyle("WindowTitle.FontSize"));
      _layoutBox.addChild(this._titleBar);
      _layoutBox.addChild(window.content);
      _layoutBox.addChild(window.statusBar);
      window.setDragComponent(this._titleBar);
      this.refreshTitle(window.title);
      this.refreshIcon(window.titleIcon);
      this.refreshCloseButtonVisibility(window.showCloseButton);
   }
   
   override protected function refreshTitle(param1:*) : void
   {
      this.titleLbl.text = param1;
   }
   
   override protected function refreshIcon(param1:*) : void
   {
      if(param1 is Bitmap)
      {
         this.titleIcon.bitmap = param1 as Bitmap;
         this.titleIcon.visible = true;
      }
      else
      {
         this.titleIconSWF.source = param1 as String;
      }
   }
   
   override protected function refreshCloseButtonVisibility(param1:Boolean) : void
   {
      this.closeBtn.visible = param1;
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      graphics.beginFill(component.getStyle("BackgroundColor"),component.getStyle("BackgroundAlpha"));
      graphics.drawRect(0,0,param1,param2);
      graphics.endFill();
   }
   
   public function onCloseButtonClick(param1:MouseEvent) : void
   {
      window.doClose();
   }
}

import com.edgebee.atlas.ui.Component;
import com.edgebee.atlas.ui.controls.TextInput;
import com.edgebee.atlas.ui.skins.Skin;
import flash.events.FocusEvent;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

class TextInputSkin extends Skin
{
    
   
   private var _textField:TextField;
   
   protected var _paddingLeft:Number;
   
   protected var _paddingRight:Number;
   
   protected var _paddingTop:Number;
   
   protected var _paddingBottom:Number;
   
   protected var _focused:Boolean;
   
   public function TextInputSkin(param1:Component)
   {
      super(param1);
   }
   
   public function get textInput() : TextInput
   {
      return component as TextInput;
   }
   
   public function get textField() : TextField
   {
      return this._textField;
   }
   
   override public function get layoutChildren() : Boolean
   {
      return true;
   }
   
   override protected function setEnabled(param1:Boolean) : void
   {
      super.setEnabled(param1);
      if(this._textField)
      {
         if(enabled)
         {
            this._textField.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn,false,0,true);
            this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
         }
         else
         {
            this._textField.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
            this._textField.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         }
      }
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      setStyle("BorderThickness",1);
      setStyle("BorderColor",16777215);
      setStyle("BackgroundAlpha",0);
      this._textField = new TextField();
      this._textField.antiAliasType = AntiAliasType.ADVANCED;
      this._textField.gridFitType = GridFitType.PIXEL;
      this._textField.type = TextFieldType.INPUT;
      this._textField.multiline = this.textInput.multiline;
      this._textField.maxChars = this.textInput.maxChars;
      this._textField.displayAsPassword = this.textInput.displayAsPassword;
      this._textField.restrict = Boolean(enabled) && Boolean(this.textInput.editable) ? null : "";
      if(enabled)
      {
         this._textField.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn,false,0,true);
         this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
      }
      this._textField.defaultTextFormat = new TextFormat(getStyle("FontFamily"),8,getStyle("FontColor"),getStyle("FontWeight") == "bold",getStyle("FontStyle") == "italic",getStyle("FontDecoration") == "italic");
      addChild(this._textField);
   }
   
   override protected function measure() : void
   {
      var _loc1_:Array = null;
      var _loc2_:String = null;
      super.measure();
      this._paddingLeft = 1;
      this._paddingRight = 1;
      this._paddingTop = 1;
      this._paddingBottom = 1;
      this.textField.width = component.width - (this._paddingLeft + this._paddingRight);
      if(component.percentWidth == 0)
      {
         measuredWidth = this.textField.width + this._paddingLeft + this._paddingRight;
      }
      if(component.percentHeight == 0)
      {
         _loc1_ = [this.textField.selectionBeginIndex,this.textField.selectionEndIndex];
         _loc2_ = String(this.textField.text);
         this.textField.text = "Wj";
         measuredHeight = 20;
         this.textField.text = _loc2_;
         this.textField.setSelection(_loc1_[0],_loc1_[1]);
      }
      if(border)
      {
         border.invalidateSize();
      }
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      this._paddingLeft = 1;
      this._paddingRight = 1;
      this._paddingTop = 1;
      this._paddingBottom = 1;
      this.textField.height = component.height - (this._paddingTop + this._paddingBottom);
      this._textField.y = this._paddingTop;
      this._textField.x = this._paddingLeft;
      filters = null;
   }
   
   private function onFocusIn(param1:FocusEvent) : void
   {
      this._focused = true;
      invalidateDisplayList();
   }
   
   private function onFocusOut(param1:FocusEvent) : void
   {
      this._focused = false;
      invalidateDisplayList();
   }
}
