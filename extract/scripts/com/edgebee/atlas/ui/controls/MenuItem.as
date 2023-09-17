package com.edgebee.atlas.ui.controls
{
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.Listable;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.containers.Menu;
   import com.edgebee.atlas.ui.containers.SubMenu;
   import com.edgebee.atlas.ui.skins.*;
   import com.edgebee.atlas.util.Timer;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class MenuItem extends Component implements Listable
   {
       
      
      public var menu:Menu;
      
      public var icon:String;
      
      public var type:String;
      
      public var selectData:Object;
      
      public var subMenu:SubMenu;
      
      private var _menuItemInfo:Object;
      
      private var _mouseDown:Boolean;
      
      private var _skin:Skin;
      
      private var _label;
      
      private var _selected:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _overTimer:Timer;
      
      public function MenuItem(param1:Menu)
      {
         this._overTimer = new Timer(500);
         super();
         this.menu = param1;
         useMouseScreen = true;
         UIGlobals.root.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      override protected function setEnabled(param1:Boolean) : void
      {
         super.setEnabled(param1);
         if(enabled)
         {
            colorMatrix.reset();
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         else
         {
            colorMatrix.saturation = -100;
            colorMatrix.brightness = -5;
            colorMatrix.contrast = -50;
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
      }
      
      public function get listElement() : Object
      {
         return this._menuItemInfo;
      }
      
      public function set listElement(param1:Object) : void
      {
         this._menuItemInfo = param1;
         if(this._menuItemInfo)
         {
            if(this._menuItemInfo.hasOwnProperty(Menu.ENABLED))
            {
               enabled = this._menuItemInfo[Menu.ENABLED];
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.LABEL))
            {
               this.label = this._menuItemInfo[Menu.LABEL];
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.ICON))
            {
               this.icon = this._menuItemInfo[Menu.ICON];
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.TYPE))
            {
               this.type = this._menuItemInfo[Menu.TYPE];
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.SELECT_DATA))
            {
               this.selectData = this._menuItemInfo[Menu.SELECT_DATA];
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.TOOLTIP))
            {
               if(this._menuItemInfo[Menu.TOOLTIP] != null)
               {
                  toolTip = this._menuItemInfo[Menu.TOOLTIP];
               }
            }
            if(this._menuItemInfo.hasOwnProperty(Menu.SUB_MENUS))
            {
               this.subMenu = new SubMenu(this.menu,this._menuItemInfo[Menu.SUB_MENUS] as Array,this);
               this._overTimer.addEventListener(TimerEvent.TIMER,this.toggleSubMenu);
            }
         }
         else
         {
            this.label = null;
            this.icon = null;
            this.type = null;
            this.selectData = null;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this._skin.invalidateDisplayList();
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         if(enabled && Boolean(this.subMenu))
         {
            if(param1)
            {
               this._overTimer.start();
            }
            else
            {
               this._overTimer.stop();
            }
         }
         this._skin.invalidateDisplayList();
      }
      
      override public function get layoutChildren() : Boolean
      {
         return true;
      }
      
      public function get label() : *
      {
         return this._label;
      }
      
      public function set label(param1:*) : void
      {
         this._label = param1;
      }
      
      override public function get styleClassName() : String
      {
         return "MenuItem";
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._mouseDown = true;
      }
      
      private function onStageMouseUp(param1:MouseEvent) : void
      {
         this._mouseDown = false;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(this._mouseDown)
         {
            this._mouseDown = false;
            if(this.subMenu)
            {
               this.toggleSubMenu(param1);
               param1.stopImmediatePropagation();
            }
            else
            {
               this.menu.triggerMenuItem(this.selectData);
            }
         }
      }
      
      private function onMouseRollOver(param1:MouseEvent) : void
      {
         this.highlighted = true;
      }
      
      private function onMouseRollOut(param1:MouseEvent) : void
      {
         this.highlighted = false;
      }
      
      private function toggleSubMenu(param1:*) : void
      {
         var _loc2_:Point = null;
         var _loc3_:* = undefined;
         this._overTimer.stop();
         if(this.subMenu.popped)
         {
            this.selected = false;
            this.subMenu.hide();
         }
         else
         {
            this.selected = true;
            _loc2_ = new Point(width + 1,0);
            _loc2_ = localToGlobal(_loc2_);
            this.subMenu.show(_loc2_.x,_loc2_.y);
            _loc3_ = getStyle("ClickSound",null);
            UIGlobals.playSound(_loc3_);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._skin = new (getStyle("Skin",MenuItemSkin) as Class)(this);
         addChild(this._skin);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = this._skin.width;
         measuredHeight = this._skin.height;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this._skin.width = param1;
         this._skin.height = param2;
      }
   }
}
