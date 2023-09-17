package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.ui.controls.MenuItem;
   
   public class SubMenu extends Menu
   {
       
      
      private var _menuItem:MenuItem;
      
      public function SubMenu(param1:Menu, param2:Array, param3:MenuItem)
      {
         super(param1,param2);
         this._menuItem = param3;
      }
      
      public function get menuParent() : Menu
      {
         return _parent as Menu;
      }
      
      public function get popped() : Boolean
      {
         return _popped;
      }
      
      override public function show(param1:Number, param2:Number) : void
      {
         if(_poppedMenus.length > this.menuParent.index + 1)
         {
            (_poppedMenus[this.menuParent.index + 1] as Menu).hide();
         }
         doShowMenu(param1,param2);
      }
      
      override protected function doHideMenu() : void
      {
         super.doHideMenu();
         this._menuItem.selected = false;
      }
   }
}
