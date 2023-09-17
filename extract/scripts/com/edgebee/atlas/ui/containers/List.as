package com.edgebee.atlas.ui.containers
{
   import com.edgebee.atlas.events.ExtendedEvent;
   import com.edgebee.atlas.interfaces.IKbNavigatable;
   import flash.ui.Keyboard;
   
   public class List extends TileList
   {
      
      public static const KB_ACTIVATION:String = "KB_ACTIVATION";
       
      
      public function List()
      {
         super(TileList.VERTICAL);
      }
      
      override public function get styleClassName() : String
      {
         return "List";
      }
      
      override public function get columnCount() : uint
      {
         return 1;
      }
      
      override public function set hasKbFocus(param1:Boolean) : void
      {
         super.hasKbFocus = param1;
         if(param1)
         {
            selectedItem = dataProvider.first;
         }
      }
      
      override public function get isMetaKbNode() : Boolean
      {
         return false;
      }
      
      override public function get kbFirstNode() : IKbNavigatable
      {
         return this;
      }
      
      override public function kbMove(param1:uint) : IKbNavigatable
      {
         var _loc4_:IKbNavigatable = null;
         var _loc2_:int = 0;
         var _loc3_:uint = uint(dataProvider.getItemIndex(selectedItem));
         if(param1 == Keyboard.UP)
         {
            if(_loc3_ == 0)
            {
               if((_loc4_ = upLink) != this)
               {
                  return _loc4_;
               }
               _loc3_ = uint(dataProvider.length - 1);
            }
            else
            {
               _loc2_ = -1;
               _loc3_--;
            }
         }
         else if(param1 == Keyboard.DOWN)
         {
            if(_loc3_ == dataProvider.length - 1)
            {
               if((_loc4_ = downLink) != this)
               {
                  return _loc4_;
               }
               _loc3_ = 0;
            }
            else
            {
               _loc2_ = 1;
               _loc3_++;
            }
         }
         selectedItem = dataProvider.getItemAt(_loc3_);
         return this;
      }
      
      override public function kbActivate() : void
      {
         dispatchEvent(new ExtendedEvent(KB_ACTIVATION,selectedItem,true));
      }
   }
}
