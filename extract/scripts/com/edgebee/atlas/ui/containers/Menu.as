package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.data.ArrayCollection;
   import com.edgebee.atlas.events.MenuEvent;
   import com.edgebee.atlas.ui.Component;
   import com.edgebee.atlas.ui.UIGlobals;
   import com.edgebee.atlas.ui.controls.MenuItem;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Menu extends Box
   {
      
      public static const TYPE:String = "TYPE";
      
      public static const LABEL:String = "LABEL";
      
      public static const LOCALIZED_LABEL:String = "LLABEL";
      
      public static const ICON:String = "ICON";
      
      public static const SELECT_DATA:String = "SDATA";
      
      public static const ENABLED:String = "ENABLED";
      
      public static const TOOLTIP:String = "TOOLTIP";
      
      public static const SUB_MENUS:String = "CHILDREN";
      
      public static const TYPE_SEPARATOR:String = "SEPARATOR";
      
      public static const TYPE_CHECK:String = "CHECK";
      
      public static const TYPE_RADIO:String = "RADIO";
      
      protected static var _poppedMenus:Array = [];
       
      
      public var index:int = -1;
      
      private var _clicked:Boolean = false;
      
      protected var _parent:Component;
      
      protected var _popped:Boolean;
      
      protected var _menuData:ArrayCollection;
      
      public function Menu(param1:Component, param2:Array)
      {
         super(Box.VERTICAL);
         this._parent = param1;
         autoSizeChildren = true;
         setStyle("PaddingTop",1);
         setStyle("PaddingBottom",1);
         setStyle("PaddingRight",1);
         setStyle("PaddingLeft",1);
         setStyle("SoftBorderThickness",5);
         setStyle("SoftBorderColor",16777215);
         setStyle("BorderEdgeAlpha",0.25);
         setStyle("BackgroundAlpha",getStyle("BackgroundAlpha",1));
         setStyle("BackgroundColor",getStyle("BackgroundColor",16711680));
         this._menuData = new ArrayCollection(param2);
      }
      
      override public function get styleClassName() : String
      {
         return "Menu";
      }
      
      public function show(param1:Number, param2:Number) : void
      {
         if(_poppedMenus.length)
         {
            (_poppedMenus[0] as Menu).hide();
         }
         this.doShowMenu(param1,param2);
         UIGlobals.root.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
      }
      
      public function hide() : void
      {
         var _loc1_:Menu = null;
         do
         {
            _loc1_ = _poppedMenus.pop() as Menu;
            _loc1_.doHideMenu();
         }
         while(_loc1_ != this);
         
         UIGlobals.root.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         dispatchEvent(new MenuEvent(MenuEvent.CLOSED,null));
      }
      
      public function triggerMenuItem(param1:Object) : void
      {
         (_poppedMenus[0] as Menu).dispatchEvent(new MenuEvent(MenuEvent.ITEM_CLICK,param1));
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MenuItem = null;
         super.createChildren();
         for each(_loc1_ in this._menuData)
         {
            _loc2_ = new MenuItem(this);
            _loc2_.listElement = _loc1_;
            addChild(_loc2_);
         }
         setStyle("BorderThickness",1);
      }
      
      public function changeParent(param1:Component) : void
      {
         this._parent = param1;
      }
      
      protected function doShowMenu(param1:Number, param2:Number) : void
      {
         this.index = _poppedMenus.length;
         _poppedMenus.push(this);
         var _loc3_:Point = new Point(param1,param2);
         UIGlobals.popUpManager.addPopUp(this,this._parent,false);
         validateNow(false);
         if(_loc3_.x + width > UIGlobals.root.width)
         {
            _loc3_.x = UIGlobals.root.width - (width + 5);
         }
         if(_loc3_.y + height > UIGlobals.root.height)
         {
            _loc3_.y = UIGlobals.root.height - (height + 5);
         }
         UIGlobals.popUpManager.positionPopUp(this,_loc3_.x,_loc3_.y);
         this._popped = true;
      }
      
      protected function doHideMenu() : void
      {
         UIGlobals.popUpManager.removePopUp(this);
         this._popped = false;
         this.index = -1;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.hide();
      }
   }
}
